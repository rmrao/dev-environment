set -e
cp -r .vim ~
if (( $EUID == 0 )); then
    echo "WARNING: Not installing vim as you didn't run this as root."
else
    add-apt-repository ppa:jonathonf/vim
    apt update
    apt install vim
fi

eval ./update_vimrc.sh

# Install Vundle and vim plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
