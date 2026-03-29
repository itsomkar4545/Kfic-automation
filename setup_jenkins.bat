@echo off
echo ========================================
echo KFIC Jenkins Setup Script
echo ========================================
echo.

echo This script will help you setup Jenkins for KFIC automation
echo.

:menu
echo Select an option:
echo 1. Download Jenkins
echo 2. Install Jenkins Plugins (Manual)
echo 3. Create Jenkins Job (Manual)
echo 4. Start Jenkins Server
echo 5. Open Jenkins Dashboard
echo 6. View Setup Guide
echo 0. Exit
echo.

set /p choice="Enter your choice (0-6): "

if "%choice%"=="1" goto download_jenkins
if "%choice%"=="2" goto install_plugins
if "%choice%"=="3" goto create_job
if "%choice%"=="4" goto start_jenkins
if "%choice%"=="5" goto open_dashboard
if "%choice%"=="6" goto view_guide
if "%choice%"=="0" goto exit

echo Invalid choice. Please try again.
goto menu

:download_jenkins
echo.
echo Downloading Jenkins...
echo Please download Jenkins from: https://www.jenkins.io/download/
echo Choose "Generic Java package (.war)"
echo Save it in this folder: %cd%
echo.
pause
goto menu

:install_plugins
echo.
echo Installing Jenkins Plugins:
echo ========================================
echo 1. Open Jenkins: http://localhost:8080
echo 2. Go to: Manage Jenkins > Manage Plugins
echo 3. Install these plugins:
echo    - Robot Framework Plugin
echo    - Pipeline Plugin
echo    - Git Plugin
echo    - Email Extension Plugin
echo.
pause
goto menu

:create_job
echo.
echo Creating Jenkins Job:
echo ========================================
echo 1. Click "New Item"
echo 2. Enter name: KFIC-Automation
echo 3. Select: Pipeline
echo 4. In Pipeline section:
echo    - Definition: Pipeline script from SCM
echo    - SCM: Git
echo    - Repository URL: [Your Git Repo]
echo    - Script Path: Jenkinsfile
echo 5. Save
echo.
pause
goto menu

:start_jenkins
echo.
echo Starting Jenkins Server...
if exist jenkins.war (
    echo Jenkins found! Starting server...
    java -jar jenkins.war --httpPort=8080
) else (
    echo Jenkins.war not found!
    echo Please download Jenkins first (Option 1)
)
pause
goto menu

:open_dashboard
echo.
echo Opening Jenkins Dashboard...
start http://localhost:8080
goto menu

:view_guide
echo.
echo Opening Jenkins Setup Guide...
if exist docs\JENKINS_SETUP.md (
    start docs\JENKINS_SETUP.md
) else (
    echo Setup guide not found!
)
goto menu

:exit
echo.
echo Jenkins setup completed!
echo.
echo Quick commands:
echo - Start Jenkins: java -jar jenkins.war
echo - Access Dashboard: http://localhost:8080
echo - View Logs: http://localhost:8080/log/all
echo.
pause
exit