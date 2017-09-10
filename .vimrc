syntax on

set t_Co=256

colorscheme jellybeans
set background=dark

"set relativenumber
set number
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set ruler
set encoding=utf-8
set noshowmode

""""" MAPPINGS

nnoremap <Enter> o<Esc>

""""" AIRLINE SETTINGS

set laststatus=2
let g:airline_theme='murmur'
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline_powerline_fonts = 1

""""" PLUGINS

call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'wikitopian/hardmode'
Plug 'leafgarland/typescript-vim'
Plug 'scrooloose/nerdtree'
Plug 'gregsexton/MatchTag'
Plug 'jimenezrick/vimerl'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'christoomey/vim-tmux-runner'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-endwise'
Plug 'vim-syntastic/syntastic'
Plug 'rking/ag.vim'

call plug#end()

""""" SYNASTIC SETTINGS

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"""""

set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

"""""

set hidden
set hlsearch       "highlight searches
set backspace=2
set tabpagemax=100

set foldmethod=indent

"key mapping for opening lines without entering insert mode
nmap <Enter> o<Esc>
nmap <C-J> ddp
nmap <C-K> kddpk

nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

iabbrev </ </<C-X><C-O>

nmap <C-G> :FZF<Enter>
