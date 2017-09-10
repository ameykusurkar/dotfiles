DIR=$(HOME)/dotfiles

all: vim zsh

vim:
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

zsh: oh_my_zsh
	ln -svf $(DIR)/zsh/zshrc ~/.zshrc
	ln -svf $(DIR)/zsh/aliases ~/.aliases

oh_my_zsh: $(HOME)/.oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

.PHONY: vim zsh
