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
    end
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
  },
}
