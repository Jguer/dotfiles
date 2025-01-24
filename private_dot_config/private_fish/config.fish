eval "$(/opt/homebrew/bin/brew shellenv)"

if status is-interactive
  starship init fish | source
  zoxide init fish | source
  set fish_greeting ""
end

alias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'

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
