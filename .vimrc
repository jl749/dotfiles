" ~/.vimrc
" Plugin-free vim that behaves like .config/nvim (and etc/nixos/modules/editor/nvim/init.lua).

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Neovim defaults that vim does not have (see :h vim-differences)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
syntax enable

set encoding=utf-8
set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set display=lastline
set formatoptions=tcqj
set hidden
set history=10000
set hlsearch
set incsearch
set laststatus=2
set listchars=tab:>\ ,trail:-,nbsp:+
set nrformats=bin,hex
set ruler
set shortmess+=F
set showcmd
set sidescroll=1
set smarttab
set nostartofline
set switchbuf=uselast
set tabpagemax=50
set ttimeout ttimeoutlen=50
set wildmenu
set wildoptions=pum,tagfile

" Y yanks to end of line, & repeats :s with flags, <C-u>/<C-w> are undoable in insert mode
nnoremap Y y$
nnoremap & :&&<CR>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" nvim only has these with autocmds on; keep them grouped so re-sourcing doesn't stack them
augroup vimrc
  autocmd!
  autocmd FocusGained,BufEnter * silent! checktime
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options (kept in sync with .config/nvim/lua/options.lua)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ' '
let maplocalleader = ' '

" vim built without +clipboard keeps yanks local; the option is still set for builds that have it
if has('clipboard')
  set clipboard=unnamedplus
endif

set number
set relativenumber
set signcolumn=yes
set tabstop=2
set shiftwidth=2
set expandtab
set updatetime=300
set mouse=

" t_8f/t_8b are what make truecolor survive tmux (needs terminal-features ",*:RGB", see .tmux.conf)
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if has('terminal')
  tnoremap <Esc> <C-\><C-n>
endif

nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>

set background=dark
colorscheme desert


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Built-in stand-ins for the nvim plugin maps (telescope)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set path+=**
set wildignore+=*/.git/*,*/__pycache__/*,*.o,*.pyc
nnoremap <leader>ff :find<Space>
nnoremap <leader>fg :vimgrep //j **<Left><Left><Left><Left><Left>
nnoremap <leader>fb :ls<CR>:buffer<Space>
nnoremap <leader>fh :help<Space>
