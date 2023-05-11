return {
  'neovim/nvim-lspconfig',
  name = 'lspconfig',
  config = function()
    require('lsp-format').setup {}

    local function get_ls_cmd(ls)
      local language_servers_dir = vim.fn.stdpath('data') .. '/mason/bin/'
      return language_servers_dir .. ls
    end

    local on_attach = function(client, _)
      require('lsp-format').on_attach(client)

      local function buf_set_keymap(...)
        vim.keymap.set(...)
      end

      local opts = {
        noremap = true,
        silent = true
      }

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
      buf_set_keymap('n', '<leader>fm', function()
        vim.lsp.buf.format({
          async = true
        })
      end, opts)
      buf_set_keymap('n', '<leader>fp', ':ElixirFromPipe<CR>', opts)
      buf_set_keymap('n', '<leader>tp', ':ElixirToPipe<CR>', opts)
      -- buf_set_keymap('n', '<leader>em', ':ElixirExpandMacro<CR>', opts)
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local function config(ls, rest_opts)
      local cmd
      local default_opts = {}
      rest_opts = rest_opts or default_opts

      if type(ls) ~= "table" then
        cmd = { get_ls_cmd(ls) }
      else
        cmd = ls
      end

      rest_opts.capabilities = capabilities
      rest_opts.on_attach = on_attach
      rest_opts.cmd = cmd

      return rest_opts
    end

    local nvim_lsp = require('lspconfig')

    -- nvim_lsp.elixirls.setup(config('elixir-ls', {
    --   settings = {
    --     elixirLS = {
    --       dialyzerEnabled = true,
    --       fetchDeps = false
    --     }
    --   }
    -- }))

    -- nvim_lsp.tailwindcss.setup({
    --   cmd = { get_ls_cmd("tailwindcss-language-server"), "--stdio" },
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })

    -- nvim_lsp.tailwindcss.setup({
    -- })
    -- nvim_lsp.ccls.setup(config('ccls'))

    nvim_lsp.html.setup(config('vscode-html-language-server', {
      filetypes = { 'html', 'eelixir', 'html-eex', 'heex' },
      init_options = {
        configurationSection = { 'html', 'css', 'javascript' },
        embeddedLanguages = {
          css = true,
          javascript = true
        },
        provideFormatter = true
      }
    }))

    require('rust-tools').setup {
      capabilities = capabilities,
      server = {
        cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/rust-analyzer') },
        on_attach = on_attach
      }
    }

    nvim_lsp.tsserver.setup(config({ get_ls_cmd('typescript-language-server'), '--stdio' }))

    nvim_lsp.lua_ls.setup(config('lua-language-server', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT', },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = {
              vim.api.nvim_get_runtime_file('', true),
              vim.api.nvim_get_runtime_file('/lua/vim/lsp', true),
            },
          },
        }
      }
    }))

    require('elixir').setup({
      credo = { enable = false },
      elixirls = {
        settings = require('elixir.elixirls').settings {
          dialyzerEnabled = true,
          fetchDeps = false,
          enableTestLenses = false,
          suggestSpecs = false,
        },
        on_attach = on_attach,
        capabilities = capabilities
      }
    })

    nvim_lsp.efm.setup({ filetypes = { 'elixir' }, cmd = { get_ls_cmd('efm-langserver') } })

    -- nvim_lsp.gopls.setup(config('gopls'))

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or 'rounded'
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
  end
}
