return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  -- use a release tag to download pre-built binaries
  version = "1.*",
  ---@module 'blink.cmp'
  opts_extend = { "sources.default" },
  opts = {
    keymap = {
      preset = "super-tab",
      keymap = {
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          function() -- sidekick next edit suggestion
            local ok, sidekick = pcall(require, "sidekick")
            if ok then
              sidekick.nes_jump_or_apply()
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
      ["<CR>"] = {
        function(cmp)
          if cmp.is_visible() then
            local item = cmp.get_selected_item()
            local kind = vim.lsp.protocol.CompletionItemKind
            if item and item.kind == kind.Snippet then
              return cmp.accept()
            end
          end
        end,
        "fallback",
      },
    },
    completion = {
      keyword = { range = "full" },
      list = {
        selection = {
          -- Do not preselect inside a snippet
          preselect = function(ctx)
            return not require("blink.cmp").snippet_active({ direction = 1 })
          end,
          auto_insert = false,
        },
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
      keymap = { preset = "inherit", ["<CR>"] = { "fallback" } },
      completion = { menu = { auto_show = true } },
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          async = true,
          fallbacks = {}, -- by default, buffer completions shows when lsp has no results, this config disable that behavior
        },
        path = {
          opts = {
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          min_keyword_length = function()
            return vim.fn.getcmdtype() == "" and 4 or 0
          end,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
