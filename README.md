# dev_environment

Personal development environment configurations for macOS. This repository contains my dotfiles and settings for various development tools.

## 📦 What's Included

### 🖥️ Terminal & Shell
- **Zsh** (`.zshrc`) - Shell configuration with Oh My Zsh, Powerlevel10k theme, and useful plugins
  - Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, web-search
  - Custom aliases for `eza`, `lazygit`, `nvim`
  - FZF integration with `fd` for fuzzy finding
  - Zoxide for smarter directory navigation
- **WezTerm** (`.wezterm.lua`) - Modern terminal emulator configuration
  - Catppuccin Frappé color scheme
  - MesloLGS Nerd Font Mono at 17pt
  - Minimal UI with no tab bar

### 🔧 Development Tools
- **Neovim** (`.config/`) - Text editor configuration
- **Cursor** (`.cursor/`) - AI-powered IDE settings
  - Custom rules and skills
  - Editor preferences (`settings.json`)
- **Tmux** (`.tmux.conf`, `.tmux/`) - Terminal multiplexer configuration
  - Custom prefix key (`Ctrl+a`)
  - Vim-style pane navigation
  - TPM plugin manager with useful plugins:
    - vim-tmux-navigator
    - tmux-themepack (powerline/double/red)
    - tmux-continuum (auto-save sessions)
    - tmux-yank
    - tmux-which-key

## 🚀 Key Features

- **Unified Navigation**: Seamless navigation between tmux panes and vim/neovim splits
- **Enhanced Productivity**: Modern CLI tools (eza, fd, bat, fzf, zoxide)
- **Git Integration**: Lazy git alias and git-aware prompts
- **Python Development**: IPython debugger configured as default breakpoint
- **Persistent Sessions**: Tmux sessions automatically saved and restored
