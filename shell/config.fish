alias ls="exa"
alias ll="exa --icons --git -la"
alias tree="exa --icons --tree"

alias cat="bat"

set fish_greeting

# Git alias
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

alias dco='docker-compose'

zoxide init fish | source
starship init fish | source

function fish_user_key_bindings
	fzf_key_bindings
end

set SSH_AUTH_SOCK {$XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh
set DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"

fish_config theme choose TokyoNight\ Storm
