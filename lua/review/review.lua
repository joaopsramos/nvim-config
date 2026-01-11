local M = {}

local state = {
  buf = nil,
  win = nil,
  files = {},
  current_idx = 0,
  width = 40,
  wo = nil,
  last_opened_file_idx = nil,
}

local porcelain_status = {
  A = "added",
  M = "modified",
  D = "deleted",
  R = "renamed",
  ["?"] = "untracked",
}

local icons = {
  staged = "",
  unstaged = "",
  A = "A",
  M = "M",
  D = "D",
  R = "R",
  ["?"] = "?",
}

local icon_highlights = {
  A = "ReviewAdded",
  M = "ReviewModified",
  D = "ReviewDeleted",
  R = "ReviewRenamed",
  ["?"] = "ReviewUntracked",
}

local idx_offset = 3

local function parse_git_status_line(line)
  if line == "" then
    return nil
  end

  local file = { change_types = {} }
  local x, y, output = line:match("^(.)(.)%s*(.+)$")

  local path = output

  if string.find(output, "->", 1, true) then
    local paths = vim.split(output, "->")
    path = vim.trim(paths[2])
  end

  file.path = vim.trim(path)
  file.output = vim.trim(output)
  file.x_icon = x
  file.y_icon = y

  local x_status = porcelain_status[x]
  local y_status = porcelain_status[y]

  if x == " " then
    file.staged = false
  else
    file.change_types[x_status] = true
    file.staged = x ~= "?"
  end

  if y == " " then
    file.unstaged = false
  else
    file.change_types[y_status] = true
    file.unstaged = true
  end

  return file
end

local function update_files()
  local files = {}

  local output = vim.fn.systemlist("git status --porcelain")
  for _, line in ipairs(output) do
    local file = parse_git_status_line(line)

    if file then
      table.insert(files, file)
    end
  end

  table.sort(files, function(a, b)
    return a.path < b.path
  end)

  state.files = files
end

local function refresh()
  update_files()

  if #state.files == 0 then
    state.current_idx = 0
    return
  end

  if state.current_idx == 0 and #state.files > 0 then
    state.current_idx = 1
  end

  if state.current_idx > #state.files then
    state.current_idx = #state.files
    return
  end
end

local function refresh_one(idx)
  local status = vim.fn.system("git status --porcelain -- " .. state.files[idx].path)
  local updated_file = parse_git_status_line(status)

  if not updated_file then
    refresh()
    return
  end

  local types = updated_file.change_types

  -- FIXME: when unstaging a renamed file, the cursor do not goes to the correct file
  if types.added or types.deleted or types.renamed or types.untracked then
    refresh()
    return
  end

  state.files[idx] = updated_file
end

local function get_icons(file)
  local x_icon = icons[file.x_icon] or " "
  local y_icon = icons[file.y_icon] or " "

  if file.staged and file.unstaged then
    return x_icon, y_icon
  end

  if file.staged then
    return x_icon, " "
  else
    return y_icon, " "
  end
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

  if #state.files == 0 then
    table.insert(lines, " No changes to review")
    table.insert(lines, "")
    table.insert(highlights, { line = 2, col = 0, end_col = #lines[3], hl = "Comment" })
  else
    table.insert(lines, "")

    for i, file in ipairs(state.files) do
      local x_icon, y_icon = get_icons(file)

      local status_icon
      local status_hl
      if file.staged and file.unstaged then
        status_icon = "[-]"
        status_hl = "ReviewModified"
      elseif file.staged then
        status_icon = "[x]"
        status_hl = "ReviewStaged"
      else
        status_icon = "[ ]"
        status_hl = "ReviewUnstaged"
      end

      local line = string.format(" %s %s%s %s", status_icon, x_icon, y_icon, file.output)

      table.insert(lines, line)

      local line_idx = #lines - 1

      if i == state.current_idx then
        table.insert(highlights, { line = line_idx, col = 0, full_line = true, hl = "ReviewLine" })
      end

      local current_col = 1
      table.insert(highlights,
        { line = line_idx, col = current_col, end_col = current_col + #status_icon, hl = status_hl })

      current_col = current_col + #status_icon + 1
      for _, icon in ipairs({ x_icon, y_icon }) do
        if icon == " " then
          current_col = current_col + 1
        else
          table.insert(highlights, {
            line = line_idx,
            col = current_col,
            end_col = current_col + #icon,
            hl = icon_highlights[icon]
          })
          current_col = current_col + #icon
        end
      end
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
    if hl.full_line then
      vim.api.nvim_buf_set_extmark(state.buf, ns, hl.line, hl.col, { hl_eol = true, line_hl_group = hl.hl })
    else
      vim.api.nvim_buf_set_extmark(state.buf, ns, hl.line, hl.col, { end_col = hl.end_col, hl_group = hl.hl })
    end
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

local function open_diff()
  if state.current_idx == 0 or state.current_idx > #state.files then
    return
  end

  local file = state.files[state.current_idx]
  local filepath = vim.fn.getcwd() .. "/" .. file.path

  close_diff_windows()

  -- Focus sidebar and create new window to the right
  vim.api.nvim_set_current_win(state.win)
  vim.cmd("vertical botright new")

  vim.cmd("edit " .. vim.fn.fnameescape(filepath))

  vim.cmd("silent! Gvdiffsplit HEAD")
  vim.cmd("wincmd x")
  vim.cmd("set wrap")

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_width(state.win, state.width)
  end

  vim.cmd("wincmd =")
  vim.cmd("wincmd l")

  state.last_opened_file_idx = state.current_idx
end

local function move_cursor()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_cursor(state.win, { state.current_idx + idx_offset, 0 })
  end
end

local function stage(to_stage)
  if state.current_idx == 0 or state.current_idx > #state.files then
    return
  end

  local file = state.files[state.current_idx]
  local filepath = vim.fn.fnameescape(file.path)

  if to_stage then
    vim.fn.system("git add " .. filepath)
  else
    if file.change_types.renamed then
      local paths = vim.split(file.output, "->")
      vim.fn.system(string.format("git restore --staged %s %s", paths[1], paths[2]))
      refresh()
      render()
      return
    else
      vim.fn.system("git restore --staged " .. filepath)
    end
  end

  refresh_one(state.current_idx)
  render()
  move_cursor()
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
  move_cursor()
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
  move_cursor()
end

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  -- TODO: Do not delete buffer
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
    if not state.last_opened_file_idx then
      return
    end

    vim.fn.system("git add " .. state.files[state.last_opened_file_idx].path)

    refresh_one(state.last_opened_file_idx)
    next_file()
    open_diff()
  end)

  local gitsigns = require("gitsigns")

  vim.keymap.set("n", "s", function()
    gitsigns.stage_hunk(nil, nil, function()
      refresh_one(state.last_opened_file_idx)
      render()
    end)
  end)

  vim.keymap.set("n", "R", function()
    gitsigns.reset_buffer_index(function()
      refresh_one(state.last_opened_file_idx)
      render()
    end)
  end)
end

local function setup_autocmds()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    buffer = state.buf,
    callback = function()
      refresh()
      render()
    end,
  })

  vim.api.nvim_create_autocmd("BufHidden", {
    buffer = state.buf,
    once = true,
    callback = function()
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

  refresh()

  if #state.files == 0 then
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
  -- TODO: setup autocmds only once
  setup_autocmds()
  render()
  move_cursor()
  open_diff()
end

return M
