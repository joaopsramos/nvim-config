return {
  'kyazdani42/nvim-web-devicons',
  'nvim-lua/plenary.nvim',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-fugitive',
  'AndrewRadev/splitjoin.vim',
  'mg979/vim-visual-multi',
  'mtdl9/vim-log-highlighting',
  --revisit
  'nvim-telescope/telescope-live-grep-args.nvim',
  --revisit
  'ThePrimeagen/harpoon',
  { 'nvim-zh/colorful-winsep.nvim', opts = {},     event = { "WinLeave" } },
  { 'norcalli/nvim-colorizer.lua',  opts = { '*' } },
  {
    'numToStr/Comment.nvim',
    opts = {},
    keys = {
      { 'gc', mode = { 'n', 'v' } },
      { 'gb', mode = { 'n', 'v' } },
    }
  },
  { 'windwp/nvim-autopairs',         opts = {} },
  -- revisit
  { 'lukas-reineke/lsp-format.nvim', name = 'lsp-format' },
  {
    'kassio/neoterm',
    init = function()
      vim.g.neoterm_default_mod = 'botright'
      vim.g.neoterm_automap_keys = false
    end
  },
  { 'rmagatti/auto-session', lazy = false,                  opts = {} },
  {
    'vim-test/vim-test',
    init = function()
      vim.g['test#strategy'] = 'neoterm'
    end
  },
  { 'simeji/winresizer',     keys = { '<C-e>', mode = 'n' } },
  {
    'APZelos/blamer.nvim',
    init = function()
      vim.g.blamer_enabled = true
      vim.g.blamer_prefix = '👀 '
      vim.g.blamer_show_in_visual_modes = 0
      vim.g.blamer_show_in_insert_modes = 0
    end
  },
  -- revisit
  {
    'folke/trouble.nvim',
    name = 'trouble',
    opts = {},
    dependencies = 'kyazdani42/nvim-web-devicons'
  },
  {
    'editorconfig/editorconfig-vim',
    init = function()
      vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }
    end
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = { scope = { enabled = false } }
  },
  { 'nanozuki/tabby.nvim', dependencies = 'nvim-tree/nvim-web-devicons',      opts = {} },
  { 'ustrajunior/ex_maps', opts = { create_mappings = true, mapping = 'mtt' } },
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  -- revisit
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
  -- revisit
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
  --revisit
  { "js-everts/cmp-tailwind-colors", opts = {}, },
  { "phaazon/hop.nvim", config = true },
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
          x_padding = 1, -- Padding from right edge of window boundary
          y_padding = 1,
        }
      }
    },
  }
}
