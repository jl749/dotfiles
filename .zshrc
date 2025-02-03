# appended contents via `cat .zshrc >> ~/.zshrc`

function del_pycache() {find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf}

# some useful xargs commands
# docker image ls -a | tail -n +2 | awk '{print $3}' | xargs docker image rm
# ps aux | grep CLIKA/bin/python | awk '{print $2}' | xargs kill -9

# CUDA related
export CUDA_VISIBLE_DEVICES=0
export CUDA_HOME=/usr/local/cuda
export PATH="$PATH:$CUDA_HOME/bin"
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:$LD_LIBRARY_PATH
alias trtexec="/usr/src/tensorrt/bin/trtexec"
function gpu_who() {(nvidia-smi |tr -s ' '|grep -Eo "| [0123456789]+ N/A N/A [0-9]{3,} .*"|awk -F' ' '{system("s=$(cat /proc/"$4"/cmdline| tr \"\\0\" \" \");u=$(ps -o uname= -p "$4");echo "$1"sep"$4"sep$u sep"$7"sep$s" ) }'|sed 's/sep/\t/g')}


# ANDROID related
export ANDROID_NDK_VERSION="23.1.7779620"
alias adb="~/Android/Sdk/platform-tools/adb"
alias aarch64-linux-android31-clang++=~/Android/Sdk/ndk/${ANDROID_NDK_VERSION}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android31-clang++

# PYTHON related
function del_pycache() {find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf}
