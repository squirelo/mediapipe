@echo off
bazel build -c opt --define MEDIAPIPE_DISABLE_GPU=1 --action_env PYTHON_BIN_PATH="C:\\Python39\\python.exe" mediapipe/unreal:ump_shared 