#!/usr/bin/env bash
# Claude Code status line: model, location, context, quota, cost.
# Reads the session JSON on stdin (see `docs/en/statusline`).
# Uses only Claude Code's own numbers, so there is no external tool to install
# and nothing to cache: the 5h/7d figures are the same ones Anthropic bills on.
set -uo pipefail

# Unit separator, not tab: bash collapses runs of IFS *whitespace*, so empty
# fields would silently shift every later value one slot to the left.
IFS=$'\x1f' read -r model effort fast dir ctx cost h5 d7 < <(
	jq -r '[
    .model.display_name // "?",
    .effort.level // "",
    (if .fast_mode then "fast" else "" end),
    .workspace.current_dir // .cwd // "",
    (.context_window.used_percentage // 0 | floor),
    (.cost.total_cost_usd // 0),
    (.rate_limits.five_hour.used_percentage // -1 | floor),
    (.rate_limits.seven_day.used_percentage // -1 | floor)
  ] | map(tostring) | join("\u001f")' 2>/dev/null
) || exit 0

R=$'\033[0m' DIM=$'\033[2m' BOLD=$'\033[1m' CYAN=$'\033[36m'

# green under 50%, yellow under 80%, red at or above
hue() {
	if [ "${1:-0}" -ge 80 ]; then
		printf '\033[31m'
	elif [ "${1:-0}" -ge 50 ]; then
		printf '\033[33m'
	else
		printf '\033[32m'
	fi
}

seg=("${BOLD}${model}${R}${effort:+${DIM}:${effort}${R}}${fast:+ ${CYAN}⚡${R}}")

if [ -n "$dir" ]; then
	label=${dir/#$HOME/\~}
	seg+=("${CYAN}${label##*/}${R}")
	if branch=$(git -C "$dir" branch --show-current 2>/dev/null) && [ -n "$branch" ]; then
		dirty=""
		git -C "$dir" diff --quiet --ignore-submodules HEAD 2>/dev/null || dirty="*"
		seg+=("${DIM}${branch}${dirty}${R}")
	fi
fi

seg+=("$(hue "$ctx")${ctx}%${R}${DIM} ctx${R}")
[ "$h5" -ge 0 ] && seg+=("$(hue "$h5")${h5}%${R}${DIM} 5h${R}")
[ "$d7" -ge 0 ] && seg+=("$(hue "$d7")${d7}%${R}${DIM} 7d${R}")
seg+=("${DIM}\$$(printf '%.2f' "$cost")${R}")

printf '%s' "${seg[0]}"
for s in "${seg[@]:1}"; do printf '%s%s' "${DIM} · ${R}" "$s"; done
printf '\n'
