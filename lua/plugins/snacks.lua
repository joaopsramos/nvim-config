return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    explorer = {},
    -- indent = {
    --   char = "▏",
    --   animate = { enabled = false }
    -- },
    picker = {
      formatters = {
        file = {
          -- filename_first = true,
          truncate = 60,
        }
      }
    },
    image = {},
    words = { enabled = true },
  },
  keys = {
    { "<C-p>",      function() Snacks.picker.files() end,       desc = "Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Buffers" },
    { "g/",         function() Snacks.picker.grep() end,        desc = "Grep" },
    { "gs",         function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>ri", function() Snacks.picker.resume() end,      desc = "Resume" },
  }
}
