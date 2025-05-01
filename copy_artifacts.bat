@echo off
REM Script to copy built artifacts from Docker output to Unreal project location

echo Copying MediaPipe build artifacts...

REM Update these paths to match your Unreal project location
set UNREAL_PROJECT_PATH=..\UE4MediaPipeProject\Plugins\MediaPipe\Source\ThirdParty
set INCLUDE_PATH=%UNREAL_PROJECT_PATH%\include
set LIB_PATH=%UNREAL_PROJECT_PATH%\lib\Win64

REM Create directory structure if it doesn't exist
if not exist "%INCLUDE_PATH%" mkdir "%INCLUDE_PATH%"
if not exist "%LIB_PATH%" mkdir "%LIB_PATH%"

REM Copy header files and libraries
if exist docker_output\include (
  xcopy /y /s /i docker_output\include\* "%INCLUDE_PATH%\"
  echo Copied header files
) else (
  echo Warning: Include directory not found in build output
)

if exist docker_output\lib (
  xcopy /y docker_output\lib\*.* "%LIB_PATH%\"
  echo Copied libraries
) else (
  echo Warning: Library files not found in build output
)

echo Done. 