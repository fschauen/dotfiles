local M = {}

local extend = function(opts)
  return vim.tbl_extend('keep', opts or {}, { noremap = true })
end

M.nmap = function(tbl)
  vim.api.nvim_set_keymap('n', tbl[1], tbl[2], extend(tbl[3]))
end

M.imap = function(tbl)
  vim.api.nvim_set_keymap('n', tbl[1], tbl[2], extend(tbl[3]))
end

M.buffer_nmap = function(tbl)
  vim.api.nvim_buf_set_keymap(0, 'n', tbl[1], tbl[2], extend(tbl[3]))
end

M.buffer_imap = function(tbl)
  vim.api.nvim_buf_set_keymap(0, 'i', tbl[1], tbl[2], extend(tbl[3]))
end

return M

