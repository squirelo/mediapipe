#!/bin/bash

# Create output directory if it doesn't exist
mkdir -p ./docker_output

# Build the Docker image
echo "Building Docker image for MediaPipe Unreal build..."
docker build -t mediapipe-unreal-builder .

# Run the Docker container with source and output directories mounted
echo "Running build in Docker container..."
docker run --rm \
  -v "$(pwd):/mediapipe" \
  -v "$(pwd)/docker_output:/output" \
  mediapipe-unreal-builder

echo "Build process completed. Check the ./docker_output directory for build artifacts." 