@echo off
setlocal enabledelayedexpansion

REM Script to delete empty folders and 0-byte files recursively

REM Check if a path argument was provided
if "%~1"=="" (
    set "startPath=%CD%"
) else (
    if exist "%~1" (
        set "startPath=%~1"
    ) else (
        echo ERROR: The path '%~1' does not exist!
        exit /b 1
    )
)

echo Starting cleanup from directory: !startPath!
echo.

REM Counters
set /a deletedFiles=0
set /a deletedFolders=0

REM Delete 0-byte files
echo Deleting 0-byte files...
for /r "!startPath!" %%F in (*) do (
    if %%~zF==0 (
        echo Deleting file: %%F
        del /f /q "%%F" 2>nul
        if !errorlevel!==0 set /a deletedFiles+=1
    )
)

echo.
echo Deleting empty folders...

REM Delete empty folders (loop multiple times for nested folders)
:loop
set /a folderDeleted=0

for /f "delims=" %%D in ('dir "!startPath!" /ad /b /s ^| sort /r') do (
    dir "%%D" /a /b 2>nul | findstr "^" >nul
    if errorlevel 1 (
        echo Deleting folder: %%D
        rd "%%D" 2>nul
        if !errorlevel!==0 (
            set /a deletedFolders+=1
            set /a folderDeleted=1
        )
    )
)

if !folderDeleted!==1 goto loop

REM Summary
echo.
echo === Cleanup completed ===
echo Files deleted: !deletedFiles!
echo Folders deleted: !deletedFolders!

endlocal
