#!/usr/bin/env bash
set -ex

DEVICE_GDB_PATH="/data/data/com.termux/files/usr/bin/gdb"
DEVICE_WORK_DIR="/data/local/tmp/cjh"
TARGET_ARGS="-m /data/local/tmp/cjh/Qwen__Qwen2.5-1.5B-Instruct-Q8_0.gguf -p 请介绍一下成都这座城市 -n 256"

export LD_LIBRARY_PATH=./
cd ${DEVICE_WORK_DIR}

${DEVICE_GDB_PATH} --args ./llama-cli ${TARGET_ARGS}