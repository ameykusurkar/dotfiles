if not command -v gum > /dev/null
	echo "Please install gum to continue!"
        exit 1
end

if not command -v starship > /dev/null
	if gum confirm "Install starship?"
		curl -sS https://starship.rs/install.sh | sh
	else
		echo "Skipping starship installation."
	end
end

if not test -d $HOME/.config/nvim
        echo "Setting up neovim..."
        DOTFILES=(pwd) make clean-nvim nvim
end

if not test -e $HOME/.config/fish/config.fish
        echo "Setting up fish"
        DOTFILES=(pwd) make fish
end

if not test (basename "$SHELL") = "fish"
        if gum confirm "Make fish default shell?"
                chsh -s (which fish)
        end
end
