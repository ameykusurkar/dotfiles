DIR=$(HOME)/dotfiles

all: vim zsh

vim:
	ln -svfh $(DIR)/vim ~/.vim
	ln -svf $(DIR)/vim/vimrc ~/.vimrc

zsh: $(HOME)/.oh-my-zsh
	ln -svf $(DIR)/zsh/zshrc ~/.zshrc
	ln -svf $(DIR)/zsh/aliases ~/.aliases

$(HOME)/.oh-my-zsh:
	$(DIR)/scripts/install-oh-my-zsh

clean:
	rm -f ~/.vimrc
	rm -f ~/.zshrc
	rm -f ~/.aliases
	rm -rf ~/.oh-my-zsh

.PHONY: vim zsh
