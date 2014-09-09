" Pathogen load
filetype off

call pathogen#infect()
call pathogen#helptags()

filetype on
filetype plugin indent on
syntax on

" tabs
set tabstop=4
set shiftwidth=4
set expandtab
set ai

" appearance
if has("gui_gtk2")
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
  colorscheme slate
endif


set wildignore=*.pyc,*.bak,*.o,*.e,*~ " wildmenu: ignore these extensions
set wildmenu                    " command-line completion in an enhanced mode
set showcmd                     " display incomplete commands


let mapleader="`"

"let g:C_MapLeader ='`'

map <S-y> y$<CR>
map <C-t> <ESC>:tabnew<CR>
map <C-h> <ESC>:tabprev<CR>
map <C-l> <ESC>:tabnext<CR>
map <C-w> <ESC>:tabclose<CR>

" always show statusline
set ls=2
set statusline=%F%m%r%h%w
set statusline+=%= " stick to right
set statusline+=%{fugitive#statusline()}
set statusline+=\ [line\ %l\/%L\ %c%V]

"-------------------------------------------------------------------------------
" thrift
"-------------------------------------------------------------------------------
au BufRead,BufNewFile *.thrift set filetype=thrift
au! Syntax thrift source ~/.vim/thrift.vim

"-------------------------------------------------------------------------------
" py.test
"-------------------------------------------------------------------------------
" Execute the tests
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
" Cycle through test errors
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>

autocmd FileType python map <buffer> <leader>8 :call Flake8()<CR>

"-------------------------------------------------------------------------------
" Add the virtualenv's site-packages to vim path
"-------------------------------------------------------------------------------
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

"-------------------------------------------------------------------------------
" comma always followed by a space
"-------------------------------------------------------------------------------
inoremap  ,  ,<Space>
inoremap  ,, ,
inoremap  ,<CR> ,<CR>

"-------------------------------------------------------------------------------
" autocomplete parenthesis, brackets, braces and quotes
"-------------------------------------------------------------------------------
"inoremap {      {}<Left>
"inoremap {<CR>  {<CR>}<Esc>O<Tab>
"inoremap {{     {
"inoremap {}     {}
"
"inoremap (      ()<Left>
"inoremap (<CR>  (<CR>)<Esc>O<Tab>
"inoremap ((     (
"inoremap ()     ()
"
"inoremap [      []<Left>
"inoremap [<CR>  [<CR>]<Esc>O<Tab>
"inoremap [[     [
"inoremap []     []
"
"inoremap "      ""<Left>
"inoremap ""     "
"
"inoremap '      ''<Left>
"inoremap ''     '

"-------------------------------------------------------------------------------
" navigation inside insert mode
"-------------------------------------------------------------------------------
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
imap <C-a> <C-o>^
imap <C-e> <C-o>$

"-------------------------------------------------------------------------------
" c/c++ header file auto define
"-------------------------------------------------------------------------------
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), '[\.-]', "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  execute "normal! O"
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

"-------------------------------------------------------------------------------
" strip trailing whitespace
"-------------------------------------------------------------------------------
fun! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfun
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespaces()<CR>
"autocmd FileType vim,python,js,css,less,html,c,cpp autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
match Todo /\s\+$/

" unselect
"nnoremap <CR> :nohlsearch<CR>
" move faster between vertical splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>

" navigate to next pep8 error
nnoremap <C-N> :cn<CR>
nnoremap <C-P> :cp<CR>

"-------------------------------------------------------------------------------
" doxygentoolkit plugin
"-------------------------------------------------------------------------------
let g:DoxygenToolkit_briefTag_pre=""
