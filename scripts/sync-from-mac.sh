#!/usr/bin/env bash
# Copy config from this Mac into the repo. Run it after you change your local config,
# then review `git diff` and commit.
# ~/.zshrc is NOT synced because it holds secrets. Edit mac/.zshrc and
# roles/shell/templates/zshrc.j2 by hand instead.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
dest="$repo/dotfiles"
mac="$repo/mac"

rsync -a --delete \
  --exclude '.git' --exclude '*.bak*' --exclude '*.log' --exclude '.nvimlog' \
  "$HOME/.config/nvim/" "$dest/nvim/"
cp "$HOME/.tmux.conf" "$dest/tmux.conf"
cp "$HOME/.p10k.zsh" "$dest/p10k.zsh"
mkdir -p "$dest/claude"
cp "$HOME/.claude/CLAUDE.md" "$dest/claude/CLAUDE.md"

cp "$HOME/.wezterm.lua" "$mac/.wezterm.lua"
cp "$HOME/.config/zed/settings.json" "$HOME/.config/zed/keymap.json" "$mac/zed/"
cp "$HOME/.config/cmux/cmux.json" "$mac/cmux/cmux.json"

# Fail loudly if anything that looks like a credential slipped in.
if grep -rInE '(github_pat_|gh[pousr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY|[A-Z_]*(API_KEY|_PAT|_TOKEN|_SECRET)=[^[:space:]$])' "$dest" "$mac"; then
  echo "ERROR: possible secret found (see above). Remove it before committing." >&2
  exit 1
fi

echo "Synced. Review with: git -C \"$repo\" diff --stat"
