install:
	bash install.sh

backup:
	cp -f ~/.bashrc.ftw dotfiles/
	if [ -r ~/.bashrc.ftw.mac ]; then cp -f ~/.bashrc.ftw.mac dotfiles/; fi
	if [ -r ~/.bashrc.ftw.linux ]; then cp -f ~/.bashrc.ftw.linux dotfiles/; fi
