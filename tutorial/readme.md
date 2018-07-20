# Build Your Own Docker Environment
For some time now, I've packaged all of my development tools in a container.
Some of you might be wondering why one would ever want to do this. The primary
reason for me has been simplifying how I synchronize my development environment
between the three machines I use every day (personal laptop, work laptop, and
desktop).

Before this, I was using a script which would install all of my dependencies
but I noticed there were issues: whenever I needed to run the script I would
realize that it was broken. Nowadays I don't have this issue since I rely on
the image to already have everything I need.

So, this tutorial will go into how to roll your own containerized environment.
I will start with the basics and work my way to how to run docker commands from
a container as well as the pitfalls of doing so.

## 0. Setup Your Repository
First we're going to want to setup a workspace for your things:

```
mkdir dev-environment
cd dev-environment
git init
touch Dockerfile
vim Dockerfile
```

This tutorial assumes that you are using this image as your base:
```dockerfile
FROM ubuntu:xenial
```

## 1. Setting Up Your User
The Ubuntu image does not include a user with a home directory aside from root.
Since always being root is not desirable, we will create

```dockerfile

# This tutorial does not include how to optimize the image size, therefore
# we won't be placing various commands on a single line.
RUN apt-get update

# Install sudo command...
RUN apt-get install -y sudo

# Feel free to change this to whatever your want
ENV DOCKER_USER developer

# Start by creating our passwordless user.
RUN adduser --disabled-password --gecos '' "$DOCKER_USER"

# Give root priviledges
RUN adduser "$DOCKER_USER" sudo

# Give passwordless sudo. This is only acceptable as it is a private
# development environment not exposed to the outside world. Do NOT do this on
# your host machine or otherwise.
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the user to be our newly created user by default.
USER "$DOCKER_USER"

# This will determine where we will start when we enter the container.
WORKDIR "/home/$DOCKER_USER"

# The sudo message is annoying, so skip it
RUN touch ~/.sudo_as_admin_successful
```

## 2. Basic Tooling
The `ubuntu:xenial` image does not include much since its built for "ready to
ship" applications. We will be developing in our container instead, so several
essential packages must be installed:

```dockerfile

# We will need this to build c/c++ dependencies. This is common enough
# in all my various projects that I include it in my base image; there are
# often transitive dependencies in Python/NodeJs/Rust projects which require
# c/c++ compilation.
RUN sudo apt-get install -y build-essential

# The Ubuntu image does not include curl. I prefer it, but it isn't necessary.
# Note that if you decide to not install this you will need to use wget instead
# for some of the installation commands in this tutorial.
RUN sudo apt-get install -y curl

# We will need git so we can clone repositories
RUN sudo apt-get install -y git

# SSH is not bundled by default. I always use ssh to push to Github.
RUN sudo apt-get install -y openssh-client

# The manuals are always handy for development.
RUN sudo apt-get install -y man-db

# Get basic tab completion
RUN sudo apt-get install -y bash-completion
```

### Testing It Out

Now lets build the image:
```bash
docker build -t tutorial .
```

And then run it:
```bash
docker run --rm -ti tutorial bash
```

Lets see if it works (exit with `q`):
```bash
man git
```

To get ssh working, you will need to create a volume to your `~/.ssh`
directory (replace `$DOCKER_USER` with the user name you selected at the
begining).

```bash
docker run --rm -ti --volume ~/.ssh:/home/$DOCKER_USER/.ssh tutorial bash
```

## 3. Setting up an editor
Personally, I use Neovim. Those of you who prefer Nano, Micro, Slap, Yi or
Emacs (or some other terminal-based editor) can install that instead. Keep in
mind that some of the parts in this tutorial will be specifically for Neovim.


### Install Neovim
Personally, I've been using the unstable version of neovim. It hasn't been
prone to issues due to being bleeding edge so I can recommend giving it a spin:

```dockerfile

# To add addionnal apt repositories, we will require this package.
RUN sudo apt-get install -y software-properties-common

# Now add the repository for neovim
RUN sudo add-apt-repository ppa:neovim-ppa/unstable

# Update the package listing
RUN sudo apt-get update

# Install the real deal
RUN sudo apt-get install neovim -y

# Make neovim the default editor for git, etc.
ENV EDITOR nvim
```

### Configuration
There's a lot of customization which can be done with Neovim, but for now we
will just start with some basics.

Create a file containing your Neovim configuration and open it:
```vim
touch init.vim
vim
```

