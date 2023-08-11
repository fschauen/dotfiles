return {
  'tpope/vim-commentary',
  cmd = 'Commentary',
  keys = {
    { 'gc',  '<Plug>Commentary',    mode = { 'n', 'x', 'o' }, desc = 'Comment in/out' },
    { 'gcc', '<Plug>CommentaryLine',             desc = 'Comment in/out line' },
    { 'gcu', '<Plug>Commentary<Plug>Commentary', desc = 'Undo comment in/out' },
  },
}
