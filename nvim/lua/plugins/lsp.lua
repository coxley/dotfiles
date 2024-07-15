map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

local prettier_filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "scss",
    "typescript",
    "typescriptreact",
    "tsx",
}


local disable_formatexpr = function(client, bufnr)
    -- default_lsp_on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
end

return {
    {
        "neovim/nvim-lspconfig",
        -- dependencies = { "hrsh7th/cmp-nvim-lsp" },
        keys = {
            { "gP",         "<cmd>lua require('goto-preview').close_all_win()<CR>",               desc = "LSP: Close Windows",           options },
            { "gp",         "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",     desc = "LSP: Preview Definition",      options },
            { "gpi",        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "LSP: Preview Implementations", options },
            { "gpr",        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",     desc = "LSP: Preview References",      options },
            { '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                             desc = "LSP: Code Action",             options },
            { '<leader>f',  '<cmd>lua vim.lsp.buf.format()<CR>',                                  desc = "LSP: Format",                  options },
            { '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                  desc = "LSP: Rename Token",            options },
            { '<space>d',   '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                        desc = "LSP: Next Diagnostic",         options },
            { '<space>e',   '<cmd>lua vim.diagnostic.get()<CR>',                                  desc = "LSP: Diagnostics",             options },
            { 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>',                                   desc = "LSP: Hover",                   options },
            { 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>',                              desc = "LSP: Goto Definition",         options },
            { 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',                          desc = "LSP: Goto Implementation",     options },
            { 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                              desc = "LSP: References",              options },
        },
        config = function()
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    underline = true,
                    -- This sets the spacing and the prefix, obviously.
                    virtual_text = {
                        spacing = 4,
                        prefix = ''
                    }
                }
            )
            -- Stylelint
            require('lspconfig')["stylelint_lsp"].setup {
                on_attach = disable_formatexpr,
                settings = {
                    stylelintplus = {
                        autoFixOnFormat = true,
                    },
                },
            }

            -- Zig
            require('lspconfig').zls.setup {}
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                pattern = { "*.css", "*.scss", "*.less" },
                callback = function()
                    require('lspconfig').cssls.setup({})
                end,
            })

            require("lspconfig").lua_ls.setup({})
            vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = {},
            },
        },
        opts = {
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "zls",
            },
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        ft = { "javascript", "javascriptreact", "typescriptreact", "typescript" },
        config = function()
            local null_ls = require("null-ls")
            -- format on save
            local group = vim.api.nvim_create_augroup("lsp_format_on_save", {
                clear = false,
            })
            local event = "BufWritePre" -- or "BufWritePost"
            local async = event == "BufWritePost"

            null_ls.setup({
                sources = { require('null-ls').builtins.formatting.prettier },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.keymap.set("n", "<Leader>f", function()
                            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                        end, { buffer = bufnr, desc = "[lsp] format" })

                        vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                        vim.api.nvim_create_autocmd(event, {
                            buffer = bufnr,
                            group = group,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr, async = async })
                            end,
                            desc = "[lsp] format on save",
                        })
                    end
                end,
            })
        end
    },
    {
        "MunifTanjim/prettier.nvim",
        ft = prettier_filetypes,
        opts = {
            bin = 'prettier',
            filetypes = prettier_filetypes,
        },
    },
    { "mhartington/formatter.nvim", opts = {}, },
    { "rmagatti/goto-preview",      opts = {}, },
    {
        "pmizio/typescript-tools.nvim",
        ft = { "javascript", "javascriptreact", "typescriptreact", "typescript" },
        dependencies = {
            { "windwp/nvim-ts-autotag", opts = {}, },
        },
        config = function()
            require('typescript-tools').setup({
                settings = {
                    tsserver_path = "/opt/homebrew/bin/typescript-language-server",
                    tsserver_plugins = {
                        "@styled/typescript-styled-plugin",
                    },
                },
            })
            require('lspconfig')["typescript-tools"].setup {
                on_attach = disable_formatexpr,
            }
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble<cr>",                       desc = "Trouble: Toggle",                unpack(options) },
            { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Trouble: Workspace Diagnostics", unpack(options) },
            { "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",  desc = "Trouble: Document Diagnostics",  unpack(options) },
            { "<leader>xl", "<cmd>Trouble loclist<cr>",               desc = "Trouble: Location List",         unpack(options) },
            { "<leader>xq", "<cmd>Trouble quickfix<cr>",              desc = "Trouble: Quickfix",              unpack(options) },
            { "gR",         "<cmd>Trouble lsp_references<cr>",        desc = "Trouble: LSP References",        unpack(options) },
        },
        config = function()
            require("trouble").setup()
        end
    },
}
