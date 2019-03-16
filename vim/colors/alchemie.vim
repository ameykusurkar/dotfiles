" -----------------------------------------------------------------------------
" file        : alchemie.vim
" description : vim colorscheme
" author      : Elias Löwe <elias@lowenware.com>
" version     : 2017-12-27-1
" -----------------------------------------------------------------------------

let g:colors_name = 'alchemie'

set background=dark

highlight clear
if exists('syntax_on')
  syntax reset
endif

hi! Normal           guifg=#7fadb8  guibg=#002030  gui=NONE       ctermfg=5     ctermbg=1     cterm=NONE

hi! LineNr           guifg=#39556a  guibg=#000c10  gui=NONE       ctermfg=11    ctermbg=1     cterm=NONE
hi! CursorLineNr     guifg=#87a6c7  guibg=#002840  gui=NONE       ctermfg=8     ctermbg=2     cterm=NONE
hi! CursorLine       guifg=NONE     guibg=#002840  gui=NONE       ctermfg=NONE  ctermbg=2     cterm=NONE
hi! CursorColumn     guifg=NONE     guibg=#002840  gui=NONE       ctermfg=NONE  ctermbg=2     cterm=NONE
hi! ColorColumn      guifg=NONE     guibg=#c14b5f  gui=NONE       ctermfg=NONE  ctermbg=15    cterm=NONE

hi! TabLine          guifg=#87a6c7 guibg=#2f343f gui=NONE ctermfg=8 ctermbg=3 cterm=NONE
hi! TabLineFill      guifg=#87a6c7 guibg=#2f343f gui=NONE ctermfg=8 ctermbg=3 cterm=underline
hi! TabLineSel       guifg=#c5dcf4 guibg=#002030 gui=NONE ctermfg=9 ctermbg=1 cterm=underline

hi! Error            guifg=#c14b5f  guibg=NONE     gui=reverse    ctermfg=15    ctermbg=NONE  cterm=reverse
hi! ErrorMsg         guifg=#c14b5f  guibg=NONE     gui=reverse    ctermfg=15    ctermbg=NONE  cterm=reverse
hi! WarningMsg       guifg=#ffc78d  guibg=NONE     gui=NONE       ctermfg=7     ctermbg=NONE  cterm=NONE
hi! MoreMsg          guifg=#c5dcf4  guibg=NONE     gui=NONE       ctermfg=9     ctermbg=NONE  cterm=NONE
hi! Question         guifg=#da9cba  guibg=NONE     gui=NONE       ctermfg=12    ctermbg=NONE  cterm=NONE

hi! DiffAdd          guifg=#b3d5ab  guibg=NONE     gui=reverse    ctermfg=13    ctermbg=NONE  cterm=reverse
hi! DiffText         guifg=#87a6c7  guibg=NONE     gui=reverse    ctermfg=8     ctermbg=NONE  cterm=reverse
hi! DiffChange       guifg=#da9cba  guibg=NONE     gui=reverse    ctermfg=12     ctermbg=NONE  cterm=reverse
hi! DiffDelete       guifg=#39556a  guibg=NONE     gui=reverse    ctermfg=11     ctermbg=NONE  cterm=reverse

hi! Title            guifg=#c5dcf4  guibg=NONE     gui=NONE       ctermfg=9     ctermbg=NONE  cterm=NONE
hi! PreProc          guifg=#b3d5ab  guibg=NONE     gui=NONE       ctermfg=13    ctermbg=NONE  cterm=NONE
hi! Comment          guifg=#39556a  guibg=NONE     gui=NONE       ctermfg=11     ctermbg=NONE  cterm=reverse
hi! Function         guifg=#83e1f3  guibg=NONE     gui=NONE       ctermfg=14    ctermbg=NONE  cterm=NONE
" asm commands, registers, operands etc
hi! Identifier       guifg=#7fadb8  guibg=NONE     gui=NONE       ctermfg=5    ctermbg=NONE  cterm=NONE
" ifs, returns, fors etc
hi! Statement        guifg=#b3d5ab  guibg=NONE     gui=NONE       ctermfg=13    ctermbg=NONE  cterm=NONE
" stdin, stdout, NULL etc
hi! Constant         guifg=#5296e2  guibg=NONE     gui=NONE       ctermfg=10    ctermbg=NONE  cterm=NONE
hi! Operator         guifg=#5296e2  guibg=NONE     gui=NONE       ctermfg=10    ctermbg=NONE  cterm=NONE
hi! Type             guifg=#da9cba  guibg=NONE     gui=NONE       ctermfg=12     ctermbg=NONE  cterm=reverse
hi! String           guifg=#6c96ac  guibg=NONE     gui=NONE       ctermfg=8     ctermbg=NONE  cterm=NONE
hi! Directory        guifg=#c5dcf4  guibg=NONE     gui=NONE       ctermfg=9     ctermbg=NONE  cterm=NONE
hi! VimCommentTitle  guifg=#c5dcf4  guibg=NONE     gui=NONE       ctermfg=9     ctermbg=NONE  cterm=NONE
hi! Number           guifg=#87a6c7  guibg=NONE     gui=NONE       ctermfg=8     ctermbg=NONE  cterm=NONE
hi! Special          guifg=#c5dcf4  guibg=NONE     gui=NONE       ctermfg=9     ctermbg=NONE  cterm=NONE

