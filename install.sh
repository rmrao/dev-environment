curl -O https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip
CURR=`pwd`
ln -sf ${CURR}/aliases ${HOME}/.aliases
ln -sf ${CURR}/zshrc ${HOME}/.zshrc
ln -sf ${CURR}/gitignore ${HOME}/.gitignore
ln -sf ${CURR}/tmux.conf ${HOME}/.tmux.conf
ln -sf ${CURR}/nvim ${HOME}/.config/nvim
