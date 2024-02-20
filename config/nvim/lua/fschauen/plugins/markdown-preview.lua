return {
  "iamcco/markdown-preview.nvim",

  build = function()
    vim.fn["mkdp#util#install"]()
  end,

  cmd = {
    "MarkdownPreview",
    "MarkdownPreviewStop",
    "MarkdownPreviewToggle",
  },

  ft = "markdown",

  init = function()
    vim.g.mkdp_theme = "dark"
  end,
}
