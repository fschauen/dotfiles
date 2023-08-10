local chars = { '│', '¦', '┆', '┊', '┊', '┊', '┊', '┊', '┊', '┊' }
local show_first_level = false

return {
  'lukas-reineke/indent-blankline.nvim',
  keys = require('fschauen.keymap').indent_blankline,
  lazy = false,  -- trows an error when lazy loading
  opts = {
    enabled = false,
    use_treesitter = true,
    show_first_indent_level = show_first_level,
    show_current_context = true,
    show_trailing_blankline_indent = false,
    char_list = chars,
    context_char_list = chars,
    indent_level = #chars + (not show_first_level and 1 or 0),
  },
}

