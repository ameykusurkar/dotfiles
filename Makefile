nvim:
	mkdir -p ~/.config/nvim
	ln -sv $(DOTFILES)/nvim/init.lua ~/.config/nvim/init.lua
	ln -sv $(DOTFILES)/nvim/lua ~/.config/nvim/lua

clean-nvim:
	rm -rf ~/.config/nvim

fish:
	ln -sv $(DOTFILES)/fish/config.fish ~/.config/fish/config.fish

clean-fish:
	rm -f ~/.config/fish/config.fish

tmux:
	ln -sv $(DOTFILES)/.tmux.conf ~/.tmux.conf

clean-tmux:
	rm -f ~/.tmux.conf

.PHONY: nvim clean-nvim fish clean-fish tmux clean-tmux
