#
# ~/.bash_profile
#

if [ -d "$HOME/awmdotfiles/scripts" ] ; then
  export PATH="$PATH:$HOME/awmdotfiles/scripts"
fi

if [ -d "$HOME/Go/bin" ] ; then
  export PATH="$PATH:$HOME/Go/bin"
fi

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
