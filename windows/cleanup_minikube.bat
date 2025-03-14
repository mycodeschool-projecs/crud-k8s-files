@echo off
echo ============================================================================
echo                  CLEANING UP MINIKUBE ON WINDOWS
echo ============================================================================
echo.

REM 1) Check if minikube is on PATH
where minikube >nul 2>nul
IF NOT %ERRORLEVEL%==0 (
    echo [INFO] Minikube not found on PATH. No minikube command to remove.
) ELSE (
    echo [INFO] Stopping all running minikube clusters...
    minikube stop 2>nul

    echo [INFO] Deleting all minikube clusters...
    minikube delete --all --purge 2>nul
)

echo.
REM 2) Remove the .minikube folder in USERPROFILE
echo [INFO] Removing %USERPROFILE%\.minikube directory...
IF EXIST "%USERPROFILE%\.minikube" (
    rmdir /s /q "%USERPROFILE%\.minikube"
    IF %ERRORLEVEL%==0 (
        echo [INFO] Successfully removed .minikube folder.
    ) ELSE (
        echo [WARN] Could not remove .minikube folder. You may need to remove it manually.
    )
) ELSE (
    echo [INFO] .minikube folder not found. Skipping.
)

echo.
REM 3) Remove old minikube executables if known location
echo [INFO] Attempting to remove known Minikube paths...
IF EXIST "C:\Program Files\Minikube\minikube.exe" (
    del "C:\Program Files\Minikube\minikube.exe"
    echo [INFO] Removed C:\Program Files\Minikube\minikube.exe
)

IF EXIST "C:\Program Files (x86)\Minikube\minikube.exe" (
    del "C:\Program Files (x86)\Minikube\minikube.exe"
    echo [INFO] Removed C:\Program Files (x86)\Minikube\minikube.exe
)

echo.
REM 4) Remove from PATH if previously added
echo [INFO] Removing Minikube from the PATH (for this session)...
set "NEWPATH=%PATH:C:\Program Files\Minikube\=%"
set "NEWPATH=%NEWPATH:C:\Program Files (x86)\Minikube\=%"
set PATH=%NEWPATH%

echo.
REM 5) Remove potential registry entries if installed via Windows installer
echo [INFO] Removing Minikube registry entries (if they exist)...
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\Minikube" /f 2>nul
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Minikube" /f 2>nul

echo.
echo ============================================================================
echo [CONCLUSION]
echo 1. Stopped and removed any running Minikube clusters.
echo 2. Deleted the .minikube folder (if it existed).
echo 3. Removed known Minikube executables (if found).
echo 4. Cleaned up PATH references to Minikube (for this session).
echo 5. Removed potential Minikube registry entries.
echo.
echo [INFO] Minikube cleanup is complete.
echo ============================================================================
pause
:: Force the window to remain open (especially if double-clicked)
cmd /k
