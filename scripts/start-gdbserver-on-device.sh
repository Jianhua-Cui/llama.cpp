#!/usr/bin/env bash
set -ex

push_only=0
if [ -n "$1" ]; then
    push_only=$1
fi

DEVICE_DIR="/data/local/tmp/cjh"
DEVICE_IP_PORT="192.168.31.167:8848"
EXECUTABLE="llama-cli"
TARGET_ARGS="-m '/data/local/tmp/cjh/Qwen__Qwen2.5-1.5B-Instruct-Q4_0.gguf' -p '成都是一座' -n 256"

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
adb push ${WORK_DIR}/build/bin/${EXECUTABLE} ${DEVICE_DIR}/

adb shell "chmod +x ${DEVICE_DIR}/gdbserver"
adb shell "chmod +x ${DEVICE_DIR}/${EXECUTABLE}"
echo -e "\033[32mUse target remote ${DEVICE_IP_PORT} in GDB to connect to device\033[0m"

if [ $push_only -eq 0 ]; then
    # 这里使用 sh -c 来处理复杂的命令和参数
    adb exec-out "sh -c 'cd ${DEVICE_DIR}; export LD_LIBRARY_PATH=./; ./gdbserver ${DEVICE_IP_PORT} ./${EXECUTABLE} ${TARGET_ARGS}'"
fi
