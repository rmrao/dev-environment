set nocompatible

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'

" vim-plug Plugins
call plug#begin('~/.vim/bundle')
Plug 'gmarik/Vundle.vim'
Plug 'w0rp/ale'
" Plug 'davidhalter/jedi-vim'
Plug 'nvie/vim-flake8'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'rmrao/python-syntax'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'scrooloose/nerdtree'
Plug 'Raimondi/delimitMate'
" Plug 'ervandew/supertab'
" Plug 'Valloric/MatchTagAlways'
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'lervag/vimtex'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jeetsukumaran/vim-python-indent-black'
call plug#end()

let g:isort_command = 'isort'

" Change python indentation to better match PEP8
let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'
let g:pyindent_close_paren = 0

" Change python syntax highlighting to ignore space errors
let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

" Change latex flavor
let g:tex_flavor = "latex"

" Tell airline about the other extensions being used so it can incorporate
" them
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1

" ALE settings
let g:ale_linters_explicit = 1
let g:ale_echo_msg_format = '[%linter%% - code%] %s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" SuperTab
" let g:SuperTabDefaultCompletionType = '<C-o>'
" use <tab> for trigger completion and navigate to the next complete item

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

let g:delimitMate_expand_cr = 1

" Navigate buffers with tabs
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <C-X> :bdelete<CR>

" Open/close folds with <Space>
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Coc shortcuts
nnoremap <leader>d :call CocActionAsync('jumpDefinition')<CR>
nnoremap <silent> <C-j> :call CocAction('diagnosticNext')<CR>
nnoremap <silent> <C-k> :call CocAction('diagnosticPrevious')<CR>
" nnoremap <S-k> :YcmCompleter GetDoc<CR>
" nnoremap <Leader>f :YcmCompleter FixIt<CR>
nmap <C-_> <Plug>CommentaryLine
imap <C-_> <Esc><Plug>CommentaryLineA
" xmap <C-_> <Plug>CommentaryLine
command Black :call Black()<CR>
command Fmt :call Isort()<CR>

" Vim Settings

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
set autoindent
filetype plugin indent on

set background=dark
silent! colorscheme gruvbox

au BufNewFile,BufRead *.cuh set ft=cuda
au BufEnter *.cc set ft=cpp
au FileType * set fo=tcql
au FileType python setlocal completeopt-=preview
au FileType python setlocal indentkeys-=<:>
au FileType python setlocal indentkeys-=:
