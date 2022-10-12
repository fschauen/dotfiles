local ok, colorizer = pcall(require, 'colorizer')
if ok and colorizer then
  colorizer.setup({'*'}, { mode = 'foreground' })
end

