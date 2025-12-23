return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- local custom_tokyonight = require("lualine.themes.tokyonight")

    -- custom_tokyonight.command.fg = "#F5A97F"

    local function macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == '' then
        return ''
      else
        return 'Recording @' .. recording_register
      end
    end

    require("lualine").setup({
      options = {
        icons_enabled = true,
        -- theme = custom_tokyonight,
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = { "Avante", "AvanteSelectedFiles", "AvanteInput" }
        },
        ignore_focus = {
          'dap-repl',
          'dapui_console',
          'dapui_watches',
          'dapui_stacks',
          'dapui_breakpoints',
          'dapui_scopes',
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
        lualine_x = {
          macro_recording,
          {
            require("noice").api.status.command.get,
            cond = require("noice").api.status.command.has,
            color = { fg = "#ff9e64" },
          },
          {
            require("noice").api.status.search.get,
            cond = require("noice").api.status.search.has,
            color = { fg = "#8BD5CA" },
          },
          'filetype'
        },
        lualine_y = { 'lsp_status', },
        lualine_z = { 'location', 'progress' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {
        lualine_c = {
          {
            "navic",
            color_correction = "dynamic",
            navic_opts = nil
          }
        }
      },
      inactive_winbar = {},
      extensions = { 'nvim-dap-ui' }
    })

    local bg = "#282a36"
    local fg = "#CAD3F5"
    local accent = "#8AADF4"

    local groups = {
      "File", "Module", "Namespace", "Package", "Class", "Method", "Property",
      "Field", "Constructor", "Enum", "Interface", "Function", "Variable",
      "Constant", "String", "Number", "Boolean", "Array", "Object", "Key",
      "Null", "EnumMember", "Struct", "Event", "Operator", "TypeParameter",
      "Text", "Separator"
    }

    for _, grp in ipairs(groups) do
      vim.api.nvim_set_hl(0, "NavicIcons" .. grp, { default = true, bg = bg, fg = accent })
    end

    vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = bg, fg = fg })
  end
}
