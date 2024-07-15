return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                modules = {},
                ensure_installed = {
                    "css",
                    "earthfile",
                    "go",
                    "html",
                    "javascript",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "query",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "zig",
                },
                sync_install = false,
                auto_install = true,
                ignore_install = { 'phpdoc' },

                highlight = {
                    enable = true,
                    -- Zig text input gets REALLY slow with highlight enabled for me
                    disable = { "zig" },
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = false
                },
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            enable = true,         -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 0,         -- How many lines the window should span. Values <= 0 mean no limit.
            trim_scope = 'outer',  -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            -- separator = '─',
            patterns = {           -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                -- For all filetypes
                -- Note that setting an entry here replaces all other patterns for this entry.
                -- By setting the 'default' entry below, you can control which nodes you want to
                -- appear in the context window.
                default = {
                    'class',
                    'function',
                    'method',
                    'for',
                    'while',
                    'if',
                    'switch',
                    'case',
                },
            },
        }
    },
    {
        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
