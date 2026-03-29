@echo off
echo ========================================
echo Java 17 Upgrade Script for Jenkins
echo ========================================
echo.

echo Current Java Version:
java -version
echo.

echo Step 1: Downloading Java 17...
echo.

REM Create temp directory
if not exist "temp" mkdir temp

echo Downloading OpenJDK 17 (Eclipse Temurin)...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jdk_x64_windows_hotspot_17.0.9_9.msi' -OutFile 'temp\openjdk17.msi'"

if exist "temp\openjdk17.msi" (
    echo ✅ Java 17 downloaded successfully!
    echo.
    echo Step 2: Installing Java 17...
    echo.
    echo This will open the installer. Please follow these steps:
    echo 1. Click "Next" through the installer
    echo 2. Accept the license agreement
    echo 3. Choose installation directory (default is fine)
    echo 4. Click "Install"
    echo 5. Click "Finish"
    echo.
    pause
    
    REM Run installer
    start /wait msiexec /i "temp\openjdk17.msi" /quiet
    
    echo.
    echo Step 3: Setting JAVA_HOME...
    echo.
    
    REM Set JAVA_HOME (adjust path if needed)
    setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot"
    setx PATH "%PATH%;%JAVA_HOME%\bin"
    
    echo ✅ Java 17 installation completed!
    echo.
    echo Step 4: Verifying installation...
    echo Please close this window and open a new command prompt.
    echo Then run: java -version
    echo You should see Java 17.
    echo.
    
) else (
    echo ❌ Download failed!
    echo.
    echo Manual download steps:
    echo 1. Go to: https://adoptium.net/temurin/releases/
    echo 2. Select: Java 17 (LTS)
    echo 3. Select: Windows x64
    echo 4. Download and install the .msi file
    echo.
)

echo Step 5: After Java 17 is installed, run Jenkins:
echo java -jar jenkins.war --httpPort=8080
echo.

pause