return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = {
        "bashls",
        "marksman",
        "gopls",
        "pyright",
        "ruff",
      },
    },
    config = function(_, opts)
	  vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
          },
        },
      })

      local group = vim.api.nvim_create_augroup("personal_lsp", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
	        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client then
            return
          end

          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          local function map(mode, lhs, rhs, description)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = args.buf,
              desc = description,
            })
          end

          map(
            "n",
            "<leader>cd",
            vim.diagnostic.open_float,
            "Line diagnostics"
          )

          if client:supports_method("textDocument/codeAction") then
            map(
              { "n", "x" },
              "<leader>ca",
              vim.lsp.buf.code_action,
              "Code action"
            )
          end

          if client:supports_method("textDocument/rename") then
            map(
              "n",
              "<leader>cr",
              vim.lsp.buf.rename,
              "Rename symbol"
            )
          end

          if client:supports_method("textDocument/references") then
            map(
              "n",
              "<leader>cR",
              "<cmd>Telescope lsp_references<CR>",
              "Find references"
            )
          end
        end,
      })

      require("mason-lspconfig").setup(opts)
    end,
  },
}
