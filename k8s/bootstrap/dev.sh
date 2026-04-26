#!/bin/bash

helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace

kubectl apply -k infra/argocd/overlays/dev/ --server-side

kubectl apply -f argocd-applications/dev/root-app.yaml