-- Packer
vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'nvim-lualine/lualine.nvim'

  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- use 'L3MON4D3/LuaSnip'

  use 'norcalli/nvim-colorizer.lua'

  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'windwp/nvim-autopairs'

  use 'lukas-reineke/lsp-format.nvim'

  -- use 'sheerun/vim-polyglot'

  use 'kassio/neoterm'

  use 'lewis6991/gitsigns.nvim'

  use 'rmagatti/auto-session'

  use 'vim-test/vim-test'

  use 'simeji/winresizer'

  use 'APZelos/blamer.nvim'

  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'

  use 'editorconfig/editorconfig-vim'

  use 'lukas-reineke/indent-blankline.nvim'

  use 'nanozuki/tabby.nvim'

  use 'folke/which-key.nvim'

  -- use({
  --   'mhanberg/elixir.nvim',
  --   requires = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim' }
  -- })

  use({
    'ustrajunior/ex_maps',
    config = function()
      require('ex_maps').setup({
        create_mappings = true,
        mapping = 'mtt',
      })
    end
  })

  use 'simrat39/rust-tools.nvim'

  use 'tpope/vim-fugitive'

  -- use 'folke/tokyonight.nvim'

  use 'rcarriga/nvim-notify'

  use 'AndrewRadev/splitjoin.vim'

  use 'nvim-treesitter/nvim-treesitter-context'

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use { 'catppuccin/nvim', as = 'catppuccin' }

  use 'nvim-treesitter/playground'
  use 'mg979/vim-visual-multi'

  use({
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',

      'jfpedroza/neotest-elixir',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-elixir'),
        }
      })
    end
  })

  use 'RRethy/vim-illuminate'
  use 'ray-x/lsp_signature.nvim'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use 'elixir-editors/vim-elixir'
end)
