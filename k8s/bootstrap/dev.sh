#!/bin/bash

kubectl apply -k infra/argocd/overlays/dev/

kubectl apply -f argocd-applications/dev/root-app.yaml