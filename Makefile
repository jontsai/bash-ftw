## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## install - Installs bash-ftw
install:
	bash install.sh

## backup - Back up bash-ftw dotfiles from the home directory
backup:
	cp -f ~/.bashrc.ftw dotfiles/
	if [ -r ~/.bashrc.ftw.mac ]; then cp -f ~/.bashrc.ftw.mac dotfiles/; fi
	if [ -r ~/.bashrc.ftw.linux ]; then cp -f ~/.bashrc.ftw.linux dotfiles/; fi
