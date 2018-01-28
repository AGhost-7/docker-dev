FROM aghost7/nvim

USER aghost-7

COPY plugin.vim /tmp/plugin.vim

RUN cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim && \
	nvim +PlugInstall +qall && \
	sudo rm /tmp/plugin.vim

# Install openssl/pkgconf to compile against for reqwest and Iron.
RUN sudo apt-get update && \
	sudo apt-get install pkgconf libssl-dev --no-install-recommends -y && \
	sudo apt-get clean && \
	sudo rm -rf /var/lib/apt/lists/*

COPY install-rust.sh /install-rust.sh

ONBUILD COPY .rust-toolchain $HOME/.rust-toolchain
ONBUILD RUN /install-rust.sh

CMD ["/bin/bash"]

