return {
  'kyazdani42/nvim-web-devicons',
  'kyazdani42/nvim-tree.lua',
  'nvim-lua/plenary.nvim',
   {
    'nvim-telescope/telescope.nvim',
    dependencies = {  'nvim-lua/plenary.nvim'  }
  },
  {'nvim-treesitter/nvim-treesitter', build =  ':TSUpdate'},
  'nvim-lualine/lualine.nvim',
 'williamboman/mason.nvim',
 'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  -- 'L3MON4D3/LuaSnip'
  'norcalli/nvim-colorizer.lua',
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'windwp/nvim-autopairs',
  'lukas-reineke/lsp-format.nvim',
  -- 'sheerun/vim-polyglot'
  'kassio/neoterm',
  'lewis6991/gitsigns.nvim',
  'rmagatti/auto-session',
  'vim-test/vim-test',
  'simeji/winresizer',
  'APZelos/blamer.nvim',
  { 'folke/trouble.nvim', name='trouble' ,config = true, dependencies = {
 'kyazdani42/nvim-web-devicons'}
  },

  'SirVer/ultisnips',
  'honza/vim-snippets',
  'editorconfig/editorconfig-vim',
  'lukas-reineke/indent-blankline.nvim',
  'nanozuki/tabby.nvim',
  'folke/which-key.nvim',
  { 'ustrajunior/ex_maps', opts = { create_mappings = true, mapping = 'mtt' } },
  'simrat39/rust-tools.nvim',
  'tpope/vim-fugitive',
  'rcarriga/nvim-notify',
  'AndrewRadev/splitjoin.vim',
  'nvim-treesitter/nvim-treesitter-context',
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  'nvim-treesitter/playground',
  'mg979/vim-visual-multi',

  'antoinemadec/FixCursorHold.nvim',

 -- {
   -- 'nvim-neotest/neotest',
  --  opts = { adapters = { require('neotest-elixir') } } ,
   -- dependencies = {
    --  'nvim-lua/plenary.nvim',
   --   'nvim-treesitter/nvim-treesitter',
  --    'antoinemadec/FixCursorHold.nvim',

 --     'jfpedroza/neotest-elixir',
--    }
  --},

  'RRethy/vim-illuminate',
  'ray-x/lsp_signature.nvim',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'elixir-editors/vim-elixir',
}
