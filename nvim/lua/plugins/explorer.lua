return {
  {
    "folke/snacks.nvim",
    -- Show dotfiles (.env, .github, ...) like Zed. Press H in the explorer to toggle.
    opts = { picker = { sources = { explorer = { hidden = true } } } },
    keys = {
      -- Like Zed's project_panel::ToggleFocus. <leader>e maps to this key.
      -- Opens the explorer if closed, focuses it if unfocused, returns to the editor if focused.
      -- It never closes the explorer; press q inside the explorer to close it.
      {
        "<leader>fe",
        function()
          local explorer = Snacks.picker.get({ source = "explorer" })[1]
          if not explorer then
            Snacks.explorer({ cwd = LazyVim.root() })
          elseif explorer:is_focused() then
            vim.api.nvim_set_current_win(explorer.main)
          else
            explorer:focus()
          end
        end,
        desc = "Explorer Snacks (root dir)",
      },
    },
  },
}
