require('notify').setup({
  background_colour = '#24273A'
})

vim.notify = require('notify')

require('nvim-web-devicons').get_icons()

-- Colorizer
require('colorizer').setup()

-- Autopairs
require('nvim-autopairs').setup({
  enable_check_bracket_line = false,
  map_cr = false
})
