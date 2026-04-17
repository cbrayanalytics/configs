return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      -- Language adapters
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "rcasia/neotest-bash",
    },
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end,                                          desc = "Test: run nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,                        desc = "Test: run file" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end,                           desc = "Test: run all" },
      { "<leader>ts", function() require("neotest").run.stop() end,                                         desc = "Test: stop" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end,   desc = "Test: output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end,                              desc = "Test: output panel" },
      { "<leader>tS", function() require("neotest").summary.toggle() end,                                   desc = "Test: summary" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                      desc = "Test: debug nearest" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            python = function()
              return vim.fn.getcwd() .. "/.venv/bin/python"
            end,
          }),
          require("neotest-go")({
            experimental = { test_table = true },
            args = { "-race", "-count=1" },
          }),
          require("neotest-bash")(),
        },
        status = { virtual_text = true },
        output = { open_on_run = false },
        quickfix = {
          open = function()
            require("trouble").open("qflist")
          end,
        },
      }
    end,
  },
}
