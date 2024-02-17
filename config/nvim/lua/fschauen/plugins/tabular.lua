local M = { 'godlygeek/tabular' }

M.cmd ={
  'AddTabularPattern',
  'AddTabularPipeline',
  'Tabularize',
}

M.config = function(--[[plugin]]_, --[[opts]]_)
  if vim.fn.exists('g:tabular_loaded') == 1 then
    vim.cmd [[ AddTabularPattern! first_comma /^[^,]*\zs,/ ]]
    vim.cmd [[ AddTabularPattern! first_colon /^[^:]*\zs:/ ]]
    vim.cmd [[ AddTabularPattern! first_equal /^[^=]*\zs=/ ]]
  end
end

return M

