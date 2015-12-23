syntax on

set t_Co=256
colorscheme jellybeans
set number
set tabstop=4
set shiftwidth=4
set ruler
set encoding=utf-8

""""" MAPPINGS

nnoremap <Enter> o<Esc>

""""" AIRLINE SETTINGS

set laststatus=2
let g:airline#extensions#tabline#enabled = 1

""""" PLUGINS

call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'

call plug#end()
