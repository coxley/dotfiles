local options = { noremap = true, silent = true }
local keys = {
    { "<leader><leader>f",  "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find Files",     unpack(options) },
    { '<leader><leader>g',  "<cmd>lua require('telescope.builtin').live_grep()<cr>",  desc = "Live Grep",      unpack(options) },
    { '<leader><leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>",    desc = "Search Buffers", unpack(options) },
    { '<leader><leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>",  desc = "Search Help",    unpack(options) },
}

return {
    {
        "nvim-telescope/telescope.nvim",
        keys = keys,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            extensions = {
                lsp_handlers = {
                    code_action = {
                        telescope = require('telescope.themes').get_dropdown({}),
                    },
                },
            },
        }
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        keys = keys,
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require('telescope').load_extension('fzf')
        end
    },
    {
        "gbrlsnchs/telescope-lsp-handlers.nvim",
        keys = keys,
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require('telescope').load_extension('lsp_handlers')
        end
    },
    {
        "nvim-telescope/telescope-media-files.nvim",
        keys = keys,
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
    },
}
