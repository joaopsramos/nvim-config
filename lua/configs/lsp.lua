-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("nvim-lsp-installer").setup {}

-- lsp-format
require("lsp-format").setup {}

local on_attach = function(client, bufnr)
  require "lsp-format".on_attach(client)

  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fm', '<cmd>lua vim.lsp.buf.format({async = true})<CR>:w<CR>', opts)
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
end

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

require('lspconfig').elixirls.setup {
  -- Unix
  cmd = { vim.fn.expand('~/.local/share/nvim/lsp_servers/elixir/elixir-ls/language_server.sh') },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false
    }
  }
}

require('lspconfig').tailwindcss.setup {
  capabilities = capabilities
}

require('lspconfig').ccls.setup {
  cmd = { 'ccls' },
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').html.setup {
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

require('rust-tools').setup {
  capabilities = capabilities,
  server = {
    cmd = { vim.fn.expand('~/.local/share/nvim/lsp_servers/rust/rust-analyzer') },
    on_attach = on_attach
  }
}

require('lspconfig').tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "typescript-language-server", "--stdio" }
}

require('lspconfig').sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}
