#!/usr/bin/env bash
set -ex

BUILD_TYPE="Release"
if [ -n "$1" ]; then
    BUILD_TYPE=$1
fi
echo "BUILD_TYPE: ${BUILD_TYPE}"

SRC_DIR=$(readlink -f "`dirname $0`")
echo "SRC_DIR: ${SRC_DIR}"
cd $(dirname ${SRC_DIR})

# check NDK_ROOT env variable
if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "Please set ANDROID_NDK_HOME environment variable"
    exit 1
else
    echo "use $ANDROID_NDK_HOME to build for android"
fi

CMAKE_PARA_ANDROID="-DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake \
    -DANDROID_NDK=${ANDROID_NDK_HOME} \
    -DGGML_OPENMP=OFF \
    -DGGML_LLAMAFILE=OFF \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_TOOLCHAIN=clang++ \
    -DANDROID_PLATFORM=android-28 \
    -DBUILD_SHARED_LIBS=OFF"

if [ "${BUILD_TYPE}" == "Release" ]; then
    CMAKE_PARA=" -DCMAKE_INSTALL_PREFIX=$(dirname ${SRC_DIR})/install \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_FLAGS='-O3' \
        -DCMAKE_CXX_FLAGS='-O3' \
        -G Ninja"
else
    # For Debug build, add -O0 and -g for debugging
    CMAKE_PARA=" -DCMAKE_INSTALL_PREFIX=$(dirname ${SRC_DIR})/install \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_C_FLAGS_DEBUG='-O0' \
        -DCMAKE_CXX_FLAGS_DEBUG='-O0' \
        -G Ninja"
fi

CMAKE_PARA="${CMAKE_PARA} ${CMAKE_PARA_ANDROID}"

if [ ! -d "build" ]; then
    mkdir build && cd build
else
    cd build
fi

cmake ${CMAKE_PARA} .. 
ninja install -v
