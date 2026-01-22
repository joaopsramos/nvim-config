return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup()

      vim.api.nvim_create_user_command("TSSetup", function()
        vim.notify("Installing treesitter parsers...", vim.log.levels.INFO)

        treesitter.install({
          "bash",
          "regex",
          "yaml",
          "elixir",
          "heex",
          "go",
          "rust",
          "javascript",
          "typescript",
          "python",
          "json",
          "html",
        })
      end, {})
    end,
    -- init = function()
    -- treesitter-modules does this
    -- vim.api.nvim_create_autocmd('FileType', {
    --   pattern = { '<filetype>' },
    --   callback = function() vim.treesitter.start() end,
    -- })
    -- end
  },
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      highlight = {
        enable = true,
        disable = function(params)
          local max_filesize = 200 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(params.buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = false, -- set to `false` to disable one of the mappings
          node_incremental = "<C-space>",
          node_decremental = "<C-S-space>",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
      line_numbers = true,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- (Not sure about it) doc recommends setting this to true, but it breaks jumps between do/end blocks
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "V", -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })
    end,
    keys = function()
      local ts_select = require("nvim-treesitter-textobjects.select")
      local ts_move = require("nvim-treesitter-textobjects.move")
      local ts_swap = require("nvim-treesitter-textobjects.swap")
      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      local select_textobject = function(query)
        ts_select.select_textobject(query, "textobjects")
      end

      -- stylua: ignore
      return {
        { "af",         function() select_textobject("@function.outer") end,           mode = { "x", "o" },      desc = "Select outer function", },
        { "if",         function() select_textobject("@function.inner") end,           mode = { "x", "o" },      desc = "Select inner function", },
        { "ac",         function() select_textobject("@class.outer") end,              mode = { "x", "o" },      desc = "Select outer class", },
        { "ic",         function() select_textobject("@class.inner") end,              mode = { "x", "o" },      desc = "Select inner class", },
        { "ib",         function() select_textobject("@block.inner") end,              mode = { "x", "o" },      desc = "Select inner block", },
        { "ab",         function() select_textobject("@block.outer") end,              mode = { "x", "o" },      desc = "Select outer block", },
        { "]f",         function() ts_move.goto_next_start("@function.outer") end,     mode = { "n", "x", "o" }, desc = "Next function start", },
        { "]F",         function() ts_move.goto_next_end("@function.outer") end,       mode = { "n", "x", "o" }, desc = "Next function end", },
        { "[f",         function() ts_move.goto_previous_start("@function.outer") end, mode = { "n", "x", "o" }, desc = "Previous function start", },
        { "[F",         function() ts_move.goto_previous_end("@function.outer") end,   mode = { "n", "x", "o" }, desc = "Previous function end", },
        { ";",          ts_repeat_move.repeat_last_move,                               mode = { "n", "x", "o" }, desc = "Repeat last move", },
        { ",",          ts_repeat_move.repeat_last_move_opposite,                      mode = { "n", "x", "o" }, desc = "Repeat last move opposite", },
        { "f",          ts_repeat_move.builtin_f_expr,                                 mode = { "n", "x", "o" }, expr = true, },
        { "F",          ts_repeat_move.builtin_F_expr,                                 mode = { "n", "x", "o" }, expr = true, },
        { "t",          ts_repeat_move.builtin_t_expr,                                 mode = { "n", "x", "o" }, expr = true, },
        { "T",          ts_repeat_move.builtin_T_expr,                                 mode = { "n", "x", "o" }, expr = true, },
        { "<leader>sn", function() ts_swap.swap_next("@parameter.inner") end,          mode = { "n" },           desc = "Swap next parameter", },
        { "<leader>sp", function() ts_swap.swap_previous("@parameter.inner") end,      mode = { "n" },           desc = "Swap previous parameter", },
      }
    end,
  },
}
