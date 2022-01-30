local colors = {}
if vim.opt.termguicolors:get() then
    colors = {
        base03  = '#002b36',    yellow  = '#b58900',
        base02  = '#073642',    orange  = '#cb4b16',
        base01  = '#586e75',    red     = '#dc322f',
        base00  = '#657b83',    magenta = '#d33682',
        base0   = '#839496',    violet  = '#6c71c4',
        base1   = '#93a1a1',    blue    = '#268bd2',
        base2   = '#eee8d5',    cyan    = '#2aa198',
        base3   = '#fdf6e3',    green   = '#859900',
    }
else
    colors = {
        base03  =  8,           yellow  =  3,
        base02  =  0,           orange  =  9,
        base01  = 10,           red     =  1,
        base00  = 11,           magenta =  5,
        base0   = 12,           violet  = 13,
        base1   = 14,           blue    =  4,
        base2   =  7,           cyan    =  6,
        base3   = 15,           green   =  2,
    }
end

local percent_lines = '%3p%%×%L'
local relative_path = { 'filename', path = 1 }
local git_diff = {
    'diff',
    diff_color = {
        added    = { fg = colors.green }, modified = { fg = colors.yellow },
        removed  = { fg = colors.red },
    },
}

require('lualine').setup {
    options = {
        icons_enabled = false,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        theme = {
            normal = {
                a = { fg = colors.base03, bg = colors.blue,     },
                b = { fg = colors.base03, bg = colors.base00    },
                c = { fg = colors.base1,  bg = colors.base02    },
                -- x == c
                -- y == b
                z = { fg = colors.base03,  bg = colors.base0    },
            },
            insert  = { a = { fg = colors.base03, bg = colors.green,    } },
            visual  = { a = { fg = colors.base03, bg = colors.magenta,  } },
            replace = { a = { fg = colors.base03, bg = colors.red,      } },
            inactive = {
                a = { fg = colors.base00, bg = colors.base02,   },
                b = { fg = colors.base00, bg = colors.base02    },
                c = { fg = colors.base00, bg = colors.base02    },
            },
        },
    },

    sections = {
        lualine_a = {
            'mode',
            {
                function() return 'PASTE' end,
                color = { bg = colors.yellow },
                cond = function() return vim.opt.paste:get() end
            },
        },
        lualine_b = { 'diagnostics' },
        lualine_c = { relative_path },
        lualine_x = { 'branch', git_diff },
        lualine_y = { 'filetype', 'encoding', 'fileformat' },
        lualine_z = { 'location', percent_lines },

    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { relative_path },
        lualine_x = { 'branch', git_diff },
        lualine_y = { 'filetype', 'encoding', 'fileformat' },
        lualine_z = { 'location', percent_lines },
    },

    tabline = {},

    extensions = { 'fugitive', 'quickfix' }
}

