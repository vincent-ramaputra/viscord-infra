# Viscord demo on a single EC2 instance (Docker Compose)

A cheap, always-on demo. The EKS + Argo CD setup in `terraform/` and `k8s/` is still the
"real" design; this directory runs the same images on one VM.

```
Internet ──443──> caddy ──> web, auth/user/guild/message-service, ws-gateway   (compose network only)
         ──443──> sfu.<domain> ──> sfu-service
         ──UDP 40000-40099──> sfu-service (WebRTC media)
```

## 1. AWS resources

`terraform/aws/demo` creates everything in this section: instance with Docker and swap already
installed, Elastic IP, security group, instance profile, IMDS hop limit and the Route53 records. With
it, `terraform apply` replaces this section and the Docker/swap commands in section 2. What it creates:

- **Instance:** `t3.medium` (2 vCPU / 4 GB), Ubuntu 24.04, 20 GB gp3. The images are amd64 only, so no Graviton (`t4g`).
  Use `ap-southeast-3` to stay next to the existing S3 bucket.
- **Elastic IP** attached to the instance. The SFU announces this IP to browsers, so it must not change on stop/start.
- **Security group inbound:** 22/tcp (your IP only), 80/tcp, 443/tcp, 443/udp, 40000-40099/udp.
- **IAM instance profile** with `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject` on `arn:aws:s3:::<bucket>/*`
  and `s3:ListBucket` on `arn:aws:s3:::<bucket>`.
- **IMDS hop limit 2.** Containers sit one network hop further from the metadata endpoint than the host, and IMDSv2's
  default limit of 1 silently blocks them from getting instance-profile credentials:
  ```bash
  aws ec2 modify-instance-metadata-options --instance-id <id> --http-put-response-hop-limit 2 --http-tokens required
  ```
- **DNS:** A records for `<domain>` and `sfu.<domain>`, both pointing to the Elastic IP.

## 2. Server setup

```bash
# Docker + compose plugin
curl -fsSL https://get.docker.com | sudo sh && sudo usermod -aG docker $USER   # re-login after this

# 2 GB swap as a safety net on a 4 GB box
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# copy this directory, including .env, to the server (from your machine)
scp -i ~/.ssh/demo-vm.pem -r infra/compose/. ubuntu@<ip>:/opt/viscord/
```

## 3. Secrets (`.env`)

```bash
cd /opt/viscord && cp .env.example .env && chmod 600 .env

openssl rand -base64 32   # -> POSTGRES_PASSWORD
openssl rand -base64 32   # -> JWT_SECRET

# voice-ticket key pair: guild-service signs (PKCS#8 private), sfu-service verifies (SPKI public)
openssl ecparam -name prime256v1 -genkey -noout | openssl pkcs8 -topk8 -nocrypt -out ticket.key
openssl ec -in ticket.key -pubout -out ticket.pub
base64 -w0 ticket.key     # -> SFU_TICKET_PRIVATE_KEY
base64 -w0 ticket.pub     # -> SFU_TICKET_PUBLIC_KEY
rm ticket.key ticket.pub
```

Fill in `DOMAIN` and `PUBLIC_IP` too.

## 4. Run

```bash
docker compose up -d
docker compose ps                      # everything "running"; data stores "healthy"
docker compose logs -f guild-service   # migrations run on first boot
```

Deploying a new version: change the tag in `.env` (e.g. `GUILD_TAG=sha-abc1234`), then `docker compose up -d`.

## Notes

- `POSTGRES_PASSWORD` and `postgres-init/` only take effect when the `pgdata` volume is created. Changing them later
  means `docker compose down -v` (wipes data) or running SQL by hand.
- Back up the database before risky changes: `docker compose exec postgres pg_dumpall -U viscord > backup.sql`.
- There is no observability stack here. Use `docker compose logs` and `docker stats`.
