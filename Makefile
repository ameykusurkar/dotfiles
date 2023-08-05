DIR=$(HOME)/dotfiles

nvim-old:
	mkdir -p ~/.config/nvim/plugin
	ln -svf $(DIR)/nvim/init.old.lua ~/.config/nvim/init.lua
	ln -svf $(DIR)/nvim/plugin/luasnip.lua ~/.config/nvim/plugin/luasnip.lua

nvim:
	mkdir -p ~/.config/nvim
	ln -svf $(DIR)/nvim/init.lua ~/.config/nvim/init.lua

clean-nvim:
	rm -rf ~/.config/nvim

fish:
	ln -svf $(DIR)/fish/config.fish ~/.config/fish/config.fish

.PHONY: nvim-old nvim clean-nvim fish
