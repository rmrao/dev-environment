set -e
cp -a bashrc "${HOME}/.bashrc"
eval ./install_vim.sh
su -c 'eval ./install_tmux.sh' $LOGNAME
su -c 'eval ./install_python.sh' $LOGNAME
