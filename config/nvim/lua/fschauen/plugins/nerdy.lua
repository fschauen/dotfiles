local helper = require("fschauen.plugins.telescope").keymap_helper
local lhs, desc = helper.lhs, helper.description

return {
  "2kabhishek/nerdy.nvim",

  cmd = "Nerdy",

  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope.nvim",
  },

  keys = {
    { lhs("i"), "<cmd>Nerdy<cr>", desc = desc("Nerd [i]cons") },
  },
}
