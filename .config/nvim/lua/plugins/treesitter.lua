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
                    "gotmpl",
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
                    additional_vim_regex_highlighting = true,
                    disable = function(lang, buf)
                        -- Zig text input gets REALLY slow with highlight enabled for me
                        if lang == "zig" then
                            return false
                        end
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },
                -- indent = {
                --     enable = false
                -- },
            })
            vim.treesitter.language.register('gotmpl', 'gotmpl')
            vim.treesitter.language.register('markdown', 'vimwiki')
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
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require 'nvim-treesitter.configs'.setup({
                textobjects = {
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>s"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader><leader>s"] = "@parameter.inner",
                        },
                    },
                },
            })
        end
    },
}
