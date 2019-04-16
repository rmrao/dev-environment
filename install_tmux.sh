#!/bin/bash

set -e
cp -a tmux.conf "${HOME}/.tmux.conf"
if (( $EUID != 0 )); then
    [[ $(dpkg-query -W --showformat='${Status}\n' curl | grep "install ok installed") ]] || { echo "curl not installed" 1>&2; exit 1; }
    [[ $(dpkg-query -W --showformat='${Status}\n' libtool | grep "install ok installed") ]] || { echo "libtool not installed" 1>&2; exit 1; }
    [[ $(dpkg-query -W --showformat='${Status}\n' pkg-config | grep "install ok installed") ]] || { echo "pkg-config not installed" 1>&2; exit 1; }
    [[ $(dpkg-query -W --showformat='${Status}\n' automake | grep "install ok installed") ]] || { echo "automake not installed" 1>&2; exit 1; }
    git clone https://github.com/jealie/install_tmux.git && ./install_tmux/install_tmux.sh
    echo "" >> "${HOME}/.bashrc"
    echo "export PATH=~/local/bin:\$PATH" >> "${HOME}/.bashrc"
    source "${HOME}/.bashrc" 
    rm -rf ./install_tmux
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
