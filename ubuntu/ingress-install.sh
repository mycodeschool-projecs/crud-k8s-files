#!/usr/bin/env bash
set -e

###############################################################################
# 0) Variables
###############################################################################
KUBECONFIG_PATH="/etc/rancher/k3s/k3s.yaml"
NAMESPACE="ingress-nginx"
RELEASE_NAME="ingress-nginx"
CHART_REPO="ingress-nginx"
CHART_NAME="ingress-nginx/ingress-nginx"

###############################################################################
# 1) Ensure K3s is running
###############################################################################
echo "[INFO] Checking if K3s is running..."
if ! systemctl is-active --quiet k3s; then
  echo "[ERROR] K3s is not active! Please start K3s first:"
  echo "  sudo systemctl start k3s"
  exit 1
fi

###############################################################################
# 2) Set kubeconfig
###############################################################################
echo "[INFO] Setting KUBECONFIG to ${KUBECONFIG_PATH}"
export KUBECONFIG="${KUBECONFIG_PATH}"

# Quick check
echo "[INFO] Checking cluster connectivity with kubectl..."
if ! kubectl get nodes >/dev/null 2>&1; then
  echo "[ERROR] Could not connect to Kubernetes cluster with ${KUBECONFIG_PATH}!"
  exit 1
fi

###############################################################################
# 3) Remove existing ingress-nginx (if any)
###############################################################################
echo "[INFO] Removing old ingress-nginx release if it exists..."
helm uninstall "${RELEASE_NAME}" --namespace "${NAMESPACE}" || true

# Also delete the namespace if you want a clean slate
echo "[INFO] Deleting namespace ${NAMESPACE}..."
kubectl delete ns "${NAMESPACE}" --ignore-not-found=true

# Wait for the namespace to terminate
echo "[INFO] Waiting for namespace ${NAMESPACE} to finalize..."
while kubectl get ns "${NAMESPACE}" >/dev/null 2>&1; do
  echo "  ...still terminating..."
  sleep 2
done

###############################################################################
# 4) Re-install ingress-nginx via Helm
###############################################################################
echo "[INFO] Adding or updating ingress-nginx Helm repo..."
helm repo add "${CHART_REPO}" https://kubernetes.github.io/ingress-nginx || true
helm repo update

echo "[INFO] Creating namespace ${NAMESPACE}..."
kubectl create namespace "${NAMESPACE}" || true

echo "[INFO] Installing ingress-nginx via Helm..."
helm upgrade --install "${RELEASE_NAME}" \
  "${CHART_NAME}" \
  --namespace "${NAMESPACE}" \
  --set controller.publishService.enabled=true

###############################################################################
# 5) Verify Installation
###############################################################################
echo "[INFO] Waiting for the ingress-nginx controller to roll out..."
kubectl rollout status deployment/ingress-nginx-controller -n "${NAMESPACE}" --timeout=120s

echo "[INFO] All done! The ingress-nginx controller should be reinstalled."
kubectl get pods -n "${NAMESPACE}"
