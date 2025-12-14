return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = {    -- :h background
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = false,
      term_colors = false,
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
        fidget = true,
        mason = true,
        neotest = true,
        which_key = true,
        notify = true,
        noice = false,
        -- avante = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            ok = { "undercurl" },
          },
          inlay_hints = {
            background = true,
          },
        },
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
          overlay3 = "#939AB7",
          overlay2 = "#6E738D",
          overlay1 = "#8087A2",
          overlay0 = "#6E738D",
          surface2 = "#5B6078",
          surface1 = "#494D64",
          surface0 = "#363A4F",

          base = "#282a36",
          -- mantle = "#1E2030",
          mantle = "#282a36",
          -- crust = "#181926",
          curst = "#282a36",
        }
      },
      custom_highlights = function(c)
        return {
          -- ['@identifier'] = { fg = c.yellow },
          ['@keyword'] = { fg = c.maroon },
          ['@type'] = { fg = c.mauve },
          ['@type.definition'] = { fg = c.mauve },
          ['@type.builtin.go'] = { fg = c.yellow },
          ['@variable.parameter'] = { fg = c.red },
          ["@operator"] = { fg = c.teal },
          ["@punctuation.bracket"] = { fg = c.overlay2 },
          ["@entity.name.namespace"] = { fg = c.yellow },

          ["@keyword.function"] = { fg = c.maroon },
          ["@module.elixir"] = { fg = c.mauve, style = { "italic" } },
          ['@string.special.symbol.elixir'] = { fg = c.sapphire },

          htmlEndTag = { fg = c.flamingo },

          TreesitterContext = { bg = c.surface0 },
          TreesitterContextLineNumber = { fg = c.red },
          LineNr = { fg = c.surface2 },
          CursorLineNr = { fg = c.blue },
          TelescopeMatching = { fg = c.sapphire },
          TelescopeSelection = { fg = c.peach, bg = c.none, style = { "bold" } },
          GitSignsChange = { fg = c.peach },
          DiffChange = { bg = '#223159' },
          -- DiffAdd = { bg = '#283b4d' },
          DiffDelete = { bg = '#3f2d3d' },
          DiffText = { bg = '#394b70' },

          TabLineSel = { fg = c.green, bg = c.mantle },
          EndOfBuffer = { fg = c.surface1 },

          IblScope = { fg = c.overlay0 },

          AvanteTitle = { bg = c.lavender, fg = c.base },
          AvanteReversedTitle = { bg = c.none, fg = c.lavender },
          AvanteSubtitle = { bg = c.peach, fg = c.base },
          AvanteReversedSubtitle = { bg = c.none, fg = c.peach },
          AvanteThirdTitle = { bg = c.blue, fg = c.base },
          AvanteReversedThirdTitle = { bg = c.none, fg = c.blue },
          AvanteInlineHint = { fg = c.red },
          AvanteSidebarWinSeparator = { link = "WinSeparator" },
          AvantePromptInputBorder = { fg = c.blue },

          AvanteConflictCurrent = { bg = '#283b4d' },
          AvanteConflictIncoming = { bg = '#223159' },
          AvanteConflictAncestor = { bg = '#394b70' },
          AvanteConflictDelete = { bg = '#3f2d3d' },
        }
      end
    })

    vim.cmd.colorscheme "catppuccin"
  end
}

-- return {
--   "folke/tokyonight.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('tokyonight').setup({
--       style = "moon",
--       terminal_colors = false,
--       transparent = true,
--       lualine_bold = true,
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--       on_colors = function(colors)
--         local custom_colors = {
--           _name = "tokyonight_moon",
--           _style = "moon",
--           bg = "#222436",
--           bg_dark = "#1e2030",
--           bg_float = "#1e2030",
--           bg_highlight = "#2f334d",
--           bg_popup = "#1e2030",
--           bg_search = "#3e68d7",
--           bg_sidebar = "#1e2030",
--           bg_statusline = "NONE",
--           bg_visual = "#2d3f76",
--           black = "#1b1d2b",
--           blue = "#82aaff",
--           blue0 = "#3e68d7",
--           blue1 = "#65bcff",
--           blue2 = "#0db9d7",
--           blue5 = "#89ddff",
--           blue6 = "#b4f9f8",
--           blue7 = "#394b70",
--           border = "#1b1d2b",
--           -- border_highlight = "#589ed7",
--           border_highlight = "#8AADF4",
--           comment = "#636da6",
--           cyan = "#86e1fc",
--           dark3 = "#545c7e",
--           dark5 = "#737aa2",
--           diff = {
--             add = "#273849",
--             change = "#252a3f",
--             delete = "#3a273a",
--             text = "#394b70"
--           },
--           -- error = "#c53b53",
--           error = "#ff757f",
--           fg = "#c8d3f5",
--           fg_dark = "#828bb8",
--           fg_float = "#c8d3f5",
--           -- fg_gutter = "#3b4261",
--           fg_gutter = "#363A4F",
--           -- fg_sidebar = "#828bb8",
--           fg_sidebar = "#CAD3F5",
--           fg_surface1 = "#494D64",
--           fg_text = "#CAD3F5",
--           git = {
--             add = "#b8db87",
--             change = "#F5A97F",
--             delete = "#ff757f",
--             ignore = "#545c7e"
--           },
--           green = "#c3e88d",
--           green1 = "#4fd6be",
--           green2 = "#41a6b5",
--           hint = "#4fd6be",
--           info = "#0db9d7",
--           magenta = "#c099ff",
--           magenta2 = "#ff007c",
--           none = "NONE",
--           -- orange = "#ff966c",
--           orange = "#F5A97F",
--           purple = "#fca7ea",
--           rainbow = { "#82aaff", "#ffc777", "#c3e88d", "#4fd6be", "#c099ff", "#fca7ea" },
--           red = "#ff757f",
--           red1 = "#c53b53",
--           teal = "#4fd6be",
--           terminal = {
--             black = "#1b1d2b",
--             black_bright = "#444a73",
--             blue = "#82aaff",
--             blue_bright = "#9ab8ff",
--             cyan = "#86e1fc",
--             cyan_bright = "#b2ebff",
--             green = "#c3e88d",
--             green_bright = "#c7fb6d",
--             magenta = "#c099ff",
--             magenta_bright = "#caabff",
--             red = "#ff757f",
--             red_bright = "#ff8d94",
--             white = "#828bb8",
--             white_bright = "#c8d3f5",
--             -- yellow = "#ffc777",
--             yellow = "#EED49F",
--             yellow_bright = "#ffc777"
--           },
--           terminal_black = "#444a73",
--           todo = "#82aaff",
--           -- warning = "#ffc777",
--           warning = "#EED49F",
--           -- yellow = "#ffc777",
--           yellow = "#EED49F",
--         }
--
--         for k, v in pairs(custom_colors) do
--           colors[k] = v
--         end
--       end,
--
--       on_highlights = function(hl, c)
--         hl.CursorLineNr = { fg = c.magenta }
--         hl.LineNr = { fg = c.fg_surface1 }
--         hl.LineNrAbove = { fg = c.fg_surface1 }
--         hl.LineNrBelow = { fg = c.fg_surface1 }
--
--         hl.TelescopeNormal = { bg = c.none }
--         hl.TelescopeBorder = { fg = c.border_highlight, bg = c.none }
--         hl.TelescopePromptBorder = { fg = c.orange, bg = c.none }
--         hl.TelescopePromptTitle = { fg = c.orange, bg = c.none }
--       end
--     })
--
--     vim.cmd [[colorscheme tokyonight]]
--   end
-- }
