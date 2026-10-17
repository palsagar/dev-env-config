# Zed Configuration Tracking Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Track only durable Zed settings and keybindings in the repository while excluding local permissions and generated state.

**Architecture:** Add a top-level `zed/` directory with two JSONC configuration copies and a deny-by-default `.gitignore`. Leave the active Zed directory unchanged and use the repository's existing copy-based deployment model.

**Tech Stack:** Zed JSONC configuration, Git, Bun 1.3.14 (`Bun.JSONC`), Markdown.

## Global Constraints

- Track exactly `zed/.gitignore`, `zed/settings.json`, and `zed/keymap.json` under `zed/`.
- Remove only the complete `agent.sandbox_permissions` object from the tracked settings.
- Keep every other setting unchanged, including `session.trust_all_worktrees`.
- Copy the active keymap byte-for-byte.
- Leave `~/.config/zed/` unchanged, including its sandbox grants and prompt database.
- Do not use symlinks or add deployment automation.
- Do not track `prompts/`, the empty `themes/` directory, databases, locks, caches, session state, or machine-specific authorization state.
- Preserve JSONC comments and trailing commas; do not normalize either configuration file.
- Do not stage the pre-existing untracked `.DS_Store` or `.claude/` paths.

---

### Task 1: Track Durable Zed Configuration

**Files:**
- Create: `zed/.gitignore`
- Create: `zed/settings.json`
- Create: `zed/keymap.json`
- Modify: `README.md` in the `### 🔧 Development Tools` section
- Temporary test: `/tmp/dev-env-config-zed-check.ts`

**Interfaces:**
- Consumes: `~/.config/zed/settings.json` and `~/.config/zed/keymap.json` as the approved source configuration.
- Produces: a clean `zed/` config directory containing only the two durable JSONC files and its allowlist; later machines consume these as clean tracked copies.

- [ ] **Step 1: Write the failing validation script**

Create `/tmp/dev-env-config-zed-check.ts` with this exact content:

```typescript
import assert from "node:assert/strict";

const repo = "/Users/sagarpal/projects/dev-env-config";
const active = "/Users/sagarpal/.config/zed";

const trackedSettingsText = await Bun.file(`${repo}/zed/settings.json`).text();
const trackedSettings = Bun.JSONC.parse(trackedSettingsText);
const activeSettings = Bun.JSONC.parse(await Bun.file(`${active}/settings.json`).text());

assert.equal(trackedSettings.agent.sandbox_permissions, undefined);
delete activeSettings.agent.sandbox_permissions;
assert.deepStrictEqual(trackedSettings, activeSettings);
assert.equal(trackedSettingsText.includes("/Users/sagarpal"), false);

const trackedKeymapBytes = await Bun.file(`${repo}/zed/keymap.json`).bytes();
const activeKeymapBytes = await Bun.file(`${active}/keymap.json`).bytes();
assert.deepStrictEqual(trackedKeymapBytes, activeKeymapBytes);
Bun.JSONC.parse(new TextDecoder().decode(trackedKeymapBytes));

console.log("PASS: valid JSONC; settings differ only by sandbox permissions; keymap is identical");
```

- [ ] **Step 2: Run the validation script and verify RED**

Run:

```bash
bun /tmp/dev-env-config-zed-check.ts
```

Expected: non-zero exit with an `ENOENT` error for `zed/settings.json`, because the tracked files do not exist yet.

- [ ] **Step 3: Create the deny-by-default allowlist**

Create `zed/.gitignore` with this exact content:

```gitignore
*
!.gitignore
!keymap.json
!settings.json
```

- [ ] **Step 4: Create sanitized tracked settings**

Create `zed/settings.json` with this exact content. This is the active settings file with only `agent.sandbox_permissions` removed:

