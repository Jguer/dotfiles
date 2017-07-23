export GOPATH=$HOME/Go
export EDITOR=nvim
export QT_QPA_PLATFORMTHEME=gtk2

eval "$(ssh-agent)"

[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi
