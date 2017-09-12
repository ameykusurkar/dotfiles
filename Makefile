DIR=$(HOME)/dotfiles

all: vim zsh

vim:
	ln -svfh $(DIR)/vim ~/.vim
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

vim-plug:
	vim +PlugInstall +:qa

zsh: $(HOME)/.oh-my-zsh
	ln -svf $(DIR)/zsh/zshrc ~/.zshrc
	ln -svf $(DIR)/zsh/aliases ~/.aliases

$(HOME)/.oh-my-zsh:
	$(DIR)/scripts/install-oh-my-zsh

# To test setup from scratch
teardown: teardown-vim teardown-zsh

teardown-vim:
	rm -f ~/.vimrc
	rm -rf ~/.vim
	rm -rf $(DIR)/vim/plugged

teardown-zsh:
	rm -f ~/.zshrc
	rm -f ~/.aliases
	rm -rf ~/.oh-my-zsh

.PHONY: vim zsh
