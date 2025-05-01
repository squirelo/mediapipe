# Building MediaPipe for Unreal with Docker

This guide will help you build the MediaPipe Unreal plugin using Docker on Windows. This approach avoids the need to install bazel and all the dependencies on your local machine.

## Prerequisites

1. Install Docker Desktop for Windows: https://www.docker.com/products/docker-desktop
2. Ensure Docker is running in Linux container mode
3. Make sure you have at least 8GB of RAM and 20GB of free disk space

## Building Steps

1. Open a PowerShell or Command Prompt window in this directory
2. Run the build script:
   ```
   .\build_with_docker.bat
   ```
   This will:
   - Build the Docker image with all required dependencies
   - Run the container to compile MediaPipe for Unreal
   - Output the build artifacts to the `docker_output` directory

3. After the build completes, run the copy script to move the files to your Unreal project:
   ```
   .\copy_artifacts.bat
   ```
   Note: You may need to edit `copy_artifacts.bat` to set the correct path to your Unreal project.

## Troubleshooting

If you encounter Docker-related issues:
- Make sure Docker is running
- Check that you have sufficient disk space
- Try increasing Docker's memory allocation in Docker Desktop settings

If you encounter build failures:
- Check the console output for specific error messages
- Make sure you have the latest MediaPipe code
- Try cleaning the Docker environment: `docker system prune -a`

## Manual Docker Commands

If you need more control, you can run the Docker commands manually:

```
# Build the Docker image
docker build -t mediapipe-unreal-builder .

# Run the container
docker run --rm -v "%cd%:/mediapipe" -v "%cd%\docker_output:/output" mediapipe-unreal-builder
``` 