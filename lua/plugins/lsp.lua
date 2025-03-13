return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/nvim-cmp',
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  name = 'lspconfig',
  config = function()
    require('mason').setup()
    local util = require('helper.utils')

    local function get_ls_cmd(ls)
      local language_servers_dir = vim.fn.stdpath('data') .. '/mason/bin/'
      return language_servers_dir .. ls
    end

    local nvim_lsp = require('lspconfig')

    local servers = {
      lexical = {
        filetypes = { "elixir", "eelixir", "heex" },
        cmd = { "/home/joao/.local/share/nvim/mason/packages/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
        root_dir = function(fname)
          return nvim_lsp.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
        end,
      },

      -- elixirls = {
      --   cmd = {get_ls_cmd("elixir-ls")},
      --   settings = {
      --     elixirLS = {
      --       dialyzerEnabled = true,
      --       fetchDeps = false
      --     }
      --   }
      -- },

      gopls = {
        settings = {
          gopls = {
            staticcheck = true,
            gofumpt = true
          }
        }
      },

      gleam = true,

      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT', },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/busted/library",
                -- vim.api.nvim_get_runtime_file('', true),
                -- vim.api.nvim_get_runtime_file('/lua/vim/lsp', true),
              },
            },
          }
        }
      },

      efm = { filetypes = { 'elixir' } },

      ts_ls = {},

      emmet_language_server = {},

      tailwindcss = {
        init_options = {
          userLanguages = {
            elixir = "phoenix-heex",
            heex = "phoenix-heex",
            svelte = "html",
          },
        },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              typescript = "javascript",
              typescriptreact = "html",
              ["html-eex"] = "html",
              ["phoenix-heex"] = "html",
              heex = "html",
              eelixir = "html",
              elixir = "html",
              svelte = "html",
              surface = "html",
            },
            experimental = {
              classRegex = {
                [[class= "([^"]*)]],
                [[class: "([^"]*)]],
                '~H""".*class="([^"]*)".*"""',
              },
            },
            validate = true,
          },
        },
      }
    }

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require("lspconfig")

    for name, server_config in pairs(servers) do
      if server_config == true then
        server_config = {}
      end
      server_config = vim.tbl_deep_extend("force", {}, {
        capabilities = capabilities,
      }, server_config)

      lspconfig[name].setup(server_config)
    end

    vim.g.rustaceanvim = {
      -- server = { on_attach = on_attach }
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(_)
        -- Delete defaults
        -- vim.keymap.del('n', 'grn', { buffer = args.buf })
        -- vim.keymap.del('n', 'gra', { buffer = args.buf })
        -- vim.keymap.del('n', 'grr', { buffer = args.buf })
        -- vim.keymap.del('n', 'gri', { buffer = args.buf })
        -- vim.keymap.del('n', 'gO', { buffer = args.buf })
        -- vim.keymap.del('i', '<C-s>', { buffer = args.buf })

        util.keymap('n', 'gd', vim.lsp.buf.definition, { desc = "Definition" })
        util.keymap('n', 'gD', vim.lsp.buf.declaration, { desc = "Declaration" })
        util.keymap('n', 'gy', vim.lsp.buf.type_definition, { desc = "Type definition" })
        util.keymap('n', 'gI', vim.lsp.buf.implementation, { desc = "Implementation" })
        util.keymap('n', 'K', vim.lsp.buf.hover, { desc = "Hover" })
        util.keymap('i', '<C-h>', vim.lsp.buf.signature_help, { desc = "Signature help" })
        util.keymap('n', 'cd', vim.lsp.buf.rename, { desc = "Rename (change definition)" })
        util.keymap('n', 'g.', vim.lsp.buf.code_action, { desc = "Code actions" })
        util.keymap('n', '<leader>gr', '<cmd>Glance references<CR>', { desc = "References" })
        util.keymap('n', 'gh', vim.diagnostic.open_float, { desc = "Open diagnostic" })
        util.keymap('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
        util.keymap('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
        util.keymap('n', '<leader>fm', function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file" })
        -- vim.keymap.set('n', '<leader>fp', ':ElixirFromPipe<CR>', opts)
        -- vim.keymap.set('n', '<leader>tp', ':ElixirToPipe<CR>', opts)
        -- vim.keymap.set('n', '<leader>em', ':ElixirExpandMacro<CR>', opts)
      end
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {})
                  .offset_encoding or "utf-16"
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        vim.lsp.buf.format({ async = false })
      end
    })

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or 'rounded'
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
  end
}
