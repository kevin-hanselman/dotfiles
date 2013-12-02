"
" VIMRC
"

set backspace=indent,eol,start " makes backspace key work

" TABS & SPACES
set shiftwidth=4
set tabstop=4
set expandtab   " use spaces in place of tabs
set smarttab
set autoindent
set listchars=tab:->,trail:~
set list

" GENERAL
set autoread    " read when file is changed externally
"set wrap       " line wrap
set number      " show line numbers
set scrolloff=3 " start scrolling when cursor is X lines from the top/bottom
syntax on       " enable syntax highlighting
filetype plugin indent on     " enable filetype detection
colorscheme elflord
set visualbell t_vb=    " no bell

" SEARCH & REPLACE
set hlsearch
set wrapscan

