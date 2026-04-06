return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                               desc = "DAP: Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                        desc = "DAP: Continue" },
      { "<leader>di", function() require("dap").step_into() end,                                       desc = "DAP: Step into" },
      { "<leader>do", function() require("dap").step_over() end,                                       desc = "DAP: Step over" },
      { "<leader>dO", function() require("dap").step_out() end,                                        desc = "DAP: Step out" },
      { "<leader>dt", function() require("dap").terminate() end,                                       desc = "DAP: Terminate" },
      { "<leader>dr", function() require("dap").repl.open() end,                                       desc = "DAP: Open REPL" },
      { "<leader>du", function() require("dapui").toggle() end,                                        desc = "DAP: Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" },                    desc = "DAP: Eval expression" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,       desc = "DAP: Conditional breakpoint" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- UI
      dapui.setup()

      -- Virtual text
      require("nvim-dap-virtual-text").setup()

      -- Python
      require("dap-python").setup()

      -- Go
      require("dap-go").setup()
    end,
  },

  -- Auto-install debug adapters via Mason
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "python", "delve" },
      handlers = {},
    },
  },
}
