@echo off
echo ============================================================================
echo              CONFIGURING RANCHER DESKTOP (v2.x) ON WINDOWS
echo ============================================================================
echo.

REM 1) Check if rdctl is available
where rdctl >nul 2>nul
IF NOT %ERRORLEVEL%==0 (
    echo [ERROR] rdctl not found on PATH.
    echo [HINT] Please ensure Rancher Desktop is installed and rdctl is accessible.
    echo [HINT] Typically: C:\Program Files\Rancher Desktop\resources\resources\win32\rdctl.exe
    echo.
    pause
    goto END
)

REM 2) Configure and start Rancher Desktop in one go
REM    For example:
REM    - Set container engine to containerd
REM    - Enable Kubernetes
REM    - Set Kubernetes version to v1.25.9
REM
REM    If you wish to disable Kubernetes, use --kubernetes.enabled=false
REM    If you want Docker (Moby) instead of containerd, set --container-engine.name=moby
REM
echo [INFO] Starting Rancher Desktop with new configuration...
rdctl start ^
  --container-engine.name=containerd ^
  --kubernetes.enabled=true ^
  --kubernetes.version=v1.25.9

IF NOT %ERRORLEVEL%==0 (
    echo.
    echo [ERROR] Failed to apply the new Rancher Desktop config.
    echo [HINT] Check the output above or logs for details.
    echo.
    pause
    goto END
)

echo.
echo ============================================================================
echo [CONCLUSION]
echo Rancher Desktop is starting with:
echo  - Container Engine = containerd
echo  - Kubernetes = enabled
echo  - Kubernetes Version = v1.25.9
echo
echo [NOTE] CPU and memory must be configured via the Rancher Desktop UI.
echo        (Settings -> Virtual Machine).
echo ============================================================================
pause

:END
cmd /k
