return {
  'norcalli/nvim-colorizer.lua',

  cond = vim.opt.termguicolors:get(),

  config = function()
    require('colorizer').setup({'*'}, { mode = 'foreground' })
  end,
}

