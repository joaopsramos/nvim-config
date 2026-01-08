local M = {}

local state = {
  buf = nil,
  win = nil,
  staged_files = {},
  unstaged_files = {},
  current_idx = 0,
  cursor_section = "",
  width = 40,
  wo = nil,
  last_opened_file = {},
}

local porcelain_status = {
  A = "added",
  M = "modified",
  D = "deleted",
  R = "renamed",
  ["?"] = "untracked",
}

local staged_idx_offset = 3
local unstaged_idx_offset = 2

local function parse_git_status_line(line)
  if line == "" then
    return nil
  end

  local file = {}
  local x, y, path = line:match("^(.)(.)%s*(.+)$")

  file.path = path
  file.x_icon = x
  file.y_icon = y

  local x_status = porcelain_status[x]
  local y_status = porcelain_status[y]

  if x == " " then
    file.staged = false
  else
    file[x_status] = true
    file.staged = x == "?" and false or true
  end

  if y == " " then
    file.unstaged = false
  else
    file[y_status] = true
    file.unstaged = true
  end

  return file
end

local function update_idx(direction)
  local new_idx = state.current_idx + direction
  local section = state.cursor_section

  if section == "" then
    if #state.staged_files > 0 then
      section = "staged"
    elseif #state.unstaged_files > 0 then
      section = "unstaged"
    else
      return
    end
  end

  if section == "staged" then
    if new_idx <= 0 then
      if #state.unstaged_files > 0 then
        section = "unstaged"
        new_idx = #state.unstaged_files
      else
        new_idx = #state.staged_files
      end
    elseif new_idx > #state.staged_files then
      if #state.unstaged_files > 0 then
        section = "unstaged"
      end

      new_idx = 1
    end
  end

  if section == "unstaged" then
    if new_idx <= 0 then
      if #state.staged_files > 0 then
        section = "staged"
        new_idx = #state.staged_files
      else
        new_idx = #state.unstaged_files
      end
    elseif new_idx > #state.unstaged_files then
      if #state.staged_files > 0 then
        section = "staged"
      end

      new_idx = 1
    end
  end

  state.current_idx = new_idx
  state.cursor_section = section
end

local function move_cursor()
  local position = 0

  if state.cursor_section == "staged" then
    position = state.current_idx + staged_idx_offset
  elseif state.cursor_section == "unstaged" then
    position = state.current_idx + #state.staged_files + staged_idx_offset

    if #state.staged_files > 0 then
      position = position + unstaged_idx_offset
    end
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_cursor(state.win, { position, 0 })
  end
end

local function update_changed_files()
  local staged_files = {}
  local unstaged_files = {}

  local output = vim.fn.systemlist("git status --porcelain")
  for _, line in ipairs(output) do
    local file = parse_git_status_line(line)

    if file then
      if file.staged then
        table.insert(staged_files, file)
      end

      if file.unstaged then
        table.insert(unstaged_files, file)
      end
    end
  end

  table.sort(staged_files, function(a, b)
    return a.path < b.path
  end)

  table.sort(unstaged_files, function(a, b)
    return a.path < b.path
  end)

  state.staged_files = staged_files
  state.unstaged_files = unstaged_files

  update_idx(0)
end

-- local function refresh()
--   update_changed_files()
--   update_idx(1)

-- if #state.staged_files == 0 and #state.unstaged_files == 0 then
--   state.current_idx = 0
--   return
-- end
--
-- if state.cursor_section == "staged" and state.current_idx > #state.files then
--   state.current_idx = #state.staged_files
--   return
-- end
--
--
-- if state.current_idx == 0 and #state.files > 0 then
--   state.current_idx = 1
-- end
-- end

local function refresh_one(file)
  -- local status = vim.fn.system("git status --porcelain -- " .. file.path)
  -- file = parse_git_status_line(status)
  update_changed_files()
end

