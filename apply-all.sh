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
