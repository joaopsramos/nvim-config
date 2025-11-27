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
    keys = {
      { "<A-w>", function() require("copilot.suggestion").accept_word() end, desc = "Accept Copilot word",         mode = { 'i' } },
      { "<A-n>", function() require("copilot.suggestion").next() end,        desc = "Next Copilot suggestion",     mode = { 'i' } },
      { "<A-p>", function() require("copilot.suggestion").prev() end,        desc = "Previous Copilot suggestion", mode = { 'i' } },
      { "<A-d>", function() require("copilot.suggestion").dismiss() end,     desc = "Dismiss Copilot suggestion",  mode = { 'i' } },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    init = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          -- vim.opt_local.conceallevel = 0
        end,
      })
    end,
    opts = {
      model = 'gpt-4.1',
      -- window = {
      --   layout = 'float',
      --   width = 80,         -- Fixed width in columns
      --   height = 20,        -- Fixed height in rows
      --   border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
      --   title = 'AI Assistant',
      --   zindex = 100,       -- Ensure window stays on top
      -- },
      headers = {
        user = ' 🤡 You ',
        assistant = '🤖 Copilot ',
        tool = '🔧 Tool ',
      },
      separator = '-',
      auto_fold = true, -- Automatically folds non-assistant messages
      mappings = {
        complete = {
          insert = "<Tab>",
        },
        close = {
          normal = "<C-c>",
          insert = "<C-c>",
        },
      },
    },
    keys = {
      { "<leader>aa", ":CopilotChat<CR>",             desc = "Open AI Assistant",                mode = { 'n' } },
      { "<leader>aa", ":CopilotChat<CR>i#selection ", desc = "Open AI Assistant with selection", mode = { 'v' } },
    },
  },
}
