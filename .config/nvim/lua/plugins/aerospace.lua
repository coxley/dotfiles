return {
    {
        'coxley/aerospace-focus.nvim',
        opts = {},
        -- Required when sharing the same keybinds as aerospace, as it will swallow the
        -- keypress before lazy.nvim has a chance to load the plugin.
        lazy = false,
        -- opts = {
        --     extra_argv = {
        --         '--boundaries-action',
        --         'wrap-around-the-workspace'
        --     },
        -- },
        keys = {
            { "<C-h>", ":AeroSpaceFocus left<CR>",  noremap = true, silent = true },
            { "<C-j>", ":AeroSpaceFocus down<CR>",  noremap = true, silent = true },
            { "<C-k>", ":AeroSpaceFocus up<CR>",    noremap = true, silent = true },
            { "<C-l>", ":AeroSpaceFocus right<CR>", noremap = true, silent = true },
        },
    }
}
