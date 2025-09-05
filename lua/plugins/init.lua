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
  'mbbill/undotree',
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
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
  -- bug when deleting all buffers
  -- { 'nvim-zh/colorful-winsep.nvim', opts = {},     event = { "WinLeave" } },
  { 'norcalli/nvim-colorizer.lua', opts = { '*' } },
  {
    'numToStr/Comment.nvim',
    opts = {},
    keys = {
      { 'gc', mode = { 'n', 'v' } },
      { 'gb', mode = { 'n', 'v' } },
    }
  },
  { 'windwp/nvim-autopairs',       opts = {} },
  {
    'kassio/neoterm',
    init = function()
      vim.g.neoterm_default_mod = 'botright'
      vim.g.neoterm_automap_keys = false
    end
  },
  -- { 'rmagatti/auto-session', lazy = false,                                      opts = {} },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    opts = {
      autoload = true
    }
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
  { 'ustrajunior/ex_maps',           opts = { create_mappings = true, mapping = 'mtt' } },
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  {
    'nvim-neotest/neotest',
    config = function()
      local golang_opts = {}

      require('neotest').setup({
        adapters = {
          require('neotest-elixir'),
          require('neotest-golang')(golang_opts)
        }
      })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'jfpedroza/neotest-elixir',

      -- Go
      'nvim-neotest/nvim-nio',
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "fredrikaverpil/neotest-golang", version = "*" }
    }
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      hint_enable = false,
      handler_opts = {
        border = "rounded"
      }
    }
  },
  --revisit
  { "js-everts/cmp-tailwind-colors", opts = {}, },
  { "phaazon/hop.nvim",              config = true },
  -- Noice do the same thing
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
        -- under_cursor = false,
      })
    end
  },
  { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async', config = true },
  {
    'SmiteshP/nvim-navic',
    dependencies = 'neovim/nvim-lspconfig',
    opts = {
      highlight = true,
      format_text = function(text)
        if #text <= 30 then
          return text
        end

        return string.sub(text, 1, 40) .. ".." .. string.sub(text, #text - 5, #text)
      end
    }
  },
  {
    'tpope/vim-projectionist',
    event = 'VeryLazy',
    config = function()
      vim.g.projectionist_heuristics = {
        ["mix.exs"] = {
          ["lib/*.ex"] = {
            type = "src",
            alternate = "test/{}_test.exs",
          },
          ["test/*_test.exs"] = {
            type = "src",
            alternate = "lib/{}.ex",
          }
        }
      }
    end
  }
}
