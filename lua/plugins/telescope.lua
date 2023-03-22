local util = require('helper.functions')

local telescope_keymaps = {
  { keymap = '<leader>fi', cmd = '<cmd>Telescope find_files<CR>' },
  { keymap = '<leader>gr', cmd = '<cmd>Telescope live_grep<CR>' },
  { keymap = '<leader>fb', cmd = '<cmd>Telescope buffers<CR>' },
  { keymap = '<leader>fg', cmd = '<cmd>Telescope git_branches<CR>' },
  { keymap = '<leader>sh', cmd = '<cmd>Telescope help_tags<CR>' },
}

return { {
  'nvim-telescope/telescope.nvim',
  keys = util.map(telescope_keymaps, function(_, spec) return spec.keymap end),
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      name = 'telescope._extensions.fzf',
      build = 'make',
      dependencies = { 'nvim-telescope/telescope.nvim' },
      config = function()
        require('telescope').load_extension('fzf')
      end
    }
  },
  config = function()
    require('telescope').setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case'
        }
      },
      defaults = {
        path_display = {
          truncate = 1
        },
        -- Default configuration for telescope goes here:
        -- config_key = value,
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

    local opts = { noremap = true, silent = true }

    for _, spec in pairs(telescope_keymaps) do
      vim.api.nvim_set_keymap('n', spec.keymap, spec.cmd, opts)
    end
  end
},
}
