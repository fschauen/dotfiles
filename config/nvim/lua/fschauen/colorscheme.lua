local M = {}

M.setup = function()
  local colorscheme = 'gruvbox'
  vim.cmd('silent! colorscheme ' .. colorscheme)
  if vim.v.errmsg ~= '' then
    vim.notify(('Colorscheme %s not found!'):format(colorscheme), vim.log.levels.WARN)
  end
end

return M

