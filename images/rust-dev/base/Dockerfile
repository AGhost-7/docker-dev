FROM aghost7/nvim:bionic

USER aghost-7

# Install openssl/pkgconf to compile against for reqwest and Iron.
RUN sudo apt-get update && \
	sudo apt-get install pkgconf libssl-dev --no-install-recommends -y && \
	sudo apt-get clean && \
	sudo rm -rf /var/lib/apt/lists/*

COPY ./plugin.vim /tmp/plugin.vim

RUN cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim && \
	nvim +PlugInstall +qall && \
	sudo rm /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

RUN cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim && \
	sudo rm /tmp/post-plugin.vim

COPY install-rust.sh /install-rust.sh

ONBUILD COPY .rust-toolchain $HOME/.rust-toolchain
ONBUILD RUN /install-rust.sh

# For some reason rustup doesn't work well so I'll only place a volume for the
# cargo registry.
VOLUME $HOME/.cargo/registry

RUN sudo chown -R $USER:$USER $HOME/.cargo

CMD ["/bin/bash"]

