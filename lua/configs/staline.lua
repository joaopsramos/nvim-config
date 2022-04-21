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
        bg              = "#282a36",     -- Default background is transparent.
        inactive_color  = "#6272a4",
        inactive_bgcolor = "#282a36",
        true_colors     = true,       -- true lsp colors.
        font_active     = "none",     -- "bold", "italic", "bold,italic", etc
        branch_symbol   = " ",
    },
    mode_colors = {
        n = "#bd93f9",
        i = "#8be9fd",
        v = "#50fa7b",
        c = "#ffb86c",   -- etc..
        t = "#ff5555"
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

