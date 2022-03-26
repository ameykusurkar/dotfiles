set -gx DOTFILES $HOME/dotfiles
set -gx STARSHIP_CONFIG $DOTFILES/starship.toml
set -gx EDITOR vim
set -gx VISUAL $EDITOR
set -gx GOPATH (go env GOPATH)

fish_add_path -g $HOME/.cargo/bin
fish_add_path -g $GOPATH/bin

abbr -a gd git diff
abbr -a ga git add
abbr -a gst git status
abbr -a gl git pull
abbr -a gp git push
abbr -a gc git commit
abbr -a gcam git commit -a -m
abbr -a glg git log --stat
abbr -a gcaa git commit -a --amend
abbr -a gco git checkout
abbr -a gcb git checkout -b
abbr -a grbi git rebase -i
abbr -a grba git rebase --abort
abbr -a grbc git rebase --continue

abbr -a be bundle exec
abbr -a dcopa 'git diff origin/master --name-only --relative --diff-filter=ACMRTUXB | grep ".*.rb\$" | xargs bundle exec rubocop -a'

abbr -a sfish source ~/.config/fish/config.fish

abbr -a vfish vim ~/.config/fish/config.fish
abbr -a vstar vim $STARSHIP_CONFIG

abbr -a vimrc vim ~/.vimrc
abbr -a penv vim ~/.private-env.fish

abbr -a zshrc vim ~/.zshrc
abbr -a penvz vim ~/.private-env

abbr -a k kubectl

[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

[ -f ~/.private-env.fish ]; and source ~/.private-env.fish

source /usr/local/opt/asdf/libexec/asdf.fish

# Set the greeting to be empty
set fish_greeting

# Needs to be the last line of the config
starship init fish | source
