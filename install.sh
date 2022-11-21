#!/bin/bash

BINPATH=${HOME}/.local/bin
mkdir -p $BINPATH

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sf ./zshrc ${HOME}/.zshrc
ln -sf ./bash_aliases ${HOME}/.bash_aliases

# Install zsh gruvbox theme
echo "Installing zsh gruvbox theme..."
curl -fsSL https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme

# Install newer tmux
echo "Installing tmux..."
git clone https://github.com/jealie/install_tmux.git && ./install_tmux/install_tmux.sh
ln -sf ./tmux.conf ${HOME}/.tmux.conf

# Install neovim
echo "Installing neovim..."
curl -fsSL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar xz
ln -sf ./nvim-linux64/bin/nvim ${BINPATH}/nvim
mkdir -p ${HOME}/.config/nvim
ln -sf ./init.vim ${HOME}/.config/nvim/init.vim

# Install newest node.js (for coc.nvim)
echo "Installing node.js..."
curl -fsSL install-node.vercel.app/lts | bash

# Update neovim packages
echo "Installing neovim plugins..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall
nvim +CocInstall +qall

# Install anaconda
echo "Installing miniconda..."
curl -fsSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh | bash -b -p ${HOME}/miniconda
source ${HOME}/.zshrc  # update path

# Install default environment
${HOME}/miniconda/bin/conda create -n default "python<3.10"
${HOME}/miniconda/bin/conda activate default
${HOME}/miniconda/bin/mamba install mypy flake8 autopep8 ipython cython pytorch cudatoolkit torchvision biopython jupyter matplotlib seaborn pandas numpy scipy -c pytorch
