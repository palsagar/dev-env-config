-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Background autosave: save on InsertLeave and after ~1s idle in normal mode.
-- Uses `noautocmd write` so BufWritePre/BufWritePost do NOT fire — conform/LazyFormat
-- never runs on autosave. Manual `:w` still formats normally.
local autosave_group = vim.api.nvim_create_augroup("user_autosave", { clear = true })
local autosave_timer = (vim.uv or vim.loop).new_timer()

local function autosave()
  if
    vim.bo.modified
    and vim.bo.modifiable
    and not vim.bo.readonly
    and vim.bo.buftype == ""
    and vim.fn.expand("%") ~= ""
  then
    vim.cmd("silent! noautocmd write")
  end
end

vim.api.nvim_create_autocmd("InsertLeave", {
  group = autosave_group,
  callback = autosave,
  desc = "Autosave on InsertLeave (no formatting)",
})

vim.api.nvim_create_autocmd("TextChanged", {
  group = autosave_group,
  callback = function()
    autosave_timer:stop()
    autosave_timer:start(1000, 0, vim.schedule_wrap(autosave))
  end,
  desc = "Debounced autosave on TextChanged (no formatting)",
})

-- Open the explorer sidebar on startup, like Zed's project panel, so Ctrl+h can reach it.
-- Focus stays in the editor. Skipped for git commit/rebase messages ($EDITOR is nvim)
-- and when `nvim <dir>` already opened it.
local function open_explorer()
  if
    not vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo.filetype)
    and not Snacks.picker.get({ source = "explorer" })[1]
  then
    Snacks.explorer({ cwd = LazyVim.root(), enter = false })
  end
end

-- LazyVim loads this file before startup ends when nvim opens a file, and after it otherwise.
if vim.v.vim_did_enter == 1 then
  open_explorer()
else
  vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = open_explorer })
end
