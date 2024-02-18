local M = {}

M.diagnostics = {
  Debug   = ' ',
  Error   = ' ',
  Hint    = ' ',
  Info    = ' ',
  Trace   = '✎ ',
  Warn    = ' ',
}

M.diagnostics_bold = {
  Debug   = ' ',
  Error   = ' ',
  Hint    = '󰌵 ',
  Info    = ' ',
  Trace   = '✎ ',
  Warn    = ' ',
}

M.git = {
  Branch = '󰘬',         -- 
  file = {
    Deleted     = '✗',  -- 
    Ignored     = '◌',
    Renamed     = '➜',  -- 
    Staged      = '✓',  -- S
    Unmerged    = '',  -- 
    Unstaged    = '✶',  -- 
    Untracked   = '',  -- U
  }
}

-- Custom mix of lspkind defaults and VS Code codicons :)
M.kind = {
  Array             = ' ',
  Boolean           = ' ',
  Class             = ' ',
  Color             = ' ',
  Constant          = '󰏿 ',   -- 
  Constructor       = ' ',
  Copilot           = ' ',
  Enum              = ' ',   -- 
  EnumMember        = ' ',   -- 
  Event             = ' ',
  Field             = ' ',
  File              = ' ',
  Folder            = ' ',   -- 󰉋
  Function          = '󰊕 ',   -- 
  Interface         = ' ',
  Key               = ' ',
  Keyword           = ' ',
  Method            = ' ',
  Module            = ' ',
  Namespace         = ' ',
  Null              = ' ',   -- 󰟢
  Number            = ' ',
  Object            = ' ',
  Operator          = ' ',
  Package           = ' ',
  Property          = ' ',
  Reference         = ' ',   -- 
  Snippet           = ' ',
  String            = ' ',
  Struct            = ' ',
  Text              = ' ',
  TypeParameter     = ' ',
  Unit              = ' ',
  Value             = '󰎠 ',
  Variable          = '󰀫 ',   -- 
}

M.modes = {
  Normal          = '', --   'Normal '   'n'
  OperatorPending = '', --   'O-Pend '   'no'
  NormalI         = '', --   'Normal '   'ni'  (normal via i_CTRL-O)
  Visual          = '󰒉', --   'Visual '   'v'
  VisualBlock     = '󰩭', --   'V-Block'   ''
  Select          = '󰒉', --   'Select '   's'
  SelectBlock     = '󰩭', --   'S-Block'   ''
  Insert          = '', --   'Insert '   'i'
  Replace         = '󰄾', --   'Replace'   'r'
  VirtualReplace  = '󰶻', --   'V-Repl '   'rv'
  Command         = '', --   'Command'   'c'
  Ex              = '', --   '  Ex   '   'cv'
  modeore         = '', --   ' modeore   'rm'  (modeORE)
  Confirm         = '󰭚', --   'Confirm'   'r?'  (:confirm)
  Shell           = '', --   ' Shell '   '!'   (external command executing)
  Terminal        = '', --   ' Term  '   't'
}

M.ui = {
  Attention             = '',
  Bug                   = '',    -- 
  Checkbox              = '',    --  󰄬 󰄬 
  Checkmark             = '',    --  󰄬 󰄬 
  ChevronDown           = '',    -- 
  ChevronLeft           = '',    -- 
  ChevronRight          = '',    -- 
  ChevronUp             = '',    -- 
  ChevronSmallDown      = '',
  ChevronSmallLeft      = '',
  ChevronSmallRight     = '',
  ChevronSmallUp        = '',
  Circle                = '●',
  EmptyFolder           = '',
  EmptyFolderOpen       = '',
  File                  = '',    -- 
  FileSymlink           = '',    -- 
  Files                 = '',
  Fire                  = '',    -- 
  Folder                = '󰉋',
  FolderOpen            = '',
  FolderSymlink         = '',
  Gauge                 = '󰓅',    -- 
  LineLeft              = '▏',
  LineLeftBold          = '▎',
  LineMiddle            = '│',
  LineMiddleBold        = '┃',
  Modified              = '',
  Note                  = '',    -- 
  Paste                 = '',
  Play                  = '',
  ReadOnly              = '',    -- 'RO',
  Search                = '',    -- 
  Sleep                 = '󰒲',
  TestTube              = '󰙨',    -- 󰤑
  Toggle                = '󰨚',
  Warning               = '',
}

return M

