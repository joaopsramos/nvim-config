local M = {}

M.map = function(table, mapper)
  local list = {}

  for k, v in pairs(table) do
    list[#list + 1] = mapper(k, v)
  end

  return list
end

return M
