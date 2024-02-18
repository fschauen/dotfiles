local M = { 'stevearc/dressing.nvim' }

M.lazy = false

M.opts = {
  input = {
    insert_only = false,  -- <esc> changes to Normal mode
    mappings = {
      n = {
        ['<C-c>'] = 'Close',
      },
      i = {
        ['<c-k>'] = 'HistoryPrev',
        ['<c-j>'] = 'HistoryNext',
      },
    },
  },
}

return M

