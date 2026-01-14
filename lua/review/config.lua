--- @class ReviewConfig
--- @field width number Width of the sidebar window
--- @field icons table Icon definitions for file states
--- @field highlights table Highlight group definitions

local M = {}

--- @type ReviewConfig
M.defaults = {
  width = 40,
  icons = {
    staged = "[x] ",
    unstaged = "[ ] ",
    staged_unstaged = "[-] ",
    A = "A",
    M = "M",
    D = "D",
    R = "R",
    ["?"] = "?",
  },
  highlights = {
    ReviewStaged = { fg = "#A6DA95" },
    ReviewAdded = { fg = "#8BD5CA" },
    ReviewModified = { fg = "#EED49F" },
    ReviewRenamed = { fg = "#F5A97F" },
    ReviewUnstaged = { fg = "#8AADF4" },
    ReviewUntracked = { fg = "#C6A0F6" },
    ReviewDeleted = { fg = "#ED8796" },
    ReviewFileDir = { bg = "#8087A2" },
    ReviewLine = { bg = "#494D64" },
    ReviewStatusTitle = { fg = "#C6A0F6" },
    ReviewStatusCount = { fg = "#F5A97F" },
  },
}

local function apply_highlights()
  for name, hl in pairs(M.opts.highlights) do
    vim.api.nvim_set_hl(0, name, hl)
  end
end

--- Current configuration
--- @type ReviewConfig
M.opts = vim.deepcopy(M.defaults)

--- @param opts table|nil User configuration options
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.defaults, opts or {})
  apply_highlights()
end

return M
