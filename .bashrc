# appended contents via `cat .bashrc >> ~/.bashrc`

# some useful xargs commands
# docker image ls -a | tail -n +2 | awk '{print $3}' | xargs docker image rm
# ps aux | grep CLIKA/bin/python | awk '{print $2}' | xargs kill -9

# PS1 definition
# \t = Time (HH:MM:SS)
# \u = Username
# \w = Current Directory
parse_git_branch() {
  local ref
  ref=$(git symbolic-ref --short HEAD 2> /dev/null) \
    || ref=$(git rev-parse --short HEAD 2> /dev/null) \
    || return
  printf ' (%s)' "$ref"
}
export PS1="\[\e[36m\][\t] \[\e[32m\]<\u> \[\e[34m\]\w\[\e[91m\]\$(parse_git_branch)\[\e[0m\] \$ "

if [ -d /usr/local/cuda ]; then
  export CUDA_VISIBLE_DEVICES=0
  export CUDA_HOME=/usr/local/cuda
  export PATH="$PATH:$CUDA_HOME/bin"
  export LD_LIBRARY_PATH="$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi

if command -v nvim > /dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
fi

# gpu utils
function gpu_who() {
  local -A gpu_index
  local idx uuid pid mem user cmd

  while IFS=, read -r idx uuid; do
    gpu_index[${uuid# }]=$idx
  done < <(nvidia-smi --query-gpu=index,gpu_uuid --format=csv,noheader)

  while IFS=, read -r uuid pid mem; do
    read -r user cmd < <(ps -o uname=,args= -p "${pid# }")
    printf '%s\t%s\t%s\t%s\t%s\n' \
      "${gpu_index[${uuid# }]}" "${pid# }" "$user" "${mem# }" "$cmd"
  done < <(nvidia-smi --query-compute-apps=gpu_uuid,pid,used_gpu_memory --format=csv,noheader)
}

# python utils
function del_pycache() {
  find . \( -name '__pycache__' -o -name '*.py[co]' \) -prune -exec rm -rf {} +
}
