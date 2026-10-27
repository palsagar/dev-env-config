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

  -- Richer styling than LazyVim's plain defaults.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- Keep rendering in every mode, including insert (the cursor line still shows raw text).
      render_modes = true,
      heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
      checkbox = { enabled = true },
      pipe_table = { preset = "round" },
      -- Math is drawn as images by Snacks.image below; this text-based version would need
      -- an extra converter (utftex/latex2text) and would render the same math twice.
      latex = { enabled = false },
    },
  },

  -- Draw images and LaTeX math inside the buffer (Kitty graphics protocol, e.g. Ghostty).
  -- Uses ImageMagick for images and tectonic/pdflatex for math.
  {
    "folke/snacks.nvim",
    opts = { image = { enabled = true } },
  },

  -- Snacks.image finds $math$ in markdown through the latex treesitter parser.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "latex" } },
  },
}
