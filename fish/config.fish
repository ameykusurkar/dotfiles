set -gx DOTFILES $HOME/dotfiles
set -gx STARSHIP_CONFIG $DOTFILES/starship.toml
set -gx EDITOR vim

abbr -a gd git diff
abbr -a ga git add
abbr -a gst git status
abbr -a gl git pull
abbr -a gp git push
abbr -a gc git commit
abbr -a gcam git commit -a -m
abbr -a glg git log --stat
abbr -a gcaa git commit -a --amend

abbr -a sfish source ~/.config/fish/config.fish

abbr -a vfish vim ~/.config/fish/config.fish
abbr -a vstar vim $STARSHIP_CONFIG

abbr -a vimrc vim ~/.vimrc
abbr -a penv vim ~/.private-env.fish

[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

[ -f ~/.private-env.fish ]; and source ~/.private-env.fish

source /opt/asdf-vm/asdf.fish

# Needs to be the last line of the config
starship init fish | source