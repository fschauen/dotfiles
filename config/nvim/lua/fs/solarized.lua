local M = {}

M.setup = function()
  if vim.g.colors_name then
    vim.cmd 'hi clear'
  end

  if vim.fn.exists('syntax_on') then
    vim.cmd 'syntax reset'
  end

  vim.g.colors_name = 'solarized'

  local colorbuddy = require('colorbuddy')
  local Color      = colorbuddy.Color
  local C          = colorbuddy.colors
  local Group      = colorbuddy.Group
  local G          = colorbuddy.groups
  local S          = colorbuddy.styles

  -- Color.new('base03' , '#002b36')
  Color.new('base03' , '#002028')
  Color.new('base02' , '#073642')
  Color.new('base01' , '#586e75')
  Color.new('base00' , '#657b83')
  Color.new('base0'  , '#839496')
  Color.new('base1'  , '#93a1a1')
  Color.new('base2'  , '#eee8d5')
  Color.new('base3'  , '#fdf6e3')
  Color.new('yellow' , '#b58900')
  Color.new('orange' , '#cb4b16')
  Color.new('red'    , '#dc322f')
  Color.new('magenta', '#d33682')
  Color.new('violet' , '#6c71c4')
  Color.new('blue'   , '#268bd2')
  Color.new('cyan'   , '#2aa198')
  -- Color.new('green'  , '#859900')
  Color.new('green'  , '#719e07')

  Color.new('bg'           , C.base03)

  Group.new('Error'        , C.red)
  Group.new('Warning'      , C.yellow)
  Group.new('Information'  , C.blue)
  Group.new('Hint'         , C.cyan)

  Group.new('Normal'      , C.base0  , C.NONE  , S.NONE)
  Group.new('NormalNC'    , G.Normal)
  Group.new('Comment'     , C.base01 , C.NONE  , S.NONE)
  Group.new('Constant'    , C.cyan   , C.NONE  , S.NONE)
  Group.new('Identifier'  , C.blue   , C.NONE  , S.NONE)

  Group.new('Statement'   , C.green  , C.NONE  , S.NONE)
  Group.new('PreProc'     , C.orange , C.NONE  , S.NONE)
  Group.new('Type'        , C.yellow , C.NONE  , S.NONE)
  Group.new('Special'     , C.red    , C.NONE  , S.NONE)
  Group.new('Underlined'  , C.violet , C.NONE  , S.NONE)
  Group.new('Ignore'      , C.NONE   , C.NONE  , S.NONE)
  Group.new('Error'       , C.red    , C.NONE  , S.NONE)
  Group.new('TODO'        , C.magenta, C.NONE  , S.bold)

  Group.new('SpecialKey'  , C.base00 , C.base02, S.bold)
  Group.new('NonText'     , C.base02 , C.NONE  , S.NONE)
  Group.new('StatusLine'  , C.base1  , C.base02, S.reverse)
  Group.new('StatusLineNC', C.base00 , C.base02, S.reverse)
  Group.new('Visual'      , C.base01 , C.base03, S.reverse)
  Group.new('Directory'   , C.blue   , C.NONE  , S.NONE)
  Group.new('ErrorMsg'    , C.red    , C.NONE  , S.reverse)

  Group.new('IncSearch'   , C.orange , C.NONE  , S.standout)
  Group.new('Search'      , C.yellow , C.NONE  , S.reverse)

  Group.new('MoreMsg'     , C.blue   , C.NONE  , S.NONE)
  Group.new('ModeMsg'     , C.blue   , C.NONE  , S.NONE)
  Group.new('Question'    , C.cyan   , C.NONE  , S.bold)
  Group.new('VertSplit'   , C.base00 , C.NONE  , S.NONE)
  Group.new('Title'       , C.orange , C.NONE  , S.bold)
  Group.new('VisualNOS'   , C.NONE   , C.base02, S.reverse)
  Group.new('WarningMsg'  , C.red    , C.NONE  , S.NONE)
  Group.new('WildMenu'    , C.base2  , C.base02, S.reverse)
  Group.new('Folded'      , C.base0  , C.base02, S.bold     , C.base03)
  Group.new('FoldColumn'  , C.base0  , C.base02, S.NONE)

  Group.new('DiffAdd'     , C.green  , C.base02, S.bold     , C.green)
  Group.new('DiffChange'  , C.yellow , C.base02, S.bold     , C.yellow)
  Group.new('DiffDelete'  , C.red    , C.base02, S.bold)
  Group.new('DiffText'    , C.blue   , C.base02, S.bold     , C.blue)

  Group.new('SignColumn'  , C.base0  , C.NONE  , S.NONE)
  Group.new('Conceal'     , C.blue   , C.NONE  , S.NONE)

  Group.new('SpellBad'    , C.NONE   , C.NONE  , S.undercurl, C.red)
  Group.new('SpellCap'    , C.NONE   , C.NONE  , S.undercurl, C.violet)
  Group.new('SpellRare'   , C.NONE   , C.NONE  , S.undercurl, C.cyan)
  Group.new('SpellLocal'  , C.NONE   , C.NONE  , S.undercurl, C.yellow)

  -- pum (popup menu)
  Group.new('Pmenu', G.Normal, C.base02, S.NONE) -- popup menu normal item
  Group.new('PmenuSel', C.base01, C.base2, S.reverse) -- selected item
  Group.new('PmenuSbar', C.base02, C.NONE, S.reverse)
  Group.new('PmenuThumb', C.base0, C.NONE, S.reverse)

  -- be nice for this float border to be cyan if active
  Group.new('FloatBorder', C.base02)

  Group.new('TabLine', C.base0, C.base02, S.NONE, C.base0)
  Group.new('TabLineFill', C.base0, C.base02)
  Group.new('TabLineSel', C.yellow, C.bg)

  Group.new('LineNr', C.base01, C.NONE, S.NONE)
  Group.new('CursorLine', C.NONE, C.base02, S.NONE, C.base1)
  Group.new('CursorLineNr', C.NONE, C.NONE, S.NONE, C.base1)
  Group.new('ColorColumn', C.NONE, C.base02, S.NONE)
  Group.new('Cursor', C.base03, C.base0, S.NONE)
  Group.link('lCursor', G.Cursor)
  Group.link('TermCursor', G.Cursor)
  Group.new('TermCursorNC', C.base03, C.base01)

  Group.new('MatchParen', C.red, C.base01, S.bold)

  Group.new('GitGutterAdd', C.green)
  Group.new('GitGutterChange', C.yellow)
  Group.new('GitGutterDelete', C.red)
  Group.new('GitGutterChangeDelete', C.red)

  Group.new('GitSignsAddLn', C.green)
  Group.new('GitSignsAddNr', C.green)
  Group.new('GitSignsChangeLn', C.yellow)
  Group.new('GitSignsChangeNr', C.yellow)
  Group.new('GitSignsDeleteLn', C.red)
  Group.new('GitSignsDeleteNr', C.red)
  Group.link('GitSignsCurrentLineBlame', G.Comment)

  -- vim highlighting
  Group.link('vimVar', G.Identifier)
  Group.link('vimFunc', G.Identifier)
  Group.link('vimUserFunc', G.Identifier)
  Group.link('helpSpecial', G.Special)
  Group.link('vimSet', G.Normal)
  Group.link('vimSetEqual', G.Normal)
  Group.new('vimCommentString', C.violet)
  Group.new('vimCommand', C.yellow)
  Group.new('vimCmdSep', C.blue, C.NONE, S.bold)
  Group.new('helpExample', C.base1)
  Group.new('helpOption', C.cyan)
  Group.new('helpNote', C.magenta)
  Group.new('helpVim', C.magenta)
  Group.new('helpHyperTextJump', C.blue, C.NONE, S.underline)
  Group.new('helpHyperTextEntry', C.green)
  Group.new('vimIsCommand', C.base00)
  Group.new('vimSynMtchOpt', C.yellow)
  Group.new('vimSynType', C.cyan)
  Group.new('vimHiLink', C.blue)
  Group.new('vimGroup', C.blue, C.NONE, S.underline + S.bold)

  Group.new('gitcommitSummary', C.green)
  Group.new('gitcommitComment', C.base01, C.NONE, S.italic)
  Group.link('gitcommitUntracked', G.gitcommitComment)
  Group.link('gitcommitDiscarded', G.gitcommitComment)
  Group.new('gitcommitSelected', G.gitcommitComment)
  Group.new('gitcommitUnmerged', C.green, C.NONE, S.bold)
  Group.new('gitcommitOnBranch', C.base01, C.NONE, S.bold)
  Group.new('gitcommitBranch', C.magenta, C.NONE, S.bold)
  Group.link('gitcommitNoBranch', G.gitcommitBranch)
  Group.new('gitcommitDiscardedType', C.red)
  Group.new('gitcommitSelectedType', C.green)
  Group.new('gitcommitHeader', C.base01)
  Group.new('gitcommitUntrackedFile', C.cyan)
  Group.new('gitcommitDiscardedFile', C.red)
  Group.new('gitcommitSelectedFile', C.green)
  Group.new('gitcommitUnmergedFile', C.yellow)
  Group.new('gitcommitFile', C.base0)
  Group.link('gitcommitDiscardedArrow', G.gitCommitDiscardedFile)
  Group.link('gitcommitSelectedArrow', G.gitCommitSelectedFile)
  Group.link('gitcommitUnmergedArrow', G.gitCommitUnmergedFile)

  Group.link('diffAdded', G.Statement)
  Group.link('diffLine', G.Identifier)

  Group.new('NeomakeErrorSign', C.orange)
  Group.new('NeomakeWarningSign', C.yellow)
  Group.new('NeomakeMessageSign', C.cyan)
  Group.new('NeomakeNeomakeInfoSign', C.green)

  Group.new('CmpItemKind', C.green, C.NONE, S.NONE)
  Group.new('CmpItemMenu', G.NormalNC, C.bg, S.NONE)
  -- Group.new('CmpItemAbbr', C.base0, C.bg, S.NONE)
  -- Group.new('CmpItemAbbrMatch', C.base0, C.bg, S.NONE)
  Group.new("CmpItemKindText", C.base3, C.NONE, S.NONE)
  Group.new("CmpItemKindMethod", C.green, C.NONE, S.NONE)
  Group.new("CmpItemKindFunction", C.blue, C.NONE, S.NONE)
  Group.new("CmpItemKindConstructor", C.orange, C.NONE, S.NONE)
  Group.new("CmpItemKindField", C.yellow, C.NONE, S.NONE)
  Group.new("CmpItemKindVariable", C.orange, C.NONE, S.NONE)
  Group.new("CmpitemKindClass", C.yellow, C.NONE, S.NONE)
  Group.new("CmpItemKindInterface", C.yellow, C.NONE, S.NONE)
  Group.new("CmpItemKindModule", C.green, C.NONE, S.NONE)
  Group.new("CmpItemKindProperty", C.green, C.NONE, S.NONE)
  Group.new("CmpItemKindUnit", C.orange, C.NONE, S.NONE)
  Group.new("CmpItemKindValue", C.cyan, C.NONE, S.NONE)
  Group.new("CmpItemKindEnum", C.yellow, C.NONE, S.NONE)
  Group.new("CmpItemKindKeyword", C.green, C.NONE, S.NONE)
  Group.new("CmpItemKindSnippet", C.magenta, C.NONE, S.NONE)
  Group.new("CmpItemKindColor", C.magenta, C.NONE, S.NONE)
  Group.new("CmpItemKindFile", C.violet, C.NONE, S.NONE)
  Group.new("CmpItemKindReference", C.violet, C.NONE, S.NONE)
  Group.new("CmpItemKindFolder", C.violet, C.NONE, S.NONE)
  Group.new("CmpItemKindEnumMember", C.cyan, C.NONE, S.NONE)
  Group.new("CmpItemKindConstant", C.cyan, C.NONE, S.NONE)
  Group.new("CmpItemKindStruct", C.yellow, C.NONE, S.NONE)
  Group.new("CmpItemKindEvent", C.orange, C.NONE, S.NONE)
  Group.new("CmpItemKindOperator", C.cyan, C.NONE, S.NONE)
  Group.new("CmpItemKindTypeParameter", C.orange, C.NONE, S.NONE)

  Group.new('LspSagaCodeActionTitle', C.green)
  Group.new('LspSagaBorderTitle', C.yellow, C.NONE, S.bold)
  Group.new('LspSagaDiagnosticHeader', C.yellow)
  Group.new('ProviderTruncateLine', C.base02)
  Group.new('LspSagaShTruncateLine', G.ProviderTruncateLine)
  Group.new('LspSagaDocTruncateLine', G.ProviderTruncateLine)
  Group.new('LspSagaCodeActionTruncateLine', G.ProviderTruncateLine)
  Group.new('LspSagaHoverBorder', C.cyan)
  Group.new('LspSagaRenameBorder', G.LspSagaHoverBorder)
  Group.new('LSPSagaDiagnosticBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaSignatureHelpBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaCodeActionBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaLspFinderBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaFloatWinBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaSignatureHelpBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaDefPreviewBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaAutoPreviewBorder', G.LspSagaHoverBorder)
  Group.new('LspFloatWinBorder', G.LspSagaHoverBorder)
  Group.new('LspLinesDiagBorder', G.LspSagaHoverBorder)
  Group.new('LspSagaFinderSelection', C.green, C.NONE, S.bold)
  --Group.new('SagaShadow', C.base02)

  Group.new('TelescopeMatching', C.orange, G.Special, G.Special, G.Special)
  Group.new('TelescopeBorder', C.base01) -- float border not quite dark enough, maybe that needs to change?
  Group.new('TelescopePromptBorder', C.cyan) -- active border lighter for clarity
  Group.new('TelescopeTitle', G.Normal) -- separate them from the border a little, but not make them pop
  Group.new('TelescopePromptPrefix', G.Normal) -- default is G.Identifier
  Group.link('TelescopeSelection', G.CursorLine)
  Group.new('TelescopeSelectionCaret', C.cyan)

  Group.new('NeogitDiffAddHighlight', C.blue, C.red)
  Group.new('NeogitDiffDeleteHighlight', C.blue, C.red)
  Group.new('NeogitHunkHeader', G.Normal, C.base02)
  Group.new('NeogitHunkHeaderHighlight', G.Normal, C.red)
  Group.new('NeogitDiffContextHighlight', C.base2, C.base02)
  Group.new('NeogitCommandText', G.Normal)
  Group.new('NeogitCommandTimeText', G.Normal)
  Group.new('NeogitCommandCodeNormal', G.Normal)
  Group.new('NeogitCommandCodeError', G.Error)
  Group.new('NeogitNotificationError', G.Error, C.NONE)
  Group.new('NeogitNotificationInfo', G.Information, C.NONE)
  Group.new('NeogitNotificationWarning', G.Warning, C.NONE)

  -- seblj/nvim-tabline
  Group.new('TabLineSeparatorActive', C.cyan)
  Group.link('TabLineModifiedSeparatorActive', G.TablineSeparatorActive)

  -- kevinhwang91/nvim-bqf
  Group.new('BqfPreviewBorder', C.base01)
  Group.new('BqfSign', C.cyan)

  -- Primeagen/harpoon
  Group.new("HarpoonBorder", C.cyan)
  Group.new("HarpoonWindow", G.Normal)

  Group.new("NvimTreeFolderIcon", C.blue)

  -- phaazon/hop.nvim
  Group.link('HopNextKey', G.IncSearch)
  Group.link('HopNextKey1', G.IncSearch)
  Group.link('HopNextKey2', G.IncSearch)

  function M.translate(group)
    if vim.fn.has("nvim-0.6.0") == 0 then return group end

    if not string.match(group, "^LspDiagnostics") then return group end

    local translated = group
    translated = string.gsub(translated, "^LspDiagnosticsDefault", "Diagnostic")
    translated = string.gsub(translated, "^LspDiagnostics", "Diagnostic")
    translated = string.gsub(translated, "Warning$", "Warn")
    translated = string.gsub(translated, "Information$", "Info")
    return translated
  end

  local lspColors = {
    Error       = G.Error,
    Warning     = G.Warning,
    Information = G.Information,
    Hint        = G.Hint,
  }
  for _, lsp in pairs({ "Error", "Warning", "Information", "Hint" }) do
    local lspGroup = Group.new(M.translate("LspDiagnosticsDefault" .. lsp), lspColors[lsp])
    Group.link(M.translate("LspDiagnosticsVirtualText" .. lsp), lspGroup)
    Group.new(M.translate("LspDiagnosticsUnderline" .. lsp), C.NONE, C.NONE, S.undercurl, lspColors[lsp])
  end

  for _, name in pairs({ "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }) do
    Group.link(M.translate(name), G.CursorLine)
  end

  return M
end

return M
