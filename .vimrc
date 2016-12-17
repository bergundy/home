"-------------------------------------------------------------------------------
" Vundle
"-------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
"Plugin 'tpope/vim-repeat' " Conflicts with vim-tmux-navigator
Plugin 'tpope/vim-surround'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'guns/vim-clojure-static'
Plugin 'Valloric/YouCompleteMe'
Plugin 'davidhalter/jedi-vim'
Plugin 'ap/vim-buftabline'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'
Plugin 'tomtom/tcomment_vim'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'cocopon/iceberg.vim'


call vundle#end()            " required

" nerdtree
map <C-N> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeIgnore = ['\.pyc$']

" ctrl p
set runtimepath^=~/.vim/bundle/ctrlp.vim

" syntastic
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--max-line-length 120'

"jedi
let g:jedi#show_call_signatures = "2"

" buftabline
let g:buftabline_indicators = 1


filetype plugin indent on
syntax on

" buffers
set hidden
nnoremap <C-O> :bnext<CR>
nnoremap <C-I> :bprev<CR>
nnoremap <C-W> :bdelete<CR>
nnoremap <C-T> :vsp<CR>

" indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set ai

" ruby
autocmd FileType ruby set tabstop=2 shiftwidth=2

" http://vim.wikia.com/wiki/Modeline_magic
set modeline
set modelines=5

" appearance
colorscheme iceberg


set wildignore=*.pyc,*.bak,*.o,*.e,*~   " wildmenu: ignore these extensions
set wildmenu                            " command-line completion in an enhanced mode
set showcmd                             " display incomplete commands


let mapleader="`"

" always show statusline
set ls=2
set statusline=%F%m%r%h%w
set statusline+=%= " stick to right
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=[line\ %l\/%L\ %c%V]

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
" splits
"-------------------------------------------------------------------------------
set splitbelow
set splitright

" move faster between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

map <S-y> y$<CR>
"map <C-t> <ESC>:tabnew<CR>
"map <C-h> <ESC>:tabprev<CR>
"map <C-l> <ESC>:tabnext<CR>
"map <C-w> <ESC>:tabclose<CR>
"
"-------------------------------------------------------------------------------
" navigation inside insert mode
"-------------------------------------------------------------------------------
"imap <C-h> <Left>
"imap <C-j> <Down>
"imap <C-k> <Up>
"imap <C-l> <Right>
imap <C-a> <C-o>^
imap <C-e> <C-o>$

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

"-------------------------------------------------------------------------------
" auto set paste - http://superuser.com/questions/437730/always-use-set-paste-is-it-a-good-idea/904446#904446
"-------------------------------------------------------------------------------
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
map <Leader>rp :call VimuxRunCommand("clear; python " . bufname("%"))<CR>
