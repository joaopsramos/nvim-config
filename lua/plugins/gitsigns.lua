return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  opts = {
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,  -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    on_attach = function(bufnr)
      local gitsigns = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next', { target = 'all' })
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev', { target = 'all' })
        end
      end)

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "Stage hunk" })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Reset hunk" })

      map('v', '<leader>hs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "Stage hunk" })

      map('v', '<leader>hr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "Reset hunk" })

      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "Stage buffer" })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "Reset buffer (!!!)" })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Preview hunk" })
      map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = "Full line blame" })
      map('n', '<leader>hB', gitsigns.blame, { desc = "Full blame" })
      map('n', '<leader>hd', function()
        local file = vim.fn.expand('%')

        -- Get the last commit that touched this file
        local cmd = string.format("git log -n 1 --pretty=format:%%h -- %s", vim.fn.shellescape(file))
        local last_commit = vim.fn.system(cmd):gsub("\n", "")

        gitsigns.diffthis(last_commit .. "~1")
      end, { desc = "Open diff" })
      map('n', '<leader>hD', gitsigns.toggle_deleted, { desc = "Toggle deleted" })
      map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { desc = "Send changes to quickfix list" })
      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
}
