return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "mtdl9/vim-log-highlighting",
  { "nvim-mini/mini.icons", opts = {} },
  { "windwp/nvim-autopairs", opts = {} },
  { "norcalli/nvim-colorizer.lua", opts = { "*" } },
  { "js-everts/cmp-tailwind-colors", opts = {} },
  { "MagicDuck/grug-far.nvim", opts = {} },
  { "windwp/nvim-ts-autotag", event = "VeryLazy", opts = {} },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
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
    "mbbill/undotree",
    keys = {
      { "<leader>u", ":UndotreeToggle<CR>:UndotreeFocus<CR>", desc = "Undotree toggle and focus", silent = true },
    },
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
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- stylua: ignore
      wk.add({
        { "<leader>a",  group = "Avante" },
        { "<leader>b",  group = "Buffers" },
        { "<leader>d",  group = "Dap" },
        { "<leader>f",  group = "Files" },
        { "<leader>ie", group = "IEx" },
        { "<leader>g",  group = "Git" },
        { "<leader>gb", group = "Git branch" },
        { "<leader>gs", group = "Git stash" },
        { "<leader>h",  group = "Hunks and Harpoon" },
        { "<leader>t",  group = "Tests and Tabs" },
        { "<leader>n",  group = "Neotest and Notifications" },
        { "<leader>tb", group = "Tabs" },
        { "<leader>w",  group = "Windows",                  proxy = "<C-w>", },
        { "Z",          group = "Quit" },
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    opts = {},
    init = function()
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      -- stylua: ignore start
      { "<leader>hl", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon quick menu" },
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
          vim.notify("File added", vim.log.levels.INFO, { title = "Harpoon" })
        end,
        desc = "Harpoon add file"
      },
      { "<SA-h>",     function() require("harpoon"):list():prev({ ui_nav_wrap = true }) end,             desc = "Harpoon previous file" },
      { "<SA-l>",     function() require("harpoon"):list():next({ ui_nav_wrap = true }) end,             desc = "Harpoon next file" },
      -- stylua: ignore end
    },
  },
  {
    "phaazon/hop.nvim",
    opts = {},
    keys = {
      { "<leader>j", ":HopWord<CR>", desc = "Jump", silent = true },
    },
  },
  {
    "simeji/winresizer",
    init = function()
      vim.g.winresizer_start_key = false
    end,
    keys = {
      { "<leader>wr", ":WinResizerStartResize<CR>", desc = "Resize", silent = true },
    },
  },
  {

    "gbprod/yanky.nvim",
    opts = {
      ring = {
        history_length = 10,
        storage = "memory",
      },
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        on_put = false,
        timer = 200,
      },
    },
    -- stylua: ignore
    keys = {
      { "y",          "<Plug>(YankyYank)",          mode = { "n", "x" },                                desc = "Yank text" },
      { "p",          "<Plug>(YankyPutAfter)",      mode = { "n", "x" },                                desc = "Put yanked text after cursor" },
      { "P",          "<Plug>(YankyPutBefore)",     mode = { "n", "x" },                                desc = "Put yanked text before cursor" },
      { "<leader>yh", "<cmd>YankyRingHistory<cr>",  mode = { "n", "x" },                                desc = "Open Yank History" },
      { "<A-p>",      "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
      { "<A-n>",      "<Plug>(YankyNextEntry)",     desc = "Select next entry through yank history" },
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
    init = function()
      -- All this to avoid setting winbar in terminals (empty line)
      vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
        callback = function()
          if vim.bo.buftype == "" then
            vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          end
        end,
      })
    end,
  },
}
