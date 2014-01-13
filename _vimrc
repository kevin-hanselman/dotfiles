set nocompatible              " be iMproved
filetype off                  " required!
filetype plugin indent on     " required!

set t_Co=256                        "let terminal vim use 256 colors

if has("gui_running")
    set guioptions-=e  "or gui tabs
    set guioptions-=T  "no toolbars
    set guioptions-=m  "or menu
    set guioptions-=r  "or scrollbars
    set guioptions-=l  "or scrollbars
    set guifont=Consolas\ for\ Powerline\ 10
    set lines=999 columns=999
endif

" run bundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

    "plugin management
Bundle 'gmarik/vundle'

    "fancypants status line. note that the powerline patched fonts are installed and used above
Bundle 'bling/vim-airline'

    "nice motion plugin, relieves 'w' spam
Bundle 'Lokaltog/vim-easymotion'

    "file tree, hotkeyed to control-f below
Bundle 'scrooloose/nerdtree'

    " makes NERDTree feel like a true panel, independent of tabs.
Bundle 'jistr/vim-nerdtree-tabs'

    "syntax checking and reporting thanks to YCM integration
Bundle 'scrooloose/syntastic'

    "syntax autocompletion and intellisense. requires llvm/clang for c/c++
Bundle 'Valloric/YouCompleteMe'

    "adds a window that shows all of the functions in the current file
Bundle 'majutsushi/tagbar'

    "visual undo tree. nice for when you need to go back to a branch
Bundle 'sjl/gundo.vim'

    "ctrl-p for go to anything
Bundle 'kien/ctrlp.vim'

    "provides a method to switch between .h and .cpp
Bundle 'derekwyatt/vim-fswitch'

    "vim front end for 'the silver searcher' - an awfully named, incredibly fast search program (installation required)
Bundle 'rking/ag.vim'

    "provides hg/git change status in the left gutter
Bundle 'mhinz/vim-signify'

    " color schemes
Bundle 'tomasr/molokai'
Bundle 'altercation/vim-colors-solarized'
Bundle 'vim-scripts/jammy.vim'
Bundle 'vim-scripts/jellybeans.vim'
Bundle 'vim-scripts/chlordane.vim'
Bundle 'noah/vim256-color'

    "Improved C++ highlighting
Bundle 'octol/vim-cpp-enhanced-highlight'
Bundle 'SirVer/ultisnips'

    " Improved vim session management
"Bundle 'tpope/vim-obsession'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'

syntax enable
set clipboard=unnamed
set tabstop=4                       "a tab is four spaces.
set shiftwidth=4                    "four spaces for autoindenting
set softtabstop=4
set expandtab                       "Insert spaces instead of tabs
set shiftround                      "use multiple of shiftwidth for indenting

set encoding=utf-8
set smartindent                     "Seems to do a decent job with indenting
set scrolloff=3                     "always show 3 lines of code above/below cursor
set hidden                          "Dont delete buffers, just hide them. Lets us :e another file without having to s
set wildmenu                        "improve auto complete menu
set wildmode=list:longest           "when tab is pressed, show a list similar to ls
set cursorline                      "highlight the line the cursor is on
set ttyfast                         "it is fast, this aint no modem
set ruler
set backspace=indent,eol,start      "Backspace over everything
set laststatus=2                    "always show status bar
set number
set relativenumber                  "number gutter shows line number as relative to current
let mapleader = ","                 "change the leader key to comma
set undofile                        "save undo tree when file is closed
set undodir=~/.vim/undo             "undo files should be kept out of the working dir
set undolevels=1000                 "Many many levels of undo
set backup                          "backup files should be kept out of the working dir
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" tame searching
set ignorecase                      "better searching:
set smartcase                       "ignore case in a search until there is some capitalization
set gdefault                        "apply replaces globally, do have to add g to them anymore
set incsearch                       "Jump to the first instance as you type the search term
set showmatch                       "always show matching ()'s
set hlsearch                        "Highlight all of the search terms

" setup line wrapping
set wrap
set textwidth=119
set formatoptions=qrn1
set colorcolumn=120

" show unwanted whitespace
set list
set listchars=tab:»\ ,trail:·,extends:…
set showbreak=\ \ …
set background=dark
set history=1000                    "Remember a ton of commands
set mouse=a                         "Allow for better mouse interaction

colorscheme hybrid

let g:airline_powerline_fonts = 1
let g:airline_theme="murmur"
let g:airline#extensions#tabline#enabled = 1

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
let g:ycm_confirm_extra_conf = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" old vim-powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

map <C-n> :call NumberToggle()<cr>
map <C-f> :NERDTreeMirrorToggle<CR>
map <C-b> :TagbarToggle<CR>
map <C-g> :GundoToggle<CR>
map <A-o> :FSHere<CR>

" whenever a file is opened/switched to, find it in NERDTree
"autocmd BufEnter * if &modifiable | NERDTreeFind | wincmd p | endif

" override NERDtree-tabs autoclose when last file is closed
"let g:nerdtree_tabs_autoclose=0

" don't open nerdtree tab on startup, this messes with vim-session
let g:nerdtree_tabs_open_on_gui_startup=0

"let NERDTreeHijackNetrw=1

" if you're in an active session, save the session on vim exit
let g:session_autosave='yes'

" if you open vim with a --servername arg, load that session
let g:session_autoload='yes'

" typing jj in insert mode gets you out.
inoremap jj <Esc>
nnoremap JJJJ <Nop>

" ;w instead of :w, faster to type
"nnoremap ; :
" Easy window navigation
"map <C-h> <C-w>h
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-l> <C-w>l
" vim training wheels: dont allow arrow keys!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" fix direction keys for line wrap, other wise they jump over wrapped lines
nnoremap j gj
nnoremap k gk
"remap f1. I'll type :help when I want it
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

nnoremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
inoremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap Q <nop>

nnoremap <tab> :tabnext<CR>
nnoremap <S-tab> :tabNext<CR>

inoremap <C-o> :CtrlPTag<CR>
nnoremap <C-o> :CtrlPTag<CR>
vnoremap <C-o> :CtrlPTag<CR>

map <C-h> ^
imap <C-h> <Home>
map <C-l> $
imap <C-l> <End>

