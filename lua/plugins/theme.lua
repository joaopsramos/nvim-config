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
      transparent_background = true,
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
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        fidget = true,
        dap = true,
        dap_ui = true,
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
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
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
          Identifier = { fg = c.peach },
          Type = { fg = c.mauve },
          Keyword = { fg = c.red },
          ['@keyword.function'] = { fg = c.red },
          ['@string.special.symbol'] = { fg = c.sapphire },
          ["@module"] = { fg = c.mauve, style = { "italic" } },

          htmlEndTag = { fg = c.flamingo },

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

          TabLineSel = { fg = c.green, bg = c.mantle },
          EndOfBuffer = { fg = c.surface1 },
        }
      end
    })

    vim.cmd.colorscheme "catppuccin"
  end
}
