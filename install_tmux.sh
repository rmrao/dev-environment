set -e
cp .tmux.conf ~
if (( $EUID != 0 )); then
    git clone https://github.com/jealie/install_tmux.git && ./install_tmux/install_tmux.sh
    echo "WARNING: Not install vim as you didn't run this as root."
else
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
