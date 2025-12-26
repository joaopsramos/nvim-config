return {
  {
    "tpope/vim-fugitive",
    -- stylua: ignore
    keys = {
      { "<leader>gi",   ":Git<CR><C-w>5-5j",            desc = "Open git",           silent = true },
      { "<leader>gI",   ":Git<space>",                  desc = "Run git command" },

      { "<leader>gl",   ":Git log<CR>",                 desc = "Git log",            silent = true },

      { "<leader>gci",  ':Git commit -m ""<Left>',      desc = "Git commit" },

      { "<leader>gP",   ":Git push -u origin HEAD<CR>", desc = "Git push",           silent = true },
      { "<leader>gp",   ":Git pull<CR>",                desc = "Git pull",           silent = true },

      { "<leader>gsw",  ":Git switch<space>",           desc = "Git switch" },
      { "<leader>gsb",  ":Git switch --create<space>",  desc = "Git switch --create" },
      { "<leader>gsm",  ":Git switch main<CR>",         desc = "Git switch main",    silent = true },
      { "<leader>gsn",  ":Git switch next<CR>",         desc = "Git switch next",    silent = true },
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
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
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
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage hunk" })

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset hunk" })

        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer (!!!)" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        -- stylua: ignore
        map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Full line blame" })
        map("n", "<leader>hB", gitsigns.blame, { desc = "Full blame" })
        map("n", "<leader>hd", function()
          local file = vim.fn.expand("%")

          -- Get the last commit that touched this file
          local cmd = string.format("git log -n 1 --pretty=format:%%h -- %s", vim.fn.shellescape(file))
          local last_commit = vim.fn.system(cmd):gsub("\n", "")

          gitsigns.diffthis(last_commit .. "~1")
        end, { desc = "Open diff" })
        map("n", "<leader>hD", gitsigns.toggle_deleted, { desc = "Toggle deleted" })
        map("n", "<leader>hQ", function()
          gitsigns.setqflist("all")
        end, { desc = "Send changes to quickfix list" })
        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },
  {
    "APZelos/blamer.nvim",
    init = function()
      vim.g.blamer_enabled = true
      vim.g.blamer_prefix = "👀 "
      vim.g.blamer_show_in_visual_modes = 0
      vim.g.blamer_show_in_insert_modes = 0
      vim.cmd([[highlight Blamer guifg=#494D64]])
    end,
  },
}
