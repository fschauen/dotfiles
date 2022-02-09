local M = {}

local map = function(mode, lhs, rhs, opts)
  local opts = vim.tbl_extend('keep', opts or {}, { noremap = true })
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

local buf_map = function(mode, lhs, rhs, opts)
  local opts = vim.tbl_extend('keep', opts or {}, { noremap = true })
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
end

M.nmap        = function(tbl) map('n', tbl[1], tbl[2], tbl[3]) end
M.imap        = function(tbl) map('i', tbl[1], tbl[2], tbl[3]) end
M.vmap        = function(tbl) map('v', tbl[1], tbl[2], tbl[3]) end
M.buffer_nmap = function(tbl) buf_map('n', tbl[1], tbl[2], tbl[3]) end
M.buffer_imap = function(tbl) buf_map('i', tbl[1], tbl[2], tbl[3]) end

M.colors = function(gui)
  if gui or vim.opt.termguicolors:get() then
    return {
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
      green   = "#859900",
    }
  end
  return {
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

return M

