if vim.fn.exists('g:tabular_loaded') ~= 1 then return end

vim.cmd [[ AddTabularPattern! first_comma /^[^,]*\zs,/ ]]
vim.cmd [[ AddTabularPattern! first_colon /^[^:]*\zs:/ ]]
vim.cmd [[ AddTabularPattern! first_equal /^[^=]*\zs=/ ]]

