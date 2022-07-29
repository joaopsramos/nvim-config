-- Packer
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'navarasu/onedark.nvim'

  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'tamton-aquib/staline.nvim'

  use 'williamboman/nvim-lsp-installer'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'L3MON4D3/LuaSnip'

  use 'norcalli/nvim-colorizer.lua'

  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'windwp/nvim-autopairs'

  use "lukas-reineke/lsp-format.nvim"

  use 'sheerun/vim-polyglot'

  use 'drewtempelmeyer/palenight.vim'

  use 'kassio/neoterm'

  use 'airblade/vim-gitgutter'

  use 'rmagatti/auto-session'

  use 'vim-test/vim-test'

  use 'simeji/winresizer'

  use 'APZelos/blamer.nvim'

  use 'mattn/emmet-vim'

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
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
  --   "mhanberg/elixir.nvim",
  --   requires = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" }
  -- })

  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require('catppuccin').setup({})
    end
  })

  use({
    'ustrajunior/ex_maps',
    config = function()
    require("ex_maps").setup({
        create_mappings = true,
        mapping = "mtt",
    })
    end
  })

  use 'simrat39/rust-tools.nvim'

  use 'tpope/vim-fugitive'
end)
