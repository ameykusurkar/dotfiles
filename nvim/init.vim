""""" PLUGINS (TODO)

call plug#begin()

"""" Productivity
" Plug 'AndrewRadev/splitjoin.vim'

" Open files in github
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'

"""" Consider alternatives
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

""""" FOLDING (TODO)

" " Toggle fold
" nnoremap <Space> za

" set foldmethod=indent
" set foldlevelstart=99 " Unfold everything when opening file

""""" MISCELLANEOUS MAPPINGS

" Cycle though buffers
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" nnoremap <C-G> :Files<CR>

nnoremap <leader>g V:OpenGithubFile<CR>
vnoremap <leader>g :OpenGithubFile<CR>

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

" let g:indent_guides_guide_size=1

" let g:ale_fixers = {'ruby': ['rubocop'], 'go': ['goimports'], 'rust': ['rustfmt'], 'javascript': ['prettier'], 'css': ['stylelint'], 'haskell': ['hlint', 'stylish-haskell']}
" let g:ale_ruby_rubocop_executable='bundle'
" let g:ale_linters = {'rust': ['cargo', 'analyzer'], 'haskell': ['stack_build', 'hlint'], 'ruby': ['ruby', 'rubocop']}
" let g:ale_rust_rustc_options = '' " Default option requires nightly

" let test#strategy = "dispatch"
" autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