```jsonc
// Zed settings
//
// For information on how to configure Zed, see the Zed
// documentation: https://zed.dev/docs/configuring-zed
//
// To see all of Zed's default settings without changing your
// custom settings, run `zed: open default settings` from the
// command palette (cmd-shift-p / ctrl-shift-p)
{
  "agent": {
    "default_model": {
      "provider": "openai-subscribed",
      "model": "gpt-6.1-sol",
      "enable_thinking": true,
      "effort": "medium"
    },
    "favorite_models": [],
    "model_parameters": []
  },
  "icon_theme": "Zed (Default)",
  "session": {
    "trust_all_worktrees": true
  },
  "vim_mode": true,
  "terminal": {
    "font_family": "MesloLGS NF"
  },
  "git": {
    "inline_blame": {
      "enabled": false
    }
  },
  "base_keymap": "VSCode",
  "tab_bar": {
    "show_tab_bar_buttons": false
  },
  "relative_line_numbers": "enabled",
  "sticky_scroll": {
    "enabled": false
  },
  "gutter": {
    "line_numbers": true
  },
  "minimap": {
    "show": "always"
  },
  "cursor_shape": "block",
  "autosave": {
    "after_delay": {
      "milliseconds": 1000
    }
  },
  "buffer_font_fallbacks": [
    "Menlo",
    "Monaco",
    "Courier New",
    "monospace"
  ],
  "buffer_font_family": "MesloLGS NF",
  "format_on_save": "on",
  "agent_servers": {
    "claude-acp": {
      "type": "registry"
    }
  },
  "ui_font_size": 16,
  "buffer_font_size": 15,
  "theme": {
    "mode": "dark",
    "light": "Gruvbox Light",
    "dark": "Gruvbox Dark",
  },
}
```

- [ ] **Step 5: Copy the durable keybindings exactly**

Create `zed/keymap.json` with this exact content:

