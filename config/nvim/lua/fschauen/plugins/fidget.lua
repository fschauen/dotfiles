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
  }
end

return M

