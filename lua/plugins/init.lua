return {
  'kyazdani42/nvim-web-devicons',
  'nvim-lua/plenary.nvim',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-fugitive',
  'mg979/vim-visual-multi',
  'mtdl9/vim-log-highlighting',
  --revisit
  'nvim-telescope/telescope-live-grep-args.nvim',
  --revisit
  'ThePrimeagen/harpoon',
  'mechatroner/rainbow_csv',
  {

    'AndrewRadev/splitjoin.vim',
    init = function()
      vim.g.splitjoin_split_mapping = ''
      vim.g.splitjoin_join_mapping = ''
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
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
  { 'windwp/nvim-autopairs', opts = {} },
  {
    'kassio/neoterm',
    init = function()
      vim.g.neoterm_default_mod = 'botright'
      vim.g.neoterm_automap_keys = false
    end
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    init = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {}
  },
  {
    'vim-test/vim-test',
    init = function()
      vim.g['test#strategy'] = 'neoterm'
    end
  },
  {
    'simeji/winresizer',
    init = function()
      vim.g.winresizer_start_key = false
    end
  },
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
  -- {
  --   'folke/trouble.nvim',
  --   name = 'trouble',
  --   opts = {},
  --   dependencies = 'kyazdani42/nvim-web-devicons'
  -- },
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
  { 'ustrajunior/ex_maps',   opts = { create_mappings = true, mapping = 'mtt' } },
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  {
    'nvim-neotest/neotest',
    config = function()
      require('neotest').setup({
        adapters = { require('neotest-elixir') }
      })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'jfpedroza/neotest-elixir',
    }
  },
  {
    'ray-x/lsp_signature.nvim',
    name = 'lsp_signature',
    event = 'VeryLazy',
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    },
    config = function(_, opts) require('lsp_signature').setup(opts) end
  },
  --revisit
  { "js-everts/cmp-tailwind-colors", opts = {}, },
  { "phaazon/hop.nvim",              config = true },
  -- {
  --   "j-hui/fidget.nvim",
  --   opts = {
  --     notification = {
  --       window = {
  --         winblend = 0,
  --         x_padding = 1, -- Padding from right edge of window boundary
  --         y_padding = 1,
  --       }
  --     }
  --   },
  -- },
  {
    'RRethy/vim-illuminate',
    event = 'VeryLazy',
    name = 'illuminate',
    config = function()
      require('illuminate').configure({
        -- under_cursor: whether or not to illuminate under the cursor
        under_cursor = false,
      })
    end
  },
}
