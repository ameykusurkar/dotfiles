DIR=$(HOME)/dotfiles

all: vim zsh

vim:
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

zsh:
	ln -svf $(DIR)/zsh/zshrc ~/.zshrc
	ln -svf $(DIR)/zsh/aliases ~/.aliases

.PHONY: vim zsh
