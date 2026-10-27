#!/usr/bin/env bash
# Install the system tools that the Neovim config in nvim/ needs on macOS.
# Mason installs the language servers and formatters itself on the first nvim launch;
# this script covers the tools Mason depends on and the ones it cannot install.
# Safe to re-run: every tool that is already on PATH is skipped.
set -euo pipefail

command -v brew >/dev/null || {
  echo "Homebrew is required: https://brew.sh" >&2
  exit 1
}

# Xcode Command Line Tools provide the C compiler that builds treesitter parsers,
# and the python3 that Mason uses for pypi-based tools (ty).
xcode-select -p >/dev/null 2>&1 || {
  echo "Run 'xcode-select --install' first, then re-run this script." >&2
  exit 1
}

# "<command> <homebrew formula>"
tools=(
  "nvim neovim"        # the editor
  "rg ripgrep"         # text search (Space+/)
  "fd fd"              # file finder (Space+Space)
  "lazygit lazygit"    # git UI (Space+g+g)
  "npm node"           # Mason's npm-based language servers, and mermaid-cli below
  "magick imagemagick" # images in markdown (Snacks.image)
  "gs ghostscript"     # PDF pages in Snacks.image
  "tectonic tectonic"  # LaTeX math in markdown (Snacks.image)
)

for entry in "${tools[@]}"; do
  read -r cmd formula <<<"$entry"
  if command -v "$cmd" >/dev/null; then
    echo "ok: $cmd"
  else
    brew install "$formula"
  fi
done

# Mermaid diagrams in markdown (Snacks.image)
if command -v mmdc >/dev/null; then
  echo "ok: mmdc"
else
  npm install -g @mermaid-js/mermaid-cli
fi

# Icons in the explorer, statusline and markdown headings. Select it in your terminal's font settings.
if brew list --cask font-meslo-lg-nerd-font >/dev/null 2>&1; then
  echo "ok: font-meslo-lg-nerd-font"
else
  brew install --cask font-meslo-lg-nerd-font
fi

echo
echo "Done. Next: copy nvim/ to ~/.config/nvim and start nvim (see README.md)."
