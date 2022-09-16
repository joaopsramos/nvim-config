-- require('onedark').setup  {
--     -- Main options --
--     style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
--     transparent = false,  -- Show/hide background
--     term_colors = false, -- Change terminal color as per the selected theme style
--     ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
--     -- toggle theme style ---
--     toggle_style_key = '<leader>ts', -- Default keybinding to toggle
--     toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

--     -- Change code style ---
--     -- Options are italic, bold, underline, none
--     -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
--     code_style = {
--     --    comments = 'italic',
--         keywords = 'none',
--         functions = 'none',
--         strings = 'none',
--         variables = 'none'
--     },

--     -- Custom Highlights --
--     colors = {
--         red = "#e06c75",
--         dark_red = "#be5046",
--         green = "#98c379",
--         yellow = "#e5c07b",
--         dark_yellow = "#d19a66",
--         blue = "#61afef",
--         purple = "#c678dd",
--         cyan = "#56b6c2",
--         white = "#abb2bf",
--         black = "#282c34",
--         comment_grey = "#5c6370",
--         gutter_fg_grey = "#4b5263",
--         cursor_grey = "#2c323c",
--         visual_grey = "#3e4452",
--         menu_grey = "#3e4452",
--         special_grey = "#3b4048",
--         vertsplit = "#3e4452"
--     }, -- Override default colors
--     highlights = {}, -- Override highlight groups

--     -- Plugins Config --
--     diagnostics = {
--         darker = true, -- darker colors for diagnostic
--         undercurl = true,   -- use undercurl instead of underline for diagnostics
--         background = true,    -- use background color for virtual text
--     },
-- }

-- require('onedark').load()

-- -- vim.cmd[[colorscheme dracula]]

-- -- vim.cmd[[colorscheme palenight]]

require("tokyonight").setup({
  style = "storm", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = false, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value `:help attr-list`
    comments = "italic",
    keywords = "italic",
    functions = "NONE",
    variables = "NONE",
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- fucntion will be called with a ColorScheme table
  on_colors = function(c)
    c.none = "NONE"
    c.bg = "#282a36"
    c.bg_dark = "#21222b"
    c.bg_highlight = "#313340"
    c.fg = "#c0caf5"
    c.fg_dark = "#a9b1d6"
    c.fg_gutter = "#3b4261"
    c.selection = "#44475a"
    c.comment = "#6272a4"
    c.blue = "#7aa2f7"
    c.blue0 = "#3d59a1"
    c.blue1 = "#2ac3de"
    c.blue2 = "#0db9d7"
    c.blue5 = "#89ddff"
    c.blue6 = "#b4f9f8"
    c.blue7 = "#394b70"
    c.cyan = "#7dcfff"
    c.dark3 = "#545c7e"
    c.dark5 = "#737aa2"
    c.green = "#9ece6a"
    c.green1 = "#73daca"
    c.green2 = "#41a6b5"
    c.magenta = "#bd93f9"
    c.magenta2 = "#ff007c"
    c.orange = "#ff9e64"
    c.purple = "#bd93f9"
    c.red = "#f7768e"
    c.red1 = "#db4b4b"
    c.teal = "#1abc9c"
    c.yellow = "#e0af68"
    c.terminal_black = "#414868"

    c.error = c.red
    c.bg_sidebar = c.bg_dark
    c.bg_visual = c.selection
    c.bg_float = c.bg
    c.bg_statusline = c.bg_dark

    c.git = { change = c.orange, add = c.green, delete = c.red }
    c.gitSigns = { change = c.orange, add = c.green, delete = c.red }

    c.diff = {
      change = "#223159",
      add = "#283b4d",
      delete = "#3f2d3d",
      text = c.blue7
    }
  end,

  --- You can override specific highlights to use other groups or a hex color
  --- fucntion will be called with a Highlights and ColorScheme table
  on_highlights = function(h, c)
    h.TSType = { fg = c.purple }
    h.TSConstBuiltin = { fg = c.orange }
    -- h.TSOperator = {fg = c.orange}
    h.TSKeyword = { fg = c.red }
    h.TSParameterReference = { fg = c.red }
    h.TSConstructor = { fg = c.red }
    h.TSKeywordFunction = { fg = c.red }
    -- Elixir atoms
    h.Identifier = { fg = c.cyan }
  end,
})

vim.cmd([[
    colorscheme tokyonight
]])
