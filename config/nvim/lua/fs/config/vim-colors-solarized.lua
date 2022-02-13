local util = require'fs.util'
local C = util.colors()
local highlight = util.highlight

local config = function()
  vim.cmd [[silent! colorscheme solarized]]

  highlight('Normal')       { bg = 'NONE' }                   -- transparent background
  highlight('NonText')      { fg = C.base02, attrs = 'NONE' } -- subtle EOL symbols
  highlight('Whitespace')   { fg = C.orange }                 -- listchars
  highlight('SpellBad')     { fg = C.yellow }
  highlight('QuickFixLine') { fg = C.yellow, bg = C.base02 }  -- selected quickfix item
  highlight('CursorLineNr') { fg = C.yellow, attrs = 'NONE' } -- current line number
end

return { config = config }

