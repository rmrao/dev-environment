map <C-_> :s:^\(\s*\):\1\/\/ <CR>
map <C-T> :s:^\(\s*\)\/\/ :\1<CR>

let b:ale_linters = ['nvcc']
let b:ale_cuda_nvcc_options = '-std=c++17 -Wall -Wextra'
