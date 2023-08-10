return {
  'godlygeek/tabular',
  cmd ={
    'AddTabularPattern',
    'AddTabularPipeline',
    'Tabularize',
  },
  config = function()
    if vim.fn.exists('g:tabular_loaded') == 1 then
      vim.cmd [[ AddTabularPattern! first_comma /^[^,]*\zs,/ ]]
      vim.cmd [[ AddTabularPattern! first_colon /^[^:]*\zs:/ ]]
      vim.cmd [[ AddTabularPattern! first_equal /^[^=]*\zs=/ ]]
    end
  end,
}

