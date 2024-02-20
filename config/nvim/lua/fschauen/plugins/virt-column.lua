local toggle_colorcolumn = function()
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = "+1" -- one after 'textwidth'
  else
    vim.o.colorcolumn = "" -- none
  end
end

local icons = require("fschauen.util.icons")

return {
  "lukas-reineke/virt-column.nvim",

  event = { "BufReadPost", "BufNewFile" },

  keys = {
    { "<leader>sc", toggle_colorcolumn, desc = icons.ui.Toggle .. "  toggle virtual colunn" },
  },

  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts or {}, {
      char = icons.ui.LineMiddle,
    })
  end,
}
