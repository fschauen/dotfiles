local helper = require("fschauen.plugins.telescope").keymap_helper
local lhs, desc = helper.lhs, helper.description

return {
  "folke/todo-comments.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  event = { "BufReadPost", "BufNewFile" },

  keys = {
    { lhs("t"), "<cmd>TodoTelescope<cr>", desc = desc("[t]odos") },
  },

  opts = function(_, opts)
    local icons = require("fschauen.util.icons")
    return vim.tbl_deep_extend("force", opts or {}, {
      keywords = {
        TODO = { icon = icons.ui.Checkbox },
        FIX = { icon = icons.ui.Bug },
        HACK = { icon = icons.ui.Fire },
        WARN = { icon = icons.ui.Warning },
        PERF = { icon = icons.ui.Gauge },
        NOTE = { icon = icons.ui.Note },
        TEST = { icon = icons.ui.TestTube },
      },
      gui_style = { fg = "bold" },
      highlight = {
        multiline = false,
        before = "fg",
        keyword = "wide_fg",
        after = "",
      },
    })
  end,
}