hi! WildMenu         guifg=#87a6c7  guibg=#000c10  gui=reverse    ctermfg=8     ctermbg=0     cterm=reverse
hi! StatusLine       guifg=#c5dcf4  guibg=#39556a  gui=NONE       ctermfg=9     ctermbg=11    cterm=NONE
hi! StatusLineSpot   guifg=#39556a  guibg=#39556a  gui=NONE       ctermfg=11    ctermbg=11    cterm=NONE
hi! StatusLineBranch guifg=#c5dcf4  guibg=#2f343f  gui=NONE       ctermfg=9     ctermbg=3    cterm=NONE
hi! StatusLineNC     guifg=#c5dcf4  guibg=#39556a  gui=reverse    ctermfg=1     ctermbg=11   cterm=reverse

hi! Visual           guifg=#87a6c7  guibg=NONE     gui=reverse    ctermfg=8     ctermbg=NONE  cterm=reverse

hi! PmenuSel         guifg=#c5dcf4  guibg=#39556a  gui=NONE       ctermfg=9     ctermbg=11    cterm=NONE
hi! Pmenu            guifg=#002030  guibg=#39556a  gui=NONE       ctermfg=1     ctermbg=11    cterm=NONE
hi! PmenuSbar        guifg=#002030  guibg=#39556a  gui=NONE       ctermfg=1     ctermbg=11    cterm=NONE
hi! PmenuThumb       guifg=#002030  guibg=#39556a  gui=NONE       ctermfg=1     ctermbg=11    cterm=NONE

hi! FoldColumn       guifg=#002840  guibg=NONE     gui=NONE       ctermfg=2     ctermbg=NONE  cterm=NONE

hi! Todo             guifg=#c5dcf4  guibg=NONE     gui=reverse    ctermfg=9     ctermbg=NONE  cterm=reverse
hi! MatchParen       guifg=#c5dcf4  guibg=#002030  gui=bold       ctermfg=9     ctermbg=1     cterm=bold
hi! SignColumn       guifg=#002840  guibg=NONE     gui=NONE       ctermfg=2     ctermbg=NONE  cterm=NONE
hi! Underlined       guifg=#002840  guibg=NONE     gui=underline  ctermfg=2     ctermbg=NONE  cterm=underline

hi! NonText          guifg=#39556a  guibg=NONE     gui=NONE       ctermfg=11    ctermbg=NONE  cterm=NONE
hi! SpecialKey       guifg=#39556a  guibg=NONE     gui=NONE       ctermfg=11    ctermbg=NONE  cterm=NONE

hi! SpecialComment   guifg=#39556a  guibg=NONE     gui=reverse    ctermfg=11    ctermbg=NONE  cterm=reverse
hi! Search           guifg=#002840  guibg=#ffc78d  gui=reverse    ctermfg=2     ctermbg=7     cterm=reverse
hi! VertSplit        guifg=#39556a  guibg=NONE     gui=NONE       ctermfg=11    ctermbg=0     cterm=NONE

hi! SpellBad         guifg=#c14b5f  guibg=NONE     gui=undercurl  ctermfg=15    ctermbg=NONE  cterm=undercurl
hi! SpellLocal       guifg=#39556a  guibg=NONE     gui=undercurl  ctermfg=11    ctermbg=NONE  cterm=undercurl
hi! SpellRare        guifg=#39556a  guibg=NONE     gui=undercurl  ctermfg=11    ctermbg=NONE  cterm=undercurl
hi! SpellCap         guifg=#da9cba  guibg=NONE     gui=undercurl  ctermfg=12    ctermbg=NONE  cterm=undercurl

let g:terminal_color_0  = '#000c10' " the darkest
let g:terminal_color_1  = '#002030' " terminal BG
let g:terminal_color_2  = '#002840' " terminal highlight
let g:terminal_color_3  = '#2f343f' " panels
let g:terminal_color_4  = '#ffffff' " white
let g:terminal_color_5  = '#7fadb8' " normal text
let g:terminal_color_6  = '#6c96a0' " softer text
let g:terminal_color_7  = '#ffc78d' " yellow
let g:terminal_color_8  = '#87a6c7' " text
let g:terminal_color_9  = '#c5dcf4' " bright text
let g:terminal_color_10 = '#5296e2' " links & selections
let g:terminal_color_11 = '#39556a' " comments and shadowed content
let g:terminal_color_12 = '#da9cba' " rose
let g:terminal_color_13 = '#b3d5ab' " green
let g:terminal_color_14 = '#83e1f3' " blue
let g:terminal_color_15 = '#c14b5f' " red

let g:terminal_color_foreground = '#c5dcf4' " default text color
let g:terminal_color_background = '#002030' " default bg terminal color

" Javascript ------------------------------------------------------------------
highlight link jsStorageClass Keyword

" Markdown --------------------------------------------------------------------
highlight link markdownLinkText String
highlight link markdownUrl Question

" PHP -------------------------------------------------------------------------
highlight link phpVarSelector PreProc

" CSS -------------------------------------------------------------------------
highlight link cssIdentifier PreProc
highlight link cssClassName  PreProc

" -----------------------------------------------------------------------------
