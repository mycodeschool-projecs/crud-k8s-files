#!/usr/bin/env bash
set -e
echo "Applying Kubernetes manifests..."
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f pv-pvc.yaml
kubectl apply -f mysql-statefulset.yaml
kubectl apply -f deployment-api.yaml
kubectl apply -f deployment-kube-land.yaml
kubectl apply -f deployment-client.yaml
kubectl apply -f ingress.yaml
echo "All manifests have been successfully applied."
