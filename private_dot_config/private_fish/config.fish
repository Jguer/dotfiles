if test -f /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

fish_add_path --append /opt/homebrew/opt/node@22/bin
fish_add_path --append /home/jguer/go/bin

if status is-interactive
  starship init fish | source
  zoxide init fish | source
  podman completion fish | source
  set fish_greeting ""
end

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx PAGER bat
set -gx BAT_PAGER "less -RSF"
set -gx BAT_THEME "base16"

fish_config theme choose "Everforest"
alias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'
alias gpgssh='set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)'

alias ls="eza"
alias ll="eza --icons --git -la"
alias tree="eza --icons --tree"

alias cat="bat"

alias gco='git checkout'
alias gcb='git checkout -b'

alias gdf='git diff'
alias gps='git push'
alias gpl='git pull'

alias grbi='git rebase -i'
alias gct='git commit -v'
alias gcta='git commit -v -a'
alias gst='git status'
alias gad='git add'
