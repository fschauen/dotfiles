local C = require'fs.util'.colors()

local a_fg = C.base03

return {
  normal = {
    a = { fg = a_fg,     bg = C.blue   },
    b = { fg = C.base03, bg = C.base0  },
    c = { fg = C.base1,  bg = C.base02 },
  },
  insert = {
    a = { fg = a_fg, bg = C.green },
  },
  visual = {
    a = { fg = a_fg, bg = C.magenta },
  },
  replace = {
    a = { fg = a_fg, bg = C.red },
  },
  inactive = {
    a = { fg = C.base02, bg = C.base00 },
    b = { fg = C.base02, bg = C.base01 },
    c = { fg = C.base01, bg = C.base03 },
  },
}

