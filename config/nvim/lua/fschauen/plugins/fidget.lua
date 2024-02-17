local M = { 'j-hui/fidget.nvim' }

M.branch = 'legacy'

M.event = 'LspAttach'

M.config = function()
  require('fidget').setup {
    text = {
      done = require('fschauen.icons').ui.Checkmark,
      spinner = {
        '▱▱▱▱▱▱▱',
        '▰▱▱▱▱▱▱',
        '▰▰▱▱▱▱▱',
        '▰▰▰▱▱▱▱',
        '▰▰▰▰▱▱▱',
        '▰▰▰▰▰▱▱',
        '▰▰▰▰▰▰▱',
        '▰▰▰▰▰▰▰',
        '▱▰▰▰▰▰▰',
        '▱▱▰▰▰▰▰',
        '▱▱▱▰▰▰▰',
        '▱▱▱▱▰▰▰',
        '▱▱▱▱▱▰▰',
        '▱▱▱▱▱▱▰',
      },
    },
    timer = {
      spinner_rate = 75,
    },
    window = {
      blend = 50,
    },
    fmt = {
      max_messages = 10,
    }
  }
end

return M

