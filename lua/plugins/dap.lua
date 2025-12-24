return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
  },
  config = function()
    local dap = require "dap"
    local ui = require "dapui"

    require("dapui").setup()
    require("dap-go").setup()

    require("nvim-dap-virtual-text").setup()

    -- Handled by nvim-dap-go
    -- dap.adapters.go = {
    --   type = "server",
    --   port = "${port}",
    --   executable = {
    --     command = "dlv",
    --     args = { "dap", "-l", "127.0.0.1:${port}" },
    --   },
    -- }

    dap.adapters.lldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
        detached = false,
      }
    }

    dap.adapters.coreclr = {
      type = 'executable',
      command = "netcoredbg",
      args = { '--interpreter=vscode' }
    }

    local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
    if elixir_ls_debugger ~= "" then
      dap.adapters.mix_task = {
        type = "executable",
        command = elixir_ls_debugger,
      }

      dap.configurations.elixir = {
        {
          type = "mix_task",
          name = "phoenix server",
          task = "phx.server",
          request = "launch",
          projectDir = "${workspaceFolder}",
          exitAfterTaskReturns = false,
          debugAutoInterpretAllModules = false,
        },
        {
          type = "mix_task",
          name = "test",
          task = "test",
          taskArgs = { "--trace" },
          startApps = true,
          request = "launch",
          projectDir = "${workspaceFolder}",
          requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" },
          exitAfterTaskReturns = false,
          debugAutoInterpretAllModules = false,
        },
      }
    end


    dap.configurations.rust = {
      {
        name = "Debug an executable",
        type = "lldb",
        request = "launch",
        program = function()
          local path = vim.fn.input({
            prompt = 'Path to executable: ',
            default = vim.fn.getcwd() .. '/',
            completion = 'file'
          })
          return (path and path ~= "") and path or dap.ABORT
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }


    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch",
        request = "launch",
        program = function()
          local path = vim.fn.input({
            prompt = 'Path to debug dll: ',
            default = vim.fn.getcwd() .. '/',
            completion = 'file'
          })

          return (path and path ~= "") and path or dap.ABORT
        end,
      },
    }

    vim.keymap.set("n", "<F6>", dap.toggle_breakpoint)
    vim.keymap.set("n", "<F7>", dap.run_to_cursor)

    -- Eval var under cursor
    vim.keymap.set("n", "<space>?", function()
      require("dapui").eval(nil, { enter = true })
    end)

    vim.keymap.set("n", "<F1>", dap.continue)
    vim.keymap.set("n", "<F2>", dap.step_over)
    vim.keymap.set("n", "<F3>", dap.step_into)
    vim.keymap.set("n", "<F4>", dap.step_out)
    vim.keymap.set("n", "<F5>", dap.step_back)
    vim.keymap.set("n", "<F11>", dap.restart)
    vim.keymap.set("n", "<F12>", dap.disconnect)

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end

    local sign = vim.fn.sign_define

    sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  end,
}
