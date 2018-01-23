FROM tutorial:2

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

# vim: set ft=dockerfile:
