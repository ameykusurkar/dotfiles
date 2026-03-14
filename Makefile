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

claude: clean-claude
	mkdir -p ~/.claude/skills
	ln -sv $(DOTFILES)/claude/skills/tmux-show ~/.claude/skills/tmux-show

clean-claude:
	rm -rf ~/.claude/skills/tmux-show

.PHONY: nvim lazyvim clean-nvim fish clean-fish tmux clean-tmux alacritty clean-alacritty claude clean-claude
