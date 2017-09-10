DIR=$(HOME)/dotfiles

all: vim

vim:
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

.PHONY: vim
