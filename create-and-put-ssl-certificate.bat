@echo off
echo === Setting up Ingress with TLS ===

:: Step 1: Generate a self-signed certificate and key
echo Generating self-signed certificate and key...
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=react-app.local"

if %errorlevel% neq 0 (
    echo Failed to generate certificate and key.
    exit /b 1
)

:: Step 2: Create the TLS secret in Kubernetes
echo Creating TLS secret...
kubectl create secret tls react-app-tls --cert=tls.crt --key=tls.key --dry-run=client -o yaml | kubectl apply -f -

if %errorlevel% neq 0 (
    echo Failed to create TLS secret.
    exit /b 1
)

:: Step 3: Apply the Ingress resource
echo Applying Ingress resource...
kubectl apply -f ingress.yaml

if %errorlevel% neq 0 (
    echo Failed to apply Ingress resource.
    exit /b 1
)

echo === Setup complete ===
echo Test access to the application:
echo curl -k https://react-app.local
pause