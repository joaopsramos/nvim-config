-- require('tokyonight').setup({
--   style = 'storm', -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
--   transparent = false, -- Enable this to disable setting the background color
--   terminal_colors = false, -- Configure the colors used when opening a `:terminal` in Neovim
--   styles = {
--     -- Style to be applied to different syntax groups
--     -- Value is any valid attr-list value `:help attr-list`
--     comments = 'italic',
--     keywords = 'italic',
--     functions = 'NONE',
--     variables = 'NONE',
--     -- Background styles. Can be 'dark', 'transparent' or 'normal'
--     sidebars = 'dark', -- style for sidebars, see below
--     floats = 'dark', -- style for floating windows
--   },
--   sidebars = { 'qf', 'help' }, -- Set a darker background on sidebar-like windows. For example: `['qf', 'vista_kind', 'terminal', 'packer']`
--   day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
--   hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
--   dim_inactive = false, -- dims inactive windows
--   lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

--   --- You can override specific color groups to use other groups or a hex color
--   --- fucntion will be called with a ColorScheme table
--   on_colors = function(c)
--     c.none = 'NONE'
--     c.bg = '#282a36'
--     c.bg_dark = '#21222b'
--     c.bg_highlight = '#313340'
--     c.fg = '#c0caf5'
--     c.fg_dark = '#a9b1d6'
--     c.fg_gutter = '#3b4261'
--     c.selection = '#44475a'
--     c.comment = '#6272a4'
--     c.blue = '#7aa2f7'
--     c.blue0 = '#3d59a1'
--     c.blue1 = '#2ac3de'
--     c.blue2 = '#0db9d7'
--     c.blue5 = '#89ddff'
--     c.blue6 = '#b4f9f8'
--     c.blue7 = '#394b70'
--     c.cyan = '#7dcfff'
--     c.dark3 = '#545c7e'
--     c.dark5 = '#737aa2'
--     c.green = '#9ece6a'
--     -- c.green1 = '#21b9d4'
--     c.green1 = '#54bac9'
--     c.green2 = '#41a6b5'
--     c.magenta = '#bd93f9'
--     c.magenta2 = '#ff007c'
--     c.orange = '#ff9e64'
--     c.purple = '#bd93f9'
--     c.red = '#f7768e'
--     c.red1 = '#db4b4b'
--     c.teal = '#1abc9c'
--     c.yellow = '#e0af68'
--     c.terminal_black = '#414868'

--     c.error = c.red
--     c.bg_sidebar = c.bg_dark
--     c.bg_visual = c.selection
--     c.bg_float = c.bg
--     c.bg_statusline = c.bg_dark

--     c.git = { change = c.orange, add = c.green, delete = c.red }
--     c.gitSigns = { change = c.orange, add = c.green, delete = c.red }

--     c.diff = {
--       change = '#223159',
--       add = '#283b4d',
--       delete = '#3f2d3d',
--       text = c.blue7
--     }
--   end,

--   --- You can override specific highlights to use other groups or a hex color
--   --- fucntion will be called with a Highlights and ColorScheme table
--   on_highlights = function(h, c)
--     h.Constant = { fg = c.orange }

--     h['@type'] = { fg = c.purple }
--     h['@keyword'] = { fg = c.red }
--     h['@keyword.function'] = { fg = c.red }
--     -- h['@parameter'] = { fg = c.yellow }

--     -- Elixir atoms
--     h.Identifier = { fg = c.cyan }

--     h.TreesitterContext = { bg = c.bg_highlight }
--     h.TreesitterContextLineNumber = { fg = c.red }

--     h.LineNr = { fg = c.dark5 }
--     h.CursorLineNr = { fg = c.cyan }


--     -- htmlTag = { fg = c.mauve },
--     -- htmlEndTag = { fg = c.mauve },
--     h.htmlTagName = { fg = c.purple }
--     h.htmlArg = { fg = c.red }
--   end,
-- })

-- vim.cmd([[
--   colorscheme tokyonight
-- ]])

require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "macchiato",
  },
  compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  transparent_background = false,
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,
    treesitter = true,
    -- neotest = true,
    which_key = true,
    notify = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    --
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
  color_overrides = {
    all = {
      rosewater = "#F4DBD6",
      flamingo = "#F0C6C6",
      pink = "#F5BDE6",
      mauve = "#C6A0F6",
      red = "#ED8796",
      maroon = "#EE99A0",
      peach = "#F5A97F",
      yellow = "#EED49F",
      green = "#A6DA95",
      teal = "#8BD5CA",
      sky = "#91D7E3",
      sapphire = "#8BE9FD",
      blue = "#8AADF4",
      lavender = "#B7BDF8",

      text = "#CAD3F5",
      subtext1 = "#B8C0E0",
      subtext0 = "#A5ADCB",
      overlay2 = "#939AB7",
      overlay1 = "#8087A2",
      overlay0 = "#6E738D",
      surface2 = "#5B6078",
      surface1 = "#494D64",
      surface0 = "#363A4F",

      base = "#282a36",
      mantle = "#1E2030",
      crust = "#181926",
    }
  },
  custom_highlights = function(c)
    return {
      -- Normal = { bg = c.none },
      -- NormalNC = { bg = c.none },
      -- Constant = { fg = c.mauve },
      Identifier = { fg = c.peach },

      ['@type'] = { fg = c.mauve },
      ['@keyword'] = { fg = c.red },
      ['@keyword.function'] = { fg = c.red },
      -- -- -- ['@parameter'] = { fg = c.peach },
      ['@symbol'] = { fg = c.sapphire },
      -- ['@operator'] = { fg = c.pink },
      -- ['@function'] = { fg = c.blue },
      -- ['@function.call'] = { fg = c.blue },
      -- ['@tag'] = { fg = c.pink },
      -- ['@tag.attribute'] = { fg = c.yellow },

      -- htmlTag = { fg = c.mauve },
      htmlEndTag = { fg = c.flamingo },
      -- htmlTagName = { fg = c.pink },
      -- htmlString = { fg = c.yellow },
      -- htmlArg = { fg = c.green },

      TreesitterContext = { bg = c.surface0 },
      TreesitterContextLineNumber = { fg = c.red },

      LineNr = { fg = c.surface1 },
      CursorLineNr = { fg = c.blue },

      TelescopeMatching = { fg = c.sapphire },
      TelescopeSelection = { fg = c.peach, bg = c.none, style = { "bold" } },

      GitSignsChange = { fg = c.peach },

      DiffChange = { bg = '#223159' },
      DiffAdd = { bg = '#283b4d' },
      DiffDelete = { bg = '#3f2d3d' },
      DiffText = { bg = '#394b70' },

      -- Search = { bg = c.surface1 },
      -- CurSearch = { bg = c.blue },
      -- IncSearch = { bg = c.peach },
      -- Substitute = { bg = c.none, fg = c.red },

      -- CmpItemKindField = { fg = c.sapphire },
      -- CmpItemKindVariable = { fg = c.peach },
      -- CmpItemKindProperty = { fg = c.sapphire },
      -- CmpItemKindText = { fg = c.text },
      -- CmpItemKindKeyword = { fg = c.pink },

      TabLineSel = { fg = c.green, bg = c.mantle },

      EndOfBuffer = { fg = c.surface1 },

      --       NotifyWARNBorder = { fg = c.peach },
      --       NotifyWARNIcon = { fg = c.peach },
      --       NotifyWARNTitle = { fg = c.peach, style = { "italic" } },
    }
  end
})

vim.api.nvim_command "colorscheme catppuccin"
