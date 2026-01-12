local config = require("review.config")

local M = {}

local ICON_HIGHLIGHTS = {
  A = "ReviewAdded",
  M = "ReviewModified",
  D = "ReviewDeleted",
  R = "ReviewRenamed",
  ["?"] = "ReviewUntracked",
}

--- @param file table
--- @return string, string Status
local function get_file_icons(file)
  local icons = config.opts.icons
  local x_icon = icons[file.x_icon] or " "
  local y_icon = icons[file.y_icon] or " "

  if file.staged and file.unstaged then
    return x_icon, y_icon
  elseif file.staged then
    return x_icon, " "
  else
    return y_icon, " "
  end
end

--- @param file table
--- @param lines table Lines buffer to append to
--- @param highlights table Highlights buffer to append to
local function render_file_line(file, lines, highlights)
  local x_icon, y_icon = get_file_icons(file)

  local status_icon, status_hl
  if file.staged and file.unstaged then
    status_icon = config.opts.icons.staged_unstaged
    status_hl = "ReviewModified"
  elseif file.staged then
    status_icon = config.opts.icons.staged
    status_hl = "ReviewStaged"
  else
    status_icon = config.opts.icons.unstaged
    status_hl = "ReviewUnstaged"
  end

  local filename = vim.fn.fnamemodify(file.output, ":t")
  local dir = vim.fn.fnamemodify(file.output, ":h")

  if file.change_types.renamed then
    local paths = vim.split(file.output, "->")
    local filename_before = vim.fn.fnamemodify(paths[1], ":t")
    local filename_after = vim.fn.fnamemodify(paths[2], ":t")
    local dir_before = vim.fn.fnamemodify(paths[1], ":h")
    local dir_after = vim.fn.fnamemodify(paths[2], ":h")

    if dir_before ~= "." and dir_after ~= "." then
      filename = filename_before .. " -> " .. filename_after
      dir = dir_before .. " -> " .. dir_after
    end
  end

  if dir == "." then
    dir = ""
  end

  local line = string.format(" %s %s%s %s %s", status_icon, x_icon, y_icon, filename, dir)
  table.insert(lines, line)

  local line_idx = #lines - 1
  local current_col = 1

  -- Highlight directory path
  if dir ~= "" then
    table.insert(highlights, { line = line_idx, col = #line - #dir, end_col = #line, hl = "Comment" })
  end

  -- Highlight status icon
  table.insert(highlights, { line = line_idx, col = current_col, end_col = current_col + #status_icon, hl = status_hl })

  -- Highlight change type icons
  current_col = current_col + #status_icon + 1
  for _, icon in ipairs({ x_icon, y_icon }) do
    if icon ~= " " then
      table.insert(highlights, {
        line = line_idx,
        col = current_col,
        end_col = current_col + #icon,
        hl = ICON_HIGHLIGHTS[icon] or "Normal",
      })
    end
    current_col = current_col + #icon
  end
end

--- @param buf number
--- @param files table
--- @param current_idx number
function M.render(buf, files, current_idx)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local lines = {}
  local highlights = {}

  table.insert(lines, " Git Review")
  table.insert(lines, "")
  table.insert(highlights, { line = 0, col = 0, end_col = #lines[1], hl = "Title" })

  if #files == 0 then
    table.insert(lines, " No changes to review")
    table.insert(highlights, { line = 2, col = 0, end_col = #lines[3], hl = "Comment" })
  else
    table.insert(lines, string.format(" Changes (%d)", #files))

    for i, file in ipairs(files) do
      render_file_line(file, lines, highlights)

      -- Highlight current line
      if i == current_idx then
        table.insert(highlights, { line = #lines - 1, col = 0, full_line = true, hl = "ReviewLine" })
      end
    end

    table.insert(lines, "")
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Apply highlights
  local ns = vim.api.nvim_create_namespace("review.nvim")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for _, hl in ipairs(highlights) do
    if hl.full_line then
      vim.api.nvim_buf_set_extmark(buf, ns, hl.line, hl.col, { hl_eol = true, line_hl_group = hl.hl })
    else
      vim.api.nvim_buf_set_extmark(buf, ns, hl.line, hl.col, { end_col = hl.end_col, hl_group = hl.hl })
    end
  end
end

return M
