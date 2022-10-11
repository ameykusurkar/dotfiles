DIR=$(HOME)/dotfiles

mac: vim-mac zsh vim-plug
linux: vim-linux zsh vim-plug

vim-mac:
	ln -svfh $(DIR)/vim ~/.vim
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

vim-linux:
	ln -svf $(DIR)/vim ~/.vim
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

vim-plug: $(HOME)/.vim/autoload/plug.vim
	vim +PlugInstall +PlugClean +:qa
	mkdir -p $(DIR)/vim/swapfiles

$(HOME)/.vim/autoload/plug.vim:
	curl -fLo $@ --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim:
	ln -svf $(DIR)/nvim/init.vim ~/.config/nvim/init.vim
	ln -svf $(DIR)/nvim/support.lua ~/.config/nvim/support.lua

zsh: $(HOME)/.oh-my-zsh
	ln -svf $(DIR)/zsh/zshrc ~/.zshrc
	ln -svf $(DIR)/zsh/aliases ~/.aliases
	git submodule update --init --recursive

fish:
	ln -svf $(DIR)/fish/config.fish ~/.config/fish/config.fish

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

.PHONY: vim zsh fish omf nvim
