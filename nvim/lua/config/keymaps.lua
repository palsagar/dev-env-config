-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Python-specific keymaps
-- Snacks.keymap with `ft` also covers Python buffers opened before this file loads (on VeryLazy).
-- Space+c+f (format) comes from LazyVim and already runs ruff_fix + ruff_format via conform.

-- Ruff: Fix all issues
Snacks.keymap.set("n", "<leader>rf", function()
  vim.lsp.buf.code_action({ context = { only = { "source.fixAll.ruff" } }, apply = true })
end, { ft = "python", desc = "Ruff: Fix all" })

-- Ruff: Organize imports
Snacks.keymap.set("n", "<leader>ro", function()
  vim.lsp.buf.code_action({ context = { only = { "source.organizeImports.ruff" } }, apply = true })
end, { ft = "python", desc = "Ruff: Organize imports" })
