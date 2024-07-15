return {
    "MunifTanjim/nui.nvim",
    "nvim-neotest/nvim-nio",
    "wsdjeg/vim-fetch",
    "McAuleyPenney/tidy.nvim",
    "wsdjeg/vim-fetch",
    {
        "ray-x/guihua.lua",
        event = "VeryLazy",
        build = "cd lua/fzy && make",
        opts = {},
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {

            input = {
                -- Set to false to disable the vim.ui.input implementation
                enabled = true,

                -- Default prompt string
                default_prompt = "➤ ",

                -- When true, <Esc> will close the modal
                insert_only = true,

                -- These are passed to nvim_open_win
                -- anchor = "SW",
                relative = "cursor",
                border = "rounded",

                -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- width = nil,
                -- min_width and max_width can be a list of mixed types.
                -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
                -- min_width = 20,
                -- max_width = nil,
                max_width = { 140, 0.9 },
                min_width = { 20, 0.2 },

                -- Window transparency (0-100)
                winblend = 10,
                -- Change default highlight groups (see :help winhl)
                winhighlight = "",

                -- override = function(conf)
                --   -- This is the config that will be passed to nvim_open_win.
                --   -- Change values here to customize the layout
                --   return conf
                -- end,

                -- see :help dressing_get_config
                get_config = nil,
            },
            select = {
                -- Set to false to disable the vim.ui.select implementation
                enabled = true,

                -- Priority list of preferred vim.select implementations
                backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

                -- Options for telescope selector
                telescope = require('telescope.themes').get_dropdown({}),

                -- Options for fzf selector
                fzf = {
                    window = {
                        width = 0.5,
                        height = 0.4,
                    },
                },

                -- Options for fzf_lua selector
                fzf_lua = {
                    winopts = {
                        width = 0.5,
                        height = 0.4,
                    },
                },

                -- Options for nui Menu
                nui = {
                    position = "50%",
                    size = nil,
                    relative = "editor",
                    border = {
                        style = "rounded",
                    },
                    max_width = 80,
                    max_height = 40,
                },

                -- Options for built-in selector
                builtin = {
                    -- These are passed to nvim_open_win
                    anchor = "NW",
                    border = "rounded",
                    -- 'editor' and 'win' will default to being centered
                    relative = "editor",

                    -- Window transparency (0-100)
                    winblend = 10,
                    -- Change default highlight groups (see :help winhl)
                    winhighlight = "",

                    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    -- the min_ and max_ options can be a list of mixed types.
                    -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
                    width = nil,
                    max_width = { 140, 0.8 },
                    min_width = { 40, 0.2 },
                    height = nil,
                    max_height = 0.9,
                    min_height = { 10, 0.2 },

                    -- override = function(conf)
                    --   -- This is the config that will be passed to nvim_open_win.
                    --   -- Change values here to customize the layout
                    --   return conf
                    -- end,
                },

                -- Used to override format_item. See :help dressing-format
                format_item_override = {},

                -- see :help dressing_get_config
                get_config = nil,
            },
        }
    },
}
