require('telescope').setup {
  extensions = {
    fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = 'smart_case' },
  },
  defaults = {
    path_display = { truncate = 1 },
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

require('telescope').load_extension('fzf')
