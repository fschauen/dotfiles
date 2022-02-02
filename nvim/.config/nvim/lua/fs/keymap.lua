local M = {}

local nvim_set_keymap = vim.api.nvim_set_keymap
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap

local extend = function(opts)
  return vim.tbl_extend('keep', opts or {}, { noremap = true })
end

local map = function(mode, lhs, rhs, opts)
  nvim_set_keymap(mode, lhs, rhs, extend(opts))
end

local buf_map = function(mode, lhs, rhs, opts)
  nvim_buf_set_keymap(0, mode, lhs, rhs, extend(opts))
end

M.nmap        = function(tbl) map('n', tbl[1], tbl[2], tbl[3]) end
M.imap        = function(tbl) map('i', tbl[1], tbl[2], tbl[3]) end
M.vmap        = function(tbl) map('v', tbl[1], tbl[2], tbl[3]) end
M.buffer_nmap = function(tbl) buf_map('n', tbl[1], tbl[2], tbl[3]) end
M.buffer_imap = function(tbl) buf_map('i', tbl[1], tbl[2], tbl[3]) end

return M

