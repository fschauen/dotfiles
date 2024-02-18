local M = { 'j-hui/fidget.nvim' }

M.branch = 'legacy'

M.event = 'LspAttach'

M.opts = {
  text = {
    done = require('fschauen.util.icons').ui.Checkmark,
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
  timer = { spinner_rate = 75 },
  window = { blend = 50 },
  fmt = { max_messages = 10 }
}

return M

