require'nvim-web-devicons'.get_icons()

-- Status bar
require('staline').setup {
    defaults = {
        cool_symbol = "  ",
        left_separator = "",
        right_separator = "",
        full_path       = false,
        mod_symbol      = "  ",
        lsp_client_symbol = " ",
        line_column     = "%p%% [%l/%L]", -- `:h stl` to see all flags.

        fg              = "#44475a",  -- Foreground text color.
        bg              = "#44475a",     -- Default background is transparent.
        inactive_color  = "#303030",
        inactive_bgcolor = "none",
        true_colors     = true,       -- true lsp colors.
        font_active     = "none",     -- "bold", "italic", "bold,italic", etc
        branch_symbol   = " ",
    },
    mode_colors = {
        n = "#bd93f9",
        i = "#8be9fd",
        v = "#50fa7b",
        c = "#ff5555",   -- etc..
    },
    mode_icons = {
        n = " ",
        i = " ",
        c = " ",
        v = " ",   -- etc..
    },
    sections = {
        left = { '- ', '-mode', 'left_sep', 'branch' },
        mid  = { 'file_name', 'lsp' },
        right = { 'cool_symbol','right_sep', '-line_column' },
    },
    special_table = {
        NvimTree = { 'NvimTree', ' ' },
        packer = { 'Packer',' ' },        -- etc
    },
    lsp_symbols = {
        Error=" ",
        Info=" ",
        Warn=" ",
        Hint="",
     },
}

-- Colorizer
require'colorizer'.setup()

-- Autopairs
require('nvim-autopairs').setup({
  enable_check_bracket_line = false
})
