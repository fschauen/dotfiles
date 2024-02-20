return {
  "stevearc/dressing.nvim",

  -- `vim.ui.select()` and `vim.ui.input()` can be used from the start.
  lazy = false,

  opts = {
    input = {
      insert_only = false, -- <esc> changes to Normal mode
      mappings = {
        n = {
          ["<C-c>"] = "Close",
        },
        i = {
          ["<c-k>"] = "HistoryPrev",
          ["<c-j>"] = "HistoryNext",
        },
      },
    },
  },
}
