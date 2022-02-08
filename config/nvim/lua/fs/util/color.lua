local M = {}

local function generate(tbl, gui)
  local cterm, gui = {}, {}
  for name, color in pairs(tbl) do
    cterm[name] = color.cterm
    gui[name] = color.gui
  end
  return cterm, gui
end

local cterm_colors, gui_colors = generate {
  base03  =  { cterm =  8, gui = '#002b36' },
  base02  =  { cterm =  0, gui = '#073642' },
  base01  =  { cterm = 10, gui = '#586e75' },
  base00  =  { cterm = 11, gui = '#657b83' },
  base0   =  { cterm = 12, gui = '#839496' },
  base1   =  { cterm = 14, gui = '#93a1a1' },
  base2   =  { cterm =  7, gui = '#eee8d5' },
  base3   =  { cterm = 15, gui = '#fdf6e3' },
  yellow  =  { cterm =  3, gui = '#b58900' },
  orange  =  { cterm =  9, gui = '#cb4b16' },
  red     =  { cterm =  1, gui = '#dc322f' },
  magenta =  { cterm =  5, gui = '#d33682' },
  violet  =  { cterm = 13, gui = '#6c71c4' },
  blue    =  { cterm =  4, gui = '#268bd2' },
  cyan    =  { cterm =  6, gui = '#2aa198' },
  green   =  { cterm =  2, gui = '#859900' },
}

M.colors = function(gui)
  if gui or vim.opt.termguicolors:get() then
    return gui_colors
  end
  return cterm_colors
end

return M

