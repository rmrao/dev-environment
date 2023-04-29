echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

curl -O https://raw.githubusercontent.com/morhetz/gruvbox-contrib/master/iterm2/gruvbox-dark.itermcolors

# TODO: hack nerd font

brew install tmux wget neovim fd node

CURR=`pwd`
ln -sf ${CURR}/aliases ${HOME}/.aliases
ln -sf ${CURR}/zshrc ${HOME}/.zshrc
ln -sf ${CURR}/gitignore ${HOME}/.gitignore
ln -sf ${CURR}/tmux.conf ${HOME}/.tmux.conf
ln -sf ${CURR}/nvim ${HOME}/.config/nvim
