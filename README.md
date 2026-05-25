# Dotfiles

Personal shell and dev environment managed with [chezmoi](https://www.chezmoi.io/).

## What's inside

- **Shell**: zsh with completion, shared history, and aliases for `eza`, `bat`, and `rg`
- **Editor**: Neovim with lazy.nvim and the rose-pine theme
- **Prompt**: starship

## Required utils

These are used across the configs. Install what you need.

### macOS (Homebrew)

```bash
brew install chezmoi git git-delta gh neovim starship zoxide eza bat ripgrep zsh go node@22 uv pnpm
brew install --cask ghostty font-intone-mono-nerd-font
```

### Linux

With Homebrew:

```bash
brew install chezmoi git git-delta gh neovim starship zoxide eza bat ripgrep zsh go node@22 uv pnpm
```

## Install

One-liner with chezmoi:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Jguer
```

Or clone and run the local install script:

```bash
git clone https://github.com/Jguer/dotfiles.git
cd dotfiles
./install.sh
```

The install script bootstraps chezmoi if it is not already installed.

## Theme

Terminal and editor use [rose-pine](https://rosepinetheme.com/).
