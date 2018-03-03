#!/bin/bash

sudo apt-get install \
    build-essential \
    cmake \
    cython \
    doxygen \
    freeglut3-dev \
    git-core \
    git-core \
    graphviz \
    libusb-1.0-0-dev \
    libxi-dev \
    libxmu-dev \
    pkg-config \
    python3.6-dev \

git submodule init
git submodule update

export CXX=g++-4.8

(cd kinect/OpenNI/Platform/Linux/CreateRedist && ./RedistMaker)
(cd kinect/OpenNI/Platform/Linux/Redist/OpenNI-Bin-Dev-Linux-x64-v1.5.7.10 && sudo ./install.sh)

(cd kinect/SensorKinect/Platform/Linux/CreateRedist && ./RedistMaker)
(cd kinect/SensorKinect/Platform/Linux/Redist/Sensor-Bin-Linux-x64-v5.1.2.1 && sudo ./install.sh)

(cd kinect/NITE && sudo ./install.sh)
