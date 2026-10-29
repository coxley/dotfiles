return {
    {
        "petertriho/nvim-scrollbar",
        branch = "refactor/v2",
        dependencies = {
            {
                'kevinhwang91/nvim-hlslens',
                config = function()
                    require('hlslens').setup()
                end
            },
            { 'lewis6991/gitsigns.nvim' },
        },
        config = function()
            require("scrollbar").setup({
                set_highlights = true,
                exclude = {
                    buftypes = {
                        terminal = true,
                    },
                    filetypes = {
                        ["blink-cmp-menu"] = true,
                        dropbar_menu = true,
                        dropbar_menu_fzf = true,
                        DressingInput = true,
                        cmp_docs = true,
                        cmp_menu = true,
                        noice = true,
                        prompt = true,
                        TelescopePrompt = true,
                    },
                },
                providers = {
                    gitsigns = false,
                },
                scrollbar = {
                    placement = {
                        gutter = "inner",
                        anchor = "NE",
                        zindex = 10,
                    },
                    layout = {
                        columns = {
                            {
                                "track",
                                "thumb",
                                { types = { "Mark" }, max_width = 4 },
                            },
                            { "marks" },
                        },
                    },
                    preset = "minimal",
                    visibility = "all",
                    hide_if_all_visible = true,
                    throttle_ms = 100,
                    thumb = {
                        highlight = { bg = "#b7bdf8" },
                        hide_if_all_visible = true,
                    },
                },
                marks = {
                    Cursor = {
                        text = "•",
                        priority = 0,
                        highlight = "Normal",
                    },
                    Search = {
                        text = { "-", "=" },
                        priority = 1,
                        highlight = { fg = "#f5a97f" },
                    },
                    Error = {
                        text = { "-", "=" },
                        priority = 2,
                        highlight = "DiagnosticVirtualTextError",
                    },
                    Warn = {
                        text = { "-", "=" },
                        priority = 3,
                        highlight = "DiagnosticVirtualTextWarn",
                    },
                    Info = {
                        text = { "-", "=" },
                        priority = 4,
                        highlight = "DiagnosticVirtualTextInfo",
                    },
                    Hint = {
                        text = { "-", "=" },
                        priority = 5,
                        highlight = "DiagnosticVirtualTextHint",
                    },
                    Misc = {
                        text = { "-", "=" },
                        priority = 6,
                        highlight = "Normal",
                    },
                    GitAdd = {
                        text = "┆",
                        priority = 7,
                        highlight = "GitSignsAdd",
                    },
                    GitChange = {
                        text = "┆",
                        priority = 7,
                        highlight = "GitSignsChange",
                    },
                    GitDelete = {
                        text = "▁",
                        priority = 7,
                        highlight = "GitSignsDelete",
                    },
                },
            })
        end,
    }
}
