return {
  "folke/snacks.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  priority = 1000,
  lazy = false,
  init = function()
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    if vim.fn.has("nvim-0.11") == 1 then
      vim._print = function(_, ...)
        dd(...)
      end
    else
      vim.print = dd
    end
  end,
  opts = {
    bigfile = {},
    lazygit = {},
    explorer = { enabled = false },
    statuscolumn = {},
    notifier = {},
    image = {},
    picker = {
      enabled = true,
      ui_select = true,
      formatters = {
        file = {
          -- filename_first = true,
          truncate = 80,
        },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "i", "n" } },
            ["<C-c>"] = "cancel",
            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
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
  },
  -- stylua: ignore
  keys = {
    { "gl",         function() Snacks.picker.buffers() end,                  desc = "Buffers" },
    { "g/",         function() Snacks.picker.grep() end,                     desc = "Grep" },
    { "gs",         function() Snacks.picker.lsp_symbols() end,              desc = "Document symbols" },
    { "<leader>pr", function() Snacks.picker.resume() end,                   desc = "Resume" },
    { "<leader>gd", function() Snacks.picker.git_diff({ group = true }) end, desc = "Git diff" },
    { "<leader>nd", function() Snacks.notifier.hide() end,                   desc = "Dismiss all notifications", },
  },
}
