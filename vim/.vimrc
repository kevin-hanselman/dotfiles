set nocompatible            " be iMproved
filetype off                " required!
filetype plugin indent on   " required!

" ------------------------------------------
" General options
" ------------------------------------------
" misc
let mapleader=' '                   " change the leader key to the space bar
set clipboard=unnamedplus           " use OS clipboard as default yank buffer
set history=1000                    " remember a ton of commands
set backspace=indent,eol,start      " backspace over everything
set spell                           " enable spell-check
set encoding=utf-8                  " sensible default encoding
                                    " (utf-8 now so listchars and showbreak work)

" whitespace and indentation
set tabstop=4                       " a tab is four spaces.
set shiftwidth=4                    " N spaces while autoindenting
set softtabstop=4                   " N spaces while editing (deletes groups of N spaces)
set expandtab                       " insert spaces instead of tabs
set smartindent                     " seems to do a decent job with indenting
set list                            " show whitespace indicated by 'listchars'
set listchars=tab:»\ ,trail:·,extends:…

" UI
syntax enable                       " syntax highlighting
if (has("termguicolors"))           " Use fg/bg colors from terminal (compatible terminals only)
  set termguicolors
endif
set mouse=a                         " allow for better mouse interaction
set scrolloff=5                     " always show N lines vertically
set sidescroll=10                   " always show N chars horizontally
set cursorline                      " highlight the line the cursor is on
set number                          " show line numbers
set relativenumber                  " number gutter shows line number as relative to current
set virtualedit=block               " virtual-block mode can expand beyond EOL
set ruler                           " show line number, column number, % of file, etc.
set laststatus=2                    " always show status bar
set shortmess+=I                    " no message on empty vim startup
set splitbelow                      " show splits to right or below, as you would read
set splitright                      " ^
set wildmenu                        " improve auto complete menu
set wildmode=list:longest,full      " filename completion
set ttyfast                         " faster, smoother redraw

" line wrapping
set textwidth=0                     " don't split lines (in the actual file) when they're too long
set wrap                            " wrap lines in the vim buffer, but not in the actual file
set linebreak                       " ^^, and break on WORDs, not characters
set showbreak=\ \ …                 " prepend these chars to lines broken by linebreak
set formatoptions+=jrn1             " see :h fo-table
set colorcolumn=100                 " highlight the preferred EOL column

" buffers
set hidden                          " don't delete buffers, just hide them
set undofile                        " save undo tree when file is closed
set undodir=~/.vim/undo             " undo files should be kept out of the working dir
set undolevels=1000                 " many many levels of undo
set backup                          " use backup files
set backupdir=~/.vim/backup         " backup files should be kept out of the working dir
set directory=~/.vim/tmp            " swapfiles should be kept out of the working dir

" searching
set smartcase                       " ignore case in a search until there is some capitalization
set ignorecase                      " needed for smartcase
set gdefault                        " s///g is implied, explicitly adding g negates effect
set incsearch                       " jump to the first instance as you type the search term
set showmatch                       " always show matching ()'s
set hlsearch                        " Highlight all of the search terms
set tags=./.tags,.tags              " look for a tag file first in the current file's directory,
                                    " then in Vim's CWD

" ------------------------------------------
" Plugins
" ------------------------------------------

if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
    set background=dark
    colorscheme base16-phd
    " To have (neo)vim use the terminal's background:
    "hi Normal guibg=NONE ctermbg=NONE
    "hi SignColumn guibg=NONE ctermbg=NONE
else
    colorscheme slate
endif

if has("gui_running")
    set guioptions=a
    set guifont="Envy Code R 10"

    " set normal, visual, selection cursor to an underline N% of the
    " character height
    set guicursor+=n-v-c:hor10-Cursor

    command! SetFont set guifont=*
else
    " for VTE compatible terms, change insert mode cursor to a vertical bar
    " see: http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
    if &term =~ 'xterm.*\|rxvt.*\|gnome-terminal\|st'
        let &t_SI = "\<Esc>[6 q"
        let &t_EI = "\<Esc>[4 q"
    endif
endif

" neovim terminal mappings
if has("nvim")
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l
    tnoremap <leader>L ls<CR>
    tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
    autocmd TermOpen * set nonumber norelativenumber nospell
endif

" ------------------------------------------
" Mappings
" ------------------------------------------

" reload this file
nnoremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" for global replace
nnoremap <leader>R *N:%s/<C-R>///c<left><left>

" typing jj in insert mode gets you out.
inoremap jj <Esc>

" Y yanks to EOL (to match D and C)
nnoremap Y y$

" grow and shrink windows
map <M-=> 10<C-w>+
map <M--> 10<C-w>-
map <M-<> 10<C-w><
map <M->> 10<C-w>>

" vim training wheels: don't allow arrow keys!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" up/down movement shouldn't skip wrapped sections of lines
nnoremap j gj
nnoremap k gk

" keep cursor in middle of screen when jumping/scrolling
nmap <C-D> <C-D>zz
nmap <C-U> <C-U>zz
nmap n nzz
nmap N Nzz
nnoremap <C-i> <C-i>zz
nnoremap <C-o> <C-o>zz

" clear search highlighting
nnoremap c/ :noh<CR>

" remap f1. I'll type :help when I want it
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

" no ex-mode
nnoremap Q <nop>

" ------------------------------------------
" Functions, commands, and autocmds
" ------------------------------------------

autocmd Filetype html setlocal ts=2 sw=2 sts=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 sts=2 expandtab
autocmd Filetype lua setlocal ts=2 sw=2 sts=2 expandtab
autocmd Filetype json setlocal ts=2 sw=2 sts=2 expandtab
autocmd Filetype python setlocal colorcolumn=80 nosmartindent
autocmd Filetype markdown setlocal colorcolumn=80 tw=80
autocmd Filetype elixir setlocal colorcolumn=80 ts=2 sw=2 sts=2 expandtab nosmartindent
autocmd BufRead,BufNewFile *.exs set syntax=elixir

" Toggle between relative and absolute line numbers
function! LineNumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc
nnoremap <leader>n :call LineNumberToggle()<CR>

command! ShrinkMultipleNewlines %s/\n\{2,\}$/\r/e

command! TrimTrailingWhitespace %s/\s\+$//e

" Generate a ctags file (named so Vim will recognize it)
command! GenerateCtags :execute '!ctags -R --fields=+l -f ' . split(&tags, ',')[0] . ' .'
