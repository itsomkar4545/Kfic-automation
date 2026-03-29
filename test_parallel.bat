@echo off
echo ========================================
echo KFIC Parallel Execution Test
echo ========================================
echo.

echo Testing parallel execution with multiple test cases...
echo.

echo 1. Running tests sequentially (for comparison)...
echo Start time: %time%
robot --outputdir results\sequential --timestampoutputs tests\
echo Sequential end time: %time%
echo.

echo 2. Running tests in parallel (4 processes)...
echo Start time: %time%
pabot --processes 4 --outputdir results\parallel --timestampoutputs tests\
echo Parallel end time: %time%
echo.

echo ========================================
echo Parallel Execution Test Completed!
echo ========================================
echo.
echo Check results:
echo - Sequential: results\sequential\
echo - Parallel: results\parallel\
echo.

if exist results\parallel\report.html (
    echo Opening parallel execution report...
    start results\parallel\report.html
)

pause