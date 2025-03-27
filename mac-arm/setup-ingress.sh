#!/bin/bash

set -e

echo "🔄 Switching to Rancher Desktop context..."
kubectl config use-context rancher-desktop

echo "🧹 Cleaning up previous ingress-nginx install (if any)..."
kubectl delete namespace ingress-nginx --ignore-not-found

echo "🚀 Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml

echo "⏳ Waiting for ingress controller pods to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pods \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo "✅ Ingress controller is ready!"
