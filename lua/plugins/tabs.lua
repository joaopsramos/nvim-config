return {
  "nanozuki/tabby.nvim",
  dependencies = "nvim-mini/mini.icons",
  event = "VeryLazy",
  config = function()
    local theme = {
      fill = "TabLineFill",
      head = "TabLine",
      current_tab = "TabLineSel",
      tab = "TabLine",
      win = "TabLine",
      tail = "TabLine",
    }

    require("tabby").setup({
      line = function(line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.name(),
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          {},
          hl = theme.fill,
        }
      end,
    })
  end,
  keys = {
    { "<leader>tba", ":$tabnew<CR>", silent = true },
    { "<leader>tbd", ":tabclose<CR>", silent = true },
    { "<leader>tbo", ":tabonly<CR>", silent = true },
  },
}
