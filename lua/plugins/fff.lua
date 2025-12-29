return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  -- No need to lazy-load with lazy.nvim.
  -- This plugin initializes itself lazily.
  lazy = false,
  opts = {
    prompt = "❯ ",
    layout = {
      prompt_position = "top",
    },
    preview = {
      line_numbers = true,
    },
  },
  keys = {
    {
      "<C-p>",
      function()
        require("fff").find_files()
      end,
      desc = "FFFind files",
    },
  },
  -- TODO: Remove this once mini.icons can be set as the icon provider
  init = function()
    local icons = require("fff.file_picker.icons")

    local icon_providers = {
      "mini.icons",
      "nvim-web-devicons",
    }

    -- Monkey patch the setup function to prefer mini.icons
    icons.setup = function()
      if icons.provider_name then
        return true
      end
      if icons.setup_failed then
        return false
      end

      icons.setup_attempted = true

      for _, provider_name in ipairs(icon_providers) do
        local ok, provider = pcall(require, provider_name)
        if ok then
          icons.provider = provider
          icons.provider_name = provider_name
          return true
        end
      end

      icons.setup_failed = true
      return false
    end
  end,
}