In the file, add the following:
```vim

" Start the list of vim plugins
call plug#begin("~/.config/nvim/plugged")

" Download a better colorscheme
Plug 'crusoexia/vim-monokai'

" Better file system browser
Plug 'scrooloose/nerdtree'

" Nerdtree git support!
Plug 'Xuyuanp/nerdtree-git-plugin'

" Allows you to run git commands from vim
Plug 'tpope/vim-fugitive'

" Github integration
Plug 'tpope/vim-rhubarb'

" Fuzzy file name searcher
Plug 'kien/ctrlp.vim'

" plugin for the tab and status bar
Plug 'vim-airline/vim-airline'

" Download powerline theme for the statusbar.
Plug 'vim-airline/vim-airline-themes'

" Git commit browser
Plug 'junegunn/gv.vim'

" End the list of vim plugins
call plug#end()

" Display the row numbers (line number)
set relativenumber

" Make the line number show up in the gutter instead of just '0'.
set number

" Add a bar on the side which delimits 80 characters.
set colorcolumn=80

" 72 characters makes it easier to read git log output.
autocmd Filetype gitcommit setl colorcolumn=72

" Will search the file as you type your query
set incsearch

" For some reason the mouse isn't enabled by default anymore...
set mouse=a

" Enable folds that are for the most part placed in the comments.
set foldmethod=marker

" Add a mapping for the NERDTree command, so you can just type :T to open
command T NERDTree

" set global theme
silent! colorscheme monokai

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme powerlineish
```

Add the following commands to your Dockerfile:
```dockerfile
# To add addionnal apt repositories, we will require this package.
RUN sudo apt-get install -y software-properties-common

# Now add the repository for neovim
RUN sudo add-apt-repository ppa:neovim-ppa/unstable

# Update the package listing
RUN sudo apt-get update

# Install the real deal
RUN sudo apt-get install neovim -y

# Create configuration directory for neovim
RUN mkdir -p "$HOME/.config/nvim"

# Copy our configuration
COPY ./init.vim /tmp/init.vim
RUN cat /tmp/init.vim > ~/.config/nvim/init.vim && \
	sudo rm /tmp/init.vim

# Install vim-plug, our plugin manager
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install all of our plugins
RUN nvim +PlugInstall +qall
```

## 4. Multiplexing
Up next, we will need to install a multiplexer. A multiplexer allows us to
open multiple shell "tabs" from a single session. This is useful in many
contexts such as accessing remote servers, but in this case we will be using
it for our development environment.

Create the configuration file and open it:
```bash
touch .tmux.conf
vim .tmux.conf
```

Place the following into your configuration file:
```
# Enable mouse
set -g mouse on

# Quick kill panels/windows
bind-key X kill-window
bind-key x kill-pane

# When in clipboard selection mode, behave like vim. E.g., "b" will go back a
# word, "w" goes to the start of the next word, "e" goes to the end of the next
# word, etc.
setw -g mode-keys vi

# Start the selection with "v" just like in vim
bind-key -Tcopy-mode-vi 'v' send -X begin-selection

# Copy the selection just like in vim with "y"
bind-key -Tcopy-mode-vi 'y' send -X copy-selection

# Set the escape time to 10 ms instead of 500
set-option -sg escape-time 10
```

The only real way to get tmux is to build it from source. Luckily, there are
plenty of resources showing how to build it on Ubuntu:
```dockerfile

ENV TMUX_VERSION 2.6

ENV TMUX_TAR "tmux-$TMUX_VERSION.tar.gz"

# Download the tmux archive
RUN curl -L -o "/tmp/tmux-$TMUX_VERSION.tar.gz" \
		"https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/$TMUX_TAR"

# Change our working directory to the location where our archive is
WORKDIR /tmp

# Untar the tmux source code
RUN tar xzf "$TMUX_TAR" -C /tmp

# Switch to the directory containing the extracted source code.
WORKDIR "/tmp/tmux-$TMUX_VERSION"

# Since we're building source code, we will require certain libraries to
# compiler against (header files) as well as library files which will be
# linked to the tmux program at runtime.
RUN sudo apt-get install -y libevent-2.0-5 libevent-dev libncurses-dev

# Generate configuration files and make sure all dependencies are present
RUN ./configure

# Build the tmux binary
RUN make

# Install tmux globally
RUN sudo make install

# Tmux requires the TERM environment variable to be set to this specific value
# to run as one would expect.
ENV TERM=screen-256color

# Switch back to our normal directory
WORKDIR /home/$DOCKER_USER

# Copy our basic tmux configuration
COPY ./.tmux.conf /tmp/.tmux.conf
RUN cat /tmp/.tmux.conf > ~/.tmux.conf && \
	sudo rm /tmp/.tmux.conf
```