```jsonc
// LazyVim-style bindings, based on ~/.config/nvim and its installed LazyVim defaults.
// Space is the leader. Native Cmd shortcuts and insert-mode Ctrl-h/j/k/l are preserved.
// Terminal Ctrl-h/j/k/l navigate Zed panes and intercept the corresponding shell keys.
// Buffer commands operate on Zed tabs in the active pane, not Neovim's global buffer list.
// Space w d closes all tabs in the pane (prompts for unsaved changes); Space b d closes one.
// Space g g uses Zed Git, not lazygit; Space g h s toggles staging instead of stage-only.
// Space f t / Space f T share Zed's terminal; no separate Neovim root/cwd terminal routing.
// Space c f uses your existing Zed formatter. Python Ruff-specific rf/ro are not remapped.
// Flash s/S are not emulated; Zed's default substitute behavior remains in place.
// No existing settings were modified. Delete this file to revert these custom bindings.

[
  {
    "context": "Editor && mode == full && vim_mode == normal && !menu",
    "bindings": {
      "space space": "file_finder::Toggle",
      "space f f": "file_finder::Toggle",
      "space f n": "workspace::NewFile",
      "space f b": "tab_switcher::OpenInActivePane",
      "space ,": "tab_switcher::OpenInActivePane",
      "space f p": "projects::OpenRecent",
      "space /": "pane::DeploySearch",
      "space s g": "pane::DeploySearch",
      "space s shift-s": "project_symbols::Toggle",
      "space s c": "command_palette::Toggle",
      "space s shift-c": "command_palette::Toggle",
      "space :": "command_palette::Toggle",
      "space s shift-r": "workspace::ReopenLastPicker",
      "space s d": "diagnostics::Deploy",
      "space x x": "diagnostics::Deploy",
      "space e": "project_panel::ToggleFocus",
      "space f e": "project_panel::ToggleFocus",
      "space f t": "terminal_panel::ToggleFocus",
      "space f shift-t": "terminal_panel::ToggleFocus",
      "space g g": "git_panel::ToggleFocus",
      "space g s": "git_panel::ToggleFocus",
      "space g d": "git::Diff",
      "space q q": "zed::Quit",
      "ctrl-h": "workspace::ActivatePaneLeft",
      "ctrl-j": "workspace::ActivatePaneDown",
      "ctrl-k": "workspace::ActivatePaneUp",
      "ctrl-l": "workspace::ActivatePaneRight",
      "ctrl-/": "terminal_panel::ToggleFocus",
      "ctrl-_": "terminal_panel::ToggleFocus",
      "shift-h": "pane::ActivatePreviousItem",
      "shift-l": "pane::ActivateNextItem",
      "[ b": "pane::ActivatePreviousItem",
      "] b": "pane::ActivateNextItem",
      "space b b": "pane::AlternateFile",
      "space `": "pane::AlternateFile",
      "space b d": [
        "pane::CloseActiveItem",
        {
          "close_pinned": false
        }
      ],
      "space b o": [
        "pane::CloseOtherItems",
        {
          "close_pinned": false
        }
      ],
      "space -": "pane::SplitDown",
      "space |": "pane::SplitRight",
      "space w s": "pane::SplitDown",
      "space w v": "pane::SplitRight",
      "space w h": "workspace::ActivatePaneLeft",
      "space w j": "workspace::ActivatePaneDown",
      "space w k": "workspace::ActivatePaneUp",
      "space w l": "workspace::ActivatePaneRight",
      "space w d": "pane::CloseAllItems",
      "space w m": "workspace::ToggleZoom",
      "space u shift-z": "workspace::ToggleZoom",
      "space u z": "workspace::ToggleCenteredLayout",
      "space s b": "buffer_search::Deploy",
      "space s s": "outline::Toggle",
      "space c s": "outline_panel::ToggleFocus",
      "space c a": "editor::ToggleCodeActions",
      "space c r": "editor::Rename",
      "space c d": "editor::Hover",
      "g r": "editor::FindAllReferences",
      "g d": "editor::GoToDefinition",
      "g shift-d": "editor::GoToDeclaration",
      "g shift-i": "editor::GoToImplementation",
      "g y": "editor::GoToTypeDefinition",
      "] d": "editor::GoToDiagnostic",
      "[ d": "editor::GoToPreviousDiagnostic",
      "] e": [
        "editor::GoToDiagnostic",
        {
          "severity": {
            "min": "error",
            "max": "error"
          }
        }
      ],
      "[ e": [
        "editor::GoToPreviousDiagnostic",
        {
          "severity": {
            "min": "error",
            "max": "error"
          }
        }
      ],
      "] w": [
        "editor::GoToDiagnostic",
        {
          "severity": {
            "min": "warning",
            "max": "warning"
          }
        }
      ],
      "[ w": [
        "editor::GoToPreviousDiagnostic",
        {
          "severity": {
            "min": "warning",
            "max": "warning"
          }
        }
      ],
      "] h": "editor::GoToHunk",
      "[ h": "editor::GoToPreviousHunk",
      "space g b": "editor::BlameHover",
      "space g h p": "editor::ToggleSelectedDiffHunks",
      "space g h s": "git::ToggleStaged",
      "space g h r": "git::Restore",
      "space u w": "editor::ToggleSoftWrap",
      "space u l": "editor::ToggleLineNumbers",
      "space u shift-l": "editor::ToggleRelativeLineNumbers",
      "space u h": "editor::ToggleInlayHints",
      "space u shift-c": "theme_selector::Toggle",
      "ctrl-up": "vim::ResizePaneUp",
      "ctrl-down": "vim::ResizePaneDown",
      "ctrl-left": "vim::ResizePaneLeft",
      "ctrl-right": "vim::ResizePaneRight"
    }
  },
  {
    "context": "Editor && mode == full && (vim_mode == normal || vim_mode == visual) && !menu",
    "bindings": {
      "j": [
        "vim::Down",
        {
          "display_lines": true
        }
      ],
      "k": [
        "vim::Up",
        {
          "display_lines": true
        }
      ],
      "down": [
        "vim::Down",
        {
          "display_lines": true
        }
      ],
      "up": [
        "vim::Up",
        {
          "display_lines": true
        }
      ],
      "space c f": "editor::Format"
    }
  },
  {
    "context": "Editor && mode == full && (vim_mode == normal || vim_mode == visual || vim_mode == insert) && !menu",
    "bindings": {
      "alt-j": "editor::MoveLineDown",
      "alt-k": "editor::MoveLineUp",
      "ctrl-s": [
        "workspace::SendKeystrokes",
        "cmd-s escape"
      ]
    }
  },
  {
    "context": "EmptyPane || (ProjectPanel && not_editing)",
    "bindings": {
      "space space": "file_finder::Toggle",
      "space f f": "file_finder::Toggle",
      "space f n": "workspace::NewFile",
      "space f b": "tab_switcher::OpenInActivePane",
      "space ,": "tab_switcher::OpenInActivePane",
      "space f p": "projects::OpenRecent",
      "space /": "pane::DeploySearch",
      "space s g": "pane::DeploySearch",
      "space s shift-s": "project_symbols::Toggle",
      "space s c": "command_palette::Toggle",
      "space s shift-c": "command_palette::Toggle",
      "space :": "command_palette::Toggle",
      "space s shift-r": "workspace::ReopenLastPicker",
      "space s d": "diagnostics::Deploy",
      "space x x": "diagnostics::Deploy",
      "space e": "project_panel::ToggleFocus",
      "space f e": "project_panel::ToggleFocus",
      "space f t": "terminal_panel::ToggleFocus",
      "space f shift-t": "terminal_panel::ToggleFocus",
      "space g g": "git_panel::ToggleFocus",
      "space g s": "git_panel::ToggleFocus",
      "space g d": "git::Diff",
      "space q q": "zed::Quit",
      "ctrl-h": "workspace::ActivatePaneLeft",
      "ctrl-j": "workspace::ActivatePaneDown",
      "ctrl-k": "workspace::ActivatePaneUp",
      "ctrl-l": "workspace::ActivatePaneRight",
      "ctrl-/": "terminal_panel::ToggleFocus",
      "ctrl-_": "terminal_panel::ToggleFocus"
    }
  },
  {
    "context": "Terminal",
    "bindings": {
      "ctrl-h": "workspace::ActivatePaneLeft",
      "ctrl-j": "workspace::ActivatePaneDown",
      "ctrl-k": "workspace::ActivatePaneUp",
      "ctrl-l": "workspace::ActivatePaneRight",
      "ctrl-/": "terminal_panel::ToggleFocus",
      "ctrl-_": "terminal_panel::ToggleFocus"
    }
  },
  {
    "context": "Dock",
    "bindings": {
      "ctrl-h": "workspace::ActivatePaneLeft",
      "ctrl-j": "workspace::ActivatePaneDown",
      "ctrl-k": "workspace::ActivatePaneUp",
      "ctrl-l": "workspace::ActivatePaneRight"
    }
  }
]
```

- [ ] **Step 6: Document the tracked Zed configuration**

In `README.md`, insert these two lines immediately after the Neovim entry and before the Cursor entry:

```markdown
- **Zed** (`zed/`) - Editor preferences and LazyVim-style keybindings
  - Tracks `settings.json` and `keymap.json`; excludes local permissions and generated state
