local helper = require("fschauen.plugins.telescope").keymap_helper
local lhs, desc = helper.lhs, helper.description

return {
  "nvim-telescope/telescope-file-browser.nvim",

  dependencies = "nvim-telescope/telescope.nvim",

  keys = {
    { lhs("B"), "<cmd>Telescope file_browser<cr>", desc = desc("file [B]rowser") },
  },

  config = function()
    require("telescope").load_extension("file_browser")
  end,
}
