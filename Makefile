DIR=$(HOME)/dotfiles

all: vim zsh

vim:
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

zsh:
	ln -svf $(DIR)/zsh/zshrc ~/.zshrc
	ln -svf $(DIR)/zsh/aliases ~/.aliases
	ln -svf $(DIR)/zsh/zsh_custom ~/.zsh_custom

.PHONY: vim zsh
