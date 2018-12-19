map <C-_> :s:^\(\s*\):\1\/\/ <CR>
map <C-T> :s:^\(\s*\)\/\/ :\1<CR>

let b:ale_linters = ['gcc']
let b:ale_c_gcc_options='-std=c11 -Wall -Wextra'
