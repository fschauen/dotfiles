local icons = require("fschauen.util.icons")

return {
  "lukas-reineke/indent-blankline.nvim",

  cmd = {
    "IBLEnable",
    "IBLDisable",
    "IBLToggle",
    "IBLEnableScope",
    "IBLDisableScope",
    "IBLToggleScope",
  },

  keys = {
    -- stylua: ignore start
    { "<leader>si", "<cmd>IBLToggle<cr>",      desc = icons.ui.Toggle .. "  toggle indent lines" },
    { "<leader>so", "<cmd>IBLToggleScope<cr>", desc = icons.ui.Toggle .. "  toggle indent line scope" },
    -- stylua: ignore end
  },

  main = "ibl",

  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts or {}, {
      enabled = false,
      indent = { char = icons.ui.LineLeft },
      scope = {
        char = icons.ui.LineLeftBold,
        enabled = false,
        show_start = false,
        show_end = false,
      },
    })
  end,
}
