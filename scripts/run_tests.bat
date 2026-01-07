@echo off
REM KFIC Automation Framework Test Execution Scripts for Windows

setlocal enabledelayedexpansion

REM Default values
set ENVIRONMENT=dev
set BROWSER=chrome
set PARALLEL_PROCESSES=4
set OUTPUT_DIR=results

REM Function to print status
:print_status
echo [INFO] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

REM Function to run smoke tests
:run_smoke_tests
call :print_status "Running Smoke Tests..."
robot --variable ENVIRONMENT:%ENVIRONMENT% --variable BROWSER:%BROWSER% --include smoke --outputdir %OUTPUT_DIR%\smoke tests\
goto :eof

REM Function to run full test suite
:run_full_suite
call :print_status "Running Full Test Suite..."
robot --variable ENVIRONMENT:%ENVIRONMENT% --variable BROWSER:%BROWSER% --outputdir %OUTPUT_DIR%\full tests\
goto :eof

REM Function to run parallel tests
:run_parallel_tests
call :print_status "Running Tests in Parallel (%PARALLEL_PROCESSES% processes)..."
pabot --processes %PARALLEL_PROCESSES% --variable ENVIRONMENT:%ENVIRONMENT% --variable BROWSER:%BROWSER% --outputdir %OUTPUT_DIR%\parallel tests\
goto :eof

REM Function to run API tests only
:run_api_tests
call :print_status "Running API Tests..."
robot --variable ENVIRONMENT:%ENVIRONMENT% --include api --outputdir %OUTPUT_DIR%\api tests\api\
goto :eof

REM Function to run LOS tests only
:run_los_tests
call :print_status "Running LOS Tests..."
robot --variable ENVIRONMENT:%ENVIRONMENT% --variable BROWSER:%BROWSER% --include los --outputdir %OUTPUT_DIR%\los tests\los\
goto :eof

REM Function to run tests by tag
:run_tests_by_tag
call :print_status "Running Tests with tag: %~1..."
robot --variable ENVIRONMENT:%ENVIRONMENT% --variable BROWSER:%BROWSER% --include %~1 --outputdir %OUTPUT_DIR%\%~1 tests\
goto :eof

REM Function to generate reports
:generate_reports
call :print_status "Generating Allure Reports..."
if exist "%OUTPUT_DIR%\allure-results" (
    allure generate %OUTPUT_DIR%\allure-results -o %OUTPUT_DIR%\allure-report --clean
    call :print_status "Allure report generated at: %OUTPUT_DIR%\allure-report\index.html"
) else (
    echo [WARNING] No allure-results directory found
)
goto :eof

REM Function to clean results
:clean_results
call :print_status "Cleaning previous results..."
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%"
goto :eof

REM Function to setup environment
:setup_environment
call :print_status "Setting up test environment..."
pip install -r requirements.txt
call :print_status "Dependencies installed successfully"
goto :eof

REM Main execution logic
if "%1"=="smoke" (
    call :run_smoke_tests
) else if "%1"=="full" (
    call :run_full_suite
) else if "%1"=="parallel" (
    call :run_parallel_tests
) else if "%1"=="api" (
    call :run_api_tests
) else if "%1"=="los" (
    call :run_los_tests
) else if "%1"=="tag" (
    if "%2"=="" (
        call :print_error "Please provide a tag name"
        exit /b 1
    )
    call :run_tests_by_tag %2
) else if "%1"=="reports" (
    call :generate_reports
) else if "%1"=="clean" (
    call :clean_results
) else if "%1"=="setup" (
    call :setup_environment
) else (
    echo Usage: %0 {smoke^|full^|parallel^|api^|los^|tag ^<tag_name^>^|reports^|clean^|setup}
    echo.
    echo Commands:
    echo   smoke     - Run smoke tests only
    echo   full      - Run complete test suite
    echo   parallel  - Run tests in parallel
    echo   api       - Run API tests only
    echo   los       - Run LOS tests only
    echo   tag       - Run tests by specific tag
    echo   reports   - Generate Allure reports
    echo   clean     - Clean previous results
    echo   setup     - Setup test environment
    echo.
    echo Environment variables:
    echo   ENVIRONMENT=%ENVIRONMENT%
    echo   BROWSER=%BROWSER%
    echo   PARALLEL_PROCESSES=%PARALLEL_PROCESSES%
    exit /b 1
)