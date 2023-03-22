return {
  {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').get_icons()
    end
  },

  'nvim-lua/plenary.nvim',

  {
    'williamboman/mason.nvim',
    config = true,
    cmd = 'Mason',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    }
  },

  { 'norcalli/nvim-colorizer.lua',   config = true },
  'tpope/vim-surround',
  {
    'numToStr/Comment.nvim',
    config = true,
    keys = {
      { 'gc', mode = { 'n', 'v' } },
      { 'gb', mode = { 'n', 'v' } },
    }
  },
  { 'windwp/nvim-autopairs',         opts = { enable_check_bracket_line = false, map_cr = false } },
  { 'lukas-reineke/lsp-format.nvim', name = 'lsp-format' },
  -- 'sheerun/vim-polyglot'
  'kassio/neoterm',
  'rmagatti/auto-session',
  'vim-test/vim-test',
  { 'simeji/winresizer',        keys = { '<C-e>', mode = 'n' } },
  'APZelos/blamer.nvim',

  {
    'folke/trouble.nvim',
    name = 'trouble',
    config = true,
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },

  'editorconfig/editorconfig-vim',
  'lukas-reineke/indent-blankline.nvim',
  'nanozuki/tabby.nvim',
  { 'ustrajunior/ex_maps',      opts = { create_mappings = true, mapping = 'mtt' } },
  { 'simrat39/rust-tools.nvim', name = 'rust-tools',                               ft = 'rust' },
  'tpope/vim-fugitive',
  'rcarriga/nvim-notify',
  'AndrewRadev/splitjoin.vim',
  'mg979/vim-visual-multi',

  -- {
  --   'nvim-neotest/neotest',
  --   config = function()
  --     require('neotest').setup({ adapters = require('neotest-elixir') })
  --   end,
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'jfpedroza/neotest-elixir',
  --   }
  -- },

  {
    'ray-x/lsp_signature.nvim',
    name = 'lsp_signature',
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    }
  },

  { 'elixir-editors/vim-elixir', ft = { 'elixir', 'eelixir', 'heex' } },

  'mtdl9/vim-log-highlighting',
}
