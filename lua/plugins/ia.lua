return {
  {
    "olimorris/codecompanion.nvim",
    opts = {
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
        },
        inline = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
        },
        cmd = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
        },
      }
    },
    init = function()
      require("plugins.ai.extensions.companion-notification").init()
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { "markdown", "codecompanion" },
      },
      {
        "echasnovski/mini.diff",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
      {
        "HakonHarnes/img-clip.nvim",
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
        },
      })
    end
  },
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = {
  --     keymaps = {
  --       accept_suggestion = "<M-l>",
  --       clear_suggestion = "<C-]>",
  --       accept_word = "<M-h>",
  --     },
  --   },
  -- },
  -- {
  --   "yetone/avante.nvim",
  --   build        = "make",
  --   lazy         = true,
  --   event        = "VeryLazy",
  --   version      = false, -- Never set this value to "*"! Never!
  --   opts         = {
  --     instructions_file = "avante.md",
  --     provider = "copilot",
  --     providers = {
  --       copilot = {
  --         endpoint = "https://api.anthropic.com",
  --         model = "claude-sonnet-4",
  --       },
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick",         -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua",              -- for file_selector provider fzf
  --     "stevearc/dressing.nvim",        -- for input provider dressing
  --     "folke/snacks.nvim",             -- for input provider snacks
  --     "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua",        -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- }
}
