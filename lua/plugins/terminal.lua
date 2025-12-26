local map = require("utils").keymap

map("t", "<C-\\>", "<C-\\><C-n>")
map("t", "<Esc>", "<C-\\><C-n>:close<CR>", { desc = "Close terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>_")

local term_group = vim.api.nvim_create_augroup("term_group", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = term_group,
  pattern = "term:/*",
  callback = function()
    vim.api.nvim_command("set relativenumber")
    vim.api.nvim_command("set number")
  end,
})

return {
  "kassio/neoterm",
  init = function()
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        pcall(vim.cmd, "Tclose!")
      end,
    })

    vim.g.neoterm_default_mod = "botright"
    vim.g.neoterm_automap_keys = false
  end,
  keys = {
    { "<C-t>", ":Ttoggle<CR><C-w><C-p>", { desc = "Toggle terminal" }, silent = true },
  },
}
