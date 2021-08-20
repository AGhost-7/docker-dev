FROM aghost7/nvim:focal

USER aghost-7

ENV IMAGE_CLASS rust

RUN sudo apt-get update && \
# needed for reqwest, warp, etc
	sudo apt-get install --no-install-recommends -y pkgconf libssl-dev && \
# stuff for embeded
    sudo apt-get install --no-install-recommends -y gdb-multiarch minicom openocd bluez rfkill usbutils && \
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
