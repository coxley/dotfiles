" ############
" Editor Setup
" ############

if has('nvim')
    " Commenting this out to maintain the same base dir for now. Configuration
    " should try to refer to s:editor_root instead of ~/.vim where possible to
    " support this changing
    " let s:editor_root=expand("~/.nvim")
    let s:editor_root=expand("~/.vim")
else
    let s:editor_root=expand("~/.vim")
endif


let mapleader=","
cmap w!! %!sudo tee > /dev/null %

" Setup runtime path
let &rtp = &rtp . ',' . s:editor_root . '/bundle/Vundle.vim'
let &rtp = &rtp . ',' . s:editor_root . expand("~/.local/lib/python3.5/site-packages/powerline/bindings/vim/")
let &rtp = &rtp . ',' . s:editor_root . expand("~/.local/lib/python2.7/site-packages/powerline/bindings/vim/")
let &rtp = &rtp . ',' . s:editor_root . expand("~/.local/lib/python2.6/site-packages/powerline/bindings/vim/")

" Disable compatibility mode
set nocompatible

set laststatus=2
set list
inoremap hh <Esc>

set listchars=tab:\▸\ ,precedes:<,extends:>
" set listchars=tab:\»\ ,

" Disable Background Color Erase (BCE) so that color schemes
" work properly when Vim is used inside tmux and GNU screen.
if &term =~ '256color'
    set t_ut=
endif

" Create wall of highlight passed 80 characters and highlight text
let &colorcolumn=join(range(81,999),",")
highlight colorcolumn ctermbg=235 guibg=#2c2d27
highlight OverLength ctermbg=white ctermfg=red
match OverLength /\%81v.\+/

" Create backup dir if not present
let backupdir=s:editor_root . '/backup'
if !filereadable(backupdir)
    silent call mkdir(backupdir, "p")
endif

" #######
" Plugins
" #######

" Install Vundle if not present
let vundle_installed=1
let vundle_readme=s:editor_root . '/bundle/Vundle.vim/README.md'
let vundle_repo = 'https://github.com/VundleVim/Vundle.vim'

if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent call mkdir(s:editor_root . '/bundle', "p")
    silent execute "!git clone " . vundle_repo . " " . s:editor_root . "/bundle/Vundle.vim"
    let vundle_installed=0
endif

" Required for bug in Vundle - re-enable after plugin shit
filetype plugin off

call vundle#rc(s:editor_root . '/bundle')
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Syntax plugins
Plugin 'neomake/neomake'
Plugin 'markcornick/vim-vagrant'
Plugin 'cespare/vim-toml'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'rodjek/vim-puppet'
Plugin 'trapd00r/irc.vim'
Plugin 'PotatoesMaster/i3-vim-syntax'
Plugin 'plasticboy/vim-markdown'
Plugin 'ClockworkNet/vim-junos-syntax'
Plugin 'kchmck/vim-coffee-script'
Plugin 'nathanalderson/yang.vim'
Plugin 'fatih/vim-go'
Plugin 'hdima/python-syntax'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'solarnz/thrift.vim'

" Color schemes
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'

" Utility plugins
Plugin 'coxley/codepad'
Plugin 'keith/gist.vim'
Plugin 'nvie/vim-flake8'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'suan/vim-instant-markdown'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'powerline/powerline'
Plugin 'kana/vim-fakeclip'
Plugin 'jlfwong/vim-arcanist'
Plugin 'phleet/vim-mercenary'

" Powerhouse plugins
Plugin 'Rykka/riv.vim'
Plugin 'Rykka/InstantRst'
Plugin 'sjl/gundo.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'scrooloose/nerdtree'
Plugin 'godlygeek/tabular'
Plugin 'Shougo/deoplete.nvim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" Distraction free
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'

" C++
Plugin 'vim-scripts/a.vim'

" Web Development
" Plugin 'mattn/emmet-vim'
Plugin 'chrisbra/Colorizer'
Plugin 'jelera/vim-javascript-syntax'

if vundle_installed == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif

call vundle#end()
filetype plugin indent on

" #########
" Filetypes
" #########

au BufRead,BufNewFile Dockerfile set ft=Dockerfile
au BufRead,BufNewFile *.pp set ts=2 sw=2 sts=2 filetype=puppet
au BufRead,BufNewFile *rb set ts=2 sw=2 sts=2 expandtab
au BufRead,BufNewFile *yml set ts=2 sw=2 sts=2 expandtab
au BufRead,BufNewFile *j2 set ts=2 sw=2 sts=2 expandtab ft=jinja

