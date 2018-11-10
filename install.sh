# Setup bashrc, vimrc, etc.
cp .bashrc ~
cp .vimrc ~
cp .tmux.conf ~
cp -r .vim ~

# Install Anaconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
rm ./Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
conda install python==3.6

# Install vim
add-apt-repository ppa:jonathonf/vim
apt update
apt install vim

# Install Vundle and vim plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


