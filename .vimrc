:let mapleader = ","
" load plugins
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}
"Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-css-color'
Plug 'preservim/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'scrooloose/nerdtree-project-plugin'
"Plug 'PhilRunninger/nerdtree-buffer-ops'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'PotatoesMaster/i3-vim-syntax'
"Plug 'rafi/awesome-vim-colorschemes'
Plug 'benmills/vimux'
Plug 'hdima/python-syntax'
"Plug 'sheerun/vim-polyglot'
Plug 'vim-python/python-syntax'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'ghifarit53/tokyonight-vim'
call plug#end()

syntax on
"set nocompatible
let g:python_highlight_all = 1

map <leader>n :NERDTreeToggle<CR>
"autocmd VimEnter * NERDTree | wincmd p
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | silent! NERDTreeToggle | endif

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent! NERDTreeMirror | endif
let g:NERDTreeFileLines = 0

" Colorscheme
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

set background=dark
set t_Co=256
colorscheme deep-space
"colorscheme tokyonight

hi! Normal ctermbg=NONE
hi! NonText ctermbg=NONE

hi TabLineFill cterm=none ctermfg=none ctermbg=grey
hi TabLineSel cterm=none ctermfg=none ctermbg=none
hi TabLine cterm=none ctermfg=white ctermbg=darkgrey

hi StatusLine cterm=NONE ctermbg=NONE ctermfg=white

" Some basics:
filetype plugin indent on
set cursorline
:highlight CursorLine cterm=NONE ctermbg=darkgrey ctermfg=NONE
:highlight CursorLineNR ctermbg=darkgrey ctermfg=white

set hlsearch
set encoding=utf-8
set number relativenumber
set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set smartindent
set cindent
set softtabstop=4
set mouse=a
set laststatus=2
"set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vx :VimuxInterruptRunner<CR>
map <Leader>vz :call VimuxZoomRunner()<CR>
map <Leader>v<C-l> :VimuxClearTerminalScreen<CR>

" run python script
autocmd! FileType python nmap <buffer> ,s <Esc>:w<Esc> :!clear<CR>
autocmd! FileType python nmap ,p <Esc>:w<Esc> :ter python "%"<CR>

" Enable spell-checking
autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=en_us
hi SpellBad cterm=none ctermfg=white ctermbg=Red
hi SpellLocal ctermfg=white ctermbg=Cyan

" Enable autocompletion:
set wildmenu
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd fileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Splits open at the bottom and right
set splitbelow splitright

" Shotcutting split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <leader>= <C-w>6+
map <leader>- <C-w>6-

" remap key for visual block mode
nnoremap <C-b> <C-v>

set clipboard=unnamedplus
" Copy selected text to system clipboard
noremap <C-c> "*y:let @+=@*<CR>
noremap y "*y:let @+=@*<CR>
noremap yy "*yy:let @+=@*<CR>
noremap Y "*y$:let @+=@*<CR>
noremap <C-v> "*p:let @+=@*<CR>
noremap p "*p:let @+=@*<CR>

" Automatically delete all trailling whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Ctrl-n to toggle NER Tree

" Ctrl-g to toggle Goyo
map <leader>g :Goyo<CR>

" Remap exit to alt+q
map <leader>w :w<CR>
map <leader>fw :w!<CR>
map <leader>q :q<CR>
map <leader>fq :q!<CR>

"map <leader>s :vsplit<CR>
map <leader>s :vertical new<CR>
map <leader>hs :split new<CR>
map <leader>tn :tabnew<CR>
map <leader>tq :tabclose<CR>
map <tab> :tabnext<CR>

map ! :!
"map <leader>r :s/\<\>/
map <leader>P :!python<space>%
" Remap exit insert mode
"inoremap <C-i> <esc>

nnoremap o o<Esc>
nnoremap O O<Esc>

let g:lightline = {'colorscheme': 'one'}
set noshowmode
set encoding=UTF-8


