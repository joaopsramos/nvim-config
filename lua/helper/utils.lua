local M = {}

M.map = function(table, mapper)
  local list = {}

  for k, v in pairs(table) do
    list[#list + 1] = mapper(k, v)
  end

  return list
end


M.keymap = function(mode, keys, cmd, opts)
  opts = opts or {}
  opts.silent = opts.silent == nil and true or opts.silent

  vim.keymap.set(mode, keys, cmd, opts)
end


return M
