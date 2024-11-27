FROM docker.io/aghost7/dev-base:noble

ENV IMAGE_CLASS rust

RUN sudo apt-get update && \
# needed for reqwest, warp, etc
	sudo apt-get install --no-install-recommends -y pkgconf libssl-dev && \
# stuff for embeded
    sudo apt-get install --no-install-recommends -y gdb-multiarch minicom openocd bluez rfkill usbutils && \
	sudo apt-get clean && \
	sudo rm -rf /var/lib/apt/lists/*

COPY ./rust.lua $HOME/.config/nvim/lua/plugins/rust.lua
RUN sudo chown -R $USER:$USER $HOME/.config/nvim/lua/plugins

ENV RUST_DEFAULT_TOOLCHAIN=stable

COPY ./zshrc-additions.sh /tmp/zshrc-additions.sh
RUN cat /tmp/zshrc-additions.sh >> ~/.zshrc && sudo rm /tmp/zshrc-additions.sh

COPY build.sh /usr/local/bin/build.sh
RUN /usr/local/bin/build.sh && sudo rm -f /usr/local/bin/build.sh

# For some reason rustup doesn't work well so I'll only place a volume for the
# cargo registry.
#RUN mkdir -p $HOME/.cargo/registry
#VOLUME $HOME/.cargo/registry
#
#RUN sudo chown -R $USER:$USER $HOME/.cargo
