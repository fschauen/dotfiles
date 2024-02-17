local M = { 'rcarriga/nvim-notify' }

local telescope_notify = function()
  local ts = vim.F.npcall(require, 'telescope')
  if not ts then return end

  local theme = require('telescope.themes').get_dropdown {
    results_title = '  Results  ',
    prompt_title  = '    Notifications  ',
  }

  local notify = ts.extensions.notify or ts.load_extension('notify')
  notify.notify(theme)
end

M.keys = {
  { '<leader>n', '<cmd>Notifications<cr>', desc = 'Display notification history' },
  { '<leader>fn', telescope_notify, desc = ' [N]otifications' },
}

M.lazy = false

M.config = function()
  local icons = require('fschauen.icons')
  local notify = require('notify')

  notify.setup {
    icons = {
      ERROR = icons.diagnostics_bold.Error,
      WARN  = icons.diagnostics_bold.Warn,
      INFO  = icons.diagnostics.Info,
      DEBUG = icons.diagnostics.Debug,
      TRACE = icons.diagnostics.Trace,
    },
    fps = 24,
    max_width = 50,
    minimum_width = 50,
    render = 'wrapped-compact',
    stages = 'fade',
    time_formats = { notification_history = '%F %T' },
    top_down = true,
  }

  vim.notify = notify
end

return M

