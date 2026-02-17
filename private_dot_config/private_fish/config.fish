if test -f /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

fish_add_path --append /opt/homebrew/opt/node@22/bin
fish_add_path --append /home/linuxbrew/.linuxbrew/opt/node@22/bin
fish_add_path --append /home/jguer/go/bin
fish_config theme choose "Rosé Pine"

if status is-interactive
    [ "$(command -v starship)" ] && eval "$(starship init fish)"
    [ "$(command -v atuin)" ] && eval "$(atuin init fish $ATUIN_INIT_FLAGS)"
    [ "$(command -v zoxide)" ] && eval "$(zoxide init fish)"
  set fish_greeting ""
  set -e SSH_AGENT_PID
  if not set -q gnupg_SSH_AUTH_SOCK_by; or test "$gnupg_SSH_AUTH_SOCK_by" -ne "$fish_pid"
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
  end
end

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx PAGER bat
set -gx BAT_THEME "rose-pine"

fish_config theme choose "Everforest"
alias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'
alias gpgssh='set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)'

if [ "$(command -v eza)" ]
    alias ll='eza -l --icons=auto --group-directories-first'
    alias l.='eza -d .*'
    alias ls='eza'
    alias l1='eza -1'
end

if [ "$(command -v ug)" ]
    alias grep='ug'
    alias egrep='ug -E'
    alias fgrep='ug -F'
    alias xzgrep='ug -z'
    alias xzegrep='ug -zE'
    alias xzfgrep='ug -zF'
end

# bat for cat
alias cat='bat --style=plain --pager=never' 2>/dev/null

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
