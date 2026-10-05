#!/bin/bash
# Runs once, on first boot (cloud-init). Progress: /var/log/cloud-init-output.log
set -euxo pipefail

# 2 GB swap: a safety net so a memory spike gets slow instead of OOM-killing Postgres.
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Docker Engine + compose plugin from Docker's apt repo.
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu
systemctl enable --now docker

# Where the compose directory goes.
mkdir -p /opt/viscord
chown ubuntu:ubuntu /opt/viscord
