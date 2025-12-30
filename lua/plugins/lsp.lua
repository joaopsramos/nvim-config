return {
  { "mason-org/mason.nvim", opts = {} },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      hint_enable = false,
      handler_opts = {
        border = "rounded",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local function get_ls_cmd(ls)
        local language_servers_dir = vim.fn.stdpath("data") .. "/mason/bin/"
        return language_servers_dir .. ls
      end

      local servers = {
        jsonls = {},
        gleam = {},
        docker_compose_language_service = { filetypes = { "yaml" } },
        pyright = {},
        efm = {},
        ts_ls = {},
        emmet_language_server = {},
        omnisharp = {},
        expert = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/busted/library",
                },
              },
            },
          },
        },
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
        },
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for name, server_config in pairs(servers) do
        server_config = vim.tbl_deep_extend("force", {}, { capabilities = capabilities }, server_config)

        vim.lsp.config[name] = server_config
        vim.lsp.enable(name)
      end

      vim.g.rustaceanvim = {
        server = {
          -- on_attach = on_attach,
          -- default_settings = {
          --   ["rust-analyzer"] = {
          --     checkOnSave = false
          --   }
          -- }
        },
      }
    end,
    init = function()
      local map = require("utils").keymap

      -- stylua: ignore start
      map("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
      map("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
      map("n", "gy", vim.lsp.buf.type_definition, { desc = "Type definition" })
      map("n", "gI", vim.lsp.buf.implementation, { desc = "Implementation" })
      map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      map("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help" })
      map("n", "cd", vim.lsp.buf.rename, { desc = "Rename (change definition)" })
      map("n", "g.", vim.lsp.buf.code_action, { desc = "Code actions" })
      map("n", "<leader>gr", function() Snacks.picker.lsp_references() end, { desc = "References" })
      map("n", "gh", vim.diagnostic.open_float, { desc = "Open diagnostic" })
      map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Go to prev diagnostic" })
      map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Go to next diagnostic" })
      map("n", "<A-f>", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file" })
      -- stylua: ignore end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf

          if client and client.server_capabilities.documentSymbolProvider then
            local ok, navic = pcall(require, "nvim-navic")
            if ok then
              navic.attach(client, bufnr)
            end
          end
        end,
      })

      -- Configure diagnostics
      local virtual_text_cfg = {
        severity = vim.diagnostic.severity.WARN,
        prefix = "",
      }

      vim.diagnostic.config({
        virtual_text = virtual_text_cfg,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      })

      map("n", "<leader>vt", function()
        local enabled = not vim.diagnostic.config().virtual_text
        vim.notify("Virtual text " .. (enabled and "enabled" or "disabled"))
        vim.diagnostic.config({ virtual_text = enabled and virtual_text_cfg or false })
      end, { desc = "Toggle virtual text" })

      -- Organize imports and format Go files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local params = vim.lsp.util.make_range_params(nil, "utf-8")
          params.context = { only = { "source.organizeImports" } }
          -- buf_request_sync defaults to a 1000ms timeout. Depending on your
          -- machine and codebase, you may want longer.
          -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          -- vim.lsp.buf.format({ async = false })
        end,
      })

      -- Set rounded border for hover and signature help
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end
    end,
  },
}
