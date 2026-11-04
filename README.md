# Developer setup

My personal development environment. This repository has two parts:

- **Dotfiles** for my Mac: shell, terminal, editor, and development tools.
- **An Ansible playbook** that reproduces the same command-line environment on a personal server. See [Set up a server](#-set-up-a-server).

| Path | Contents |
| --- | --- |
| `dotfiles/` | Config shared by the Mac and servers: Neovim, tmux, Powerlevel10k, `CLAUDE.md` |
| `mac/` | Mac-only config: `.zshrc`, WezTerm, Cursor, Zed, cmux |
| `site.yml`, `roles/`, `group_vars/`, `inventory/` | The server playbook |
| `scripts/` | `sync-from-mac.sh`, `setup-nvim.sh` |
| `tests/` | The container test for the playbook |

## 📦 What's Included

### 🖥️ Terminal & Shell
- **Zsh** (`mac/.zshrc`) - Shell configuration with Oh My Zsh, Powerlevel10k, and useful plugins
  - Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, web-search
  - Custom aliases for `eza`, `lazygit`, and `nvim`
  - FZF integration with `fd` for fuzzy finding
  - Zoxide for smarter directory navigation
  - Yazi integration for directory-aware file navigation with `ff`
- **cmux** (`mac/cmux/`) - Terminal and agent workspace app built on Ghostty
  - Vim-style pane focus with `Ctrl+h/j/k/l`, and splits with `Ctrl+\` and `Ctrl+-`
  - Tracks `cmux.json` only; sessions, window layout and account state stay local
- **WezTerm** (`mac/.wezterm.lua`) - Terminal emulator configuration
  - Catppuccin Frappé color scheme
  - MesloLGS Nerd Font Mono at 17pt
  - Minimal UI with no tab bar

### 🔧 Development Tools
- **Neovim** (`dotfiles/nvim/`) - LazyVim-based editor configuration
  - Python, Docker, Markdown, and JSON language extras
  - Python tooling with Pyright, Ruff, and ty
  - Gruvbox theme, debounced autosave, and tmux-aware navigation
  - Zed-style file explorer: opens on startup, and `Space e` moves focus between it and the editor
  - Rich Markdown rendering: styled headings, checkboxes and tables, plus images, LaTeX math and Mermaid diagrams drawn in the buffer
- **Zed** (`mac/zed/`) - Editor preferences and LazyVim-style keybindings
  - Vim mode, Gruvbox themes, autosave, and relative line numbers
  - Tracks `settings.json` and `keymap.json`; excludes local permissions and generated state
- **Cursor** (`mac/.cursor/`) - Editor settings and extension state
  - Catppuccin Macchiato theme, Vim bindings, autosave, and Ruff integration
  - Includes `settings.json` and `extensions.json`
- **Tmux** (`dotfiles/tmux.conf`) - Terminal multiplexer configuration
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
- **Reproducible Servers**: One Ansible playbook sets up the same environment on a new server

## 🔄 Synchronization

I edit config on the Mac, then copy it into this repository:

```sh
./scripts/sync-from-mac.sh   # copies config into dotfiles/ and mac/, and checks for secrets
git diff                     # review, then commit
```

To set up a new Mac, copy in the other direction:

- **Neovim**: `dotfiles/nvim/` maps to `~/.config/nvim/`.
- **Tmux**: `dotfiles/tmux.conf` maps to `~/.tmux.conf`. TPM installs the plugins.
- **Powerlevel10k**: `dotfiles/p10k.zsh` maps to `~/.p10k.zsh`.
- **Zed**: `mac/zed/settings.json` and `mac/zed/keymap.json` map to `~/.config/zed/`.
- **cmux**: `mac/cmux/cmux.json` maps to `~/.config/cmux/cmux.json`. After copying it, run `cmux reload-config`; no restart is needed. Make shortcut changes in this file, not in the cmux Settings window: the Settings window saves them in macOS app preferences, which this repository does not track.
- **Home-directory files**: `mac/.zshrc`, `mac/.wezterm.lua`, and `mac/.cursor/` map to their corresponding paths in `$HOME`.

The sync script does not copy `~/.zshrc`, because that file holds secrets. Edit `mac/.zshrc` by hand, and keep secrets out of it. This repository is public.

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
   cp -R dotfiles/nvim ~/.config/nvim
   ```
4. Start `nvim`. lazy.nvim installs the plugins at the versions in `lazy-lock.json`, and Mason installs the language servers. Wait until both finish, then restart `nvim`.
5. Run `:checkhealth snacks`. The `Snacks.image` section must report that images, LaTeX math and Mermaid diagrams are supported.

Images, math and diagrams need a terminal that supports the Kitty graphics protocol, such as Ghostty, kitty or WezTerm. In other terminals, Markdown still renders, but these parts show as plain text. Set the terminal font to "MesloLGS Nerd Font Mono" so that icons display correctly.

## 🖧 Set up a server

The playbook runs from the Mac over SSH and configures the user you connect as, root or otherwise. The server needs only sshd. A non-root user also needs passwordless sudo.

It supports **Ubuntu 24.04** and **Debian 13**, on amd64 and arm64.

| Role | Contents | Default |
| --- | --- | --- |
| `base` | Build toolchain, common `-dev` headers, git, tmux, zsh, btop, ripgrep, fd, bat, eza, zoxide, jq, ImageMagick, the `en_US.UTF-8` locale | On |
| `cli_tools` | lazygit, fzf, yazi, tree-sitter CLI, GitHub CLI | On |
| `docker` | Docker Engine (pinned major version), buildx, compose | On |
| `node` | Node.js from NodeSource | On |
| `dev_tools` | uv, `hf` CLI, ipdb, Claude Code and `CLAUDE.md`, `~/.gitconfig` | On |
| `shell` | zsh, Oh My Zsh, Powerlevel10k, `~/.zshrc`, tmux config and plugins | On |
| `neovim` | Neovim, the LazyVim config, plugins at the commits in `lazy-lock.json` | On |
| `gcloud` | gcloud CLI, gcsfuse | Off: set `gcloud_enabled: true` |
| `extras` | texlive and pandoc, emacs, apptainer, kubectl and minikube, PostgreSQL | Off: set each `extras_*` variable |
| `data_disk` | Mounts a second disk at `/data` and moves Docker, `HF_HOME` and the uv cache onto it | Off: set `data_disk_device` |

Versions live in [`group_vars/all.yml`](group_vars/all.yml). Change a version there and run the playbook again to upgrade.

### One-time setup on the Mac

```sh
uv sync
uv run ansible-galaxy collection install -r requirements.yml
```

### Provision a server

To provision one server without an inventory file (the comma after the address is required):

```sh
uv run ansible-playbook site.yml -i '203.0.113.10,' -u root --private-key ~/.ssh/my-key
```

To keep a list of servers, copy `inventory/hosts.example.yml` to `inventory/hosts.yml`, which git ignores, and add your hosts. Per-host options go there too. Then run:

```sh
uv run ansible-playbook site.yml --limit my-server
```

Run only some roles with `--tags`, for example `--tags shell,neovim`.

Log in once afterwards to authenticate with `gh auth login`. Log out and back in so the `docker` group and zsh take effect.

The playbook overwrites `~/.zshrc`, `~/.gitconfig`, `~/.tmux.conf`, `~/.p10k.zsh` and `~/.config/nvim` on every run. Put per-machine settings and secrets in `~/.zshrc.local` on the server. The playbook never touches that file.

### Update a server's dotfiles

Run `./scripts/sync-from-mac.sh`, commit, then run the playbook with `--tags shell,neovim,dev_tools`. The server `~/.zshrc` comes from [`roles/shell/templates/zshrc.j2`](roles/shell/templates/zshrc.j2), which you edit by hand.

### Testing

CI runs on every pull request and every push to `main`:

- `ansible-playbook --syntax-check` and `ansible-lint`.
- A gitleaks scan of the full history.
- `tests/container-test.sh` on Ubuntu 24.04 and Debian 13, on amd64 and arm64, as root and as a normal user. It runs the playbook twice and fails if the second run changes anything.

To run the container test locally:

```sh
./tests/container-test.sh debian:13 root
```

### Known limits

- Containers have no systemd, so the tests install Docker but never start it. The tests also skip `data_disk`. Neither has run on a real Debian 13 server yet.
- Commit signing is off on servers, because the GPG key exists only on the Mac.
- Mason language servers and treesitter parsers download the first time you open Neovim.
- GCP OS Login accounts cannot change their login shell, so for them the playbook starts zsh from `~/.bash_profile` instead.

## References
- [Zsh setup](https://www.josean.com/posts/terminal-setup)
- [Wezterm setup](https://www.josean.com/posts/how-to-setup-wezterm-terminal)
- [Tmux setup](https://www.josean.com/posts/tmux-setup)
- [Useful CLI tools](https://www.josean.com/posts/7-amazing-cli-tools)
- [LazyVim](https://www.lazyvim.org/)
- [Zed configuration](https://zed.dev/docs/configuring-zed)
