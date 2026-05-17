nvim: clean-nvim
	ln -sv $(DOTFILES)/nvim ~/.config/nvim

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

claude-skills:
	mkdir -p ~/.claude/skills
	ln -sv $(DOTFILES)/claude/me/skills/review-this ~/.claude/skills/review-this
	ln -sv $(DOTFILES)/claude/me/skills/grill-me ~/.claude/skills/grill-me

clean-claude-skills:
	rm -rf ~/.claude/skills/review-this \
		~/.claude/skills/grill-me \
		~/.claude/skills/cmux \
		~/.claude/skills/cmux-browser \
		~/.claude/skills/cmux-debug-windows \
		~/.claude/skills/cmux-markdown

clean-claude-deprecated:
	rm -rf ~/.claude/skills/tmux-show

cmux-skills:
	git -C $(HOME)/projects/manaflow-ai/cmux pull

.PHONY: nvim clean-nvim fish clean-fish tmux clean-tmux alacritty clean-alacritty claude-skills clean-claude-skills clean-claude-deprecated cmux-skills
