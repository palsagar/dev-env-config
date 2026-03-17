# Plan: Add `uv` Cursor Rule for Python Projects

## Context
The user has existing Cursor rules in `~/.cursor/rules/python/` for Python-specific guidance (comments, docstrings, types). They want a new rule covering `uv` (Astral's Python package manager) for virtual environment management, dependency handling, and related workflows. This rule should match the established format and conciseness of the existing Python rules.

## Existing Rules Format (from `~/.cursor/rules/python/`)

All Python rules share:
- **Extension**: `.mdc`
- **Frontmatter**: `globs: **/*.py` + `alwaysApply: false`
- **Body**: 1-7 lines, single paragraph, direct and prescriptive
- **Location**: `~/.cursor/rules/python/`

Examples of existing tone:
- `comments.mdc`: "Add in-line comments alongside or above the lines or blocks of code especially when the logic is non-trivial. Explain the intent (the 'what'), and not implementation detail (the 'how')."
- `types.mdc`: "Ensure signatures of functions and methods have proper type annotations (preferably from the typing and collections.abc modules)."

## Change

### Create `~/.cursor/rules/python/uv.mdc`

Content covers these areas (kept minimal per existing style):
- Use `uv` for all Python environment and dependency operations
- `uv init` for new projects, `uv venv` for environments
- `uv add`/`uv remove` for dependencies (not `pip install`)
- `uv run` to execute scripts/commands within the project environment
- `uv sync` to install from lockfile
- Prefer `pyproject.toml` over `requirements.txt`

**Draft content:**

```
---
globs: **/*.py
alwaysApply: false
---

Use `uv` (from Astral) for all Python project and environment management. Create projects with `uv init`, virtual environments with `uv venv`, and add dependencies with `uv add <package>` (never `pip install`). Run scripts and commands through `uv run <command>` to ensure the correct environment is used. Use `uv sync` to install from an existing lockfile. Always manage dependencies via `pyproject.toml` rather than `requirements.txt`.
```

## Verification
- `cat ~/.cursor/rules/python/uv.mdc` to confirm content
- Confirm frontmatter matches sibling rules (`globs: **/*.py`, `alwaysApply: false`)
