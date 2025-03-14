#!/usr/bin/env bash

###############################################################################
# Minimal script to install the NGINX Ingress Controller using Helm
# Usage:
#   chmod +x install_configure_ingress.sh
#   ./install_configure_ingress.sh
###############################################################################

set -euo pipefail

echo "============================================================================"
echo "     INSTALLING NGINX INGRESS CONTROLLER VIA HELM (MINIMAL FOR BASH)"
echo "============================================================================"

###############################################################################
# 1) Check dependencies: kubectl, helm
###############################################################################
if ! command -v kubectl &>/dev/null; then
  echo "[ERROR] 'kubectl' not found in PATH. Please install or configure it."
  exit 1
fi

if ! command -v helm &>/dev/null; then
  echo "[ERROR] 'helm' not found in PATH. Please install or configure it."
  exit 1
fi

###############################################################################
# 2) Add and update the ingress-nginx Helm repo
###############################################################################
echo "[INFO] Adding ingress-nginx Helm repo..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

###############################################################################
# 3) Create the 'ingress-nginx' namespace (safe if it already exists)
###############################################################################
echo "[INFO] Creating/using the 'ingress-nginx' namespace..."
kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

###############################################################################
# 4) Install/Upgrade the ingress-nginx Helm chart
###############################################################################
echo "[INFO] Installing/upgrading the ingress-nginx Helm chart..."
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.publishService.enabled=true

echo "[INFO] Waiting for the ingress-nginx controller to become ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=120s

echo "============================================================================"
echo "[SUCCESS] The NGINX Ingress Controller is installed in 'ingress-nginx' namespace."
echo "          You can create an Ingress resource with 'ingressClassName: nginx'"
echo "          and access your services via that Ingress."
echo "============================================================================"
