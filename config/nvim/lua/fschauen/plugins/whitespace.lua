return {
  "ntpeters/vim-better-whitespace",

  event = { "BufReadPost", "BufNewFile" },

  init = function()
    vim.g.better_whitespace_filetypes_blacklist = {
      "diff",
      "fugitive",
      "git",
      "gitcommit",
      "help",
    }
  end,

  keys = {
    { "<leader>ww", "<cmd>ToggleWhitespace<cr>" },
    { "<leader>wj", "<cmd>NextTrailingWhitespace<cr>" },
    { "<leader>wk", "<cmd>PrevTrailingWhitespace<cr>" },
    { "<leader>W", "<cmd>StripWhitespace<cr>" },
  },
}