au BufRead,BufNewFile *.cconf set filetype=python
au BufRead,BufNewFile *.cinc set filetype=python
au BufRead,BufNewFile TARGETS set filetype=python

au BufRead,BufNewFile *.thrift set filetype=thrift

" ##############
" Split and tabs
" ##############
"
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" ########
" NERDTree
" ########

nnoremap <F3> :NERDTreeToggle<CR>

let g:NERDTreeIgnore = ['\.pyc$']

" Close vim if NERDTree is the only window open and auto open for every tab
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
autocmd BufWinEnter * NERDTreeMirror

" ###############
" Phabricator/Arc
" ###############

nnoremap <leader>ai :ArcInlines<CR>
nnoremap <leader>al :ArcLint<CR>
nnoremap K :grep! "<C-R><C-W>"<CR>:cw<CR>

let fbgrep="~/bin/fbgrep"
if filereadable(fbgrep)
    set grepprg=~/bin/fbgrep
else
    set grepprg=/usr/bin/ag
endif


" #####################
" Goyo/Distraction Free
" #####################

" Map Goyo to key and trigger Limelight when Goyo is active
nnoremap <F9> :Goyo<CR>
autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

" ######
" Python
" ######

let python_highlight_all = 1
let python_version_2 = 1

" ##############
" General Editor
" ##############

syntax on                       " enables syntax highlighting
set hidden                      " multi-file behaviors
set wildmenu                    " better cmd line completion
set wildmode=list:longest       " more shell-like completion
set wildignore=*.swp,*.bak,*.pyc,*.class
set ignorecase                  " case-insensitive matching
set smartcase                   " unless there's upper-case specified
set ruler                       " cursor position
set hlsearch                    " highlight search matches
set incsearch                   " highlight search matches while typing
set nowrap                        " linewraps
set scrolloff=5                 " always show at least 5 lines below/above cur
set title                       " set window title
set visualbell                  " turn off terminal bell
set showbreak=+                 " display + for wrapped lines
set number                      " show line numbers

set cursorline                  " highlight current row cursor is in
set backup                      " keep a backup file
set backupdir=backupdir         " keep a backup file
set showcmd                     " display incomplete commands
set backspace=indent,eol,start

if has("vms")
    set nobackup
endif

" ###############
" File formatting
" ###############

set encoding=utf8               " set utf-8 encoding
set cindent                     " Indent after line ending in { and use cinwords
set ts=4 sw=4 sts=4 expandtab   " Global tab settings
set ai si                       " Auto & smart indent
set textwidth=79
set formatoptions+=r            " Auto insert the current comment prefix
set formatoptions+=q            " Allow formatting of comments with 'gq'
set foldlevel=99                " za is to fold/unfold
set ffs=unix,dos,mac            " prefer unix linefeed
set pastetoggle=<f5>            " pressing f5 in insert mode will allow pasting

set foldmethod=indent           " Enable code folding, indent works well python
nnoremap <space> za
vnoremap <space> zf

" Maps <Leader>l to highlight current line
" Entering :match will clear highlighting
nnoremap <silent> <Leader>l ml:execute 'match Search /\%'.line('.').'l/'<CR>
                                " without auto indentation being applied.
" History
set history=1000                " 1000 cmd history
set undolevels=1000             " 1000 undo levels

" #####
" Gundo
" #####

nnoremap <F4> :GundoToggle<CR>

" ######
" Colors
" ######

set t_Co=256
colorscheme molokai
highlight Search ctermbg='NONE' ctermfg=226

" ########
" Markdown
" ########

autocmd BufNewFile,BufRead *.md map <Leader>1 :HeaderDecrease<CR>
autocmd BufNewFile,BufRead *.md map <Leader>2 :HeaderIncrease<CR>
autocmd BufNewFile,BufRead *.md map <Leader>toc :Toch<CR>
let g:vim_markdown_frontmatter=1

" #########
" Colorizer
" #########

let g:colorizer_auto_filetype='css,html,javascript'

" #######
" NeoMake
" #######

autocmd! BufWritePost * Neomake

" ########
" Deoplete
" ########

let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 0

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

inoremap <silent><expr><leader><tab> deoplete#mappings#manual_complete()

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" augroup omnifuncs
"   autocmd!
"   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"   autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"   autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"   autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"   autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" augroup end

" #########
" Clipboard
" #########

if !has('nvim')
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
endif


" ##########
" Table Mode
" ##########

nnoremap <silent> <Leader>tm :TableModeToggle

" ####################
" Snippets (Ultisnips)
" ####################

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

