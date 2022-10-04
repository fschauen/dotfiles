local ok, plugin = pcall(require, 'indent_blankline')
if not ok then return end

plugin.setup {
  enabled = false,
}

-- show/hide indent guides
vim.keymap.set('n', '<leader>si', '<cmd>IndentBlanklineToggle<cr>')

