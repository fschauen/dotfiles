return {
  "tpope/vim-fugitive",

  cmd = { "G", "Git" },

  keys = {
    -- stylua: ignore start
    { "<leader>gS", "<cmd>tab Git<cr>",   desc = " [S]status with fugitive" },
    { "<leader>gb", "<cmd>Git blame<cr>", desc = " [b]lame" },
    -- stylua: ignore end
  },
}
