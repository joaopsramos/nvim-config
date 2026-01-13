local config = require("review.config")

local M = {}

local ICON_HIGHLIGHTS = {
  A = "ReviewAdded",
  M = "ReviewModified",
  D = "ReviewDeleted",
  R = "ReviewRenamed",
  ["?"] = "ReviewUntracked",
}

--- @param file FileEntry
--- @return string Status, string Status
local function get_file_icons(file)
  local icons = config.opts.icons
  local x_icon = icons[file.x_icon] or " "
  local y_icon = icons[file.y_icon] or " "

  return x_icon, y_icon
end

--- @param file FileEntry
--- @param section Section?
--- @param lines table Lines buffer to append to
--- @param highlights table Highlights buffer to append to
local function render_file_line(file, section, lines, highlights)
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
    local paths = vim.split(file.output, " -> ", { plain = true })
    local filename_before = vim.fn.fnamemodify(paths[1], ":t")
    local filename_after = vim.fn.fnamemodify(paths[2], ":t")
    local dir_before = vim.fn.fnamemodify(paths[1], ":h")
    local dir_after = vim.fn.fnamemodify(paths[2], ":h")

    if dir_before ~= "." and dir_after ~= "." then
      filename = filename_before .. " -> " .. filename_after
      dir = dir_before .. " -> " .. dir_after
    end

    if dir_before == dir_after then
      dir = dir_before
    end
  end

  if dir == "." then
    dir = ""
  end

  local section_icon = " "
  if section == "staged" then
    section_icon = x_icon
  elseif section == "unstaged" then
    section_icon = y_icon
  end

  local line = string.format(" %s %s %s %s", status_icon, section_icon, filename, dir)
  table.insert(lines, line)

  local line_idx = #lines - 1
  local current_col = 1

  -- Highlight directory path
  if dir ~= "" then
    table.insert(highlights, { line = line_idx, col = #line - #dir, end_col = #line, hl = "Comment" })
  end

  -- Highlight status icon
  table.insert(highlights, { line = line_idx, col = current_col, end_col = current_col + #status_icon, hl = status_hl })

  -- Highlight section icon
  current_col = current_col + #status_icon + 1
  table.insert(highlights, {
    line = line_idx,
    col = current_col,
    end_col = current_col + #section_icon,
    hl = ICON_HIGHLIGHTS[section_icon] or "Normal",
  })
end

--- @param buf number
--- @param staged_files FileEntry[]
--- @param unstaged_files FileEntry[]
--- @param current_idx number
--- @param current_section Section?
function M.render(buf, unstaged_files, staged_files, current_idx, current_section)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local lines = {}
  local highlights = {}

  table.insert(lines, " Git Review")
  table.insert(lines, "")
  table.insert(highlights, { line = 0, col = 0, end_col = #lines[1], hl = "Title" })

  if #unstaged_files == 0 and #staged_files == 0 then
    table.insert(lines, " No changes to review")
    table.insert(highlights, { line = 2, col = 0, end_col = #lines[3], hl = "Comment" })
  else
    if #unstaged_files > 0 then
      table.insert(lines, string.format(" Unstaged (%d)", #unstaged_files))

      for i, file in ipairs(unstaged_files) do
        render_file_line(file, "unstaged", lines, highlights)

        -- Highlight current line
        if i == current_idx and current_section == "unstaged" then
          table.insert(highlights, { line = #lines - 1, col = 0, full_line = true, hl = "ReviewLine" })
        end
      end

      table.insert(lines, "")
    end

    if #staged_files > 0 then
      table.insert(lines, string.format(" Staged (%d)", #staged_files))

      for i, file in ipairs(staged_files) do
        render_file_line(file, "staged", lines, highlights)

        -- Highlight current line
        if i == current_idx and current_section == "staged" then
          table.insert(highlights, { line = #lines - 1, col = 0, full_line = true, hl = "ReviewLine" })
        end
      end
    end

    table.insert(lines, "")
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

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
