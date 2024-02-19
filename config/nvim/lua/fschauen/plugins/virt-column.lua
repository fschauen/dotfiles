local M = { 'lukas-reineke/virt-column.nvim' }

M.event = { 'BufReadPost', 'BufNewFile' }

local toggle_colorcolumn = function()
  if vim.o.colorcolumn == '' then
    vim.o.colorcolumn = '+1'  -- one after 'textwidth'
  else
    vim.o.colorcolumn = ''    -- none
  end
end

local toggle = require('fschauen.util.icons').ui.Toggle .. '  toggle '

M.keys = {
  { '<leader>sc', toggle_colorcolumn, desc = toggle .. 'virtual colunn' },
}

M.opts = function(--[[plugin]]_, opts)
  return vim.tbl_deep_extend('force', opts or {}, {
    char = require('fschauen.util.icons').ui.LineMiddle,
  })
end

return M

