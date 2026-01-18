return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "igorlfs/nvim-dap-view",
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      -- stylua: ignore start
      { "<F1>", function() require("dap").continue() end,          desc = "Start/Continue debugging" },
      { "<F2>", function() require("dap").step_into() end,         desc = "Step into" },
      { "<F3>", function() require("dap").step_over() end,         desc = "Step over" },
      { "<F4>", function() require("dap").step_out() end,          desc = "Step out" },
      { "<F5>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<F6>",
        function()
          local input = vim.fn.input("Breakpoint condition: ")
          if input == "" then return end
          require("dap").set_breakpoint(input)
        end,
        desc = "Set Conditional Breakpoint"
      },
      {
        "<F7>",
        function()
          local input = vim.fn.input("Log: ")
          if input == "" then return end
          require("dap").set_breakpoint(nil, nil, input)
        end,
        desc = "Set pog point"
      },
      { "<F8>",       function() require("dap").run_to_cursor() end,     desc = "Run to cursor" },
      { "<F11>",      function() require("dap").restart() end,           desc = "Restart debugging" },
      { "<F12>",      function() require("dap").terminate() end,         desc = "Terminate debugging" },
      { "<leader>dc", function() require("dap").clear_breakpoints() end, desc = "Clear all breakpoints" },
      -- stylua: ignore end
    },
    config = function()
      local dap = require("dap")

      local ask_entry_file = function(msg, opts)
        return function()
          local default = opts and opts.default or (vim.fn.getcwd() .. "/")

          local path = vim.fn.input({
            prompt = msg .. ": ",
            default = default,
            completion = "file",
          })

          return (path and path ~= "") and path or dap.ABORT
        end
      end

      local mix_task = function(opts)
        local base = {
          type = "mix_task",
          request = "launch",
          projectDir = "${workspaceFolder}",
          exitAfterTaskReturns = false,
          debugAutoInterpretAllModules = false,
        }

        if opts.task == "test" then
          base.startApps = true
          base.requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" }
        end

        return vim.tbl_extend("force", base, opts)
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
          mix_task({
            name = "Phoenix server",
            task = "phx.server",
          }),
          mix_task({
            name = "Test",
            task = "test",
            taskArgs = { "--trace" },
          }),
          mix_task({
            name = "Test file",
            task = "test",
            taskArgs = { "${file}", "--trace" },
          }),
          mix_task({
            name = "Test current",
            task = "test",
            taskArgs = function()
              local line = vim.fn.line(".")
              return { "${file}:" .. line, "--trace" }
            end,
          }),
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
            program = ask_entry_file("Path to dll", { default = vim.fn.getcwd() .. "/bin/Debug/" }),
          },
          {
            type = "coreclr",
            name = "Test",
            request = "attach",
            processId = function()
              return require("dap.utils").pick_process({ filter = "dotnet" })
            end,
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

      -- stylua: ignore start
      sign("DapBreakpoint", { text = "", texthl = "DapBreakpointFg", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointConditionFg", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPointFg", linehl = "", numhl = "" })
      sign("DapBreakpointRejected", { text = "󰂭", texthl = "DapBreakpointRejectedFg", linehl = "", numhl = "" })
      sign("DapStopped", { text = "󰁕", texthl = "DapStoppedFg", linehl = "DapStoppedLine", numhl = "DapStoppedLine" })
      -- stylua: ignore end
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    opts = {
      winbar = {
        controls = {
          enabled = true,
          buttons = {
            "play",
            "step_into",
            "step_over",
            "step_out",
            "step_back",
            "run_last",
            "terminate",
          },
        },
      },
      windows = {
        size = 0.35,
      },
      help = {
        border = "rounded",
      },
    },
    -- stylua: ignore
    keys = {
      { "<F9>",       ":DapViewToggle<CR><C-w>j", desc = "Toggle DAP view",            silent = true },
      { "<leader>dw", ":DapViewWatch<CR>",        desc = "Watch variable in DAP view", silent = true },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dap_view = require("dap-view")

      dap_view.setup(opts)

      dap.listeners.before.attach.dapui_config = dap_view.open
      dap.listeners.before.launch.dapui_config = dap_view.open
      dap.listeners.before.event_terminated.dapui_config = dap_view.close
      dap.listeners.before.event_exited.dapui_config = dap_view.close
    end,
  },
}
