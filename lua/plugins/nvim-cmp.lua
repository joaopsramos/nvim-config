return {
  'hrsh7th/nvim-cmp',
  event = 'VeryLazy',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp',                name = 'cmp_nvim_lsp' },
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'honza/vim-snippets',
    'SirVer/ultisnips',
    { 'quangnguyen30192/cmp-nvim-ultisnips', config = true },
    -- { 'L3MON4D3/LuaSnip',     version = '1.*',      build = 'make install_jsregexp' },
    -- 'saadparwaiz1/cmp_luasnip'
  },
  config = function()
    local cmp = require 'cmp'

    -- require('luasnip.loaders.from_snipmate').lazy_load()

    cmp.setup({
      formatting = {
        format = require("tailwindcss-colorizer-cmp").formatter
      },
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          -- vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
          -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
          vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
        end
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
        ['<Tab>'] = cmp.mapping.confirm({ select = true }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'buffer' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'snippy' }, -- For snippy users.
      })
    })

    -- -- Set configuration for specific filetype.
    -- cmp.setup.filetype('gitcommit', {
    --   sources = cmp.config.sources({
    --     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    --   }, {
    --     { name = 'buffer' },
    --   })
    -- })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' }
      })
    })
  end
}
