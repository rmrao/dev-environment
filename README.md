# Dev Environment Setup

This are config files and install scripts for a number of programs that I often use. It mostly sets up a python development environment with vim. At the moment it contains

* .bashrc
* .vimrc + ftplugin commands for vim
* .tmux.conf (tells tmux to use 256 color)
* install script for vim8 (requires sudo - vim8 needed for asynchronous linting)
* install script for tmux new version (with or without sudo)
* install script for miniconda and python3.6

# Bashrc

The `.bashrc` file mainly changes the status line so that it gives you some information about the status of any git repository you may be in. There are extensions that do this in different ways, but I prefer what I have because it's simple, clean, and fast. 

The `.bashrc` will also change color settings that may be required for 256-bit color across tmux, vim, ssh, etc. If you have problems with colors and you haven't copied the `.bashrc` file, you may want start here.

Finally, if gruvbox (see the vim plugin below) is available on your machine, it will switch to using that as your colorscheme. You may or may not want this, so feel free to delete the corresponding line (search for `gruvbox` in the `.bashrc`) if you don't. 

# Vim Plugins

I use a bunch of vim plugins to make quality of life improvements for vim. Some of these are general quality of life improvements and some are targeted specifically for python editing. Here's a list.

### [Vundle](https://github.com/gmarik/Vundle.vim)
Vundle is a vim package manager, which is used to download and install all the other packages. That means it has to be installed first, and separately. If you don't already have vundle installed, the `install_vim.sh` script will clone and install the repository for you.

### [ALE](https://github.com/w0rp/ale)
Asynchronous Lint Engine (ALE) is a tool for linting your code asynchronously (obviously). Older vim setup guides suggest using [syntastic](https://github.com/vim-syntastic/syntastic), but I found syntastic to be extremely slow. I enable two linters by default (mypy and [flake8](https://github.com/nvie/vim-flake8)). Settings for the linters can be found in `.vim/ftplugin/python.vim`.

### [Jedi](https://github.com/davidhalter/jedi-vim)
Jedi is a python tool for autocompletion and showing documentation. There are several vim extensions that enable Jedi support. This is the one that I find the easiest to use and the most lightweight. Still, this plugin can be slow, especially on laptops. If you find that vim is being very slow, you might try disabling this first.

### [Supertab](https://github.com/ervandew/supertab)
Supertab lets you use \<TAB\> for insert completion. Combined with Jedi it uses different kinds completion depending on the context.

### [SimpylFold](https://github.com/tmhedberg/SimpylFold)
Vim doesn't do python code folding well be default. SimpylFold fixes that.

### [FastFold](https://github.com/Konfekt/FastFold)
Vim folding is a little slow - this speeds it up. I also change the fold command to map \<Space\> so it's really easy to open and close folds.

### [NerdTree](https://github.com/scrooloose/nerdtree)
NerdTree is a pretty standard addition to vim and provides an easier-to-navigate folder structure when you open a folder in vim. Honestly, I don't use nerdtree that much, and I find the default vim folder navigation feature pretty much ok. NerdTree does have some nice features like [this git plugin](https://github.com/Xuyuanp/nerdtree-git-plugin) that lets you see the changes you've made.

### [Fugitive](https://github.com/tpope/vim-fugitive)
A git wrapper that turns a lot of git commands into vim commands. It also provides information on the status of the file you're currently editing.

### [Airline](https://github.com/vim-airline/vim-airline)
Gives you a nice status and tabline. It also has integration with a bunch of other plugins (like ALE and fugitive) which can display additional information. It will also display the buffers you have open.

### [Python Syntax](https://github.com/rmrao/python-syntax)
This changes what vim highlights as python syntax. It's actually forked from a different repository, because I've changed it to also highlight function calls (function definitions and function calls are in different colors).

### [Python Indentation](https://github.com/Vimjas/vim-python-pep8-indent)
Vim does some odd things with indentation, especially when you have a continued line. Most annoyingly, it tends to put in two tabs instead of one when you continue a function call onto a second line. This plugin does fix that, although it's kind of slow and also seems to interact strangely with the pop ups from Jedi. Unfortunately I can't seem to find a better version.

### [Markdown Preview](https://github.com/JamshedVesuna/vim-markdown-preview)
A pretty lightweight markdown previewer. There are others, and I have no specific reason to praise this one over those, so you may want to experiment.

### [Gruvbox](https://github.com/morhetz/gruvbox)
A vim colorscheme that I actually use across vim and terminal. It's not everyone's favorite, and you can change the colorscheme in .vimrc by changing the `colo gruvbox` command to be whichever colorscheme you prefer. My `.bashrc` file will also switch to using gruvbox if it's available on your machine, which you can enable (just search for `gruvbox` in the `.bashrc` and delete the line on which it appears).

# Known Problems

The main known issue is with ssh, tmux, and colors. Currently the 256-bit colors will not work with standard Mac terminal, but will work with iTerm. Alternatively, you can downgrade to 16-bit colors by removing the `set termguicolors` command in the `.vimrc`.

If you do want to use gruvbox colors in terminal, the current `.bashrc` might be enough to make it work. If not, I found the easiest way to fix the colors is to manually go to settings and change the colors used to the ones gruvbox uses. You can find a list of colors on the gruvbox GitHub page.
