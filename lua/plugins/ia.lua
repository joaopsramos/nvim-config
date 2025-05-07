return {
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "folke/noice.nvim"
  --   },
  --   init = function()
  --     require("plugins.ai.extensions.companion-notification").init()
  --   end,
  --   config = function()
  --     require("codecompanion").setup({
  --       strategies = {
  --         chat = { adapter = "lm_studio" },
  --         inline = { adapter = "lm_studio" },
  --         cmd = { adapter = "lm_studio" },
  --       },
  --       adapters = {
  --         lm_studio = function()
  --           return require("codecompanion.adapters").extend("openai_compatible", {
  --             env = {
  --               url = "http://localhost:1234",
  --             },
  --             name = "lm-studio", -- Give this adapter a different name to differentiate it from the default ollama adapter
  --             schema = {
  --               model = {
  --                 default = "qwen3-8b@q3_k_l",
  --               },
  --             },
  --           })
  --         end,
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   event = "InsertEnter",
  --   cmd = "Copilot",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = {
  --         auto_trigger = true,
  --       },
  --     })
  --   end
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    config = {
      keymaps = {
        accept_suggestion = "<M-l>",
        clear_suggestion = "<C-]>",
        accept_word = "<M-h>",
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = "*", -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "openai",
      openai = {
        endpoint = "http://localhost:1234/v1",
        model = "qwen3-8b@q3_k_l",
      },
      copilot = {
        model = "claude-3.5-sonnet",
      },
      behaviour = {
        auto_apply_diff_after_generation = false,
      }
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
