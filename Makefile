nvim:
	mkdir -p ~/.config/nvim
	ln -sv $(DOTFILES)/nvim/init.lua ~/.config/nvim/init.lua
	ln -sv $(DOTFILES)/nvim/lua ~/.config/nvim/lua

clean-nvim:
	rm -rf ~/.config/nvim

fish:
	ln -sv $(DOTFILES)/fish/config.fish ~/.config/fish/config.fish

clean-fish:
	rm ~/.config/fish/config.fish

starship:
	curl -sS https://starship.rs/install.sh | sh

.PHONY: nvim clean-nvim fish clean-fish starship
