" General Editor Setup
set nocompatible                " Required for Vundle
filetype plugin off             " Required for Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'trapd00r/irc.vim'
Plugin 'Rykka/riv.vim'
Plugin 'Rykka/InstantRst'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/syntastic'
Plugin 'sjl/gundo.vim'
Plugin 'PotatoesMaster/i3-vim-syntax'
Plugin 'coxley/codepad'
Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomtom/tcomment_vim'
Plugin 'scrooloose/nerdtree'
Plugin 'godlygeek/tabular'
Plugin 'rodjek/vim-puppet'
call vundle#end()
filetype plugin indent on

" Close vim if NERDTree is the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" .pp puppet syntax
au BufRead,BufNewFile *.pp setfiletype puppet

" Open NERDTree with <F3>
nnoremap <F3> :NERDTreeToggle<CR>


if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!
nnoremap <F9> :Goyo<CR>
"autocmd FileType rst let g:solarized_termcolors=256
"autocmd FileType rst set background=light
"autocmd FileType rst colorscheme solarized

let python_highlight_all = 1
let python_version_2 = 1
syntax on                       " enables syntax highlighting
let mapleader=","               " change mapleader from \ to '
set hidden                      " multi-file behaviors
set wildmenu                    " better cmd line completion
set wildmode=list:longest       " more shell-like completion
set wildignore=*.swp,*.bak,*.pyc,*.class
set ignorecase                  " case-insensitive matching
set smartcase                   " unless there's upper-case specified
set ruler                       " cursor position
set hlsearch                    " highlight search matches
set incsearch                   " highlight search matches while typing
set wrap                        " linewraps
set scrolloff=5                 " always show at least 5 lines below/above the cur
set title                       " set window title
set visualbell                  " turn off terminal bell
set showbreak=+                 " display + for wrapped lines
set number                      " show line numbers
set encoding=utf8               " set utf-8 encoding
set ffs=unix,dos,mac            " prefer unix linefeed
set pastetoggle=<f5>            " pressing f5 in insert mode will allow pasting
                                " without auto indentation being applied.
set colorcolumn=81              " set column on 81
set cursorline                  " highlight current row cursor is in
set backup                      " keep a backup file
set textwidth=79
set backupdir=~/.vim/backup                     " keep a backup file
set showcmd                     " display incomplete commands
set backspace=indent,eol,start

" Indentation and other file formatting
set cindent                     " indent after line ending in {, and use 'cinwords'
set expandtab
set softtabstop=4 shiftwidth=4
set ai                          "Auto indent
set si                          "Smart indent
set formatoptions+=r            " Automatically insert the current comment leader
set formatoptions+=q            " Allow formatting of comments with 'gq'
set foldmethod=indent           " Enable code folding, indent works well python
set foldlevel=99                " za is to fold/unfold

" History
set history=1000                " 1000 cmd history
set undolevels=1000             " 1000 undo levels

" Mapping
nnoremap <silent> <Leader>l ml:execute 'match Search /\%'.line('.').'l/'<CR>
" Above maps <Leader>l to highlight current line
" Entering :match will clear highlighting
cmap w!! %!sudo tee > /dev/null %
autocmd FileType text setlocal textwidth=78
inoremap <C-U> <C-G>u<C-U>
nnoremap <space> za
vnoremap <space> zf
nnoremap <F4> :GundoToggle<CR>

" Colorscheme
set t_Co=256
"let base16colorspace=256
"let g:molokai_original = 1
"let g:rehash256 = 1
"set background=dark
colorscheme molokai
"colorscheme xoria256
"colorscheme solarized
highlight Search ctermbg='NONE' ctermfg=226
"highlight Search ctermbg='NONE' ctermfg=118    "Chartreuse
"let g:zenburn_high_Contrast=1
"colorscheme zenburn
"set background=dark


" Plugins
let g:syntastic_python_python_exec = '/usr/bin/python2'
" multiple cursors
"let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_next_key='<Leader>n'
"let g:multi_cursor_prev_key='<Leader>p'
"let g:multi_cursor_skip_key='<Leader>x'
"let g:multi_cursor_quit_key='<Esc>'

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
endif

" Maps for copying/pasting from X clipboard
:com -range Cz :silent :<line1>,<line2>w !xsel -i -b
:com -range Cx :silent :<line1>,<line2>w !xsel -i -p
:com -range Cv :silent :<line1>,<line2>w !xsel -i -s
:ca cv Cv
:ca cz Cz
:ca cx Cx

:com -range Pz :silent :r !xsel -o -b
:com -range Px :silent :r !xsel -o -p
:com -range Pv :silent :r !xsel -o -s

:ca pz Pz
:ca px Px
:ca pv Pv

function! CopyMatches(reg)
    let hits = []
    %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
    let reg = empty(a:reg) ? '+' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)
