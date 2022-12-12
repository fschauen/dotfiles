local C = require'solarized'.colors()

local foreground = C.base03

return {
  normal = {
    a = { fg = foreground, bg = C.blue   },
    b = { fg = C.base03,   bg = C.base0  },
    c = { fg = C.base1,    bg = C.base02 },
  },
  insert = {
    a = { fg = foreground, bg = C.green },
  },
  visual = {
    a = { fg = foreground, bg = C.magenta },
  },
  replace = {
    a = { fg = foreground, bg = C.red },
  },
  command = {
    a = { fg = foreground, bg = C.yellow },
  },
  inactive = {
    a = { fg = C.base02,   bg = C.base00 },
    b = { fg = C.base02,   bg = C.base01 },
    c = { fg = C.base01,   bg = C.base03 },
  },
}

