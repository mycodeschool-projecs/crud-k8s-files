@echo off
echo Cleaning up existing NGINX Ingress Controller...
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml --ignore-not-found=true
kubectl delete namespace ingress-nginx --ignore-not-found=true

echo Waiting for resources to be cleaned up...
timeout /t 10 >nul

echo Installing NGINX Ingress Controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

echo Waiting for NGINX Ingress Controller to be ready...
:kubectl-wait
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s
if %errorlevel% neq 0 (
    echo NGINX Ingress Controller is not ready yet. Retrying...
    timeout /t 5 >nul
    goto kubectl-wait
)

echo Applying Ingress resource...
kubectl apply -f ingress.yaml

echo Updating hosts file...
findstr /i /c:"react-app.local" %SystemRoot%\System32\drivers\etc\hosts >nul
if %errorlevel% equ 1 (
    echo 127.0.0.1 react-app.local >> %SystemRoot%\System32\drivers\etc\hosts
    echo Added react-app.local to hosts file.
) else (
    echo react-app.local already exists in hosts file.
)

echo Verifying Ingress resource...
kubectl get ingress

echo Testing access to the application...
curl https://react-app.local

pause