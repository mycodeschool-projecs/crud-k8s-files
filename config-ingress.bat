@echo off
echo Enabling and configuring Ingress in Rancher Desktop...

REM Step 1: Download the official Ingress-NGINX manifest
echo Downloading Ingress-NGINX manifest...
curl -LO https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.1/deploy/static/provider/cloud/deploy.yaml

REM Step 2: Apply the manifest
echo Applying Ingress-NGINX manifest to the cluster...
kubectl apply -f deploy.yaml

REM Step 3: Wait for Ingress-NGINX controller to become ready
echo Waiting for the Ingress-NGINX controller deployment to become available...
kubectl wait --namespace ingress-nginx \
  --for=condition=available deployment/ingress-nginx-controller \
  --timeout=120s

echo Ingress has been configured successfully!
echo You can verify by running: kubectl get pods -n ingress-nginx
pause