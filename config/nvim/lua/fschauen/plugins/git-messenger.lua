local M = { 'rhysd/git-messenger.vim' }

M.cmd = 'GitMessenger'

M.keys = {
  { '<leader>gm', '<cmd>GitMessenger<cr>', desc = ' open [m]essenger' },
}

M.init = function()
  -- Disable default mappings, as I have my own for lazy-loading.
  vim.g.git_messenger_no_default_mappings = true

  -- Always move cursor into pop-up window immediately.
  vim.g.git_messenger_always_into_popup = true

  -- Add a border to the floating window, otherwise it's confusing.
  vim.g.git_messenger_floating_win_opts = { border = 'single' }

  -- Make the UI a bit more compact by removing margins.
  vim.g.git_messenger_popup_content_margins = false

  -- Extra arguments passed to `git blame`:
  -- vim.g.git_messenger_extra_blame_args = '-w'
end

return M

