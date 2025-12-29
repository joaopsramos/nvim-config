return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- "nvim-tree/nvim-web-devicons", -- or mini.icons, optional, but recommended
    "nvim-mini/mini.icons",
  },
  lazy = false, -- neo-tree will lazily load itself
  keys = {
    { "<leader>e", ":Neotree toggle reveal<CR>", desc = "Toggle NvimTree", silent = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        pcall(vim.cmd, "Neotree close")
      end,
    })
  end,
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      window = {
        mappings = {
          -- ["/"] = "none",
          -- ["<esc>"] = "none",
        },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(arg)
          vim.opt_local.relativenumber = true
        end,
      },
    },
    -- Use mini.icons
    default_component_configs = {
      icon = {
        provider = function(icon, node, state)
          if node.type == "file" or node.type == "terminal" then
            local ok, mini_icons = pcall(require, "mini.icons")
            if not ok then
              return
            end

            local name = node.type == "terminal" and "terminal" or node.name
            local glyph, hl = mini_icons.get("file", name)

            if glyph then
              icon.text = glyph
              icon.highlight = hl or icon.highlight
            end
          end
        end,
      },
    },
  },
}
