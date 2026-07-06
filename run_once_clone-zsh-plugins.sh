#!/bin/bash

set -eu

zsh_dir="${HOME}/.zsh"
mkdir -p "${zsh_dir}"

plugins=(
    "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting"
    "zsh-history-substring-search|https://github.com/zsh-users/zsh-history-substring-search"
)

for entry in "${plugins[@]}"; do
    name="${entry%%|*}"
    url="${entry##*|}"
    dest="${zsh_dir}/${name}"

    if [[ -d "${dest}" ]]; then
        echo "skip ${name} (already at ${dest})"
        continue
    fi

    git clone --depth=1 "${url}" "${dest}"
done
