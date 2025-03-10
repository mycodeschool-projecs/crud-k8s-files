#!/bin/bash

# Clean up existing NGINX Ingress Controller resources
echo "Cleaning up existing NGINX Ingress Controller..."
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml --ignore-not-found=true
kubectl delete namespace ingress-nginx --ignore-not-found=true

# Wait for resources to be deleted
echo "Waiting for resources to be cleaned up..."
sleep 10

# Install the NGINX Ingress Controller
echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Wait for the Ingress Controller to be ready
echo "Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Apply your Ingress resource
echo "Applying Ingress resource..."
kubectl apply -f ingress.yaml

# Update /etc/hosts file to map react-app.local to localhost
echo "Updating /etc/hosts file..."
if ! grep -q "react-app.local" /etc/hosts; then
  echo "127.0.0.1 react-app.local" | sudo tee -a /etc/hosts
else
  echo "react-app.local already exists in /etc/hosts."
fi

# Verify the Ingress resource
echo "Verifying Ingress resource..."
kubectl get ingress

# Test access to the application
echo "Testing access to the application..."
curl http://react-app.local