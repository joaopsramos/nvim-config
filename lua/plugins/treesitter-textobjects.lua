return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V',  -- linewise
          ['@class.outer'] = 'V',     -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      }
    }
  end,
  keys = function()
    local ts_select = require "nvim-treesitter-textobjects.select"
    local ts_swap = require "nvim-treesitter-textobjects.swap"

    return {
      { "af",         function() ts_select.select_textobject("@function.outer", "textobjects") end, mode = { "x", "o" }, desc = "Select outer function" },
      { "if",         function() ts_select.select_textobject("@function.inner", "textobjects") end, mode = { "x", "o" }, desc = "Select inner function" },
      { "ac",         function() ts_select.select_textobject("@class.outer", "textobjects") end,    mode = { "x", "o" }, desc = "Select outer class" },
      { "ic",         function() ts_select.select_textobject("@class.inner", "textobjects") end,    mode = { "x", "o" }, desc = "Select inner class" },

      { "<leader>sn", function() ts_swap.swap_next("@parameter.inner") end,                         mode = { "n" },      desc = "Swap next parameter" },
      { "<leader>sp", function() ts_swap.swap_previous("@parameter.outer") end,                     mode = { "n" },      desc = "Swap previous parameter" },
    }
  end
}
