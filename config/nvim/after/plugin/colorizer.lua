local ok, colorizer = pcall(require, 'colorizer')
if ok and colorizer and vim.opt.termguicolors:get() then
  colorizer.setup({'*'}, { mode = 'foreground' })
end

