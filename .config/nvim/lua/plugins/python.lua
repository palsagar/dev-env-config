return {
  -- Configure all Python LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright: IDE features (completions, go-to-definition, hover) with type checking disabled
        pyright = {
          settings = {
            python = {
              analysis = {
                -- Disable type checking since we use ty for that
                typeCheckingMode = "off",
                -- Enable auto-import completions
                autoImportCompletions = true,
                -- Show parameter hints
                autoSearchPaths = true,
                -- Use library code for completions
                useLibraryCodeForTypes = true,
                -- Diagnostic mode
                diagnosticMode = "workspace",
              },
            },
          },
        },
        -- Ruff LSP: Fast linting and formatting
        ruff_lsp = {
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
          -- Disable capabilities that Pyright handles better
          capabilities = {
            hoverProvider = false,
            definitionProvider = false,
            documentSymbolProvider = false,
            -- Disable LSP formatting - we use conform.nvim with ruff_format instead
            documentFormattingProvider = false,
            documentRangeFormattingProvider = false,
          },
        },
        -- ty: Modern type checking from Astral
        ty = {
          cmd = { "ty", "server" },
          filetypes = { "python" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("pyproject.toml", "ty.toml", ".git")(fname)
              or require("lspconfig.util").path.dirname(fname)
          end,
          single_file_support = true,
        },
      },
      -- Setup function to handle ty LSP (may not be in nvim-lspconfig by default)
      setup = {
        ty = function(_, opts)
          local lspconfig = require("lspconfig")
          -- Register ty if not already registered
          if not lspconfig.configs.ty then
            lspconfig.configs.ty = {
              default_config = {
                cmd = { "ty", "server" },
                filetypes = { "python" },
                root_dir = function(fname)
                  return lspconfig.util.root_pattern("pyproject.toml", "ty.toml", ".git")(fname)
                    or lspconfig.util.path.dirname(fname)
                end,
                single_file_support = true,
              },
            }
          end
          lspconfig.ty.setup(opts)
          return true
        end,
      },
    },
  },

  -- Ensure Mason installs all required tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright", -- Python LSP for IDE features
        "ruff-lsp", -- Ruff LSP server for linting and formatting
        "ty", -- Type checker from Astral
      })
    end,
  },

  -- Configure conform.nvim to use ONLY Ruff for Python formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
      format_on_save = function(bufnr)
        -- Only format Python files with Ruff
        if vim.bo[bufnr].filetype == "python" then
          return {
            timeout_ms = 3000,
            lsp_fallback = false, -- Don't fallback to LSP formatting for Python
          }
        end
        -- For other filetypes, use default behavior
        return {
          timeout_ms = 3000,
          lsp_fallback = true,
        }
      end,
    },
  },

  -- Disable nvim-lint for Python (Ruff LSP handles it)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Remove ruff from linters_by_ft if present, Ruff LSP handles linting
      if opts.linters_by_ft and opts.linters_by_ft.python then
        opts.linters_by_ft.python = vim.tbl_filter(function(linter)
          return linter ~= "ruff"
        end, opts.linters_by_ft.python)
        -- If empty, remove the entry
        if #opts.linters_by_ft.python == 0 then
          opts.linters_by_ft.python = nil
        end
      end
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
