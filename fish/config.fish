set -gx DOTFILES $HOME/dotfiles
set -gx OMF_CONFIG $DOTFILES/omf

abbr -a gd git diff
abbr -a ga git add
abbr -a gst git status
abbr -a gl git pull
abbr -a gp git push
abbr -a gc git commit
abbr -a gcam git commit -a -m

abbr -a sfish source ~/.config/fish/config.fish
abbr -a vfish vim ~/.config/fish/config.fish

abbr -a vimrc vim ~/.vimrc
