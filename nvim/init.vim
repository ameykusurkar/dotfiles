set nocompatible " Mostly redundant, but just in case!

""""" GENERAL

syntax on
set number " Show line numbers
set ruler "Show the line and column number of the cursor position
set encoding=UTF-8
set mouse=a " Mouse support
set hidden " Modified buffers are 'hidden' instead of unloaded
set directory=$DOTFILES/vim/swapfiles// " Change swapfile location
set cursorline  " Highlights the line that the cursor is on
set timeoutlen=300 " How long vim waits mid key sequence before timing out

" Detect type of file being edited
filetype on
filetype indent on
filetype plugin on

let mapleader=","

""""" INDENTATION

set tabstop=2      " Width of TAB character
set softtabstop=2  " Width of <TAB> key
set shiftwidth=2   " Width for formatting (>, =)
set expandtab      " Convert tabs to spaces
set smarttab       " Use shiftwidth when inserting a tab in front of a line
set shiftround     " Round indent to multiple of shiftwidth

set backspace=2 " Allow backspace over indent, eol, start

""""" PLUGINS (TODO)

call plug#begin()

"""" Appearance
Plug 'itchyny/lightline.vim' " Status line appearance
Plug 'chriskempson/base16-vim' " Colorschemes

"""" Productivity
Plug 'tpope/vim-commentary' " Comment stuff out
Plug 'lewis6991/gitsigns.nvim' " Git plugin
" Plug 'AndrewRadev/splitjoin.vim'

" Open files in github
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'

"""" Consider alternatives
Plug 'scrooloose/nerdtree'
" Plug 'Valloric/MatchTagAlways' " Syntax for HTML/XML tags
" Plug 'tpope/vim-fugitive' " Git plugin
" Plug 'tpope/vim-endwise'

"""" Lint/LSP
" Plug 'dense-analysis/ale'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

"""" Navigation
" Plug 'junegunn/fzf.vim'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

"""" Language
Plug 'dag/vim-fish' " Syntax highlighting for fish scripts
" Plug 'leafgarland/typescript-vim'
" Plug 'jimenezrick/vimerl'
" Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'
" Plug 'vim-ruby/vim-ruby'
" Plug 'google/vim-jsonnet'
" Plug 'plasticboy/vim-markdown'
" Plug 'neovimhaskell/haskell-vim'
" Plug 'cespare/vim-toml'

"""" Misc
" Plug 'wikitopian/hardmode'
" Plug 'christoomey/vim-tmux-runner'
" Plug 'nathanaelkane/vim-indent-guides'
" Plug 'janko-m/vim-test'
" Plug 'tpope/vim-dispatch'

call plug#end()

""""" APPEARANCE

set termguicolors " Enable 24-bit colors
set background=dark

colorscheme base16-gruvbox-dark-hard

set noshowmode  " Don't show mode in status line, as lightline does it
set laststatus=2 " Always show status line
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'gitbranch', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'component': {
      \   'lineinfo': "%{line('.') . '/' . line('$') . ':' . col('.')}",
      \   'filename': "%{expand('%')}",
      \ },
      \ }

" Required by vim to render true colour inside tmux. Not needed by neovim, but
" keep it so that we could potentially use the same config for both.
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

""""" SEARCH

set hlsearch "highlight searches

" Ignores case unless search has uppercase chars
set ignorecase
set smartcase

" Remove highlighting for search
nnoremap ; :nohlsearch<CR>

""""" FOLDING (TODO)

" " Toggle fold
" nnoremap <Space> za

" set foldmethod=indent
" set foldlevelstart=99 " Unfold everything when opening file

""""" MISCELLANEOUS MAPPINGS

nnoremap <leader>s :source ~/.config/nvim/init.vim<CR>

" Uppercase word
nnoremap <leader>u gUiw

" Move lines up/down
nnoremap <C-J> ddp
nnoremap <C-K> kddpk

" Insert a clear newline (if inside a comment, the editor might automatically
" add the starting characters) 
nnoremap <CR> o<Esc>D

" Cycle though buffers
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" nnoremap <C-G> :Files<CR>

nnoremap <leader>g V:OpenGithubFile<CR>
vnoremap <leader>g :OpenGithubFile<CR>

" nnoremap <leader>m :Git blame<CR>
nnoremap <leader>m <cmd>lua require('gitsigns').blame_line({full=true})<CR>

nnoremap <leader>n :NERDTreeToggle<CR>

" nnoremap <leader>tn :TestNearest<CR>

" nnoremap <leader>v :belowright 15sp ~/.vimrc<CR>

" nnoremap <leader>a :Ag<CR>

" inoremap <tab> <C-N>

" nnoremap <leader>fi :ALEFix<CR>
" nnoremap <leader>ff :ALEFirst<CR>
" nnoremap <leader>fn :ALENext<CR>

" autocmd FileType ruby nnoremap <buffer> <leader>b orequire "pry"; binding.pry<ESC>
" autocmd FileType python nnoremap <buffer> <leader>b oimport pdb; pdb.set_trace()<ESC>

""""" PLUGIN SETTINGS

luafile $HOME/.config/nvim/support.lua

" let g:indent_guides_guide_size=1

" let g:ale_fixers = {'ruby': ['rubocop'], 'go': ['goimports'], 'rust': ['rustfmt'], 'javascript': ['prettier'], 'css': ['stylelint'], 'haskell': ['hlint', 'stylish-haskell']}
" let g:ale_ruby_rubocop_executable='bundle'
" let g:ale_linters = {'rust': ['cargo', 'analyzer'], 'haskell': ['stack_build', 'hlint'], 'ruby': ['ruby', 'rubocop']}
" let g:ale_rust_rustc_options = '' " Default option requires nightly

" let test#strategy = "dispatch"
" autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
