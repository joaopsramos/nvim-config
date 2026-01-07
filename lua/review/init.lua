local M = {}

local function setup_highlights()
  vim.api.nvim_set_hl(0, "ReviewStaged", { fg = "#A6DA95" })
  vim.api.nvim_set_hl(0, "ReviewUnstaged", { fg = "#8AADF4" })
  vim.api.nvim_set_hl(0, "ReviewUntracked", { fg = "#C6A0F6" })
  vim.api.nvim_set_hl(0, "ReviewDeleted", { fg = "#ED8796" })
  vim.api.nvim_set_hl(0, "ReviewLine", { bg = "#494D64" })
end

function M.setup()
  local review = require("review.review")
  vim.api.nvim_create_user_command("Review", review.open, { desc = "Open git review sidebar" })

  setup_highlights()
end

return M
