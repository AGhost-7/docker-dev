Just a concept inspired by: https://github.com/bbartolome/docker-bash

Basic idea is to have a portable development environment using docker. I took
it a bit further and made everything layered (broke it down a lot). This way I
can build images for a Rust or Scala environment (or w/e language) from the
same neovim/tmux/powerline setup, without having to strip out the nodejs part
first.

## Images
- `ubuntu-dev-base`: Ubuntu Trusty image with a few presets such as docker of
already installed. Might add docker-compose in there eventually. Not decided.
Main thing with this image though is that it downgrades from root to a regular
user. It is also configured to also passwordless `sudo` just like those vagrant
images.
- `power-tmux`: Powerline + Tmux. Based from the `ubuntu-dev-base` image.
- `ubuntu-nvim`: NeoVim image. Based from `ubuntu-tmux`. Language agnostic vim
setup (no language-specific plugins in there).
- `nodejs-dev`: nvm + nodejs specific configurations. Tag convention uses the
nodejs version which is pre-installed. For example nodejs v0.10.38 is named 
aghost7/nodejs-dev:v0.10.38.

## Vim Configuration
Vim configurations are broken down into three parts:
- `init.vim`: This is the equivalent for `.vimrc` in NeoVim.
- `plugin.vim`: This contains all plugins which will be installed using 
`vim.plug`.
- `post-plugin.vim`: Contains all plugin-specific configurations for Neovim.
Configurations which aren't plugin-specific reside in the `init.vim` file.

Breaking it down this way allows one to just run
`cat addition.vim >> $XDG_CONFIG_PATH/file` to add new plugins and configs for
specific programing languages and libraries.

## TODO
Add `htop` \w config, and pre-install `tree`.
