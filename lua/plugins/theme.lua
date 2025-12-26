return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  init = function()
    vim.cmd.colorscheme("catppuccin")
  end,
  opts = {
    background = {
      light = "latte",
      dark = "macchiato",
    },
    transparent_background = true,
    show_end_of_buffer = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      notify = true,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      dap = true,
      dap_ui = true,
      fidget = true,
      mason = true,
      neotest = true,
      which_key = true,
      noice = true,
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

        -- base = "#282a36",
        -- mantle = "#1E2030",
        -- mantle = "#282a36",
        -- crust = "#181926",
        -- curst = "#282a36",
      },
    },
    custom_highlights = function(c)
      return {
        ["@operator"] = { fg = c.teal },
        ["@punctuation.bracket"] = { fg = c.overlay2 },

        ["@keyword.function.elixir"] = { fg = c.maroon },
        ["@keyword.elixir"] = { fg = c.maroon },
        ["@module.elixir"] = { fg = c.mauve, style = { "italic" } },
        ["@string.special.symbol.elixir"] = { fg = c.sapphire },

        htmlEndTag = { fg = c.flamingo },

        TreesitterContext = { bg = c.surface0 },
        TreesitterContextLineNumber = { fg = c.red },
        LineNr = { fg = c.surface2 },
        CursorLineNr = { fg = c.blue },
        TelescopeMatching = { fg = c.sapphire },
        TelescopeSelection = { fg = c.peach, bg = c.none, style = { "bold" } },
        GitSignsChange = { fg = c.peach },
        DiffChange = { bg = "#223159" },
        -- DiffAdd = { bg = '#283b4d' },
        DiffDelete = { bg = "#3f2d3d" },
        DiffText = { bg = "#394b70" },

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

        AvanteConflictCurrent = { bg = "#283b4d" },
        AvanteConflictIncoming = { bg = "#223159" },
        AvanteConflictAncestor = { bg = "#394b70" },
        AvanteConflictDelete = { bg = "#3f2d3d" },
      }
    end,
  },
}
