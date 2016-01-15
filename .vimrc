syntax on

set t_Co=256
"" colorscheme jellybeans

colorscheme solarized
set background=dark

set number
set tabstop=4
set shiftwidth=4
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
Plug 'tpope/vim-fugitive'

call plug#end()
