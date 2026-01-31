vim.opt.termguicolors = true
vim.o.background = "dark"

return {
    { "folke/lazydev.nvim",   opts = {} },
    { "folke/which-key.nvim", opts = {}, },
    { "folke/neoconf.nvim",   cmd = "Neoconf" },
    {
        "catppuccin/nvim",
        name = "catpuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                no_italic = true,
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                integrations = {
                    aerial = false,
                    barbar = false,
                    beacon = false,
                    cmp = true,
                    coc_nvim = false,
                    dashboard = false,
                    fern = false,
                    fidget = true,
                    gitgutter = false,
                    gitsigns = false,
                    hop = false,
                    leap = true,
                    lightspeed = true,
                    lsp_saga = false,
                    lsp_trouble = true,
                    markdown = true,
                    mini = true,
                    neogit = false,
                    notify = false,
                    nvimtree = true,
                    overseer = false,
                    pounce = false,
                    symbols_outline = false,
                    telekasten = false,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                    ts_rainbow = true,
                    vim_sneak = false,
                    vimwiki = false,
                    which_key = true,
                },
            })
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        cond = false,
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                compile = true,
                transparent = false,
                theme = "dragon",
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            }
                        }
                    }
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        NormalFloat = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        FloatTitle = { bg = "none" },

                        -- Save an hlgroup with dark background and dimmed foreground
                        -- so that you can use it where your still want darker windows.
                        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                        -- Popular plugins that open floats will link to NormalFloat by default;
                        -- set their background accordingly if you wish to keep them dark and borderless
                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },

                    }
                end,
            })
            vim.cmd("colorscheme kanagawa-dragon")
        end,
    },
}
