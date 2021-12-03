alias ls="exa"
alias ll="exa --icons --git -la"
alias tree="exa --icons --tree"

alias cat="bat"

set -l foreground c0caf5
set -l selection 364A82
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

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

# Docker alias
alias dco='docker-compose'


zoxide init fish | source
starship init fish | source

function fish_user_key_bindings
	fzf_key_bindings
end
