# Copyright 2019 The MediaPipe Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:18.04

LABEL maintainer="mediapipe@google.com"

WORKDIR /io
WORKDIR /mediapipe

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        gcc-8 g++-8 \
        ca-certificates \
        curl \
        ffmpeg \
        git \
        wget \
        unzip \
        python3-dev \
        python3-opencv \
        python3-pip \
        libopencv-core-dev \
        libopencv-highgui-dev \
        libopencv-imgproc-dev \
        libopencv-video-dev \
        libopencv-calib3d-dev \
        libopencv-features2d-dev \
        software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && apt-get install -y openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 --slave /usr/bin/g++ g++ /usr/bin/g++-8
RUN pip3 install --upgrade setuptools
RUN pip3 install wheel
RUN pip3 install future
RUN pip3 install six==1.14.0
RUN pip3 install protobuf==3.19.6
RUN pip3 install tensorflow==1.14.0
RUN pip3 install tf_slim

RUN ln -s /usr/bin/python3 /usr/bin/python

# Install bazel 3.7.2
RUN apt-get update && apt-get install -y curl gnupg && \
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel-archive-keyring.gpg && \
    mv bazel-archive-keyring.gpg /usr/share/keyrings/bazel-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | \
    tee /etc/apt/sources.list.d/bazel.list && \
    apt-get update && \
    apt-get install -y bazel-3.7.2 && \
    ln -s /usr/bin/bazel-3.7.2 /usr/bin/bazel && \
    bazel version

COPY . /mediapipe/

# If we want the docker image to contain the pre-built object_detection_offline_demo binary, do the following
# RUN bazel build -c opt --define MEDIAPIPE_DISABLE_GPU=1 mediapipe/examples/desktop/demo:object_detection_tensorflow_demo

# Command to build the MediaPipe Unreal plugin and copy artifacts to /output
CMD ["bash", "-c", "cd /mediapipe && bazel build -c opt --define MEDIAPIPE_DISABLE_GPU=1 --action_env PYTHON_BIN_PATH=/usr/bin/python3 mediapipe/unreal:ump_shared && mkdir -p /output/include /output/lib && cp -r bazel-bin/mediapipe/unreal/include/* /output/include/ && cp bazel-bin/mediapipe/unreal/ump_shared.* /output/lib/"]
