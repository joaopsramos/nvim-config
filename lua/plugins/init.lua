return {
  {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').get_icons()
    end
  },

  'nvim-lua/plenary.nvim',

  {
    { 'williamboman/mason.nvim',           config = true },
    { 'williamboman/mason-lspconfig.nvim', config = true },
  },

  -- 'L3MON4D3/LuaSnip'
  { 'norcalli/nvim-colorizer.lua',   config = true },
  'tpope/vim-surround',
  'tpope/vim-commentary',
  { 'windwp/nvim-autopairs',         opts = { enable_check_bracket_line = false, map_cr = false } },
  { 'lukas-reineke/lsp-format.nvim', name = 'lsp-format' },
  -- 'sheerun/vim-polyglot'
  'kassio/neoterm',
  'rmagatti/auto-session',
  'vim-test/vim-test',
  'simeji/winresizer',
  'APZelos/blamer.nvim',

  {
    'folke/trouble.nvim',
    name = 'trouble',
    config = true,
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },

  'SirVer/ultisnips',
  'honza/vim-snippets',
  'editorconfig/editorconfig-vim',
  'lukas-reineke/indent-blankline.nvim',
  'nanozuki/tabby.nvim',
  { 'ustrajunior/ex_maps',      opts = { create_mappings = true, mapping = 'mtt' } },
  { 'simrat39/rust-tools.nvim', name = 'rust-tools' },
  'tpope/vim-fugitive',
  'rcarriga/nvim-notify',
  'AndrewRadev/splitjoin.vim',
  'nvim-treesitter/playground',
  'mg979/vim-visual-multi',

  {
    'nvim-neotest/neotest',
    config = function()
      require('neotest').setup({ adapters = require('neotest-elixir') })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',

      'jfpedroza/neotest-elixir',
    }
  },

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

  'nvim-treesitter/nvim-treesitter-textobjects',
  'elixir-editors/vim-elixir',
  'mtdl9/vim-log-highlighting',
}
