" setlocal smarttab
map <C-_> :s:^\(\s*\):\1# <CR>
map <C-T> :s:^\(\s*\)# :\1<CR>
nnoremap <silent> <C-k> :ALENextWrap<CR>
nnoremap <silent> <C-j> :ALEPreviousWrap<CR>

let b:ale_linters = ['flake8', 'mypy']
let b:ale_python_mypy_options = '--ignore-missing-imports'
let b:ale_python_flake8_options = '--ignore=W293,W291,E114,E116 --max-line-length=120'
