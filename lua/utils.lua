local M = {}

M.keymap = function(mode, keys, cmd, opts)
  opts = opts or {}
  opts.silent = opts.silent == nil and true or opts.silent

  vim.keymap.set(mode, keys, cmd, opts)
end

return M
