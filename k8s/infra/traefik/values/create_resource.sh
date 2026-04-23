#!/bin/bash

set -e

ENV=$1

if [[ -z $ENV || ($ENV != "dev" && $ENV != "var") ]]; then
    echo "Usage: ./create_resource.sh [dev|prod]"
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Paths relative to the script location
VALUES_FILE="${SCRIPT_DIR}/${ENV}.yaml"
OUT_DIR="${SCRIPT_DIR}/../overlays/${ENV}"
OUT_FILE="${OUT_DIR}/resources.yaml"

mkdir -p "${OUT_DIR}"

helm template traefik traefik/traefik \
  -n traefik \
  -f "${VALUES_FILE}" \
  > "${OUT_FILE}"
