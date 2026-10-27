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
- **cmux** (`cmux/`) - Terminal and agent workspace app built on Ghostty
  - Vim-style pane focus with `Ctrl+h/j/k/l`, and splits with `Ctrl+\` and `Ctrl+-`
  - Tracks `cmux.json` only; sessions, window layout and account state stay local
- **WezTerm** (`.wezterm.lua`) - Terminal emulator configuration
  - Catppuccin Frappé color scheme
  - MesloLGS Nerd Font Mono at 17pt
  - Minimal UI with no tab bar

### 🔧 Development Tools
- **Neovim** (`nvim/`) - LazyVim-based editor configuration
  - Python, Docker, Markdown, and JSON language extras
  - Python tooling with Pyright, Ruff, and ty
  - Gruvbox theme, debounced autosave, and tmux-aware navigation
  - Zed-style file explorer: opens on startup, and `Space e` moves focus between it and the editor
  - Rich Markdown rendering: styled headings, checkboxes and tables, plus images, LaTeX math and Mermaid diagrams drawn in the buffer
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
- **cmux**: `cmux/cmux.json` maps to `~/.config/cmux/cmux.json`. After copying it, run `cmux reload-config`; no restart is needed. Make shortcut changes in this file, not in the cmux Settings window: the Settings window saves them in macOS app preferences, which this repository does not track.
- **Home-directory files**: `.zshrc`, `.wezterm.lua`, `.tmux.conf`, `.tmux/`, and `.cursor/` map to their corresponding paths in `$HOME`.

Zed sandbox permissions, prompt databases, and other generated state remain local to each machine.

## 🛠️ Neovim Setup on a New Mac

Neovim needs some system tools besides the config files. Mason installs the language servers and formatters by itself on the first launch. `scripts/setup-nvim.sh` installs the rest with Homebrew and npm:

| Tool | Used for |
| --- | --- |
| `neovim` | The editor |
| `ripgrep`, `fd` | Text search and file finding |
| `lazygit` | Git UI (`Space g g`) |
| `node` | Mason's npm-based language servers, and mermaid-cli |
| `imagemagick`, `ghostscript` | Images and PDF pages in Markdown |
| `tectonic` | LaTeX math in Markdown |
| `@mermaid-js/mermaid-cli` (npm) | Mermaid diagrams in Markdown |
| `font-meslo-lg-nerd-font` | Icons |

The script skips every tool that is already installed, so you can run it again at any time.

1. Install [Homebrew](https://brew.sh) and the Xcode Command Line Tools (`xcode-select --install`). The Command Line Tools provide the C compiler for treesitter parsers.
2. Run the setup script from the repository root:
   ```sh
   ./scripts/setup-nvim.sh
   ```
3. Copy the config. This keeps a backup of any existing config:
   ```sh
   [ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak-$(date +%F)
   cp -R nvim ~/.config/nvim
   ```
4. Start `nvim`. lazy.nvim installs the plugins at the versions in `lazy-lock.json`, and Mason installs the language servers. Wait until both finish, then restart `nvim`.
5. Run `:checkhealth snacks`. The `Snacks.image` section must report that images, LaTeX math and Mermaid diagrams are supported.

Images, math and diagrams need a terminal that supports the Kitty graphics protocol, such as Ghostty, kitty or WezTerm. In other terminals, Markdown still renders, but these parts show as plain text. Set the terminal font to "MesloLGS Nerd Font Mono" so that icons display correctly.

## References
- [Zsh setup](https://www.josean.com/posts/terminal-setup)
- [Wezterm setup](https://www.josean.com/posts/how-to-setup-wezterm-terminal)
- [Tmux setup](https://www.josean.com/posts/tmux-setup)
- [Useful CLI tools](https://www.josean.com/posts/7-amazing-cli-tools)
- [LazyVim](https://www.lazyvim.org/)
- [Zed configuration](https://zed.dev/docs/configuring-zed)
