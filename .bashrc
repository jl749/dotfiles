# appended contents via `cat .bashrc >> ~/.bashrc`

# some useful xargs commands
# docker image ls -a | tail -n +2 | awk '{print $3}' | xargs docker image rm
# ps aux | grep CLIKA/bin/python | awk '{print $2}' | xargs kill -9

# PS1 definition
# \t = Time (HH:MM:SS)
# \u = Username
# \w = Current Directory
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\e[36m\][\t] \[\e[32m\]<\u> \[\e[34m\]\w\[\e[91m\]\$(parse_git_branch)\[\e[0m\] \$ "

# set envs
export CUDA_VISIBLE_DEVICES=0
export CUDA_HOME=/usr/local/cuda
export PATH=$PATH:$CUDA_HOME/bin
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# gpu utils
function gpu_who() {
  nvidia-smi | tr -s ' '| grep -Eo " | [0123456789]+ N/A N/A [0-9]{3,} .*" | \
      awk -F' ' '{system("s=$(cat /proc/"$4"/cmdline| tr \"\\0\" \" \");u=$(ps -o uname= -p "$4");echo "$1"sep"$4"sep$u sep"$7"sep$s" ) }' | \
      sed 's/sep/\t/g'
}

# python utils
function del_pycache() {
  find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
}
