# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# if [[ -z "$TMUX" ]] ;then
#     ID="$(tmux ls | grep -vm1 attached | cut -d: -f1)"
#     if [[ -z "$ID" ]] ;then # if not available create a new one
#         exec tmux new-session
#     else
#         exec tmux attach-session -t "$ID" # if available attach to it
#     fi
# fi
exec fish
