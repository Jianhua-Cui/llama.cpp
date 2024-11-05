#!/usr/bin/env bash
set -ex

SRC_DIR=$(readlink -f "`dirname $0`")
echo "SRC_DIR: ${SRC_DIR}"
cd $(dirname ${SRC_DIR})

CMAKE_PARA_LLAMA="-DGGML_OPENMP=OFF \
    -DGGML_LLAMAFILE=OFF "

CMAKE_PARA=" -DCMAKE_INSTALL_PREFIX=$(dirname ${SRC_DIR})/host_install \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_FLAGS=-O3 \
    -DCMAKE_CXX_FLAGS=-O3 \
    -G Ninja"

CMAKE_PARA="${CMAKE_PARA} ${CMAKE_PARA_LLAMA}"

if [ ! -d "build" ]; then
    mkdir build && cd build
else
    cd build
fi

cmake ${CMAKE_PARA} .. 
ninja install 