# Zed Configuration Tracking Design

## Goal

Track the durable Zed editor preferences and keybindings in this repository so they can be copied to other machines. Exclude prompt databases, locks, caches, session state, and machine-specific authorization state.

## Repository layout

Add a top-level `zed/` directory containing exactly these tracked files:

- `settings.json`: the current Zed settings with the complete `agent.sandbox_permissions` object removed. All other settings remain unchanged, including model preferences, agent server configuration, editor behavior, fonts, theme, and `session.trust_all_worktrees`.
- `keymap.json`: an exact copy of the current Zed keybindings.
- `.gitignore`: a deny-by-default rule with exceptions only for `.gitignore`, `settings.json`, and `keymap.json`.

Update the root README to list Zed and these two durable configuration files.

The allowlist is intentional. New files under `zed/` remain untracked unless they are explicitly approved, which prevents generated Zed state from entering git after a future copy operation.

## Local configuration and synchronization

Leave `~/.config/zed/` unchanged. Its existing sandbox grants, prompt database, and other local state remain on this machine.

Use clean tracked copies rather than symlinks. Deploying to another machine consists of copying the tracked settings and keymap into that machine's Zed config directory. Local sandbox permissions can then be granted independently. This matches the repository's existing copy-based Neovim workflow and avoids placing live Zed databases inside the working tree.

## Exclusions

Do not copy or track:

- `prompts/`, including LMDB data and lock files.
- The empty `themes/` directory.
- `agent.sandbox_permissions`, including resolved home-directory paths and network grants.
- Any future cache, session, database, lock, or machine-specific files not explicitly added to the allowlist.

## Verification

- Parse both tracked files as JSONC to preserve support for comments and trailing commas.
- Compare the tracked settings with the active settings and confirm that removal of `agent.sandbox_permissions` is the only content difference.
- Compare the tracked keymap byte-for-byte with the active keymap.
- Inspect git status and tracked files to confirm that no Zed prompt, session, database, lock, cache, or other local-state file is included.
