return {
    {
        "nvimtools/hydra.nvim",
        event = "VeryLazy",
        opts = {},
        config = function()
            require("hydra").setup({
                debug = false,
                exit = false,
                foreign_keys = nil,
                color = "red",
                timeout = false,
                invoke_on_body = false,
                hint = {
                    show_name = true,
                    position = { "bottom" },
                    offset = 0,
                    float_opts = {},
                },
                on_enter = nil,
                on_exit = nil,
                on_key = nil,
            })
        end
    },
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            'nvimtools/hydra.nvim',
        },
        opts = {},
        cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
        keys = {
            {
                mode = { 'v', 'n' },
                '<Leader>m',
                '<cmd>MCstart<cr>',
                desc = 'Create a selection for selected text or word under the cursor',
            },
        },
    }
}
