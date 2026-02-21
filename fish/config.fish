set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx GIT_EDITOR $EDITOR

fish_add_path -g /opt/homebrew/bin

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# go binary needs to be available to set GOPATH
fish_add_path -g /usr/local/go/bin

if command -v go > /dev/null
    set -gx GOPATH (go env GOPATH)
    fish_add_path -g $GOPATH/bin
else
    echo "warning: go not installed"
end

fish_add_path -g /opt/homebrew/opt/openjdk/bin
fish_add_path -g $HOME/.cargo/bin
fish_add_path -g /usr/local/opt/openjdk/bin
fish_add_path -g $HOME/.poetry/bin
fish_add_path -g $HOME/.local/bin

abbr -a ga git add
abbr -a gb git branch
abbr -a gc git commit
abbr -a gcaa git commit -a --amend
abbr -a gcam git commit -a -m
abbr -a gcb git checkout -b
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gds git diff --staged
abbr -a gl git pull
abbr -a glg git log --stat
abbr -a gp git push
abbr -a gpf git push --force-with-lease
abbr -a grba git rebase --abort
abbr -a grbc git rebase --continue
abbr -a grbi git rebase -i
abbr -a gst git status
abbr -a --command git cp cherry-pick
abbr -a gcm "git checkout (basename (git symbolic-ref --short refs/remotes/origin/HEAD))"
abbr -a grbim "git rebase -i (basename (git symbolic-ref --short refs/remotes/origin/HEAD))"

abbr -a gwl git worktree list
abbr -a gwa git worktree add
abbr -a gwr git worktree remove

abbr -a tat tmux a -t

abbr -a tree eza --tree --icons
abbr -a ,tree tree

abbr -a ls eza
abbr -a ll eza -l
abbr -a ,ls ls

abbr -a bb "brew update && brew outdated"

abbr -a b bundle
abbr -a be bundle exec
abbr -a berc bundle exec rails console
abbr -a dcopa 'git diff origin/master --name-only --relative --diff-filter=ACMRTUXB | grep ".*.rb\$" | xargs bundle exec rubocop -a'

function cdp
    cd (begin
        find ~/projects -mindepth 2 -maxdepth 2 -type d
        find ~/src -mindepth 1 -maxdepth 1 -type d
    end | fzf)
end
abbr -a fzfp fzf --preview 'bat -f {}'

set -gx DOTFILES $HOME/projects/ameykusurkar/dotfiles

# May override $DOTFILES
[ -f ~/.private-env.fish ]; and source ~/.private-env.fish

set -gx STARSHIP_CONFIG $DOTFILES/starship.toml

fish_add_path -g $DOTFILES/scripts

abbr -a v version
abbr -a sfish source ~/.config/fish/config.fish

abbr -a penv nvim ~/.private-env.fish

abbr -a k kubectl

abbr -a crr cargo run --release
abbr -a cbr cargo build --release

abbr -a bru "brew update && brew outdated | fzf -m --preview 'brew info {}' | xargs brew upgrade"

[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

# Set the greeting to be empty
set fish_greeting

if command -v starship > /dev/null
    starship init fish | source
else
    echo "warning: starship not installed"
end

if command -v fzf > /dev/null
    fzf --fish | source
else
    echo "warning: fzf not installed"
end

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/ameykusurkar/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

if command -v zoxide > /dev/null
    zoxide init --cmd cd fish | source
else
    echo "warning: zoxide not installed, using regular cd"
end
