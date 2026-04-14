@echo off
cd /d "%~dp0.."
git add .
git diff --cached --quiet
if %errorlevel% neq 0 (
    for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
    set dt=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%
    git commit -m "Auto-push on close: %dt%"
    git push origin main
    echo Changes pushed successfully.
) else (
    echo No changes to push.
)
