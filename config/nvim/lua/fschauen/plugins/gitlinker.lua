local M = { 'ruifm/gitlinker.nvim' }

M.dependencies = { 'nvim-lua/plenary.nvim' }

local open_repo = function()
    require('gitlinker').get_repo_url { action_callback = require('gitlinker.actions').open_in_browser }
end

local browser = function(mode)
  return function()
    require('gitlinker').get_buf_range_url(mode, { action_callback = require('gitlinker.actions').open_in_browser })
  end
end

local clipboard = function(mode)
  return function()
    require('gitlinker').get_buf_range_url(mode, { action_callback = require('gitlinker.actions').copy_to_clipboard })
  end
end

M.keys = {
  { '<leader>gr', open_repo,      desc = ' open [r]epository in browser' },
  { '<leader>gl', clipboard('n'), desc = ' copy perma[l]ink to clipboard' },
  { '<leader>gl', clipboard('v'), desc = ' copy perma[l]ink to clipboard', mode = 'v' },
  { '<leader>gL', browser('n'),   desc = ' open perma[L]ink in browser' },
  { '<leader>gL', browser('v'),   desc = ' open perma[L]ink in browser', mode = 'v' },
}

M.opts = function(--[[plugin]]_, opts)
  return vim.tbl_deep_extend('force', opts or {}, {
    mappings = nil,  -- I'm defining my own mappings above.
    callbacks = {
      ['git.schauenburg.me'] = require('gitlinker.hosts').get_gitea_type_url,
    },
  })
end

return M

