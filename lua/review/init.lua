local M = {}

--- @param opts table|nil Configuration options
---   - width: number - Width of the sidebar window (default: 40)
---   - icons: table - Custom icons for file states
---   - highlights: table - Custom highlight groups
function M.setup(opts)
  local config = require("review.config")
  config.setup(opts)

  local review = require("review.review")
  vim.api.nvim_create_user_command("Review", review.open, { desc = "Open git review sidebar" })
end

return M
