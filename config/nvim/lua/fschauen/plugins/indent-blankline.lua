local M = { 'lukas-reineke/indent-blankline.nvim' }

M.keys = require('fschauen.keymap').indent_blankline

M.lazy = false -- trows an error when lazy loading

local chars = { '│', '¦', '┆', '┊', '┊', '┊', '┊', '┊', '┊', '┊' }
local show_first_level = false

M.opts = {
  enabled = false,
  use_treesitter = true,
  show_first_indent_level = show_first_level,
  show_current_context = true,
  show_trailing_blankline_indent = false,
  char_list = chars,
  context_char_list = chars,
  indent_level = #chars + (not show_first_level and 1 or 0),
}

return M
