set -e
cp -a vim ${HOME}/.vim
if (( $EUID != 0 )); then
    echo "WARNING: Not installing vim as you didn't run this as root."
else
    add-apt-repository ppa:jonathonf/vim
    apt update
    apt install vim
fi

# Install Vundle and vim plugins
su -c 'git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim' $LOGNAME

su -c 'eval ./update_vimrc.sh' $LOGNAME

