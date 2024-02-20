local icons = require("fschauen.util.icons")

return {
  "NeogitOrg/neogit",

  cmd = "Neogit",

  dependencies = "nvim-lua/plenary.nvim",

  keys = {
    { "<leader>gs", "<cmd>Neogit<cr>", desc = " [s]tatus with neogit" },
  },

  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts or {}, {
      disable_hint = true,
      signs = {
        section = {
          icons.ui.Folder,
          icons.ui.EmptyFolderOpen,
        },
        item = {
          icons.ui.ChevronRight,
          icons.ui.ChevronDown,
        },
        hunk = {
          icons.ui.ChevronSmallRight,
          icons.ui.ChevronSmallDown,
        },
      },
      mappings = {
        status = {
          o = "GoToFile",
          ["="] = "Toggle",
        },
      },
    })
  end,
}
