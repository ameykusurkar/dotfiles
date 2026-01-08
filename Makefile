nvim: clean-nvim
	ln -sv $(DOTFILES)/nvim ~/.config/nvim

lazyvim: clean-nvim
	ln -sv $(DOTFILES)/nvim-lazy ~/.config/nvim

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

alacritty: $(HOME)/.config/alacritty/catppuccin-mocha.toml
	mkdir -p ~/.config/alacritty
	ln -sv $(DOTFILES)/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

clean-alacritty:
	rm -f ~/.config/alacritty/alacritty.toml

$(HOME)/.config/alacritty/catppuccin-mocha.toml:
	mkdir -p ~/.config/alacritty
	curl -LO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml

.PHONY: nvim nvim-lazy clean-nvim fish clean-fish tmux clean-tmux alacritty clean-alacritty
