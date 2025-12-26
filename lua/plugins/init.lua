return {
  "nvim-lua/plenary.nvim",
  "nvim-mini/mini.icons",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "mtdl9/vim-log-highlighting",
  { "windwp/nvim-autopairs", opts = {} },
  { "norcalli/nvim-colorizer.lua", opts = { "*" } },
  { "js-everts/cmp-tailwind-colors", opts = {} },
  { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async", opts = {} },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    opts = {
      autoload = true,
    },
  },
  {
    "nvim-mini/mini.indentscope",
    opts = {
      symbol = "▏",
      options = { try_as_border = true },
      draw = {
        delay = 0,
        animation = function()
          return 0
        end,
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏", tab_char = "▏" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      highlight = true,
      format_text = function(text)
        if #text <= 40 then
          return text
        end

        local prefix_len = 35
        local max_suffix_len = 5

        local sufix_len = math.min(max_suffix_len, #text - prefix_len)

        -- subtract 2 more to account for the ".."
        return string.sub(text, 1, prefix_len - 2) .. ".." .. string.sub(text, -sufix_len)
      end,
    },
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", ":UndotreeToggle<CR>:UndotreeFocus<CR>", desc = "Undotree toggle and focus", silent = true },
    },
  },
  {
    "editorconfig/editorconfig-vim",
    init = function()
      vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
    end,
  },
  {
    "tpope/vim-projectionist",
    event = "VeryLazy",
    init = function()
      vim.g.projectionist_heuristics = {
        ["mix.exs"] = {
          ["lib/*.ex"] = {
            type = "src",
            alternate = "test/{}_test.exs",
          },
          ["test/*_test.exs"] = {
            type = "test",
            alternate = "lib/{}.ex",
          },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = function(ctx)
        return ctx.plugin and 0 or 400
      end,
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = true })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "ThePrimeagen/harpoon",
    keys = function()
      local harpoon_ui = require("harpoon.ui")
      local harpoon_mark = require("harpoon.mark")

      return {
        { "<leader>hl", harpoon_ui.toggle_quick_menu, desc = "Harpoon quick menu" },
        {
          "<leader>ha",
          function()
            harpoon_mark.add_file()
            vim.notify("File added", vim.log.levels.INFO, { title = "Harpoon" })
          end,
          desc = "Harpoon add file",
        },
        { "<C-S-j>", harpoon_ui.nav_prev, desc = "Harpoon nav prev" },
        { "<C-S-k>", harpoon_ui.nav_next, desc = "Harpoon nav next" },
      }
    end,
  },
  {
    {
      "phaazon/hop.nvim",
      opts = {},
      keys = {
        { "<leader>j", ":HopWord<CR>", desc = "Jump", silent = true },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
  {
    "simeji/winresizer",
    init = function()
      vim.g.winresizer_start_key = false
    end,
    keys = {
      { "<leader>wr", ":WinResizerStartResize<CR>", desc = "Winresizer start resize", silent = true },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {},
  },
}
