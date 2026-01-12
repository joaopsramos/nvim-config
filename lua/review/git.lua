local M = {}

local PORCELAIN_STATUS = {
  A = "added",
  M = "modified",
  D = "deleted",
  R = "renamed",
  ["?"] = "untracked",
}

--- @param line string
--- @return FileEntry|nil Parsed
function M.parse_status_line(line)
  if line == "" then
    return nil
  end

  local x, y, output = line:match("^(.)(.)%s*(.+)$")
  if not x or not y or not output then
    return nil
  end

  output = vim.trim(output)
  local path = output

  local file = {
    path = path,
    output = output,
    x_icon = x,
    y_icon = y,
    staged = false,
    unstaged = false,
    change_types = {},
  }

  -- Handle renamed files (format: "old -> new")
  if output:find("->", 1, true) then
    local paths = vim.split(output, "->")
    path = paths[2] or path
    file.path = vim.trim(path)
  end

  if x ~= " " then
    local x_status = PORCELAIN_STATUS[x]
    if x_status then
      file.change_types[x_status] = true
    end
    file.staged = x ~= "?"
  end

  if y ~= " " then
    local y_status = PORCELAIN_STATUS[y]
    if y_status then
      file.change_types[y_status] = true
    end
    file.unstaged = true
  end

  return file
end

--- @param callback function
function M.get_status(callback)
  vim.system({ "git", "status", "--porcelain" }, { text = true }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        callback(nil, obj.stderr or "Failed to get git status")
      end)
      return
    end

    local files = {}
    for _, line in ipairs(vim.split(obj.stdout or "", "\n")) do
      local file = M.parse_status_line(line)
      if file then
        table.insert(files, file)
      end
    end

    -- Sort files by path
    table.sort(files, function(a, b)
      return a.path < b.path
    end)

    vim.schedule(function()
      callback(files, nil)
    end)
  end)
end

--- @param filepath string
--- @param callback function
function M.get_file_status(filepath, callback)
  vim.system({ "git", "status", "--porcelain", "--", filepath }, { text = true }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        callback(nil, obj.stderr or "Failed to get file status")
      end)
      return
    end

    local file = M.parse_status_line(obj.stdout or "")
    vim.schedule(function()
      callback(file, nil)
    end)
  end)
end

--- @param filepath string
--- @param callback function|nil
function M.stage_file(filepath, callback)
  callback = callback or function(_, _) end
  vim.system({ "git", "add", filepath }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        callback(false, obj.stderr or "Failed to stage file")
      else
        callback(true, nil)
      end
    end)
  end)
end

--- @param filepath string
--- @param callback function|nil
function M.unstage_file(filepath, callback)
  callback = callback or function(_, _) end
  vim.system({ "git", "restore", "--staged", filepath }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        callback(false, obj.stderr or "Failed to unstage file")
      else
        callback(true, nil)
      end
    end)
  end)
end

--- @param old_path string
--- @param new_path string
--- @param callback function|nil
function M.unstage_renamed_file(old_path, new_path, callback)
  callback = callback or function(_, _) end
  vim.system({ "git", "restore", "--staged", vim.trim(old_path), vim.trim(new_path) }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        callback(false, obj.stderr or "Failed to unstage renamed file")
      else
        callback(true, nil)
      end
    end)
  end)
end

--- @param filepath string
--- @param callback function|nil
function M.restore_file(filepath, callback)
  callback = callback or function(_, _) end
  vim.system({ "git", "restore", vim.trim(filepath) }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        callback(false, obj.stderr or "Failed to restore file")
      else
        callback(true, nil)
      end
    end)
  end)
end

return M
