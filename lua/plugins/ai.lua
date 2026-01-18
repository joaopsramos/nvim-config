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
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- stylua: ignore start
      vim.keymap.set({ "n", "x" }, "<leader>oo", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>o?", function() require("opencode").select() end, { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "Add line to opencode" })
      vim.keymap.set("n", "<AS-u>", function() require("opencode").command("session.half.page.up") end, { desc = "opencode half page up" })
      vim.keymap.set("n", "<AS-d>", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })
      -- stylua: ignore end
    end,
  },
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      nes = {
        enabled = true,
      },
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        },
      },
    },
    keys = {
      -- {
      --   "<C-.>",
      --   function()
      --     require("sidekick.cli").toggle()
      --   end,
      --   desc = "Sidekick Toggle",
      --   mode = { "n", "t", "i", "x" },
      -- },
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
}
