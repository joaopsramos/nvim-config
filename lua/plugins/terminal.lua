vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term:/*",
  callback = function()
    vim.opt_local.winbar = nil
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
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
