local M = { 'folke/trouble.nvim' }

M.dependencies = {
  'nvim-tree/nvim-web-devicons',
}

M.keys = {
  { '<leader>lt', '<cmd>TroubleToggle<cr>' },
  { '<leader>lw', '<cmd>TroubleToggle workspace_diagnostics<cr>' },
  { '<leader>ld', '<cmd>TroubleToggle document_diagnostics<cr>' },
}

M.config = function()
  require('trouble').setup {
    padding = false,      -- don't add an extra new line of top of the list
    auto_preview = false, -- don't preview automatically
  }
end

return M

