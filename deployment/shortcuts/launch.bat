@echo off

:: This bat file should always be located in /plugin_root_path/Content/launch.bat
:: This script will launch Maya with the environment variable pointing to our plugin folder.
:: Maya version can be specified as the first argument of the is bat file (%~1)
:: If no argument is given we ask through a prompt.

SET MAYA_VERSION=%~1

if "%MAYA_VERSION%"=="" ( goto ask_version ) else ( goto end_ask )

:: No argument we ask the user which Maya version he whishes to launch:
:ask_version
echo.
echo.
echo Maya version (input year 2014/2015/2016/2016.5/2017/2018)
:repeat_maya_version
set /p INPUT=": "
if not "%INPUT%"=="2014" (
if not "%INPUT%"=="2015" (
if not "%INPUT%"=="2016" (
if not "%INPUT%"=="2016.5" (
if not "%INPUT%"=="2017" (
if not "%INPUT%"=="2018" (
    echo Unsupported version, please input: 2014, 2015, 2016, 2016.5, 2017, 2018
    goto :repeat_maya_version
))))))
set MAYA_VERSION=%INPUT%
:end_ask

echo Setting maya version to: %MAYA_VERSION%

SET root_folder=%~dp0\%MAYA_VERSION%
SET SWE_SAMPLE_PATH=%~dp0\..\samples\
SET MAYA_SHELF_PATH=%MAYA_SHELF_PATH%;%root_folder%\prefs\shelves
SET MAYA_SCRIPT_PATH=%MAYA_SCRIPT_PATH%;%root_folder%\scripts
SET PYTHONPATH=%PYTHONPATH%;%root_folder%\scripts
SET XBMLANGPATH=%XBMLANGPATH%;%root_folder%\prefs\icons
SET MAYA_PLUG_IN_PATH=%MAYA_PLUG_IN_PATH%;%root_folder%\plug-ins

SET MAYA_PATH="%ProgramFiles%\Autodesk\Maya%MAYA_VERSION%\bin\"

if not exist "%MAYA_PATH:"=%\maya.exe" (
    echo !! Could not find %MAYA_PATH:"=%\maya.exe !!
    pause
    exit
)

start /d %MAYA_PATH% maya.exe

