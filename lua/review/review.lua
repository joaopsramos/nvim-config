local M = {}

local state = {
  buf = nil,
  win = nil,
  files = {},
  current_idx = 0,
  width = 40,
  wo = nil,
  last_opened_file = {},
}

local icons = {
  staged = "󰱒",
  unstaged = "",
  untracked = "",
  deleted = "󱋭",
}

local function get_changed_files()
  local git_files = {}
  local files = {}

  local staged_output = vim.fn.systemlist("git diff --cached --name-only")
  for _, file in ipairs(staged_output) do
    if file ~= "" then
      git_files[file] = git_files[file] or {}
      git_files[file].path = file
      git_files[file].staged = true
    end
  end

  local unstaged_output = vim.fn.systemlist("git diff --name-only --diff-filter=d")
  for _, file in ipairs(unstaged_output) do
    if file ~= "" then
      git_files[file] = git_files[file] or {}
      git_files[file].path = file
      git_files[file].unstaged = true
    end
  end

  local untracked_output = vim.fn.systemlist("git ls-files --others --exclude-standard")
  for _, file in ipairs(untracked_output) do
    if file ~= "" then
      git_files[file] = git_files[file] or {}
      git_files[file].path = file
      git_files[file].untracked = true
    end
  end

  local deleted_output = vim.fn.systemlist("git diff --name-only --diff-filter=D")
  for _, file in ipairs(deleted_output) do
    if file ~= "" then
      git_files[file] = git_files[file] or {}
      git_files[file].path = file
      git_files[file].deleted = true
    end
  end

  for _, file in pairs(git_files) do
    table.insert(files, file)
  end

  table.sort(files, function(a, b)
    return a.path < b.path
  end)

  return files
end

local function refresh()
  state.files = get_changed_files()
  if #state.files == 0 then
    state.current_idx = 0
    return
  end

  if state.current_idx > #state.files then
    state.current_idx = #state.files
    return
  end

  if state.current_idx == 0 and #state.files > 0 then
    state.current_idx = 1
  end
end

local function refresh_one(file)
  file.staged = false
  file.unstaged = false
  file.untracked = false
  file.deleted = false

  local status = vim.fn.system("git status --porcelain -- " .. file.path)

  if status:find("^MM") then
    file.staged = true
    file.unstaged = true
  elseif status:find("^M") or status:find("^A") then
    file.staged = true
  elseif status:find("^ M") then
    file.unstaged = true
  elseif status:find("^D") then
    file.staged = true
    file.deleted = true
  elseif status:find("^ D") then
    file.deleted = true
  elseif status:find("^??") then
    file.untracked = true
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
      local status_icon
      if file.staged and file.unstaged then
        status_icon = icons.staged .. icons.unstaged
      elseif file.staged then
        status_icon = " " .. icons.staged
      elseif file.untracked then
        status_icon = " " .. icons.untracked
      elseif file.deleted then
        status_icon = " " .. icons.deleted
      else
        status_icon = " " .. icons.unstaged
      end

      local line = string.format(" %s %s", status_icon, file.path)

      table.insert(lines, line)

      local line_idx = #lines - 1

      if i == state.current_idx then
        table.insert(highlights, { line = line_idx, col = 0, end_col = #line, hl = "ReviewLine" })
      end

      if file.staged then
        table.insert(highlights, { line = line_idx, col = 1, end_col = #icons.staged, hl = "ReviewStaged" })
      end

      if file.unstaged then
        local col = file.staged and (#icons.staged + 1) or 1
        local end_col = file.staged and (#icons.staged + #icons.unstaged + 1) or #icons.unstaged
        table.insert(highlights, { line = line_idx, col = col, end_col = end_col, hl = "ReviewUnstaged" })
      end

      if file.untracked then
        table.insert(highlights, { line = line_idx, col = 1, end_col = #icons.untracked, hl = "ReviewUntracked" })
      end

      if file.deleted then
        table.insert(highlights, { line = line_idx, col = 1, end_col = #icons.deleted, hl = "ReviewDeleted" })
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

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_width(state.win, state.width)
  end

  vim.cmd("wincmd =")
  vim.cmd("wincmd l")

  state.last_opened_file = file
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
    vim.fn.system("git restore --staged " .. filepath)
  end

  refresh_one(file)
  render()
end

local function move_cursor()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_cursor(state.win, { state.current_idx + 3, 0 })
  end
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
      refresh()
      render()
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
  setup_autocmds()
  render()
  move_cursor()
end

return M
