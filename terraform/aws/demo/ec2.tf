# Canonical publishes the current Ubuntu AMI ID in SSM, so there is no AMI ID to hardcode or owner filter to get wrong.
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_instance" "demo" {
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.demo.id]
  iam_instance_profile   = aws_iam_instance_profile.demo.name
  key_name               = var.ssh_key_name

  user_data = file("${path.module}/user-data.sh")

  dynamic "instance_market_options" {
    for_each = var.use_spot ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        # "stop" requires a persistent request. No max_price: pay the current spot price, capped at on-demand.
        spot_instance_type             = "persistent"
        instance_interruption_behavior = "stop"
      }
    }
  }

  # T3 defaults to "unlimited": once CPU credits run out it keeps bursting and bills ~$0.05/vCPU-hour
  # extra, so sustained abuse (e.g. hammering bcrypt on login) turns into cost. "standard" throttles
  # to the 20% baseline instead: an attack makes the demo slow, not expensive.
  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # IMDSv2 only
    # Containers sit one network hop behind the host (the docker bridge), so with the default
    # limit of 1 the IMDSv2 token response never reaches them and the AWS SDKs find no credentials.
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
    # Postgres data is on this disk: `terraform destroy` deletes it. Take a pg_dumpall first if you care.
    delete_on_termination = true
  }

  tags = {
    Name = "viscord-demo"
  }

  lifecycle {
    # The SSM parameter changes every time Canonical publishes a new image. Without this, the next
    # plan after that would replace the instance and wipe the database. Patch with apt instead.
    ignore_changes = [ami, user_data]
  }
}

# Stable public IP: the SFU advertises it to browsers (PUBLIC_IP in compose's .env), and DNS points at it.
# Survives instance stop/start; a plain auto-assigned public IP would not.
resource "aws_eip" "demo" {
  domain   = "vpc"
  instance = aws_instance.demo.id

  tags = {
    Name = "viscord-demo"
  }
}
