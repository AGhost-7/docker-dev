FROM aghost7/nodejs-dev-base

USER aghost-7

RUN . ~/.nvm/nvm.sh && \
	nvm install --lts=carbon && \
	nvm alias default stable

CMD ["/bin/bash"]
