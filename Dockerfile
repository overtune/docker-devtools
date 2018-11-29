FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
	build-base \
	curl \
    tmux \
	vim \
    git \
	tig \
    zsh \
	cmake \
	python3-dev

# Install Oh-my-shell
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

# Get the dotfiles
RUN cd ~ && \
	git clone https://github.com/overtune/dotfiles.git && \
	cd dotfiles && \
	sh makesymlinks.sh

# Install Vim plugs
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim
RUN vim +PlugInstall +qall && \
	cd ~/.vim/plugged/YouCompleteMe && python3 install.py

ENV TERM=xterm-256color
ENV SHELL /bin/zsh
CMD ["zsh"]
