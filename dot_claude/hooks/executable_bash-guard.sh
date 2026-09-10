#!/usr/bin/env bash
# PreToolUse(Bash): catch dangerous commands that permission rules cannot.
#
# Permission rules like `Bash(sudo *)` are prefix matches, so `env sudo rm ...`
# or `x && sudo rm ...` sail straight past them. And Read(...) deny rules only
# govern the Read tool, so `cat ~/.ssh/id_rsa` is not covered by them at all.
# This inspects the whole command string instead.
#
# Exit 2 blocks the call and shows the message to Claude.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -n "$cmd" ] || exit 0

block() {
	printf '%s\n' "$1" >&2
	exit 2
}

match() { printf '%s' "$cmd" | grep -Eq "$1"; }

# Privilege escalation anywhere in command position, not just at the start.
# Covers `sudo x`, `a && sudo x`, `env FOO=1 sudo x`, `xargs sudo x`.
if match '(^|[;&|(]|\bxargs[[:space:]]+|\benv[[:space:]]+([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*)[[:space:]]*(sudo|doas)\b'; then
	block "Blocked: privilege escalation (sudo/doas) is denied in settings.json. Run it yourself with '! <command>' if you want it."
fi

# Piping a network download straight into an interpreter.
if match '\b(curl|wget)\b[^;&]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|k|d|fi)?sh\b'; then
	block "Blocked: piping a network download into a shell. Fetch it to a file, show it, then run it."
fi

# Reading credential material through the shell, which Read(...) denies miss.
# Committed templates carry no secrets, so drop them before matching.
# (BSD sed has no \b, hence the explicit character class.)
scrubbed=$(printf '%s' "$cmd" | sed -E 's/\.env\.(example|sample|template|dist)([^[:alnum:]_]|$)/\2/g')
if printf '%s' "$scrubbed" | grep -Eq '\b(cat|bat|less|more|head|tail|strings|xxd|od|base64|cp|rsync|scp|tar|zip|open)\b[^|;&]*(\.env\b|\.env\.|/\.ssh/|id_rsa|id_ed25519|\.netrc|\.aws/credentials|\.gnupg/|\.credentials\.json|/\.kube/config)'; then
	block "Blocked: reading credential material through the shell. Use the Read tool so the deny rules in settings.json apply."
fi

exit 0
