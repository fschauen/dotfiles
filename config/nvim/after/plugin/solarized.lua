local ok, solarized = pcall(require, 'solarized')
if ok and solarized then
  vim.cmd [[colorscheme solarized]]
end

