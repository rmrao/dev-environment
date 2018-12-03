set -e

# Setup bashrc, vimrc, etc.
cp .bashrc ~
cp .vimrc ~
cp .tmux.conf ~
cp -r .vim ~

# Install vim and tmux
if (( $EUID == 0 )); then
    git clone https://github.com/jealie/install_tmux.git && ./install_tmux/install_tmux.sh
    echo "WARNING: Not install vim as you didn't run this as root."
else
    add-apt-repository ppa:jonathonf/vim
    apt update
    apt install vim

    apt install -y git automake build-essential pkg-config libevent-dev libncurses5-dev
    rm -fr /tmp/tmux
    git clone https://github.com/tmux/tmux.git /tmp/tmux
    cd /tmp/tmux
    sh autogen.sh

    if [ -f /proc/cpuinfo ]; then
        CPUS=`grep processor /proc/cpuinfo | wc -l`
    else
        CPUS=2
    fi

    ./configure && make -j${CPUS}
    make install
    cd -
    rm -fr /tmp/tmux
fi

# Install Vundle and vim plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Install Anaconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
rm ./Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
conda install python==3.6

pip install -U mypy
pip install -U flake8
