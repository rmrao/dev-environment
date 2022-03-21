" setlocal smarttab
map <C-_> :s:^\(\s*\):\1# <CR>
map <C-T> :s:^\(\s*\)# :\1<CR>
nnoremap <silent> <C-j> :ALENextWrap<CR>
nnoremap <silent> <C-k> :ALEPreviousWrap<CR>

let b:delimitMate_expand_cr = 0

let b:ale_linters = ['flake8', 'mypy']
let b:ale_python_mypy_options = '--ignore-missing-imports'
let b:ale_python_flake8_options = '--ignore=W293,W291,W503,E114,E116,E203 --max-line-length=88'

let b:black_linelength = 88
let b:black_skip_string_normalization = 1
