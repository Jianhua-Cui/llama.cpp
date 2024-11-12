#!/usr/bin/env bash
set -ex

DEVICE_DIR="/data/local/tmp/cjh"
TARGET_ARGS="-m '/data/local/tmp/cjh/Qwen__Qwen2.5-1.5B-Instruct-Q8_0.gguf' -p '请介绍一下成都这座城市' -n 256"

SRC_DIR=$(readlink -f "`dirname $0`")
WORK_DIR=$(dirname ${SRC_DIR})
echo "WORK_DIR: ${WORK_DIR}"
cd ${WORK_DIR}

adb push --sync ${WORK_DIR}/scripts/device-gdb-start.sh ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/bin/llama-cli ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/src/libllama.so ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/examples/llava/libllava_shared.so ${DEVICE_DIR}/
adb push ${WORK_DIR}/build/ggml/src/libggml.so ${DEVICE_DIR}/

adb shell "chmod +x ${DEVICE_DIR}/llama-cli"
adb shell "chmod +x ${DEVICE_DIR}/device-gdb-start.sh"
echo -e "Use \033[32mcd ${DEVICE_DIR}; sh ./device-gdb-start.sh\033[0m in adb shell"

