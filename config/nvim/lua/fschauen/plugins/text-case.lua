local M = { 'johmsalas/text-case.nvim' }

M.event = { 'BufReadPost', 'BufNewFile' }

M.opts = { prefix = '<leader>c' }

return M

