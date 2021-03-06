@echo off
rem Checkout source code

set CHROMIUM_VERSION=48.0.2564.116
set RELEASE_BRANCH=iridium_release_branch

cd develop/src

git tag -l "%CHROMIUM_VERSION%" | findstr "%CHROMIUM_VERSION%" >nul 2>&1
if not %errorlevel% == 0 (
    echo Fetching release tag...
    call git fetch origin tags/%CHROMIUM_VERSION%
)

git branch --list "%RELEASE_BRANCH%" | findstr "%RELEASE_BRANCH%" >nul 2>&1
if not %errorlevel% == 0 (
    echo Switching to release branch...
    call git checkout -B %RELEASE_BRANCH% tags/%CHROMIUM_VERSION%
) else (
    echo Resetting local changes...
    call git reset --hard tags/%CHROMIUM_VERSION%
    call git clean -d -f -f
)

echo Syncing source code...
call gclient sync --with_branch_heads --reset --nohooks
