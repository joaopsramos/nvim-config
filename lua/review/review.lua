local config = require("review.config")
local git = require("review.git")
local ui = require("review.ui")

local M = {}

--- Line offset for cursor positioning (accounting for header lines)
local LINE_OFFSET = 3

--- @class ChangeTypes
--- @field added boolean?
--- @field modified boolean?
--- @field deleted boolean?
--- @field renamed boolean?
--- @field untracked boolean?

--- @class FileEntry
--- @field path string
--- @field output string
--- @field x_icon string
--- @field y_icon string
--- @field staged boolean
--- @field unstaged boolean
--- @field change_types ChangeTypes

--- @class ReviewState
--- @field buf number|nil
--- @field win number|nil
--- @field files FileEntry[]
--- @field current_idx number
--- @field last_opened_file_idx number|nil
--- @field diff_keymaps table[] -- Keymaps to be cleared on close
local state = {
  buf = nil,
  win = nil,
  files = {},
  current_idx = 0,
  last_opened_file_idx = nil,
  diff_keymaps = {},
}

-- forward declaration
local setup_diff_keymaps

local function render()
  ui.render(state.buf, state.files, state.current_idx)
end

local function is_win_valid()
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function update_cursor_pos()
  if is_win_valid() then
    local line = math.max(1, state.current_idx + LINE_OFFSET)
    vim.api.nvim_win_set_cursor(state.win, { line, 0 })
  end
end

--- @param callback function|nil
local function refresh(callback)
  git.get_status(function(files, err)
    if err then
      vim.notify("Failed to get git status: " .. err, vim.log.levels.ERROR)
      return
    end

    state.files = files or {}

    if #state.files == 0 then
      state.current_idx = 0
    elseif state.current_idx == 0 and #state.files > 0 then
      state.current_idx = 1
    elseif state.current_idx > #state.files then
      state.current_idx = #state.files
    end

    if callback then
      callback()
    end
  end)
end

--- @param idx number
--- @param callback function|nil
local function refresh_one(idx, callback)
  local file = state.files[idx]

  if not file then
    return
  end

  git.get_file_status(file.path, function(updated_file, err)
    if err or not updated_file then
      -- File may have been removed or changed significantly, do full refresh
      refresh(callback)
      return
    end

    local types = updated_file.change_types

    if types.added or types.deleted or types.renamed or types.untracked then
      refresh(callback)
      return
    end

    state.files[idx] = updated_file
    if callback then
      callback()
    end
  end)
end

local function close_diff_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= state.win and vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if buf ~= state.buf then
        pcall(vim.api.nvim_win_close, win, false)
      end
    end
  end
end

local function open_diff()
  if state.current_idx == 0 or state.current_idx > #state.files then
    return
  end

  local file = state.files[state.current_idx]
  local filepath = vim.fn.getcwd() .. "/" .. file.path

  close_diff_windows()

  vim.api.nvim_set_current_win(state.win)
  vim.cmd("vertical leftabove new")

  vim.cmd("edit " .. vim.fn.fnameescape(filepath))

  vim.cmd("silent! Gvdiffsplit HEAD")
  vim.cmd("wincmd h | wincmd x")

  if is_win_valid() then
    vim.api.nvim_win_set_width(state.win, config.opts.width)
  end

  vim.cmd("wincmd = | wincmd l")

  setup_diff_keymaps(vim.api.nvim_get_current_buf())

  state.last_opened_file_idx = state.current_idx
end

local function next_file()
  if #state.files == 0 then
    return
  end

  state.current_idx = state.current_idx + 1
  if state.current_idx > #state.files then
    state.current_idx = 1
  end

  render()
  update_cursor_pos()
end

local function prev_file()
  if #state.files == 0 then
    return
  end

  state.current_idx = state.current_idx - 1
  if state.current_idx < 1 then
    state.current_idx = #state.files
  end

  render()
  update_cursor_pos()
end

--- @param to_stage boolean
--- @param idx number|nil File index (defaults to current)
local function stage(to_stage, idx)
  idx = idx or state.current_idx
  if idx == 0 or idx > #state.files then
    return
  end

  local file = state.files[idx]

  if to_stage then
    git.stage_file(file.path, function(success, err)
      if not success then
        vim.notify("Failed to stage file: " .. (err or "unknown error"), vim.log.levels.ERROR)
        return
      end
      refresh_one(idx, function()
        render()
        update_cursor_pos()
      end)
    end)

    return
  end

  -- For renamed files, unstage both old and new paths
  if file.change_types.renamed then
    local paths = vim.split(file.output, "->")
    git.unstage_renamed_file(paths[1], paths[2], function(success, err)
      if not success then
        vim.notify("Failed to unstage file: " .. (err or "unknown error"), vim.log.levels.ERROR)
        return
      end
      refresh(function()
        render()
        update_cursor_pos()
      end)
    end)

    return
  end

  git.unstage_file(file.path, function(success, err)
    if not success then
      vim.notify("Failed to unstage file: " .. (err or "unknown error"), vim.log.levels.ERROR)
      return
    end
    refresh_one(idx, function()
      render()
      update_cursor_pos()
    end)
  end)
