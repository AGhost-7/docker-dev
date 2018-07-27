FROM tutorial:3

ENV TMUX_VERSION 2.7

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

# vim: set ft=dockerfile:
