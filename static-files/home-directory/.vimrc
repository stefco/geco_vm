"execute pathogen#infect()

set nocompatible
set backspace=indent,eol,start
set history=1000
set nobackup
set nowrap
set mousehide
set nu "Show line number
set autoread "read file updates

set incsearch
set hlsearch
set ignorecase
set smartcase

set nowrap
set shiftround
set expandtab
set autoindent

set softtabstop=4
set tabstop=4
set shiftwidth=4
set colorcolumn=81

set ai "Auto indent
set si "Smart indent
set whichwrap+=<,>,h,l,[,]

set foldmethod=indent

"run selected python code (or whole file) by pressing <F9> while in py script
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

"macro for managing links in sphinx (only for one-liner link text)
let @v = "di``_hPOp0i.. _A:dd"
"macro for copying a URL (no spaces assumed)
let @c = "F D"

"turn on latex-to-unicode on other file types
"let g:latex_to_unicode_file_types = ".jl .js"
noremap <expr> <F7> LaTeXtoUnicode#Toggle()
inoremap <expr> <F7> LaTeXtoUnicode#Toggle()

"set theme for vim-airline
let g:airline_theme='solarized'
"allow tabline to work
let g:airline#extensions#tabline#enables = 1
" powerline fonts
let g:airline_powerline_fonts = 1
" get rid of the arrows since i can't get them aligned
let g:airline_left_sep=''
let g:airline_right_sep=''

filetype on
syntax on

autocmd FileType make set noexpandtab
autocmd FileType txt set wrap

" syntax highlighting and mustache abbreviations for spacebars
autocmd BufRead,BufNewFile *.html set filetype=mustache
let g:mustache_abbreviations = 1

" source: https://gist.github.com/alexyoung/2709590
" vim:fdm=marker

" Editor basics {{{
" Behave like Vim instead of Vi
set nocompatible

" Show a status line
set laststatus=2

" Show the current cursor position
set ruler

" Enable syntax highlighting
syn on
" }}}
" Mouse {{{
" Send more characters for redraws
set ttyfast

" Enable mouse use in all modes
set mouse=a

" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
set ttymouse=xterm2
" }}}
" Disable arrow keys {{{
"noremap  <Up>     <NOP>
"inoremap <Down>   <NOP>
"inoremap <Left>   <NOP>
"inoremap <Right>  <NOP>
"noremap  <Up>     <NOP>
"noremap  <Down>   <NOP>
"noremap  <Left>   <NOP>
"noremap  <Right>  <NOP>
" }}}
