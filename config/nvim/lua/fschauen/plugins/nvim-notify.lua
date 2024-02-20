local helper = require("fschauen.plugins.telescope").keymap_helper
local lhs, desc = helper.lhs, helper.description

local telescope_notifications = function()
  local telescope = vim.F.npcall(require, "telescope")
  if not telescope then
    vim.notify("Telescope is not installed!", vim.log.levels.WARN)
    return
  end

  local theme = require("telescope.themes").get_dropdown {
    results_title = "  Results  ",
    prompt_title = "    Notifications  ",
  }
  telescope.load_extension("notify").notify(theme)
end

local dismiss_notifications = function()
  require("notify").dismiss()
end

return {
  "rcarriga/nvim-notify",

  keys = {
    -- stylua: ignore start
    { "<leader>n", "<cmd>Notifications<cr>",  desc = "Display notification history" },
    { "<c-q>",     dismiss_notifications,     desc = "Dismiss notifications" },
    { lhs("n"),    telescope_notifications,   desc = desc("[n]otifications") },
    -- stylua: ignore end
  },

  lazy = false,

  opts = function(_, opts)
    local icons = require("fschauen.util.icons")
    return vim.tbl_deep_extend("force", opts or {}, {
      icons = {
        ERROR = icons.diagnostics_bold.Error,
        WARN = icons.diagnostics_bold.Warn,
        INFO = icons.diagnostics.Info,
        DEBUG = icons.diagnostics.Debug,
        TRACE = icons.diagnostics.Trace,
      },
      fps = 24,
      max_width = 50,
      minimum_width = 50,
      render = "wrapped-compact",
      stages = "fade",
      time_formats = {
        notification_history = "%F %T │ ",
      },
    })
  end,

  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
