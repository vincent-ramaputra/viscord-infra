#!/bin/bash

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.36.6/controller.yaml

kubectl apply -k infra/argocd/overlays/dev/

kubectl apply -f argocd-applications/dev/root-app.yaml