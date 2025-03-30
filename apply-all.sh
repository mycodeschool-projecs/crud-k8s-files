<<<<<<< HEAD
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
=======
#!/bin/bash
echo "🚀 Deploying your application..."
kubectl apply -f storage.yaml
kubectl apply -f volumes.yaml
kubectl apply -f secret.yaml
kubectl apply -f configs.yaml
kubectl apply -f mysql.yaml
kubectl apply -f auth-service.yaml
kubectl apply -f command-service.yaml
kubectl apply -f app-client.yaml
kubectl apply -f ingress.yaml
kubectl apply -f zipkin.yaml
kubectl apply -f setup.yaml
kubectl apply -f elasticsearch.yaml
kubectl apply -f kibana.yaml
kubectl apply -f logstash.yaml
>>>>>>> feat/implement-elk-refactor
