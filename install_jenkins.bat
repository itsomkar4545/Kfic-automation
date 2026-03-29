@echo off
echo ========================================
echo KFIC Jenkins Auto-Installation Script
echo ========================================
echo.

echo Step 1: Downloading Jenkins...
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java not found! Please install Java first.
    echo Download from: https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
)

echo ✅ Java found!
echo.

REM Download Jenkins if not exists
if not exist jenkins.war (
    echo Downloading Jenkins WAR file...
    powershell -Command "Invoke-WebRequest -Uri 'https://get.jenkins.io/war-stable/latest/jenkins.war' -OutFile 'jenkins.war'"
    
    if exist jenkins.war (
        echo ✅ Jenkins downloaded successfully!
    ) else (
        echo ❌ Download failed! Please download manually from:
        echo https://www.jenkins.io/download/
        pause
        exit /b 1
    )
) else (
    echo ✅ Jenkins WAR file already exists!
)

echo.
echo Step 2: Starting Jenkins...
echo.
echo Jenkins will start on: http://localhost:8080
echo Initial admin password will be displayed below.
echo Copy the password for first-time setup.
echo.
echo Press any key to start Jenkins...
pause

REM Start Jenkins
echo Starting Jenkins server...
java -jar jenkins.war --httpPort=8080

pause