local function render()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  vim.bo[state.buf].modifiable = true

  local lines = {}
  local highlights = {}

  table.insert(lines, " Git Review")
  table.insert(lines, string.rep("─", state.width - 2))
  table.insert(highlights, { line = 0, col = 0, end_col = #lines[1], hl = "Title" })

  if #state.staged_files == 0 and #state.unstaged_files == 0 then
    table.insert(lines, " No changes to review")
    table.insert(lines, "")
    table.insert(highlights, { line = 2, col = 0, end_col = #lines[3], hl = "Comment" })
  else
    if #state.staged_files > 0 then
      table.insert(lines, " Staged:")
    end

    for i, file in ipairs(state.staged_files) do
      local line = string.format(" %s %s", file.x_icon, file.path)
      table.insert(lines, line)
    end

    if #state.unstaged_files > 0 then
      if #state.staged_files > 0 then
        table.insert(lines, "")
      end

      table.insert(lines, " Unstaged:")
    end

    for i, file in ipairs(state.unstaged_files) do
      local line = string.format(" %s %s", file.y_icon, file.path)
      table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, string.rep("─", state.width - 2))
  end

  table.insert(lines, " Menu:")
  table.insert(lines, " <CR>  Open diff")
  table.insert(lines, " s     Stage")
  table.insert(lines, " r     Unstage")
  table.insert(lines, " q     Close")
  table.insert(lines, "")

  table.insert(lines, " Buffer:")
  table.insert(lines, " s     Stage/Unstage hunk")
  table.insert(lines, " S     Stage buffer")
  table.insert(lines, " R     Unstage buffer")
  table.insert(lines, " ]]    Next file")
  table.insert(lines, " [[    Previous file")

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)

  -- Apply highlights
  local ns = vim.api.nvim_create_namespace("review.nvim")
  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)

  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_set_extmark(state.buf, ns, hl.line, hl.col, { end_col = hl.end_col, hl_group = hl.hl })
  end

  vim.bo[state.buf].modifiable = false
end

local function close_diff_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if buf ~= state.buf and vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end

local function get_current_file()
  if state.cursor_section == "staged" then
    return state.staged_files[state.current_idx]
  else
    return state.unstaged_files[state.current_idx]
  end
end

local function open_diff()
  local file = get_current_file()
  local filepath = vim.fn.getcwd() .. "/" .. file.path

  close_diff_windows()

  -- Focus sidebar and create new window to the right
  vim.api.nvim_set_current_win(state.win)
  vim.cmd("vertical botright new")

  vim.cmd("edit " .. vim.fn.fnameescape(filepath))

  vim.cmd("silent! Gvdiffsplit HEAD")
  vim.cmd("wincmd x")

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_width(state.win, state.width)
  end

  vim.cmd("wincmd =")
  vim.cmd("wincmd l")

  state.last_opened_file = file
end

local function stage(to_stage)
  local file = get_current_file()
  local filepath = vim.fn.fnameescape(file.path)

  if to_stage then
    vim.fn.system("git add " .. filepath)
  else
    vim.fn.system("git restore --staged " .. filepath)
  end

  refresh_one(file)
  render()
  move_cursor()
end

local function next_file()
  if #state.staged_files == 0 and #state.unstaged_files == 0 then
    return
  end

  update_idx(1)
  render()
  move_cursor()
end

local function prev_file()
  if #state.staged_files == 0 and #state.unstaged_files == 0 then
    return
  end

  update_idx(-1)
  render()
  move_cursor()
end

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.win = nil
  state.buf = nil
end

local function setup_keymaps()
  local opts = { buffer = state.buf, silent = true, nowait = true }

  -- stylua: ignore start
  vim.keymap.set("n", "<CR>", open_diff, opts)
  vim.keymap.set("n", "j", function() next_file() end, opts)
  vim.keymap.set("n", "k", function() prev_file() end, opts)
  vim.keymap.set("n", "s", function() stage(true) end, opts)
  vim.keymap.set("n", "u", function() stage(false) end, opts)
  vim.keymap.set("n", "q", close, opts)
  -- stylua: ignore end

  -- Global keymaps
  vim.keymap.set("n", "]]", function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      next_file()
      open_diff()
    end
  end)

  vim.keymap.set("n", "[[", function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      prev_file()
      open_diff()
    end
  end)

  vim.keymap.set("n", "S", function()
    if not state.last_opened_file.path then
      return
    end

    vim.fn.system("git add " .. state.last_opened_file.path)

    refresh_one(state.last_opened_file)
    next_file()
    open_diff()
  end)

  local gitsigns = require("gitsigns")

  vim.keymap.set("n", "s", function()
    gitsigns.stage_hunk(nil, nil, function()
      refresh_one(state.last_opened_file)
      render()
    end)
  end)

  vim.keymap.set("n", "R", function()
    gitsigns.reset_buffer_index(function()
      refresh_one(state.last_opened_file)
      render()
    end)
  end)
end

local function setup_autocmds()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    buffer = state.buf,
    callback = function()
      update_changed_files()
      render()
      move_cursor()
    end,
  })

  vim.api.nvim_create_autocmd("BufHidden", {
    buffer = state.buf,
    once = true,
    callback = function()
      state.win = nil
      state.buf = nil

      vim.keymap.del("n", "s")
      vim.keymap.del("n", "S")
      vim.keymap.del("n", "R")
      vim.keymap.del("n", "]]")
      vim.keymap.del("n", "[[")
    end,
  })
end

function M.open()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close()
    return
  end

  update_changed_files()

  if #state.staged_files == 0 and #state.unstaged_files == 0 then
    vim.notify("No changes to review", vim.log.levels.INFO, { title = "Review" })
    return
  end

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].filetype = "review"

  state.win = vim.api.nvim_open_win(state.buf, true, {
    win = -1,
    split = "left",
    width = state.width,
    style = "minimal",
  })

  vim.wo[state.win].winfixwidth = true

  setup_keymaps()
  setup_autocmds()
  render()
  move_cursor()
end

return M

-- for i, file in ipairs(state.files) do
--   if file == nil then
--     goto continue
--   end
--
--   local line = string.format(" %s%s %s", file.x_icon, file.y_icon, file.path)
--
--   table.insert(lines, line)
--
--   local line_idx = #lines - 1
--
--   if i == state.current_idx then
--     table.insert(highlights, { line = line_idx, col = 0, end_col = #line, hl = "ReviewLine" })
--   end
--
--   -- if file.staged then
--   --   table.insert(highlights, { line = line_idx, col = 1, end_col = 1, hl = "ReviewStaged" })
--   -- end
--   --
--   -- if file.unstaged then
--   --   local col = file.staged and 2 or 1
--   --   local end_col = file.staged and 3 or 1
--   --   table.insert(highlights, { line = line_idx, col = col, end_col = end_col, hl = "ReviewUnstaged" })
--   -- end
--   --
--   -- if file.untracked then
--   --   table.insert(highlights, { line = line_idx, col = 1, end_col = #icons.untracked, hl = "ReviewUntracked" })
--   -- end
--   --
--   -- if file.deleted then
--   --   table.insert(highlights, { line = line_idx, col = 1, end_col = #icons.deleted, hl = "ReviewDeleted" })
--   -- end
--
--   ::continue::
-- end
