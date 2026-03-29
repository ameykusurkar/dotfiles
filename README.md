# dotfiles

Configuration files for Neovim, tmux, and Fish shell.

## Setup

```sh
make nvim    # Neovim (LazyVim)
make tmux    # tmux
make fish    # Fish shell
```

Each command creates a symlink from the expected config location to the corresponding file in this repo.

## Developing

Since configs are symlinked, any changes you make in this repo take effect immediately -- there's no need to copy files around. Just edit and reload.

To reload after making changes:

- **Fish:** `source ~/.config/fish/config.fish`
- **tmux:** `tmux source-file ~/.tmux.conf`
- **Neovim:** restart Neovim
