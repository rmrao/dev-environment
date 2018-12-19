map <C-_> :s:^\(\s*\):\1\/\/ <CR>
map <C-T> :s:^\(\s*\)\/\/ :\1<CR>

let b:ale_linters = ['g++']
let b:ale_cpp_gcc_options = '-std=c++17 -Wall -Wextra'
