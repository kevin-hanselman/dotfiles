set nocompatible            " be iMproved
filetype off                " required!
filetype plugin indent on   " required!

set t_Co=256                " let terminal vim use 256 colors

if has("gui_running")
    set guioptions=a
    " https://github.com/Lokaltog/powerline-fonts
    set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 12
    "set lines=999 columns=999
endif

" run vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

    " plugin management
Bundle 'gmarik/vundle'

    " fancypants status line. note that the powerline patched fonts are installed and used above
Bundle 'bling/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline_theme="base16"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0

    " nice motion plugin, relieves 'w' spam
Bundle 'Lokaltog/vim-easymotion'

    " file tree
Bundle 'scrooloose/nerdtree'
map <A-f> :NERDTreeFind<CR>

    " NERDTree syncs and plays better across tabs
Bundle 'jistr/vim-nerdtree-tabs'
map <C-f> :NERDTreeMirrorToggle<CR>
let g:nerdtree_tabs_open_on_gui_startup=0

    " syntax checking and reporting (YCM integration removed in Jan 2014)
Bundle 'scrooloose/syntastic'
let g:syntastic_cpp_compiler = 'gcc'

    " multi-cursors ala Sublime Text
"Bundle 'terryma/vim-multiple-cursors'

    " syntax autocompletion and intellisense. requires llvm/clang for c/c++
Bundle 'Valloric/YouCompleteMe'
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
let g:ycm_confirm_extra_conf = 0
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <C-]> :YcmCompleter GoTo<CR>
inoremap <C-]> :YcmCompleter GoTo<CR>

    " adds a window that shows all of the functions in the current file
Bundle 'majutsushi/tagbar'
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
map <C-b> :TagbarToggle<CR>

    " visual undo tree. nice for when you need to go back to a branch
Bundle 'sjl/gundo.vim'
map <C-g> :GundoToggle<CR>

    " ctrl-p for go to anything
Bundle 'kien/ctrlp.vim'
inoremap <M-p> :CtrlPTag<CR>
nnoremap <M-p> :CtrlPTag<CR>
vnoremap <M-p> :CtrlPTag<CR>

    " provides a method to switch between .h and .cpp
Bundle 'derekwyatt/vim-fswitch'
map <M-o> :FSHere<CR>

    " vim front end for 'the silver searcher' - an awfully named, incredibly fast search program (installation required)
Bundle 'rking/ag.vim'
let g:aghighlight = 1
nnoremap <M-/> :call SearchCurrentWord() <Bar> tabnew <Bar> AgFromSearch<CR>
inoremap <M-/> :call SearchCurrentWord() <Bar> tabnew <Bar> AgFromSearch<CR>

    " provides hg/git change status in the left gutter
Bundle 'mhinz/vim-signify'

    " shows function/variable signature on mouse-hover when available
Bundle 'vim-scripts/Tag-Signature-Balloons'

    " shows indent levels, handy for python code
Bundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
nnoremap <M-i> :IndentGuidesToggle<CR>
inoremap <M-i> :IndentGuidesToggle<CR>

    " colorschemes
"Bundle 'noah/vim256-color'     " this wasn't working :(
Bundle 'nanotech/jellybeans.vim'
Bundle 'flazz/vim-colorschemes'

    " improved vim session management
Bundle 'tpope/vim-obsession'
"Bundle 'xolox/vim-misc'
"Bundle 'xolox/vim-session'

    " handy shortcuts, buffer movement
"Bundle 'tpope/vim-unimpaired'

    " browse and manage open buffers
Bundle 'jlanzarotta/bufexplorer'

syntax enable
set clipboard=unnamedplus
set tabstop=4                       " a tab is four spaces.
set shiftwidth=4                    " four spaces for autoindenting
set softtabstop=4
set expandtab                       " Insert spaces instead of tabs
set shiftround                      " use multiple of shiftwidth for indenting

set encoding=utf-8
set smartindent                     " Seems to do a decent job with indenting
set scrolloff=5                     " always show N lines of code above/below cursor
set hidden                          " Dont delete buffers, just hide them. Lets us :e another file without having to s
set wildmenu                        " improve auto complete menu
set wildmode=list:longest           " when tab is pressed, show a list similar to ls
set cursorline                      " highlight the line the cursor is on
set ttyfast                         " it is fast, this aint no modem
set ruler
set backspace=indent,eol,start      " Backspace over everything
set laststatus=2                    " always show status bar
set number
set relativenumber                  " number gutter shows line number as relative to current
let mapleader = ","                 " change the leader key to comma
set virtualedit=block               " virtual-block edit can expand beyond EOL
set undofile                        " save undo tree when file is closed
set undodir=~/.vim/undo             " undo files should be kept out of the working dir
set undolevels=1000                 " Many many levels of undo
set backup                          " backup files should be kept out of the working dir
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

set noshowmode                      " airline shows me my editor mode
set shortmess+=I                    " no message on empty vim startup
set splitbelow                      " show splits to right or below, as you would read
set splitright

" tame searching
set smartcase                       " ignore case in a search until there is some capitalization
set gdefault                        " apply replaces globally, do have to add g to them anymore
set incsearch                       " Jump to the first instance as you type the search term
set showmatch                       " always show matching ()'s
set hlsearch                        " Highlight all of the search terms
set tags=./.tags;$HOME              " search for a tag file named 'tags' up directories recursively, stopping at $HOME

" setup line wrapping
set wrap
set linebreak
"set textwidth=119
set textwidth=0                     " don't split lines when they're too long
set formatoptions+=qrn1
set colorcolumn=120

" show unwanted whitespace
set list
set listchars=tab:»\ ,trail:·,extends:…
set showbreak=\ \ …
set history=1000                    " Remember a ton of commands
set mouse=a                         " Allow for better mouse interaction

set background=dark
colorscheme jellybeans

map <M-n> :call NumberToggle()<CR>
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc

" whenever a file is opened/switched to, find it in NERDTree
"autocmd BufEnter * if &modifiable | NERDTreeFind | wincmd p | endif

" strip trailing whitespace prior to save
autocmd BufWritePre * :%s/\s\+$//e

" play nice with Vim sessions: close all extraneous buffers before leaving vim
autocmd VimLeavePre * :tabdo call CloseExtraBuffers()

" uncomment to debug errors on Vim exit
"autocmd VimLeave * :sleep 5

" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" typing jj in insert mode gets you out.
inoremap jj <Esc>
nnoremap JJJJ <Nop>

" ;w instead of :w, faster to type
"nnoremap ; :

" Y yanks to EOL (to match D and C)
nnoremap Y y$

" Easy window navigation
map <M-h> <C-w>h
map <M-j> <C-w>j
map <M-k> <C-w>k
map <M-l> <C-w>l

" vim training wheels: dont allow arrow keys!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

map <C-h> ^
imap <C-h> <Esc>^i
map <C-l> $
imap <C-l> <End>

" fix direction keys for line wrap, otherwise they jump over wrapped lines
nnoremap j gj
nnoremap k gk

" when jumping search items, keep the cursor in the middle of the screen
nnoremap n nzz
nnoremap } }zz

" remap f1. I'll type :help when I want it
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap Q <nop>

" Highlight all instances of word under cursor, when idle.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        setl updatetime=4000
        echo 'Highlight current word: off'
        return 0
    else
        augroup auto_highlight
            au!
            au CursorHold * call SearchCurrentWord()
        augroup end
        setl updatetime=500
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction

function! SearchCurrentWord()
    let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
endfunction

function! CloseExtraBuffers()
    :NERDTreeClose
    :TagbarClose
    :GundoHide
endfunction
