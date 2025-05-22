#!/usr/bin/env bash
# install-ingress-nginx.sh
#
# Installs the Kubernetes Ingress-NGINX controller on Rancher Desktop
# and waits for the rollout to finish.  Tested on macOS arm64.

set -Eeuo pipefail

### ── Tunables ────────────────────────────────────────────────────
NAMESPACE="ingress-nginx"
CONTEXT="rancher-desktop"
VERSION="v1.12.2"                           # Latest as of 30 Apr 2025
TIMEOUT="180s"
MANIFEST="https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-${VERSION}/deploy/static/provider/cloud/deploy.yaml"
### ────────────────────────────────────────────────────────────────

msg()   { printf "\n\033[1;34m%s\033[0m\n" "$*"; }
error() { printf "\n\033[1;31mERROR: %s\033[0m\n" "$*" >&2; }

cleanup() {
  error "Rollout failed – dumping controller logs (last 50 lines):"
  kubectl -n "$NAMESPACE" logs deploy/ingress-nginx-controller --tail=50 2>/dev/null || true
}
trap cleanup ERR

msg "🔄 Switching to context: $CONTEXT"
kubectl config use-context "$CONTEXT"

msg "🧹 Removing any existing $NAMESPACE namespace"
kubectl delete ns "$NAMESPACE" --ignore-not-found --wait

msg "🚀 Installing Ingress-NGINX ${VERSION}"
curl -fsSL "$MANIFEST" | kubectl apply -f -

msg "⏳ Waiting for Deployment rollout (timeout ${TIMEOUT})"
kubectl -n "$NAMESPACE" rollout status deploy/ingress-nginx-controller --timeout="$TIMEOUT"

msg "🔍 Pod ↔︎ Node mapping"
kubectl -n "$NAMESPACE" get pods \
  -l app.kubernetes.io/component=controller \
  -o=custom-columns='POD:metadata.name,NODE:spec.nodeName,PHASE:status.phase'

msg "✅ Ingress-NGINX ${VERSION} is ready!"
