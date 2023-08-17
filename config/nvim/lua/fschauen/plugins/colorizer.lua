local M = { 'norcalli/nvim-colorizer.lua' }

M.cond = vim.opt.termguicolors:get()

M.event = {
  'BufReadPost',
  'BufNewFile'
}

M.config = function()
  require('colorizer').setup(nil, {
    css = true,
  })
end

return M
