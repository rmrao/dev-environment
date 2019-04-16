set -e
cp -a bashrc "${HOME}/.bashrc"
eval install_python.sh
eval install_vim.sh
eval install_tmux.sh
