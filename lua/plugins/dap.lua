return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      -- stylua: ignore start
      { "<F1>",  function() require("dap").continue() end },
      { "<F2>",  function() require("dap").step_into() end },
      { "<F3>",  function() require("dap").step_over() end },
      { "<F4>",  function() require("dap").step_out() end },
      { "<F5>",  function() require("dap").step_back() end },
      { "<F6>",  function() require("dap").toggle_breakpoint() end },
      { "<F7>",  function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end },
      { "<F8>",  function() require("dap").run_to_cursor() end },
      -- F9 ui toggle
      { "<F11>", function() require("dap").restart() end },
      { "<F12>", function() require("dap").disconnect() end },
      -- stylua: ignore end
    },
    config = function()
      local dap = require("dap")

      local ask_entry_file = function(msg)
        return function()
          local path = vim.fn.input({
            prompt = msg .. ": ",
            default = vim.fn.getcwd() .. "/",
            completion = "file",
          })

          return (path and path ~= "") and path or dap.ABORT
        end
      end

      local adapters = {
        mix_task = {
          type = "executable",
          command = vim.fn.exepath("elixir-ls-debugger"),
        },
        dlv = {
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        },
        lldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
            args = { "--port", "${port}" },
            detached = false,
          },
        },
        coreclr = {
          type = "executable",
          command = "netcoredbg",
          args = { "--interpreter=vscode" },
        },
      }

      local configs = {
        elixir = {
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
          {
            type = "mix_task",
            name = "single test",
            task = "test",
            taskArgs = function()
              local line = vim.fn.line(".")
              return { "${file}:" .. line, "--trace" }
            end,
            startApps = true,
            request = "launch",
            projectDir = "${workspaceFolder}",
            requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" },
            exitAfterTaskReturns = false,
            debugAutoInterpretAllModules = false,
          },
        },
        go = {
          {
            type = "dlv",
            name = "Debug package (with path)",
            request = "launch",
            program = ask_entry_file("Path to package dir"),
          },
        },
        rust = {
          {
            type = "lldb",
            name = "Debug an executable",
            request = "launch",
            program = ask_entry_file("Path to executable"),
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
        },
        cs = {
          {
            type = "coreclr",
            name = "Launch",
            request = "launch",
            program = ask_entry_file("Path to dll"),
          },
        },
      }

      for adapter, config in pairs(adapters) do
        dap.adapters[adapter] = config
      end

      for name, config in pairs(configs) do
        dap.configurations[name] = config
      end

      local sign = vim.fn.sign_define

      sign("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign("BreakpointRejected", { text = "", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      sign(
        "DapStopped",
        { text = "󰁕", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
      )
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<F9>",      function() require("dapui").toggle() end },
      { "<leader>?", function() require("dapui").eval(nil, { enter = true }) end, },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close
    end,
  },
}
