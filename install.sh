# Setup bashrc, vimrc, etc.
cp .bashrc ~
cp .vimrc ~
cp .tmux.conf ~
cp -r .vim ~

# Install Anaconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Install vim
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim

# Install Vundle and vim plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