```

Do not change the existing Neovim or Cursor entries.

- [ ] **Step 7: Run the validation script and verify GREEN**

Run:

```bash
bun /tmp/dev-env-config-zed-check.ts
```

Expected:

```text
PASS: valid JSONC; settings differ only by sandbox permissions; keymap is identical
```

- [ ] **Step 8: Verify ignore behavior and whitespace**

Run:

```bash
git check-ignore -v zed/prompts/prompts-library-db.0.mdb/data.mdb
git check-ignore -v zed/themes/local.json
! git check-ignore -q zed/.gitignore
! git check-ignore -q zed/settings.json
! git check-ignore -q zed/keymap.json
git diff --check -- README.md zed
```

Expected: the first two commands identify `zed/.gitignore:1:*` as the matching rule; the three negated checks and `git diff --check` succeed without output.

- [ ] **Step 9: Remove the throwaway validation script**

Run:

```bash
rm /tmp/dev-env-config-zed-check.ts
```

Expected: the temporary script is gone; no test artifact remains in the repository.

- [ ] **Step 10: Stage only the intended files and commit**

Run:

```bash
git add README.md zed/.gitignore zed/settings.json zed/keymap.json
git diff --cached --name-only
```

Expected staged file list, in Git's output order:

```text
README.md
zed/.gitignore
zed/keymap.json
zed/settings.json
```

Confirm no other path is staged, then run:

```bash
git commit -m "feat: track Zed editor configuration"
```

- [ ] **Step 11: Verify the committed Zed file set**

Run:

```bash
git ls-tree -r --name-only HEAD zed
git status --short -- README.md zed
```

Expected: the tree listing contains exactly `zed/.gitignore`, `zed/keymap.json`, and `zed/settings.json`; the status command prints nothing.
