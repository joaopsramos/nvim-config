-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require('nvim-lsp-installer').setup {}

-- lsp-format
require('lsp-format').setup {}

local on_attach = function(client, _)
  require 'lsp-format'.on_attach(client)

  local function buf_set_keymap(...) vim.keymap.set(...) end

  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gD', vim.lsp.buf.declaration, opts)
  buf_set_keymap('n', 'gd', vim.lsp.buf.definition, opts)
  buf_set_keymap('n', 'K', vim.lsp.buf.hover, opts)
  buf_set_keymap('n', 'gi', vim.lsp.buf.implementation, opts)
  buf_set_keymap('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  buf_set_keymap('i', '<C-k>', vim.lsp.buf.signature_help, opts)
  buf_set_keymap('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  buf_set_keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)
  buf_set_keymap('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  buf_set_keymap('n', 'gr', vim.lsp.buf.references, opts)
  buf_set_keymap('n', '<leader>e', vim.diagnostic.open_float, opts)
  buf_set_keymap('n', '[d', vim.diagnostic.goto_prev, opts)
  buf_set_keymap('n', ']d', vim.diagnostic.goto_next, opts)
  buf_set_keymap('n', '<leader>fm', function() vim.lsp.buf.format({ async = true }) end, opts)
end

require('lspconfig').elixirls.setup {
  -- Unix
  cmd = { vim.fn.expand('~/.local/share/nvim/lsp_servers/elixirls/elixir-ls/language_server.sh') },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
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
  filetypes = { 'html', 'eelixir', 'html-eex', 'heex' },
  init_options = {
    configurationSection = { 'html', 'css', 'javascript' },
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
    cmd = { vim.fn.expand('~/.local/share/nvim/lsp_servers/rust_analyzer/rust-analyzer') },
    on_attach = on_attach
  }
}

require('lspconfig').tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { 'typescript-language-server', '--stdio' }
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

require('lspconfig').gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach
}
