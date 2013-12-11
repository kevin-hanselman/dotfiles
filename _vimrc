"
" VIMRC
"

" TABS & SPACES
set shiftwidth=4
set tabstop=4
set expandtab                   " use spaces in place of tabs
set smarttab
set autoindent
set listchars=tab:▸\ ,trail:~
set list

" GENERAL
set backspace=indent,eol,start  " makes backspace key work
set autoread                    " read when file is changed externally
set wrap                        " line wrap
set number                      " show line numbers
set scrolloff=3                 " scrol when cursor is X lines from edge
syntax on                       " enable syntax highlighting
filetype plugin indent on       " enable filetype detection
set visualbell t_vb=            " no bell
set wildmenu                    " show a navigable menu for tab completion
set wildmode=longest,list,full
colorscheme elflord

" SEARCH & REPLACE
set hlsearch                    " highlight search matches
set incsearch                   " search as you type
" set wrapscan                    " automatically wrap search
set clipboard=unnamed           " yank and paste with the system clipboard
