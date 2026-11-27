# source from ~/.bashrc (re-runnable, and repo edits take effect without re-copying):
#   [ -f ~/GIT/dotfiles/.bashrc ] && . ~/GIT/dotfiles/.bashrc

# some useful xargs commands
# docker image ls -a | tail -n +2 | awk '{print $3}' | xargs docker image rm
# ps aux | grep '[p]ython train.py' | awk '{print $2}' | xargs kill -9
# find . -name '*.png' -print0 | xargs -0 -P "$(nproc)" -I {} sh -c 'cwebp -near_lossless 60 -z 9 -quiet "$1" -o "${1%.png}.webp" && rm "$1"' _ {}

# PS1 definition (not exported: only interactive bash understands these escapes)
# \t = Time (HH:MM:SS)
# \u = Username
# \w = Current Directory
parse_git_branch() {
	local ref
	ref=$(git symbolic-ref --short HEAD 2>/dev/null) ||
		ref=$(git rev-parse --short HEAD 2>/dev/null) ||
		return
	printf ' (%s)' "$ref"
}
PS1="\[\e[36m\][\t] \[\e[32m\]<\u> \[\e[34m\]\w\[\e[91m\]\$(parse_git_branch)\[\e[0m\] \$ "

# pin a GPU per job instead of globally, e.g. `CUDA_VISIBLE_DEVICES=0 python train.py`
if [ -d /usr/local/cuda ]; then
	export CUDA_HOME=/usr/local/cuda
	export PATH="$PATH:$CUDA_HOME/bin"
	export LD_LIBRARY_PATH="$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi

if command -v nvim >/dev/null 2>&1; then
	export EDITOR=nvim
	export VISUAL=nvim
fi

# gpu utils
gpu_who() {
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

# cache utils
# remove auto-regenerated caches under the current directory; `del_caches -n` lists them without deleting
del_caches() {
	local action=(-exec rm -rf {} +)
	[ "$1" = "-n" ] && action=(-print)
	find . -name .git -prune -o \( \
		-name '__pycache__' -o -name '*.py[co]' \
		-o -name '.pytest_cache' -o -name '.mypy_cache' -o -name '.ruff_cache' \
		-o -name '.ipynb_checkpoints' -o -name '.DS_Store' \
		\) -prune "${action[@]}"
}

# dotfiles utils
# commits follow `<scope>: update #N`, numbered per scope
#   dotup-status [scope...]   show changes and unpushed commits (all, or just those scopes)
#   dotup-update <scope...>   one commit per scope: `<scope>: update #<next>`
#   dotup-confirm          push the commits to the remote
#   dotup <scope>          update + confirm in one go
: "${DOTFILES:=$HOME/GIT/dotfiles}"

_dotup_path() {
	case $1 in
	nix) echo etc/nixos ;;
	nvim) echo .config/nvim ;;
	vimrc) echo .vimrc ;;
	tmux) echo .tmux.conf ;;
	bashrc) echo .bashrc ;;
	vscode) echo .config/Code ;;
	template) echo __nix_templates ;;
	precommit) echo .pre-commit-config.yaml ;;
	*)
		echo "unknown scope: '$1' (nix nvim vimrc tmux bashrc vscode template precommit)" >&2
		return 1
		;;
	esac
}

dotup-status() {
	local p=() unpushed s
	for s in "$@"; do
		p+=("$(_dotup_path "$s")") || return
	done
	[ ${#p[@]} -gt 0 ] && p=(-- "${p[@]}")
	echo "== changes"
	git -C "$DOTFILES" status --short "${p[@]}" | grep . || echo "(none)"
	# commits made by dotup-update that dotup-confirm hasn't pushed yet
	if unpushed=$(git -C "$DOTFILES" log --oneline '@{u}..HEAD' "${p[@]}" 2>/dev/null); then
		echo "== unpushed commits"
		echo "${unpushed:-(none)}"
	fi
}

dotup-update() {
	local s p n rc=0
	if [ $# -eq 0 ]; then
		echo "usage: dotup-update <scope...>" >&2
		return 1
	fi
	# check every scope first so a typo doesn't leave half of them committed
	for s in "$@"; do
		_dotup_path "$s" >/dev/null || return
	done
	for s in "$@"; do
		p=$(_dotup_path "$s")
		git -C "$DOTFILES" add -- "$p" || {
			rc=1
			continue
		}
		if git -C "$DOTFILES" diff --cached --quiet -- "$p"; then
			echo "no changes in $s ($p), skipped" >&2
			continue
		fi
		n=$(git -C "$DOTFILES" log --format=%s | sed -nE "s/^$s: ?update ?#([0-9]+)\$/\1/p" | sort -n | tail -1)
		# the pathspec keeps the commit to this scope even if other files are staged
		git -C "$DOTFILES" commit -m "$s: update #$((n + 1))" -- "$p" || rc=1
	done
	return $rc
}

dotup-confirm() {
	git -C "$DOTFILES" push
}

# dotup() {
# 	dotup-update "$1" && dotup-confirm
# }
