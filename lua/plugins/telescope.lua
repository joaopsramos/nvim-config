local util = require('helper.functions')

local telescope_keymaps = {
  { keymap = '<leader>fi', cmd = '<cmd>Telescope find_files<CR>' },
  { keymap = '<leader>gr', cmd = '<cmd>Telescope live_grep_args<CR>' },
  { keymap = '<leader>fb', cmd = '<cmd>Telescope buffers<CR>' },
  { keymap = '<leader>fg', cmd = '<cmd>Telescope git_branches<CR>' },
  { keymap = '<leader>sh', cmd = '<cmd>Telescope help_tags<CR>' },
  { keymap = '<leader>ri', cmd = '<cmd>Telescope resume<CR>' },
}

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-telescope/telescope-live-grep-args.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', }
  },
  keys = util.map(telescope_keymaps, function(_, spec) return spec.keymap end),
  config = function()
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case'
        },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          mappings = {
            -- extend mappings
            i = {
              ["<C-l>"] = lga_actions.quote_prompt(),
              ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-space>"] = lga_actions.to_fuzzy_refine,
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror = true }, -- mirror preview pane
        }
      },
      defaults = {
        mappings = {
          i = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            ['<C-h>'] = 'which_key',
            ['<C-e>'] = 'delete_buffer'
          }
        }
      }
    }

    telescope.load_extension('fzf')
    telescope.load_extension('live_grep_args')

    local opts = { noremap = true, silent = true }

    for _, spec in pairs(telescope_keymaps) do
      vim.api.nvim_set_keymap('n', spec.keymap, spec.cmd, opts)
    end
  end
}
