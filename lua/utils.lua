local M = {}

M.keymap = function(mode, keys, cmd, opts)
  opts = opts or {}
  opts.silent = opts.silent == nil and true or opts.silent

  vim.keymap.set(mode, keys, cmd, opts)
end

M.navigate_history = function(direction)
  -- Invert direction to match git log order
  direction = -direction
  local file = vim.fn.FugitiveReal(vim.fn.expand("%"))

  -- Get the last commit that touched this file
  local cmd = string.format("git log --pretty=format:%%H -- %s", vim.fn.shellescape(file))
  local commits = vim.fn.systemlist(cmd)
  local current_idx = vim.b.history_idx or 1
  local target_idx = current_idx + direction

  if target_idx < 1 then
    vim.notify("Already at the latest version", vim.log.levels.INFO)
    return
  elseif target_idx > #commits then
    vim.notify("Already at the oldest version", vim.log.levels.INFO)
    return
  end

  local target_hash = commits[target_idx]
  vim.cmd("Gedit " .. target_hash .. ":" .. file)

  local msg = string.format("Commit: %s (%d/%d)", target_hash:sub(1, 8), target_idx, #commits)
  vim.notify(msg, vim.log.levels.INFO)

  vim.b.history_idx = target_idx
end

return M
