return {
  'hrsh7th/nvim-cmp',
  event = 'VeryLazy',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    -- { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    -- 'saadparwaiz1/cmp_luasnip',
    'SirVer/ultisnips',
    {
      'quangnguyen30192/cmp-nvim-ultisnips',
      init = function()
        vim.g.UltiSnipsExpandTrigger = '<CR>'
        vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
        vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
      end
    },
    'honza/vim-snippets',
    'onsails/lspkind.nvim',
    {
      "MattiasMTS/cmp-dbee",
      dependencies = { "kndndrj/nvim-dbee" },
      -- ft = "sql",
      opts = {},
    },
  },
  config = function()
    local cmp = require('cmp')
    -- local luasnip = require('luasnip')
    local lspkind = require('lspkind')

    -- require('luasnip.loaders.from_snipmate').lazy_load()

    cmp.setup({
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 60,
          before = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              look = '[Dict]',
              buffer = '[Buffer]',
              luasnip = '[LuaSnip]',
              path = '[Path]',
            })[entry.source.name]

            return vim_item
          end
        })
      },
      snippet = {
        expand = function(args)
          -- luasnip.lsp_expand(args.body)
          vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'luasnip', option = { use_show_condition = false } },
        { name = 'ultisnips' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      })
    })

    cmp.setup.filetype('sql', {
      sources = {
        { name = 'cmp-dbee' },
        -- { name = "vim-dadbod-completion" },
        { name = "buffer" }
      }
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })
  end
}
