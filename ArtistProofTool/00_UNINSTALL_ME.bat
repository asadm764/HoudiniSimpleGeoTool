@echo off
setlocal EnableDelayedExpansion

:: =========================================
:: CAPTURE ORIGINAL USER PROFILE (FIRST RUN)
:: =========================================
if "%~1"=="" (
    set "ORIG_USERPROFILE=%USERPROFILE%"
) else (
    set "ORIG_USERPROFILE=%~1"
)

:: ===============================
:: AUTO-ELEVATE TO ADMIN
:: ===============================
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs -ArgumentList '%ORIG_USERPROFILE%'"
    exit /b
)

:: ===============================
:: DETECT HIGHEST HOUDINI FOLDER (houdini#.#)
:: ===============================
echo Detecting Houdini user folder...

set "USER_HOUDINI="
set "BEST_VER_NUM=0"

for /d %%D in ("%ORIG_USERPROFILE%\Documents\houdini*") do (
    set "FOLDER=%%~nxD"

    rem Must start with "houdini"
    if /I "!FOLDER:~0,7!"=="houdini" (

        rem Extract version part after "houdini"
        set "VER=!FOLDER:houdini=!"

        rem Split into major.minor
        for /f "tokens=1,2 delims=." %%a in ("!VER!") do (
            set "MAJOR=%%a"
            set "MINOR=%%b"
        )

        rem Validate numeric major/minor using arithmetic
        set /a TEST_MAJOR=MAJOR 2>nul
        if "!TEST_MAJOR!"=="!MAJOR!" (
            set /a TEST_MINOR=MINOR 2>nul
            if "!TEST_MINOR!"=="!MINOR!" (

                rem Convert version to sortable number (major*1000 + minor)
                set /a VER_NUM=MAJOR*1000 + MINOR

                rem Keep highest version
                if !VER_NUM! gtr !BEST_VER_NUM! (
                    set "BEST_VER_NUM=!VER_NUM!"
                    set "USER_HOUDINI=%%D"
                )
            )
        )
    )
)

if not defined USER_HOUDINI (
    echo No valid Houdini folder found matching houdini#.# format.
    goto done
)

echo Found highest Houdini folder: %USER_HOUDINI%

set "USER_TOOLBAR_DIR=%USER_HOUDINI%\toolbar"
set "ICONS_DEST=%USER_HOUDINI%\config\Icons"
set "SCRIPTS_DEST=%USER_HOUDINI%\scripts"

:: ===============================
:: REMOVE default.shelf + toolbar folder
:: ===============================
echo.
echo Cleaning user toolbar folder...

if exist "%USER_TOOLBAR_DIR%\default.shelf" (
    del "%USER_TOOLBAR_DIR%\default.shelf" /f >nul
    echo Removed: default.shelf
) else (
    echo default.shelf not found.
)

if exist "%USER_TOOLBAR_DIR%" (
    rmdir "%USER_TOOLBAR_DIR%" /s /q
    echo Removed toolbar folder.
) else (
    echo Toolbar folder not found.
)

:: ===============================
:: REMOVE ICONS
:: ===============================
echo Removing icons...
del "%ICONS_DEST%\artprooftool_*.png" /f >nul 2>&1

:: ===============================
:: REMOVE GLOBAL INSTALL FILES
:: ===============================
echo Removing global shelf + definitions...

for /d %%H in ("C:\Program Files\Side Effects Software\Houdini *") do (
    del "%%H\houdini\toolbar\ArtProofTool.shelf" /f >nul 2>&1
    del "%%H\houdini\scripts\artprooftool_*.json" /f >nul 2>&1
)

:done
echo.
echo Uninstall complete.
pause
exit /b
