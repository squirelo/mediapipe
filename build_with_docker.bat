@echo off
REM Create output directory if it doesn't exist
if not exist docker_output mkdir docker_output

REM Build the Docker image
echo Building Docker image for MediaPipe Unreal build...
docker build -t mediapipe-unreal-builder .

REM Run the Docker container with source and output directories mounted
echo Running build in Docker container...
docker run --rm ^
  -v "%cd%:/mediapipe" ^
  -v "%cd%\docker_output:/output" ^
  mediapipe-unreal-builder

echo Build process completed. Check the ./docker_output directory for build artifacts. 