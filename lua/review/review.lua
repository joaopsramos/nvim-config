local config = require("review.config")
local git = require("review.git")
local ui = require("review.ui")

local M = {}

--- Offsets for cursor positioning (accounting for header lines)
local STAGED_IDX_OFFSET = 2
local UNSTAGED_IDX_OFFSET = 3

--- @alias Section "staged" | "unstaged"

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

--- @class State
--- @field buf number|nil
--- @field win number|nil
--- @field staged_files FileEntry[]
--- @field unstaged_files FileEntry[]
--- @field current_idx number
--- @field current_section Section?
--- @field last_opened_file_idx number?
--- @field last_opened_file_section Section?
--- @field diff_keymaps table[] -- Keymaps to be cleared on close
local state = {
  buf = nil,
  win = nil,
  staged_files = {},
  unstaged_files = {},
  current_idx = 0,
  current_section = nil,
  last_opened_file_idx = nil,
  last_opened_file_section = nil,
  diff_keymaps = {},
}

-- forward declaration
local setup_diff_keymaps

local function render()
  ui.render(state.buf, state.unstaged_files, state.staged_files, state.current_idx, state.current_section)
end

local function is_win_valid()
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function update_cursor_pos()
  if not is_win_valid() then
    return
  end

  local position = 0

  if state.current_section == "unstaged" then
    position = state.current_idx + UNSTAGED_IDX_OFFSET
  elseif state.current_section == "staged" then
    position = state.current_idx + #state.unstaged_files + UNSTAGED_IDX_OFFSET

    if #state.unstaged_files > 0 then
      position = position + STAGED_IDX_OFFSET
    end
  end

  vim.api.nvim_win_set_cursor(state.win, { position, 0 })
end

local function update_current_idx(direction)
  direction = direction or 0
  local staged_len = #state.staged_files
  local unstaged_len = #state.unstaged_files

  if not state.current_section then
    if staged_len > 0 then
      state.current_section = "staged"
    elseif unstaged_len > 0 then
      state.current_section = "unstaged"
    else
      return
    end

    state.current_idx = 1
  end

  local section = state.current_section
  local idx = state.current_idx + direction
  local current_len = (section == "staged") and staged_len or unstaged_len
  local other_len = (section == "staged") and unstaged_len or staged_len
  local other_name = (section == "staged") and "unstaged" or "staged"

  -- Wrap/switch sections
  if idx <= 0 then
    if other_len > 0 then
      section = other_name
      idx = other_len
    else
      idx = current_len -- Wrap within same section
    end
  elseif idx > current_len then
    if other_len > 0 then
      section = other_name
      idx = 1
    else
      idx = 1 -- Wrap within same section
    end
  end

  state.current_idx = idx
  state.current_section = section
end

local function get_file(idx, section)
  idx = idx or state.current_idx
  section = section or state.current_section

  if state.current_section == "staged" then
    return state.staged_files[state.current_idx]
  end

  return state.unstaged_files[state.current_idx]
end

--- @param callback function|nil
local function refresh(callback)
  git.get_status(function(files, err)
    if err then
      vim.notify("Failed to get git status: " .. err, vim.log.levels.ERROR)
      return
    end

    state.staged_files = files.staged or {}
    state.unstaged_files = files.unstaged or {}

    update_current_idx()

    if callback then
      callback()
    end
  end)
end

--- @param idx number
--- @param section Section?
--- @param callback function|nil
local function refresh_one(idx, section, callback)
  refresh(callback)
  -- local file = get_file()
  --
  -- if not file then
  --   return
  -- end
  --
  -- git.get_file_status(file.path, function(updated_file, err)
  --   if err or not updated_file then
  --     -- File may have been removed or changed significantly, do full refresh
  --     refresh(callback)
  --     return
  --   end
  --
  --   local types = updated_file.change_types
  --
  --   if types.added or types.deleted or types.renamed or types.untracked then
  --     refresh(callback)
  --     return
  --   end
  --
  --   state.staged_files[idx] = updated_file
  --   if callback then
  --     callback()
  --   end
  -- end)
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
  local file = get_file()

  if not file then
    return
  end

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
  state.last_opened_file_section = state.current_section
end

local function next_file()
  update_current_idx(1)
  render()
  update_cursor_pos()
end

local function prev_file()
  update_current_idx(-1)
  render()
  update_cursor_pos()
end

--- @param to_stage boolean
--- @param idx number | nil File index (defaults to current)
--- @param section Section? File section (defaults to current)
local function stage(to_stage, idx, section)
  idx = idx or state.current_idx
  section = section or state.current_section

  local file = get_file(idx, section)

  if not file then
    return
  end

  if to_stage and file.unstaged then
    git.stage_file(file.path, function(success, err)
      if not success then
        vim.notify("Failed to stage file: " .. (err or "unknown error"), vim.log.levels.ERROR)
        return
      end
      refresh_one(idx, section, function()
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
    refresh_one(idx, section, function()
      render()
      update_cursor_pos()
    end)
  end)
end

local function stage_from_buffer()
  local file = get_file(state.last_opened_file_idx, state.last_opened_file_section)

  if not file or not file.unstaged then
    return
  end

  git.stage_file(file.path, function(success, err)
    if not success then
      vim.notify("Failed to stage file: " .. (err or "unknown error"), vim.log.levels.ERROR)
      return
    end

    refresh_one(state.last_opened_file_idx, state.last_opened_file_section, function()
      render()
      next_file()
      open_diff()
    end)
  end)
end

local function unstage_from_buffer()
  local file = get_file(state.last_opened_file_idx, state.last_opened_file_section)

  if not file or not file.staged then
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
    refresh_one(state.last_opened_file_idx, state.last_opened_file_section, function()
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

  local file = get_file(state.last_opened_file_idx, state.last_opened_file_section)

  if not file or file.change_types.deleted then
    return
  end

  gitsigns.stage_hunk(nil, nil, function()
    refresh_one(state.last_opened_file_idx, state.last_opened_file_section, function()
      render()
    end)
  end)
end

-- TODO: Make it work for all types of files, and handle both staged and unstaged
-- do not forget to provide a way to revert the restore
local function restore_file(idx, section)
  idx = idx or state.current_idx
  section = section or state.current_section

  local file = get_file(idx, section)

  if not file or file.staged or not file.change_types.deleted then
    return
  end

  git.restore_file(file.path, function(success, err)
    if not success then
      vim.notify("Failed to restore file: " .. (err or "unknown error"), vim.log.levels.ERROR)
      return
    end

    refresh_one(idx, section, function()
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
    if #state.staged_files == 0 and #state.unstaged_files == 0 then
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

    -- reset current idx to match current file if possible
    state.current_idx = 0

    for i, file in ipairs(state.staged_files) do
      if file.path == current_file then
        state.current_idx = i
        state.current_section = "staged"
        break
      end
    end

    if state.current_idx == 0 then
      for i, file in ipairs(state.unstaged_files) do
        if file.path == current_file then
          state.current_idx = i
          state.current_section = "unstaged"
          break
        end
      end
    end

    render()
    update_cursor_pos()
    open_diff()
  end)
end

return M
