return {
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
    end,
    -- stylua: ignore
    keys = {
      { "<A-w>", function() require("copilot.suggestion").accept_word() end, desc = "Accept Copilot word",         mode = { "i" }, },
      { "<A-n>", function() require("copilot.suggestion").next() end,        desc = "Next Copilot suggestion",     mode = { "i" }, },
      { "<A-p>", function() require("copilot.suggestion").prev() end,        desc = "Previous Copilot suggestion", mode = { "i" }, },
      { "<A-d>", function() require("copilot.suggestion").dismiss() end,     desc = "Dismiss Copilot suggestion",  mode = { "i" }, },
    },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      nes = {
        enabled = true,
      },
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
    },
  },
  {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      selector = {
        provider = "snacks",
      },
      instructions_file = "avante.md",
      provider = "copilot",
      providers = {
        copilot = {
          --   endpoint = "https://api.anthropic.com",
          model = "gpt-4.1",
          --   timeout = 30000, -- Timeout in milliseconds
          --   extra_request_body = {
          --     temperature = 0.75,
          --     max_tokens = 20480,
          --   },
        },
      },
      mode = "legacy",
      auto_suggestions_provider = false,
      behaviour = {
        auto_apply_diff_after_generation = true,
      },
      windows = {
        edit = {
          border = "rounded",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "folke/snacks.nvim", -- for input provider snacks
      -- "nvim-tree/nvim-web-devicons", -- or nvim-mini/mini.icons
      "nvim-mini/mini.icons",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            verbose = false,
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
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
