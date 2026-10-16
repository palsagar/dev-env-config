return {
  -- Disable marksman LSP: wiki-link / heading nav not used.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = { enabled = false },
      },
    },
  },

  -- Disable markdownlint diagnostics (MD013, MD060, etc.) — too noisy.
  -- Prettier formatting via conform stays enabled for manual `:w`.
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },

  -- markdownlint-cli2 is unused (nvim-lint disabled above); drop it from the
  -- markdown extra's tool list so Mason stops installing it.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "markdownlint-cli2"
      end, opts.ensure_installed or {})
    end,
  },

  -- LaTeX math rendering needs the tree-sitter CLI (for the latex grammar) plus
  -- a converter (utftex/latex2text) — none installed. Disable to keep things quiet.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      latex = { enabled = false },
    },
  },
}
