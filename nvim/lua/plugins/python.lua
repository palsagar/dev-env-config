return {
  -- Configure all Python LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright: IDE features only (hover, completions, go-to-def).
        -- ty + ruff own diagnostics; swallow pyright's publishDiagnostics to clear noise.
        pyright = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        -- Ruff language server: fast linting and code actions
        ruff = {
          init_options = {
            settings = {
              -- Enable linting
              lint = {
                enable = true,
              },
              -- Enable code actions (fix all, organize imports)
              fixAll = true,
              organizeImports = true,
            },
          },
        },
        -- ty: Modern type checking from Astral
        ty = {
          cmd = { "ty", "server" },
        },
      },
      -- Keep Pyright hover as the default hover provider
      setup = {
        ruff = function()
          Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
            client.server_capabilities.hoverProvider = false
          end)
        end,
      },
    },
  },

  -- Ensure Mason installs all required tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright", -- Python LSP for IDE features
        "ruff", -- Ruff language server for linting and code actions
        "ty", -- Type checker from Astral
      })
    end,
  },

  -- Configure conform.nvim to use ONLY Ruff for Python formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
    },
  },

  -- Disable nvim-lint for Python (Ruff LSP handles it)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      -- Ruff LSP provides Python diagnostics; avoid duplicate lints
      opts.linters_by_ft.python = nil
    end,
  },

  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      -- Auto-detect venv in common locations
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
      -- Search in parent directories
      parents = 2,
    },
    keys = {
      {
        "<leader>cv",
        function()
          require("venv-selector").open()
        end,
        desc = "Select Python venv",
      },
    },
  },

  -- Explicitly disable debugging plugins to avoid debugpy errors
  { "mfussenegger/nvim-dap", enabled = false },
  { "mfussenegger/nvim-dap-python", enabled = false },
  { "mfussenegger/nvim-dap-ui", enabled = false },
}
