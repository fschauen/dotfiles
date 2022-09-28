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

  -- Color Definitions
  local color_definitions = require('fs.util').colors(true)
  for name, rgb in pairs(color_definitions) do
    Color.new(name, rgb)
  end

  Color.new('bg', C.base04)

  -- Standard Groups
  Group.new('Normal'      , C.base0, C.NONE, S.NONE)  -- normal text
  Group.new('NormalNC'    , G.Normal)                 -- normal text in non-current windows

  Group.new('Comment'     , C.base01, C.NONE, S.NONE) -- any comment

  Group.new('Constant'    , C.cyan, C.NONE, S.NONE)  -- any constant
  Group.new('String'      , G.Constant)  -- a string constant: "this is a string"
  Group.new('Character'   , G.Constant)  -- a character constant: 'c', '\n'
  Group.new('Number'      , G.Constant)  -- a number constant: 234, 0xff
  Group.new('Boolean'     , G.Constant)  -- a boolean constant: TRUE, false
  Group.new('Float'       , G.Constant)  -- a floating point constant: 2.3e10

  Group.new('Identifier'  , C.blue, C.NONE, S.NONE)
  Group.new('Function'    , G.Identifier)

  Group.new('Statement'   , C.yellow, C.NONE, S.NONE) -- any statement
  Group.new('Conditional' , G.Statement)  -- if, then, else, endif, switch, etc.
  Group.new('Repeat'      , G.Statement)  -- for, do, while, etc.
  Group.new('Label'       , G.Statement)  -- case, default, etc.
  Group.new('Operator'    , G.Statement)  -- "sizeof", "+", "*", etc.
  Group.new('Keyword'     , G.Statement)  -- any other keyword
  Group.new('Exception'   , G.Statement)  -- try, catch, throw

  Group.new('PreProc'     , C.orange, C.NONE, S.NONE) -- generic Preprocessor
  Group.new('Include'     , G.PreProc)  -- preprocessor #include
  Group.new('Define'      , G.PreProc)  -- preprocessor #define
  Group.new('Macro'       , G.PreProc)  -- same as Define
  Group.new('PreCondit'   , G.PreProc)  -- preprocessor #if, #else, #endif, etc.

  Group.new('Type'        , C.yellow, C.NONE, S.NONE) -- int, long, char, etc.
  Group.new('StorageClass', G.Statement)  -- static, register, volatile, etc.
  Group.new('Structure'   , G.Statement)  -- struct, union, enum, etc.
  Group.new('Typedef'     , G.Statement)  -- A typedef

  Group.new('Special'       , C.red    , C.NONE  , S.NONE) -- any special symbol
  Group.new('SpecialChar'   , G.Special)  -- special character in a constant
  Group.new('Tag'           , G.Special)  -- you can use CTRL-] on this
  Group.new('Delimiter'     , G.Special)  -- character that needs attention
  Group.new('SpecialComment', G.Special)  -- special things inside a comment
  Group.new('Debug'         , G.Special)  -- debugging statements

  Group.new('Underlined'    , C.violet , C.NONE  , S.NONE)
  Group.new('Ignore'        , C.NONE   , C.NONE  , S.NONE)
  Group.new('Todo'          , C.magenta, C.NONE  , S.bold)
  Group.new('Error'         , C.red    , C.NONE  , S.NONE)
  Group.new('Warning'       , C.yellow)
  Group.new('Information'   , C.blue)
  Group.new('Hint'          , C.cyan)

  -- Additional Groups
  Group.new('StatusLine'  , C.base1 , C.base02, S.reverse)
  Group.new('StatusLineNC', C.base00, C.base02, S.reverse)
  Group.new('Visual'      , C.base01, C.bg    , S.reverse)

  Group.new('SpecialKey'  , C.base00, C.base02, S.bold)
  Group.new('SignColumn'  , C.base0 , C.NONE  , S.NONE)
  Group.new('Conceal'     , C.blue  , C.NONE  , S.NONE)
  Group.new('Cursor'      , C.bg    , C.base0, S.NONE)
  Group.new('TermCursorNC', C.bg    , C.base01)
  Group.link('lCursor'    , G.Cursor)
  Group.link('TermCursor' , G.Cursor)

  Group.new('LineNr'      , C.base01, C.NONE, S.NONE)
  Group.new('CursorLine'  , C.NONE,   C.base02, S.NONE)
  Group.new('CursorLineNr', C.base2, C.NONE, S.NONE)

  Group.new('IncSearch'   , C.orange , C.NONE  , S.standout)
  Group.new('Search'      , C.yellow , C.NONE  , S.reverse)

  Group.new('DiffAdd'     , C.green  , C.NONE, S.NONE)
  Group.new('DiffChange'  , C.yellow , C.NONE, S.NONE)
  Group.new('DiffDelete'  , C.red    , C.NONE, S.NONE)
  Group.new('DiffText'    , C.blue   , C.NONE, S.NONE)
  Group.link('diffAdded'  , G.DiffAdd)
  Group.link('diffRemoved', G.DiffDelete)
  Group.link('diffLine'   , G.Identifier)

  Group.new('SpellBad'    , C.orange, C.NONE, S.undercurl)
  Group.new('SpellCap'    , C.violet, C.NONE, S.undercurl)
  Group.new('SpellRare'   , C.cyan  , C.NONE, S.undercurl)
  Group.new('SpellLocal'  , C.yellow, C.NONE, S.undercurl)

  Group.new('ErrorMsg'    , G.Error)
  Group.new('MoreMsg'     , C.blue   , C.NONE  , S.NONE)
  Group.new('ModeMsg'     , C.blue   , C.NONE  , S.NONE)
  Group.new('Question'    , C.cyan   , C.NONE  , S.bold)
  Group.new('VertSplit'   , C.base00 , C.NONE  , S.NONE)
  Group.new('Title'       , C.orange , C.NONE  , S.bold)
  Group.new('VisualNOS'   , C.NONE   , C.base02, S.reverse)
  Group.new('WarningMsg'  , C.red    , C.NONE  , S.NONE)
  Group.new('WildMenu'    , C.base2  , C.base02, S.NONE)
  Group.new('Folded'      , C.blue   , C.bg    , S.NONE)
  Group.new('FoldColumn'  , C.blue   , C.bg    , S.NONE)

  Group.new('Directory'   , C.blue   , C.NONE  , S.NONE)

  Group.new('NonText'     , C.base02 , C.NONE  , S.NONE)  -- subtle EOL symbols
  Group.new('Whitespace'  , C.orange , C.NONE  , S.NONE)  -- listchars
  Group.new('QuickFixLine', C.yellow , C.base02, S.NONE)  -- selected quickfix item

  -- pum (popup menu)
  Group.new('Pmenu', G.Normal, C.base02, S.NONE) -- popup menu normal item
  Group.new('PmenuSel', C.base01, C.base2, S.reverse) -- selected item
  Group.new('PmenuSbar', C.base02, C.NONE, S.reverse)
  Group.new('PmenuThumb', C.base0, C.NONE, S.reverse)

  Group.new('TabLine'    , C.base0 , C.base02 , S.NONE)
  Group.new('TabLineFill', C.base0 , C.base02)
  Group.new('TabLineSel' , C.yellow, C.bg)

  Group.new('MatchParen', C.red, C.base01, S.bold)

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

  -- git highlighting
  Group.new('gitcommitSummary'        , C.green)
  Group.link('gitcommitComment'       , G.Comment)
  Group.link('gitcommitUntracked'     , G.gitcommitComment)
  Group.link('gitcommitDiscarded'     , G.gitcommitComment)
  Group.link('gitcommitSelected'      , G.gitcommitComment)
  Group.link('gitcommitOnBranch'      , G.gitcommitComment)

  Group.new('gitcommitBranch'         , C.blue , C.base02, S.NONE)
  Group.link('gitcommitNoBranch'      , G.gitcommitBranch)

  Group.new('gitcommitHeader'         , C.base01)
  Group.new('gitcommitFile'           , C.base0)

  Group.new('gitcommitSelectedType'   , C.green)
  Group.link('gitcommitSelectedFile'  , G.gitcommitSelectedType)
  Group.link('gitcommitSelectedArrow' , G.gitCommitSelectedFile)

  Group.new('gitcommitDiscardedType'  , C.orange)
  Group.link('gitcommitDiscardedFile' , G.gitcommitDiscardedType)
  Group.link('gitcommitDiscardedArrow', G.gitCommitDiscardedFile)

  Group.new('gitcommitUntrackedFile'  , C.cyan)

  Group.new('gitcommitUnmerged'       , C.yellow, C.NONE, S.NONE)
  Group.new('gitcommitUnmergedFile'   , C.red)
  Group.link('gitcommitUnmergedArrow' , G.gitCommitUnmergedFile)

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

  -- Plugin: 'ntpeters/vim-better-whitespace'
  Group.new('ExtraWhitespace', C.orange, C.orange) -- trailing whitespace

  -- Plugin: 'lukas-reineke/indent-blankline.nvim'
  Group.new('IndentBlanklineChar', C.base02, C.NONE) -- indentation guides

  -- Plugin: 'lukas-reineke/virt-column.nvim'
  Group.new('VirtColumn' , C.base02, C.NONE, S.NONE)  -- virtual column
  Group.new('ColorColumn', C.NONE  , C.NONE, S.NONE)  -- otherwise this is visible behind VirtColumn

  -- Plugin: 'kyazdani42/nvim-tree.lua'
  Group.new('NvimTreeSpecialFile' , C.base2 , C.NONE, S.NONE)
  Group.new('NvimTreeIndentMarker', C.base01, C.NONE, S.NONE)
  Group.new('NvimTreeGitStaged'   , C.green , C.NONE, S.NONE)
  Group.new('NvimTreeGitRenamed'  , C.yellow, C.NONE, S.NONE)
  Group.new('NvimTreeGitNew'      , C.yellow, C.NONE, S.NONE)
  Group.new('NvimTreeGitDirty'    , C.yellow, C.NONE, S.NONE)
  Group.new('NvimTreeGitDeleted'  , C.orange, C.NONE, S.NONE)
  Group.new('NvimTreeGitMerge'    , C.red   , C.NONE, S.NONE)

  -- Plugin: 'nvim-telescope/telescope.nvim'
  Group.new('TelescopeBorder'        , C.base01, C.NONE, S.NONE)
  Group.new('TelescopePromptBorder'  , C.base1 , C.NONE, S.NONE)
  Group.new('TelescopeTitle'         , C.base1 , C.NONE, S.NONE)
  Group.new('TelescopePromptPrefix'  , C.red   , C.NONE, S.NONE)
  Group.new('TelescopePromptCounter' , C.base1 , C.NONE, S.NONE)
  Group.new('TelescopeMatching'      , C.red   , C.NONE, S.NONE)
  Group.new('TelescopeSelection'     , C.base2 , C.NONE, S.NONE)
  Group.new('TelescopeMultiSelection', C.blue  , C.NONE, S.NONE)
  Group.new('TelescopeMultiIcon'     , C.blue  , C.NONE, S.NONE)
end

return M

