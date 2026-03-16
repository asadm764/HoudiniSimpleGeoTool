:: ===============================
:: AUTO-ELEVATE TO ADMIN
:: ===============================
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ===============================
:: LIST AND DETECT HOUDINI VERSIONS
:: ===============================
echo Detected Houdini installations:
powershell -NoProfile -Command "Get-ChildItem -Path 'C:\Program Files\Side Effects Software' -Directory | Where-Object { $_.Name -like 'Houdini *' } | ForEach-Object { ' - ' + $_.Name }"
echo.

:: Get the full latest version
for /f "usebackq delims=" %%V in (`powershell -NoProfile -Command "Get-ChildItem -Path 'C:\Program Files\Side Effects Software' -Directory | Where-Object { $_.Name -like 'Houdini *' } | ForEach-Object { $_.Name -replace 'Houdini ', '' } | Sort-Object {[Version]$_} -Descending | Select-Object -First 1"`) do (
    set "version_found=%%V"
)

if not defined version_found (
    powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('No Houdini installations found in Program Files.', 'Installer', 'OK', 'Warning')"
    exit /b
)

set "HOUDINI_VERSION=%version_found%"
echo Selected latest Houdini version: %HOUDINI_VERSION%
echo.

:: Extract major.minor version (like 20.5)
for /f "tokens=1,2 delims=." %%a in ("%HOUDINI_VERSION%") do (
    set "HOUDINI_MAJOR=%%a"
    set "HOUDINI_MINOR=%%b"
)

:: Set paths using the full version
set "INSTALL_DIR=C:\Program Files\Side Effects Software\Houdini %HOUDINI_VERSION%\houdini"
set "TOOLBAR_DIR=%INSTALL_DIR%\toolbar"
set "SHELFDEFS_DIR=%INSTALL_DIR%\scripts"
set "SCRIPT_DIR=%~dp0"
set "SHELF_FILE=%SCRIPT_DIR%ArtProofTool.shelf"
set "ICONS_SRC=%SCRIPT_DIR%icons"
set "SHELFDEFS_SRC=%SCRIPT_DIR%shelfdefinitions"
set "ICONS_DEST=%USERPROFILE%\Documents\houdini%HOUDINI_MAJOR%.%HOUDINI_MINOR%\config\Icons"
set "SCRIPTS_DEST=%USERPROFILE%\Documents\houdini%HOUDINI_MAJOR%.%HOUDINI_MINOR%\scripts"
set "STARTUP_SCRIPT=%SCRIPT_DIR%456.py"
set "HOUDINI_EXE=C:\Program Files\Side Effects Software\Houdini %HOUDINI_VERSION%\bin\houdini.exe"

:: ===============================
:: CHECK FOR HOUDINI INSTALL DIR
:: ===============================
if not exist "%INSTALL_DIR%" (
    powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Houdini %HOUDINI_VERSION% not found. Please install Houdini first.', 'Installer', 'OK', 'Warning')"
    exit /b
)

:: ===============================
:: INSTALL SHELF FILE
:: ===============================
if not exist "%TOOLBAR_DIR%" (
    mkdir "%TOOLBAR_DIR%"
)
copy "%SHELF_FILE%" "%TOOLBAR_DIR%" /Y >nul

:: ===============================
:: INSTALL ICONS TO USER FOLDER
:: ===============================
if exist "%ICONS_SRC%" (
    if not exist "%ICONS_DEST%" (
        mkdir "%ICONS_DEST%"
    )
    xcopy "%ICONS_SRC%\*" "%ICONS_DEST%\" /Y /I >nul
)

:: ===============================
:: OVERWRITE SHELFDEFINITIONS
:: ===============================
if exist "%SHELFDEFS_SRC%" (
    if not exist "%SHELFDEFS_DIR%" (
        mkdir "%SHELFDEFS_DIR%"
    )
    xcopy "%SHELFDEFS_SRC%\*" "%SHELFDEFS_DIR%\" /Y /E /I >nul
)

:: ===============================
:: INSTALL SUCCESS MESSAGE
:: ===============================
powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('ArtProofTool installed successfully into Houdini %HOUDINI_VERSION%.', 'Installer', 'OK', 'Information')"

:: ===============================
:: AUTO-LAUNCH HOUDINI
:: ===============================
if exist "%HOUDINI_EXE%" (
    start "" "%HOUDINI_EXE%"
) else (
    powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Installed successfully, but could not find Houdini.exe to launch.', 'Installer', 'OK', 'Warning')"
)