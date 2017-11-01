export GOPATH="$HOME/go"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
export GPG_TTY=$(tty)

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi
