# Docker Dev
Spin up a container to develop from anywhere!

![docker-dev](https://raw.githubusercontent.com/AGhost-7/docker-dev/assets/demo.gif)

To run, just:
```
docker run -ti aghost7/nodejs-dev:boron tmux new
```

Alternatively, using [slipway](https://github.com/AGhost-7/slipway):
```
python3 -m pip install --user slipway
slipway start aghost7/nodejs-dev:noble
```

## Terminal
Lately, I've been using [alacritty][alacritty]. You can find my configurations
[here][alacritty_config]. Gnome terminal and/or iTerm2 works fine though.

[alacritty]: https://github.com/jwilm/alacritty
[alacritty_config]: https://github.com/AGhost-7/dotfiles/tree/master/alacritty

## Images

### Language Images
Only the `:noble` tag is currently maintained.
- `dev-base`: Ubuntu base image with neovim and tmux.
- `nodejs-dev`: nvm + nodejs specific configurations. Tags available:
- `rust-dev`: NeoVim configuration and autocomplete for the Rust language. 
- `py-dev`: Python configuration with autocomplete for python and ptpython.
- `c-dev`: Ubuntu Bionic image for c development with cquery for completions.
- `deno-dev`: Ubuntu Bionic image for deno development with bash completions.
Tags Available:
- `devops`: Python image with additional tools (e.g., terraform) for devops
related tasks.
	
### Database Images
- `pg-dev`: Postgresql image with pgcli, a command line client with
autocompletions and syntax highlighting. Tags correspond to the Postgresql
version.
- `mongo-dev`: Official mongodb image with [Mongo Hacker][mongo_hacker] added.
Tags correspond to the mongdb version.

[mongo_hacker]: https://github.com/TylerBrock/mongo-hacker
[iredis]: https://github.com/laixintao/iredis


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
