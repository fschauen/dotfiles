local M = { 'norcalli/nvim-colorizer.lua' }

M.cond = vim.opt.termguicolors:get()

M.event = {
  'BufReadPost',
  'BufNewFile'
}

M.config = function()
  require('colorizer').setup(--[[ filetypes ]] nil, {
    css  = true,             -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    mode = 'foreground',
  })
end

return M

