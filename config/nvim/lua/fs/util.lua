local M = {}

M.colors = function(gui)
  if gui or vim.opt.termguicolors:get() then
    return {
      base04  = "#002028",
      base03  = "#002b36",
      base02  = "#073642",
      base01  = "#586e75",
      base00  = "#657b83",
      base0   = "#839496",
      base1   = "#93a1a1",
      base2   = "#eee8d5",
      base3   = "#fdf6e3",
      yellow  = "#b58900",
      orange  = "#cb4b16",
      red     = "#dc322f",
      magenta = "#d33682",
      violet  = "#6c71c4",
      blue    = "#268bd2",
      cyan    = "#2aa198",
      green   = "#719e07",  -- original: #859900
    }
  end
  return {
    base04  =  8,
    base03  =  8,
    base02  =  0,
    base01  = 10,
    base00  = 11,
    base0   = 12,
    base1   = 14,
    base2   =  7,
    base3   = 15,
    yellow  =  3,
    orange  =  9,
    red     =  1,
    magenta =  5,
    violet  = 13,
    blue    =  4,
    cyan    =  6,
    green   =  2,
  }
end

-- Usage example:
--  highlight('Test2', { fg = C.yellow, bg = C.base02 })
M.highlight = function(group, highlights)
  local kind = vim.opt.termguicolors:get() and 'gui' or 'cterm'

  local parts = {}
  for k, v in pairs(highlights) do
    if k == 'attrs' then k = '' end
    table.insert(parts, kind .. k .. '=' .. v)
  end

  local cmd = 'highlight ' .. group .. ' ' .. vim.fn.join(parts, ' ')
  vim.cmd(cmd)
end

M.syntax_stack = function()
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  if vim.fn.exists("*synstack") then
    local ids = vim.fn.synstack(line, col)
    P(vim.fn.map(ids, 'synIDattr(v:val, "name")'))
  end
end

return M

