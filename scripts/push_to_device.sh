set -ex

SRC_DIR=$(readlink -f "`dirname $0`")
PROJECT_DIR=$(dirname ${SRC_DIR})

adb push ${PROJECT_DIR}/install/bin/llama-cli /data/local/tmp/cjh/
adb push ${PROJECT_DIR}/install/lib/libllama.so /data/local/tmp/cjh/
adb push ${PROJECT_DIR}/install/lib/libggml.so /data/local/tmp/cjh/
adb push ${PROJECT_DIR}/install/lib/libllava_shared.so /data/local/tmp/cjh/

adb shell "chmod +x /data/local/tmp/cjh/llama-cli"