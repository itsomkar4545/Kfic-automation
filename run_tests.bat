@echo off
echo ========================================
echo KFIC Advanced Test Execution Menu
echo ========================================
echo.

:menu
echo Select an option:
echo 1. Run Single Test
echo 2. Run All Tests (Sequential)
echo 3. Run All Tests (Parallel - 4x Faster)
echo 4. Run Tests by Tag
echo 5. Run Smoke Tests
echo 6. Run Receipt Tests
echo 7. Generate Performance Report
echo 8. Clean Old Results
echo 9. Open GUI Executor
echo 0. Exit
echo.

set /p choice="Enter your choice (0-9): "

if "%choice%"=="1" goto single_test
if "%choice%"=="2" goto all_tests_seq
if "%choice%"=="3" goto all_tests_parallel
if "%choice%"=="4" goto tests_by_tag
if "%choice%"=="5" goto smoke_tests
if "%choice%"=="6" goto receipt_tests
if "%choice%"=="7" goto performance_report
if "%choice%"=="8" goto clean_results
if "%choice%"=="9" goto gui_executor
if "%choice%"=="0" goto exit

echo Invalid choice. Please try again.
goto menu

:single_test
echo.
echo Available test files:
dir /b tests\*.robot
echo.
set /p testfile="Enter test file name (e.g., login_test.robot): "
echo Running single test: %testfile%
robot --outputdir results\single tests\%testfile%
goto show_results

:all_tests_seq
echo Running all tests sequentially...
robot --outputdir results\sequential tests\
goto show_results

:all_tests_parallel
echo Running all tests in parallel (4 processes)...
pabot --processes 4 --outputdir results\parallel tests\
goto show_results

:tests_by_tag
echo.
set /p tag="Enter tag name (e.g., receipt, login, smoke): "
echo Running tests with tag: %tag%
robot --include %tag% --outputdir results\tag_%tag% tests\
goto show_results

:smoke_tests
echo Running smoke tests...
robot --include smoke --outputdir results\smoke tests\
goto show_results

:receipt_tests
echo Running receipt tests...
robot --include receipt --outputdir results\receipt tests\
goto show_results

:performance_report
echo Generating performance report...
echo.
echo Performance Metrics:
echo ====================
if exist results\performance.log (
    type results\performance.log
) else (
    echo No performance data available. Run some tests first.
)
echo.
pause
goto menu

:clean_results
echo Cleaning old results...
if exist results (
    rmdir /s /q results
    mkdir results
    echo Old results cleaned successfully.
) else (
    echo No results directory found.
)
echo.
pause
goto menu

:gui_executor
echo Starting GUI Test Executor...
python gui_executor.py
goto menu

:show_results
echo.
echo ========================================
echo Test Execution Completed!
echo ========================================
echo.
if exist results\report.html (
    echo Opening test report...
    start results\report.html
) else (
    echo Report not found in expected location.
    echo Check the results directory for output files.
)
echo.
echo Results saved in: results\
echo.
set /p open_results="Open results folder? (y/n): "
if /i "%open_results%"=="y" start results\
echo.
pause
goto menu

:exit
echo.
echo Thank you for using KFIC Test Executor!
echo Framework optimized for speed and reliability.
echo.
pause
exit