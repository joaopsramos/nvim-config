return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",

    "Kaiser-Yang/blink-cmp-avante",
  },
  -- use a release tag to download pre-built binaries
  version = "1.*",
  ---@module 'blink.cmp'
  opts = {
    keymap = { preset = "super-tab" },
    completion = {
      keyword = { range = "full" },
      list = {
        selection = { preselect = true, auto_insert = false },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        -- window = { border = "rounded" },
      },
      menu = {
        -- border = "rounded",
        draw = {
          columns = {
            { "kind_icon", "label", "label_description", gap = 1 },
            { "kind" },
          },
        },
      },
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true } },
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "avante" },
      -- By default, buffer completions shows when lsp has no results, this config disable that behavior
      providers = {
        lsp = { fallbacks = {} },
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
