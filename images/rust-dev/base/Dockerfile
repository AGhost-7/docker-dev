FROM aghost7/nvim:focal

USER aghost-7

ENV IMAGE_CLASS rust

# Install
# - openssl/pkgconf to compile against for reqwest and warp.
# - gdb-multiarch, minicom, openocd for embeded
RUN sudo apt-get update && \
	sudo apt-get install pkgconf libssl-dev gdb-multiarch minicom openocd bluez rfkill --no-install-recommends -y && \
	sudo apt-get clean && \
	sudo rm -rf /var/lib/apt/lists/*

COPY ./plugin.vim /tmp/plugin.vim

RUN cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim && \
	nvim +PlugInstall +qall && \
	sudo rm /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

RUN cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim && \
	sudo rm /tmp/post-plugin.vim

COPY rust-install.sh /usr/local/bin/rust-install.sh

# For some reason rustup doesn't work well so I'll only place a volume for the
# cargo registry.
RUN mkdir -p $HOME/.cargo/registry
VOLUME $HOME/.cargo/registry

RUN sudo chown -R $USER:$USER $HOME/.cargo
