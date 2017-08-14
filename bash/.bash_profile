export DE="mate"
export GOPATH="$HOME/go"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi
