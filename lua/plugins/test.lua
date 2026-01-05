return {
  {
    "vim-test/vim-test",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    init = function()
      vim.g["test#strategy"] = "toggleterm"
    end,
    -- stylua: ignore
    keys = {
      { "<leader>tn", ":TestNearest<CR>:Topen<CR><C-w>jG<C-w>p", desc = "Test nearest", silent = true },
      { "<leader>tf", ":TestFile<CR>:Topen<CR><C-w>jG<C-w>p",    desc = "Test file",    silent = true },
      { "<leader>ts", ":TestSuite<CR>:Topen<CR><C-w>jG<C-w>p",   desc = "Test suite",   silent = true },
      { "<leader>tl", ":TestLast<CR>:Topen<CR><C-w>jG<C-w>p",    desc = "Test last",    silent = true },
      { "<leader>tv", ":TestVisit<CR>",                          desc = "Test visit",   silent = true },
    },
  },
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      { "nvim-treesitter/nvim-treesitter", branch = "main" },

      "jfpedroza/neotest-elixir",
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        build = function()
          vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
        end,
      },
    },
    config = function()
      local golang_opts = {
        runner = "gotestsum",
      }

      require("neotest").setup({
        adapters = {
          require("neotest-elixir"),
          require("neotest-golang")(golang_opts),
        },
      })
    end,
    keys = {
      -- stylua: ignore start
      { '<leader>nt', function() require("neotest").run.run() end,                                      desc = "Test nearest" },
      { "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end,                    desc = "Test file" },
      -- { '<leader>nl', function() require("neotest").run.run_last({ extra_args = '--failed' }) end,      desc = 'Test failed' },
      { "<leader>nl", function() require("neotest").run.run_last() end,                                 desc = "Run last test" },
      { "<leader>ne", function() require("neotest").output.open({ enter = true }) end,                  desc = "Open test output" },
      { "<leader>nc", function() require("neotest").output.open({ enter = true, last_run = true }) end, desc = "Open output of last test run" },
      { "<leader>na", function() require("neotest").run.attach() end,                                   desc = "Attach to current running tests" },
      { "<leader>nb", function() require("neotest").summary.toggle() end,                               desc = "Toggle test summary" },
      { "<leader>np", function() require("neotest").run.stop() end,                                     desc = "Stop running tests" },
      { "[t",         function() require("neotest").jump.prev({ status = "failed" }) end,               desc = "Prev failed test" },
      { "]t",         function() require("neotest").jump.next({ status = "failed" }) end,               desc = "Next failed test" },
      -- stylua: ignore end
    },
  },
}
