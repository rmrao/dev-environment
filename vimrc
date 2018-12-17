set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'nvie/vim-flake8'
Plugin 'w0rp/ale'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'morhetz/gruvbox'
Plugin 'rmrao/python-syntax'
Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'tmhedberg/SimpylFold'
Plugin 'Konfekt/FastFold'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'Vimjas/vim-python-pep8-indent'

call vundle#end()

set backspace=2
imap jj <Esc>
set number
set mouse=a
syntax on

set shiftwidth=4
set tabstop=4
set expandtab
set fdm=syntax
set termguicolors

let g:delimitMate_expand_cr = 1
let g:ale_linters_explicit = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:ale_echo_msg_format = '[%linter% - %code] %%s'
let g:ale_lint_on_text_changed = 'normal' 
let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0
let g:jedi#popup_on_dot = 0
let g:SuperTabDefaultCompletionType = "context"

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <C-X> :bdelete<CR>
nnoremap <Leader>f :NERDTreeToggle<Enter>
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

set autoindent
filetype plugin indent on

set background=dark
silent! colorscheme gruvbox 

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

au BufNewFile,BufRead *.cuh set ft=cuda
au BufEnter *.cc set ft=cpp
au FileType * set fo=tcql
au FileType python au BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
au FileType python setlocal completeopt-=preview
