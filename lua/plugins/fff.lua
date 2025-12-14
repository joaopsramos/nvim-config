return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  -- No need to lazy-load with lazy.nvim.
  -- This plugin initializes itself lazily.
  lazy = false,
  opts = {
    prompt = '❯ ',
    layout = {
      prompt_position = "top",
    },
    preview = {
      line_numbers = true
    }
  },
  keys = {
    {
      "<C-p>",
      function() require('fff').find_files() end,
      desc = 'FFFind files',
    }
  }
}