end

local function stage_from_buffer()
  local file = state.files[state.last_opened_file_idx]

  if not file then
    return
  end

  git.stage_file(file.path, function(success, err)
    if not success then
      vim.notify("Failed to stage file: " .. (err or "unknown error"), vim.log.levels.ERROR)
      return
    end

    refresh_one(state.last_opened_file_idx, function()
      render()
      next_file()
      open_diff()
    end)
  end)
end

local function unstage_from_buffer()
  local file = state.files[state.last_opened_file_idx]

  if not file then
    return
  end

  local changes = file.change_types

  if changes.deleted or changes.added or changes.renamed then
    stage(false, state.last_opened_file_idx)
    return
  end

  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    vim.notify("gitsigns.nvim is required for buffer reset", vim.log.levels.WARN)
    return
  end

  gitsigns.reset_buffer_index(function()
    refresh_one(state.last_opened_file_idx, function()
      render()
    end)
  end)
end

local function toggle_hunk_staging()
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    vim.notify("gitsigns.nvim is required for hunk staging", vim.log.levels.WARN)
    return
  end

  local file = state.files[state.last_opened_file_idx]

  if not file or file.change_types.deleted then
    return
  end

  gitsigns.stage_hunk(nil, nil, function()
    refresh_one(state.last_opened_file_idx, function()
      render()
    end)
  end)
end

-- TODO: Make it work for all types of files, and handle both staged and unstaged
-- do not forget to provide a way to revert the restore
local function restore_file(idx)
  idx = idx or state.current_idx
  local file = state.files[idx]

  if not file or file.staged or not file.change_types.deleted then
    return
  end

  git.restore_file(file.path, function(success, err)
    if not success then
      vim.notify("Failed to restore file: " .. (err or "unknown error"), vim.log.levels.ERROR)
      return
    end

    refresh_one(idx, function()
      vim.notify("File restored: " .. file.path, vim.log.levels.INFO)

      render()
      open_diff()
    end)
  end)
end

local function close()
  if is_win_valid() then
    vim.api.nvim_win_close(state.win, true)
  end

  state.win = nil
end

local function setup_menu_keymaps()
  local opts = { buffer = state.buf, silent = true, nowait = true }

  -- stylua: ignore start
  vim.keymap.set("n", "<CR>", open_diff, opts)
  vim.keymap.set("n", "j", next_file, opts)
  vim.keymap.set("n", "k", prev_file, opts)
  vim.keymap.set("n", "s", function() stage(true) end, opts)
  vim.keymap.set("n", "u", function() stage(false) end, opts)
  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "X", restore_file, opts)
  --stylua: ignore end
end

setup_diff_keymaps = function(buf)
  local opts = { silent = true, buffer = buf }

  vim.keymap.set("n", "]]", function()
    if is_win_valid() then
      next_file()
      open_diff()
    end
  end, opts)

  vim.keymap.set("n", "[[", function()
    if is_win_valid() then
      prev_file()
      open_diff()
    end
  end, opts)

  vim.keymap.set("n", "S", stage_from_buffer, opts)
  vim.keymap.set("n", "s", toggle_hunk_staging, opts)
  vim.keymap.set("n", "R", unstage_from_buffer, opts)
  vim.keymap.set("n", "X", function()
    restore_file(state.last_opened_file_idx)
  end, opts)

  for _, map_id in ipairs({ "]]", "[[", "S", "s", "R", "X" }) do
    table.insert(state.diff_keymaps, { map_id = map_id, buffer = buf })
  end
end

local function setup_autocmds()
  local augroup = vim.api.nvim_create_augroup("ReviewNvim", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = augroup,
    buffer = state.buf,
    callback = function()
      refresh(function()
        render()
      end)
    end,
  })

  vim.api.nvim_create_autocmd("BufHidden", {
    group = augroup,
    buffer = state.buf,
    callback = function()
      for _, km in ipairs(state.diff_keymaps) do
        pcall(vim.keymap.del, "n", km.map_id, { buffer = km.buffer })
      end
      state.diff_keymaps = {}
    end,
  })
end

function M.open()
  if is_win_valid() then
    close()
    return
  end

  refresh(function()
    if #state.files == 0 then
      vim.notify("No changes to review", vim.log.levels.INFO, { title = "Review" })
      return
    end

    local current_file = vim.fn.expand("%:.")

    if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
      state.buf = vim.api.nvim_create_buf(false, true)
      vim.bo[state.buf].buftype = "nofile"
      vim.bo[state.buf].filetype = "review"
      vim.bo[state.buf].modifiable = false

      setup_menu_keymaps()
      setup_autocmds()
    end

    state.win = vim.api.nvim_open_win(state.buf, true, {
      win = -1,
      split = "right",
      width = config.opts.width,
      style = "minimal",
    })

    vim.wo[state.win].winfixwidth = true
    vim.wo[state.win].wrap = false

    for idx, file in ipairs(state.files) do
      if file.path == current_file then
        state.current_idx = idx
        break
      end
    end

    render()
    update_cursor_pos()
    open_diff()
  end)
end

return M
