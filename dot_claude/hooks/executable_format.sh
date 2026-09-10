#!/usr/bin/env bash
# PostToolUse(Write|Edit): format the file Claude just wrote.
#
# A hook turns formatting from something the model has to remember into
# something that always happens. If the formatter rejects the file, its output
# is fed back to Claude so it can fix the syntax while the edit is still in
# context.
set -uo pipefail

file=$(jq -r '.tool_response.filePath // .tool_input.file_path // empty' 2>/dev/null) || exit 0
[ -n "$file" ] && [ -f "$file" ] || exit 0

have() { command -v "$1" >/dev/null 2>&1; }

report() {
	jq -n --arg m "$1" \
		'{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$m}}'
	exit 0
}

case "$file" in
*.rs)
	have rustfmt || exit 0
	out=$(rustfmt --edition 2021 "$file" 2>&1) ||
		report "rustfmt could not format $file (likely a syntax error): $out"
	;;
*.go)
	have gofmt || exit 0
	out=$(gofmt -w "$file" 2>&1) ||
		report "gofmt could not format $file (likely a syntax error): $out"
	;;
*.ts | *.tsx | *.js | *.jsx | *.css | *.scss | *.json | *.md)
	# Project-local prettier only. Never shell out to `npx`, which can stall on
	# a registry download in the middle of an edit loop.
	root=$(cd "$(dirname "$file")" && git rev-parse --show-toplevel 2>/dev/null) || exit 0
	pretty="$root/node_modules/.bin/prettier"
	[ -x "$pretty" ] || exit 0
	out=$("$pretty" --write --ignore-unknown "$file" 2>&1) ||
		report "prettier could not format $file: $out"
	;;
esac

exit 0
