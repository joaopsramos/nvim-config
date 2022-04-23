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

  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
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

  use {'akinsho/bufferline.nvim', tag = "*"}

  use 'sheerun/vim-polyglot'

  use 'drewtempelmeyer/palenight.vim'

  use 'kassio/neoterm'

  use 'mg979/vim-visual-multi'

  use 'airblade/vim-gitgutter'

  use 'rmagatti/auto-session'

  use 'vim-test/vim-test'
end)
