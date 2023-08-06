DIR=$(HOME)/dotfiles

nvim:
	mkdir -p ~/.config/nvim
	ln -svf $(DIR)/nvim/init.lua ~/.config/nvim/init.lua

clean-nvim:
	rm -rf ~/.config/nvim

fish:
	ln -svf $(DIR)/fish/config.fish ~/.config/fish/config.fish

.PHONY: nvim clean-nvim fish
