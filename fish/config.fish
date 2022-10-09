# go binary needs to be available to set GOPATH
fish_add_path -g /usr/local/go/bin

set -gx DOTFILES $HOME/dotfiles
set -gx STARSHIP_CONFIG $DOTFILES/starship.toml
set -gx EDITOR vim
set -gx VISUAL $EDITOR
set -gx GOPATH (go env GOPATH)

fish_add_path -g $HOME/.cargo/bin
fish_add_path -g $GOPATH/bin
fish_add_path -g /usr/local/opt/openjdk/bin
fish_add_path -g $HOME/.poetry/bin

abbr -a ga git add
abbr -a gb git branch
abbr -a gc git commit
abbr -a gcaa git commit -a --amend
abbr -a gcam git commit -a -m
abbr -a gcb git checkout -b
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gl git pull
abbr -a glg git log --stat
abbr -a gp git push
abbr -a grba git rebase --abort
abbr -a grbc git rebase --continue
abbr -a grbi git rebase -i
abbr -a gst git status
abbr -a gcm "git checkout (basename (git symbolic-ref --short refs/remotes/origin/HEAD))"
abbr -a grbim "git rebase -i (basename (git symbolic-ref --short refs/remotes/origin/HEAD))"

abbr -a be bundle exec
abbr -a berc bundle exec rails console
abbr -a dcopa 'git diff origin/master --name-only --relative --diff-filter=ACMRTUXB | grep ".*.rb\$" | xargs bundle exec rubocop -a'

abbr -a sfish source ~/.config/fish/config.fish

abbr -a vfish vim ~/.config/fish/config.fish
abbr -a vstar vim $STARSHIP_CONFIG

abbr -a vimrc vim ~/.vimrc
abbr -a penv vim ~/.private-env.fish
abbr -a nvc nvim ~/dotfiles/nvim/init.vim

abbr -a zshrc vim ~/.zshrc
abbr -a penvz vim ~/.private-env

abbr -a k kubectl

abbr -a crr cargo run --release
abbr -a cbr cargo build --release

[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

[ -f ~/.private-env.fish ]; and source ~/.private-env.fish

# Set the greeting to be empty
set fish_greeting

[ -f /usr/local/opt/asdf/libexec/asdf.fish ]; and source /usr/local/opt/asdf/libexec/asdf.fish

# Needs to be the last line of the config
starship init fish | source
