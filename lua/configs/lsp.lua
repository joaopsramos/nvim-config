-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--  capabilities = capabilities
-- }

-- lsp-format
require("lsp-format").setup {}

local on_attach = function(client, bufnr)
  require "lsp-format".on_attach(client)

  local opts = { noremap=true, silent=true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>:w<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)    

  vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<CR>", map_opts)
  vim.keymap.set("n", "<space>tp", ":ElixirToPipe<CR>", map_opts)
  vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<CR>", map_opts)
end

elixirls_path = vim.fn.expand('~/.local/share/nvim/lsp_servers/elixir/elixir-ls/language_server.sh')

-- require'elixir'.setup({
--   cmd = { elixirls_path },
--   -- default settings, use the `settings` function to override settings
--   settings = require'elixir'.settings({
--     dialyzerEnabled = false,
--     fetchDeps = true,
--     -- enableTestLenses = true,
--     suggestSpecs = true,
--   }),

--   on_attach = on_attach
-- })

require'lspconfig'.elixirls.setup{
  -- Unix
  cmd = { elixirls_path },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false
    }
  }
}

require'lspconfig'.tailwindcss.setup{
  capabilities = capabilities
}

capabilities.textDocument.completion.completionItem.snippetSupport = true
require'lspconfig'.html.setup{
  capabilities = capabilities,
  filetypes = { "html", "eelixir", "html-eex", "heex" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    },
    provideFormatter = true
  }
}

rust_path = vim.fn.expand('~/.local/share/nvim/lsp_servers/rust/rust-analyzer')

require'lspconfig'.rust_analyzer.setup{
  cmd = { rust_path },
  on_attach = on_attach
}
