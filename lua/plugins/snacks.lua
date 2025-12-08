return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd
  end,
  opts = {
    bigfile = {},
    lazygit = {},
    explorer = { enabled = false },
    -- indent = {
    --   char = "▏",
    --   animate = { enabled = false }
    -- },
    picker = {
      ui_select = true,
      formatters = {
        file = {
          -- filename_first = true,
          truncate = 80,
        }
      },
      win = {
        input = {
          keys = {
            -- ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            -- ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        explorer = {
          win = {
            list = {
              wo = {
                number = true,
                relativenumber = true,
              },
            },
          },
        },
      },
    },
    image = {},
    words = {},
  },
  keys = {
    { "<C-p>",      function() Snacks.picker.files() end,       desc = "Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Buffers" },
    { "g/",         function() Snacks.picker.grep() end,        desc = "Grep" },
    { "gs",         function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>ri", function() Snacks.picker.resume() end,      desc = "Resume" },
    { "<leader>gd", function() Snacks.picker.git_diff() end,    desc = "Git diff" },
  }
}
