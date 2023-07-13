return {
  'norcalli/nvim-colorizer.lua',

  cond = vim.opt.termguicolors:get(),

  config = function()
    require('colorizer').setup(nil, {
      mode = 'foreground',
      css = true,
    })
  end,
}

