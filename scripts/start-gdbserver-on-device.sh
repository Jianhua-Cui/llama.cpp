#!/usr/bin/env bash
set -ex

DEVICE_DIR="/data/local/tmp/cjh"
DEVICE_IP_PORT="192.168.31.44:8848"
TARGET_ARGS="-m '/data/local/tmp/cjh/model-74701a8c35f6.gguf' -p 'You are llama3.2 1b' -cnv"

SRC_DIR=$(readlink -f "`dirname $0`")
WORK_DIR=$(dirname ${SRC_DIR})
echo "WORK_DIR: ${WORK_DIR}"
cd ${WORK_DIR}

# check NDK_ROOT env variable
if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "Please set ANDROID_NDK_HOME environment variable"
    exit 1
else
    echo "use $ANDROID_NDK_HOME to build for android"
fi

adb push --sync $ANDROID_NDK_HOME/prebuilt/android-arm64/gdbserver/gdbserver ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/bin/llama-cli ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/src/libllama.so ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/examples/llava/libllava_shared.so ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/ggml/src/libggml.so ${DEVICE_DIR}/

adb shell "chmod +x ${DEVICE_DIR}/gdbserver"
adb shell "chmod +x ${DEVICE_DIR}/llama-cli"
echo -e "\033[32mUse target remote ${DEVICE_IP_PORT} in GDB to connect to device\033[0m"

# 这里使用 sh -c 来处理复杂的命令和参数
adb exec-out "sh -c 'cd ${DEVICE_DIR}; export LD_LIBRARY_PATH=./; ./gdbserver ${DEVICE_IP_PORT} ./llama-cli ${TARGET_ARGS}'"
