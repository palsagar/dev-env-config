# Developer setup

Personal development environment configurations for macOS. This repository contains my dotfiles and settings for shell, terminal, editor, and development tools.

## 📦 What's Included

### 🖥️ Terminal & Shell
- **Zsh** (`.zshrc`) - Shell configuration with Oh My Zsh, Powerlevel10k, and useful plugins
  - Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, web-search
  - Custom aliases for `eza`, `lazygit`, and `nvim`
  - FZF integration with `fd` for fuzzy finding
  - Zoxide for smarter directory navigation
  - Yazi integration for directory-aware file navigation with `ff`
- **WezTerm** (`.wezterm.lua`) - Terminal emulator configuration
  - Catppuccin Frappé color scheme
  - MesloLGS Nerd Font Mono at 17pt
  - Minimal UI with no tab bar

### 🔧 Development Tools
- **Neovim** (`nvim/`) - LazyVim-based editor configuration
  - Python, Docker, Markdown, and JSON language extras
  - Python tooling with Pyright, Ruff, and ty
  - Gruvbox theme, debounced autosave, and tmux-aware navigation
- **Zed** (`zed/`) - Editor preferences and LazyVim-style keybindings
  - Vim mode, Gruvbox themes, autosave, and relative line numbers
  - Tracks `settings.json` and `keymap.json`; excludes local permissions and generated state
- **Cursor** (`.cursor/`) - Editor settings and extension state
  - Catppuccin Macchiato theme, Vim bindings, autosave, and Ruff integration
  - Includes `settings.json` and `extensions.json`
- **Tmux** (`.tmux.conf`, `.tmux/`) - Terminal multiplexer configuration
  - Custom prefix key (`Ctrl+a`)
  - Vim-style pane navigation and copy-mode keybindings
  - TPM plugin manager with useful plugins:
    - vim-tmux-navigator
    - tmux-themepack (powerline/double/red)
    - tmux-resurrect and tmux-continuum for persistent sessions
    - tmux-yank
    - tmux-which-key

## 🚀 Key Features

- **Unified Navigation**: Seamless navigation between tmux panes and Neovim splits, plus LazyVim-style keybindings in Zed
- **Enhanced Productivity**: Modern CLI tools including eza, fd, bat, fzf, zoxide, and Yazi
- **Git Integration**: Lazygit alias and git-aware shell prompts
- **Python Development**: Pyright, Ruff, and ty in Neovim, Ruff integration in Cursor, and `ipdb` as the default breakpoint
- **Persistent Sessions**: Tmux sessions saved by tmux-resurrect and automatically restored by tmux-continuum

## 🔄 Synchronization

Configurations are deployed as copies rather than live symlinks:

- **Neovim**: `nvim/` maps to `~/.config/nvim/`.
- **Zed**: `zed/settings.json` and `zed/keymap.json` map to `~/.config/zed/`.
- **Home-directory files**: `.zshrc`, `.wezterm.lua`, `.tmux.conf`, `.tmux/`, and `.cursor/` map to their corresponding paths in `$HOME`.

Zed sandbox permissions, prompt databases, and other generated state remain local to each machine.

## References
- [Zsh setup](https://www.josean.com/posts/terminal-setup)
- [Wezterm setup](https://www.josean.com/posts/how-to-setup-wezterm-terminal)
- [Tmux setup](https://www.josean.com/posts/tmux-setup)
- [Useful CLI tools](https://www.josean.com/posts/7-amazing-cli-tools)
- [LazyVim](https://www.lazyvim.org/)
- [Zed configuration](https://zed.dev/docs/configuring-zed)
