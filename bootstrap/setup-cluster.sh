#!/bin/bash

set -e

helm repo add traefik https://traefik.github.io/charts
helm repo update

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.36.6/controller.yaml

kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.3.7/manifests/install.yaml