@echo off
echo ===== Checking Ingress Resource =====
kubectl get ingress
kubectl describe ingress main-ingress

echo.
echo ===== Checking Backend Services =====
kubectl get svc react-app
kubectl get svc kube-land

echo.
echo ===== Checking Backend Endpoints =====
kubectl get endpoints react-app
kubectl get endpoints kube-land

echo.
echo ===== Checking Pods =====
kubectl get pods -l app=react-app
kubectl get pods -l app=kube-land

echo.
echo ===== Checking NGINX Ingress Controller Logs =====
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller --tail=50

echo.
echo ===== Checking Backend Service Logs =====
for /f "tokens=1" %%i in ('kubectl get pods -l app=react-app -o jsonpath="{.items[0].metadata.name}"') do set REACT_APP_POD=%%i
for /f "tokens=1" %%i in ('kubectl get pods -l app=kube-land -o jsonpath="{.items[0].metadata.name}"') do set KUBE_LAND_POD=%%i

echo Logs for react-app pod (%REACT_APP_POD%):
kubectl logs %REACT_APP_POD% --tail=50

echo.
echo Logs for kube-land pod (%KUBE_LAND_POD%):
kubectl logs %KUBE_LAND_POD% --tail=50

echo.
echo ===== Testing Backend Services via Port Forward =====
echo Forwarding react-app service to port 3000...
start /B kubectl port-forward svc/react-app 3000:3000
set REACT_APP_PID=%errorlevel%

echo Forwarding kube-land service to port 8082...
start /B kubectl port-forward svc/kube-land 8082:8082
set KUBE_LAND_PID=%errorlevel%

timeout /t 5 >nul

echo.
echo Testing react-app service...
curl http://localhost:3000

echo.
echo Testing kube-land service...
curl http://localhost:8082

echo.
echo Stopping port forwarding...
taskkill /PID %REACT_APP_PID% /F
taskkill /PID %KUBE_LAND_PID% /F

echo.
echo ===== Testing Ingress Access =====
echo Testing react-app via Ingress...
curl -k https://react-app.local

echo.
echo Testing kube-land via Ingress...
curl -k https://react-app.local/api

echo.
echo ===== Debugging Complete =====
pause