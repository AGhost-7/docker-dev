# Docker Dev
Spin up a container to develop from anywhere!

![docker-dev](https://raw.githubusercontent.com/AGhost-7/docker-dev/assets/demo.gif)

To run, just:
```
docker run -ti aghost7/nodejs-dev:boron tmux new
```

Alternatively, if on Linux:
```
python3 -m pip install --user slipway
slipway start aghost7/nodejs-dev:carbon
```

## Terminal
Lately, I've been using [alacritty][alacritty]. You can find my configurations
[here][alacritty_config]. Gnome terminal and/or iTerm2 works fine though.

[alacritty]: https://github.com/jwilm/alacritty
[alacritty_config]: https://github.com/AGhost-7/dotfiles/tree/master/alacritty

## Images

### Language Images
- `ubuntu-dev-base`: Ubuntu image with a few presets such as docker of
already installed. It is also configured to allow passwordless `sudo` just like
those vagrant images. Tags available:
	- `bionic`: Ubuntu Bionic Beaver (18.04) image.
	- `focal`: Ubuntu Focal Fossa (20.04) image.
- `power-tmux`: Powerline + Tmux. Based from the `ubuntu-dev-base` image.
Images available:
	- `bionic`
	- `focal`
- `nvim`: NeoVim image. Based from `ubuntu-tmux`. Language agnostic vim
setup (no language-specific plugins in there). Images available:
	- `bionic`
	- `focal`
- `nodejs-dev`: nvm + nodejs specific configurations. Tags available:
	- `focal-erbium`: Ubuntu 20.04 + NodeJs 12.
- `rust-dev`: NeoVim configuration and autocomplete for the Rust language. 
	- `focal-stable` uses rust stable with YouCompleteMe backed by only racer.
	- `focal-nightly` uses rust nightly with deoplete backed by RLS.
- `py-dev`: Python configuration with autocomplete for python and ptpython.
	- `focal`: Ubuntu 20.04 + python 3.6
- `ruby-dev`: Ruby image with language server. Tags:
	- `focal`: Ruby 2.3 pre-installed.
- `c-dev`: Ubuntu Bionic image for c development with cquery for completions.
	- `focal`: Ubuntu 20.04 + clangd
- `deno-dev`: Ubuntu Bionic image for deno development with bash completions.
Tags Available:
	- `bionic`: Ubuntu 18.4 + Deno v1.0 
- `devops`: Python image with additional tools (e.g., terraform) for devops
related tasks. Images available:
	- `focal`
	
### Database Images
- `pg-dev`: Postgresql image with pgcli, a command line client with
autocompletions and syntax highlighting. Tags correspond to the Postgresql
version:
	- `9.6`
	- `10`
	- `11`
- `my-dev`: MySql image with mycli utility. Tags correspond to the mysql
version:
	- `5.6`
	- `5.7`
	- `8.0`
- `mongo-dev`: Official mongodb image with [Mongo Hacker][mongo_hacker] added.
Tags correspond to the mongdb version:
	- `4.1`
- `redis-dev`: Redis image with [iredis][iredis] included. Tags available:
	- `6`

[mongo_hacker]: https://github.com/TylerBrock/mongo-hacker
[iredis]: https://github.com/laixintao/iredis

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

## Calling Docker on the Host
The docker daemon run over a socket. The command line tool is just a client to
the daemon. In other words, if we make the socket connectable from within the
container we're in business.

For some reason it needs `privileged` to work as well.
```bash
docker run -ti --rm \
	--privileged \
	-v `readlink -f /var/run/docker.sock`:/var/run/docker.sock \
	aghost7/ubuntu-dev-base:latest \
	tmux new
```

## SSH Forwarding and Git
For ssh, just pass the socket over to the container.
```
docker run -ti --rm \
	-v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
	-e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
	aghost7/ubuntu-dev-base:latest \
	tmux new
```
I like to avoid having to reconfigure git every time, so I mount a volume for
`.gitconfig`. `~/.ssh/known_hosts` is also anoying.

## Getting the Clipboard Working
Basically, X11 is built in a manner that allows sending display data over the
wire. I've managed to run GUI applications from a headless server through an
ssh connection in the past. The way I'm doing this is through the same old
unix socket trick for controlling the docker daemon that's on the host machine.

```bash
docker run -ti --rm \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	aghost7/ubuntu-dev-base:latest bash
```

On the host you'll need to disable one of the security features in X11.
```bash
xhost +si:localuser:$USER > /dev/null
```

Source: http://stackoverflow.com/questions/25281992/alternatives-to-ssh-x11-forwarding-for-docker-containers

## Build your own
There is a tutorial which can be found [here](tutorial/readme.md).
