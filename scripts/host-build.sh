#!/usr/bin/env bash
set -ex

SRC_DIR=$(readlink -f "`dirname $0`")
echo "SRC_DIR: ${SRC_DIR}"
cd $(dirname ${SRC_DIR})

CMAKE_PARA_LLAMA="-DGGML_OPENMP=OFF \
    -DGGML_LLAMAFILE=OFF "

CMAKE_PARA=" -DCMAKE_INSTALL_PREFIX=$(dirname ${SRC_DIR})/host_install \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS=-O3 \
    -DCMAKE_CXX_FLAGS=-O3 \
    -DBUILD_SHARED_LIBS=OFF \
    -G Ninja"

CMAKE_PARA="${CMAKE_PARA} ${CMAKE_PARA_LLAMA}"

if [ ! -d "host_build" ]; then
    mkdir host_build && cd host_build
else
    cd host_build
fi

cmake ${CMAKE_PARA} .. 
ninja install 