return {
  "tpope/vim-commentary",

  cmd = "Commentary",

  keys = {
    -- stylua: ignore start
    { "gc",  "<Plug>Commentary", mode = {"n", "x", "o"}, desc = "Comment in/out" },
    { "gcc", "<Plug>CommentaryLine",                     desc = "Comment in/out line" },
    { "gcu", "<Plug>Commentary<Plug>Commentary",         desc = "Undo comment in/out" },
    -- stylua: ignore end
  },
}
