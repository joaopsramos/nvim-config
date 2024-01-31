return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      background = {         -- :h background
        light = "latte",
        dark = "macchiato",
      },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      transparent_background = true,
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
          Type = { fg = c.mauve },
          Keyword = { fg = c.red },
          ['@keyword.function'] = { fg = c.red },
          -- -- -- ['@parameter'] = { fg = c.peach },
          ['@string.special.symbol'] = { fg = c.sapphire },
          -- ['@operator'] = { fg = c.pink },
          -- ['@function'] = { fg = c.blue },
          -- ['@function.call'] = { fg = c.blue },
          -- ['@tag'] = { fg = c.pink },
          -- ['@tag.attribute'] = { fg = c.yellow },
          ["@module"] = { fg = c.mauve, style = { "italic" } },

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

    require('tabby').setup({
      -- tabline = require('tabby.presets').active_tab_with_wins,
    })
  end
}
