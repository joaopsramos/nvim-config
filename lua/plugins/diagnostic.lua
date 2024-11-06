vim.diagnostic.config({ virtual_text = false, virtual_lines = true, })

vim.keymap.set("", "<leader>vl", function()
  local config = vim.diagnostic.config() or {}
  if config.virtual_text then
    vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
  else
    vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
  end
end, { desc = "Toggle lsp_lines" })

return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  opts = {}
}
