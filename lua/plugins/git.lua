return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    -- stylua: ignore
    keys = {
      {
        "<C-g>",
        function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == "fugitive" then
              vim.api.nvim_win_close(win, true)
              return
            end
          end

          vim.cmd("Git | wincmd 8- | normal! 5j")
        end,
        desc = "Toggle fugitive",
        silent = true
      },
      { "<leader>gi",   ":Git<space>",                  desc = "Run git command" },

      { "<leader>gl",   ":Git log<CR>",                 desc = "Git log",            silent = true },

      { "<leader>gci",  ':Git commit -m ""<Left>',      desc = "Git commit" },

      { "<leader>gp",   ":Git pull<CR>",                desc = "Git pull",           silent = true },
      { "<leader>gP",   ":Git push -u origin HEAD<CR>", desc = "Git push",           silent = true },

      { "<leader>gsw",  ":Git switch<space>",           desc = "Git switch" },
      { "<leader>gsb",  ":Git switch --create<space>",  desc = "Git switch --create" },
      { "<leader>gsm",  ":Git switch main<CR>",         desc = "Git switch main",    silent = true },
      { "<leader>gsk",  ":Git switch -<CR>",            desc = "Git switch back",    silent = true },

      { "<leader>gsth", ":Git stash<CR>",               desc = "Git stash",          silent = true },
      { "<leader>gsta", ":Git stash apply<CR>",         desc = "Git stash apply",    silent = true },
      { "<leader>gstp", ":Git stash pop<CR>",           desc = "Git stash pop",      silent = true },

      { "<leader>gbd",  ":Git branch -d<space>",        desc = "Git branch -d" },
      { "<leader>gbD",  ":Git branch -D<space>",        desc = "Git branch -D" },

      { "<leader>fh",   ":Git log -p -- <C-r>%<CR>",    desc = "Git file history",   silent = true },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = "👀 <author>, <author_time:%d/%m/%Y %H:%M> • <summary>",
      preview_config = {
        border = "rounded",
      },
      on_attach = function(bufnr)
        local gitsigns = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next", { target = "all" })
          end
        end)

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev", { target = "all" })
          end
        end)

        -- Actions
        -- stylua: ignore start
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage/Unstage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage hunk" })

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset hunk" })

        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hU", gitsigns.reset_buffer_index, { desc = "Unstage buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer (!!!)" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Full line blame" })
        map("n", "<leader>hB", gitsigns.blame, { desc = "Full blame" })
        map("n", "<leader>hD", gitsigns.toggle_deleted, { desc = "Toggle deleted" })
        map("n", "<leader>hQ", function()
          gitsigns.setqflist("all")
        end, { desc = "Send changes to quickfix list" })
        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        -- stylua: ignore end
      end,
    },
  },
}
