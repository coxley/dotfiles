local options = { noremap = true, silent = true }
local key_config = {
    file_ignore_patterns = {
        "yarn%.lock",
        "node_modules/",
        "dist/",
        "%.next",
        "build/",
        "vendor/",
    }
}

local keys = {
    {
        "<leader><leader>f",
        function()
            require("telescope.builtin").find_files(key_config)
        end,
        desc = "Find Files",
        unpack(options),
    },
    {
        "<leader><leader>g",
        function()
            require("telescope.builtin").live_grep(key_config)
        end,
        desc = "Live Grep",
        unpack(options),
    },
    {
        "<leader><leader>h",
        function()
            require("telescope.builtin").help_tags(key_config)
        end,
        desc = "Live Grep",
        unpack(options),
    },
}

return {
    {
        "nvim-telescope/telescope.nvim",
        keys = keys,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            file_ignore_patterns = {
                "vendor/"
            },
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
