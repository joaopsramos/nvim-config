return {
  "akinsho/toggleterm.nvim",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return vim.o.lines * 0.5
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    start_in_insert = false,
    hide_numbers = false,
    highlights = {
      Normal = { link = "Normal" },
    },
    auto_scroll = false,
  },
  init = function()
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype == "terminal" then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end,
    })
  end,
  keys = {
    { "<C-t>", ":ToggleTerm<CR>", desc = "Toggle terminal", silent = true },
  },
}
