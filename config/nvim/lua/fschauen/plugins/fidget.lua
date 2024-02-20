local icons = require("fschauen.util.icons")

return {
  "j-hui/fidget.nvim",

  branch = "legacy",

  event = "LspAttach",

  opts = {
    text = {
      done = icons.ui.Checkmark,
      spinner = {
        "▱▱▱▱▱▱▱",
        "▰▱▱▱▱▱▱",
        "▰▰▱▱▱▱▱",
        "▰▰▰▱▱▱▱",
        "▰▰▰▰▱▱▱",
        "▰▰▰▰▰▱▱",
        "▰▰▰▰▰▰▱",
        "▰▰▰▰▰▰▰",
        "▱▰▰▰▰▰▰",
        "▱▱▰▰▰▰▰",
        "▱▱▱▰▰▰▰",
        "▱▱▱▱▰▰▰",
        "▱▱▱▱▱▰▰",
        "▱▱▱▱▱▱▰",
      },
    },
    timer = { spinner_rate = 75 },
    window = { blend = 50 },
    fmt = { max_messages = 10 },
  },
}
