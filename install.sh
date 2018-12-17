set -e
cp bashrc "${HOME}/.bashrc"
eval ./install_vim.sh
eval ./install_tmux.sh
eval ./install_python.sh
