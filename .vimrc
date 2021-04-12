"-------------------------------------------------------------------------------
" Vundle
"-------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}

Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-repeat' " Conflicts with vim-tmux-navigator
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

Plug 'scrooloose/nerdtree'
Plug 'ap/vim-buftabline'
" Plug 'Valloric/YouCompleteMe'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mileszs/ack.vim'
Plug 'AndrewRadev/sideways.vim'

Plug 'ConradIrwin/vim-bracketed-paste'

" golang
Plug 'fatih/vim-go'
" python
" Plug 'davidhalter/jedi-vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'nvie/vim-flake8'
" clojure
Plug 'guns/vim-clojure-static'
" Plug 'clojure-vim/async-clj-omni'
" Plug 'tpope/vim-fireplace'
" rust
Plug 'rust-lang/rust.vim'
" typescript
Plug 'leafgarland/typescript-vim'

" gdscript
Plug 'calviken/vim-gdscript3'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

Plug 'tomtom/tcomment_vim'
Plug 'cocopon/iceberg.vim' " colorscheme

Plug 'tikhomirov/vim-glsl'

Plug 'hashivim/vim-hashicorp-tools'
Plug 'chr4/nginx.vim'
Plug 'lepture/vim-jinja'
Plug 'cespare/vim-toml'
Plug 'mzlogin/vim-markdown-toc'

call plug#end()            " required

call tcomment#type#Define('glsl', '// %s')
call tcomment#type#Define('kivy', '# %s')

" nerdtree
map <C-N> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeIgnore = ['\.pyc$']

" ctrl p
" set runtimepath^=~/.vim/bundle/ctrlp.vim
" let g:ctrlp_custom_ignore = 'node_modules\|build\|vendor'

" python
let g:jedi#show_call_signatures = "2"
let python_highlight_all = 1

" buftabline
let g:buftabline_indicators = 1

" rust
let g:rustfmt_autosave = 1

filetype plugin indent on
syntax on

set backupdir=~/.vim/tmp//
set directory=~/.vim/tmp//
set undodir=~/.vim/tmp//

" Some servers have issues with backup files,  see #649
set nobackup
set nowritebackup

set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

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

" special cases
autocmd FileType yaml,ruby,javascript,typescript,tf,json setlocal tabstop=2 softtabstop=2 shiftwidth=2

" http://vim.wikia.com/wiki/Modeline_magic
set modeline
set modelines=5

" appearance
colorscheme blue
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
set statusline+=%{coc#status()}
set statusline+=%*
set statusline+=[line\ %l\/%L\ %c%V]

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

map <Leader>rp :call VimuxRunCommand("clear; python " . bufname("%"))<CR>

let g:ale_typescript_tslint_config_path = expand("~/tslint.yml")
nmap gl <Plug>(coc-diagnostic-prev)

" ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" nnoremap <Leader>a :Ack!<C-r><C-w><CR>

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_leading_spaces() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_leading_spaces() abort
  let col = col('.') - 1
  return !col || getline('.')[0:col - 1] =~# '\v^\s+$'
endfunction

" Use <c-space> for trigger completion.
" inoremap <silent><expr> <c-space> echo "yay"
inoremap <silent><expr> <c-x><c-o> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gb <c-o>

nnoremap <silent> gh :call <SID>show_documentation()<CR>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)


function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" OMG argument text objects
nnoremap <Leader>h :SidewaysLeft<CR>
nnoremap <Leader>l :SidewaysRight<CR>

omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" fzf
let g:fzf_command_prefix = 'Fzf'

" Search home folder
nnoremap <Leader>a :call fzf#vim#ag(expand('~'), '"^(?=.)"', 0)<CR>
nnoremap <c-a> :let $FZF_DEFAULT_COMMAND='ag -p ~/.ignore --hidden -g "" ~' <bar> FzfFiles<CR>
nnoremap <c-p> :FzfGFiles<CR>

autocmd BufEnter * silent! lcd %:p:h " auto chdir (so ctrl-p respects the file's project)
autocmd BufRead,BufNewFile *.Jenkinsfile setfiletype groovy
autocmd BufRead,BufNewFile Jenkinsfile setfiletype groovy
autocmd BufNewFile, BufRead *.tsx setlocal filetype=typescript.tsx

" Force Saving Files that Require Root Permission
cmap w!! %!sudo tee > /dev/null %

let g:OmniSharp_server_stdio = 1
" let g:OmniSharp_server_path = '/mnt/c/Users/roeyb/.vscode/extensions/ms-dotnettools.csharp-1.21.18/.omnisharp/1.35.1/OmniSharp.exe'
" let g:OmniSharp_translate_cygwin_wsl = 1

let g:vmt_list_item_char = '-'

