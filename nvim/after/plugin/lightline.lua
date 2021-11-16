vim.g.lightline = {
    colorscheme = 'solarized',
    active = {
        left = { {'mode','paste'}, {}, {'ro','modified','path'} },
        right = { {'percent'}, {'lineinfo'}, {'ft','fenc','ff'} },
    },
    inactive = {
        left = { {'paste'}, {'ro','modified','path'} },
        right = { {'percent'}, {'lineinfo'} },
    },
    component = {
        fenc =     '%{&fenc!=#""?&fenc:&enc}',
        ff =       '%{&ff}',
        ft =       '%{&ft!=#""?&ft:"?"}',
        modified = '%M',
        paste =    '%{&paste?"PASTE":""}',
        path =     '%f',
        percent =  '%3p%%×%L',
        ro =       '%R',
    },
    subseparator = { left = '', right = '' },
}

