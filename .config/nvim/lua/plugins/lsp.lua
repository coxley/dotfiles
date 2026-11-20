map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

local prettier_filetypes = {
    -- "css",
    "graphql",
    "html",
    -- "javascript",
    -- "javascriptreact",
    "json",
    "less",
    -- "scss",
    -- "typescript",
    -- "typescriptreact",
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
        opts = {},
        config = function()
            vim.diagnostic.enable(true)

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            -- Stylelint
            vim.lsp.config("stylelint_lsp", {
                on_attach = disable_formatexpr,
                settings = {
                    stylelintplus = {
                        autoFixOnFormat = true,
                    },
                },
            })
            -- Zig
            vim.lsp.config('zls', {})
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                pattern = { "*.css", "*.scss", "*.less" },
                callback = function()
                    vim.lsp.config('cssls', {
                        capabilities = capabilities,
                    })
                end,
            })

            vim.lsp.config('graphql', {})

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                pattern = { "*.scss" },
                callback = function()
                    vim.lsp.config('somesass_ls', {})
                end,
            })

            vim.lsp.config('gopls', {})
            vim.lsp.config('protols', {})
            -- lspmux (launchd: com.coxley.lspmux; Linux: zsh init.zsh) shares one rust-analyzer per workspace
            -- across nvim instances. rustup's proxy honors rust-toolchain.toml, so
            -- rust-analyzer matches the toolchain's std; Mason's copy drifts.
            --
            -- Default: cargo-subspace loads only the open file's crate and its dependencies,
            -- so large workspaces start fast. Dependent crates stay unloaded: references and
            -- renames that cross into them are missed. `RA_FULL=1 nvim` loads the whole
            -- workspace; lspmux keeps the modes apart (pass_environment = ["RA_FULL"]).
            -- `env -u CARGO_HOME`: rustup sets it, and cargo-subspace then looks for
            -- $CARGO_HOME/bin/cargo, but Homebrew's rustup keeps its proxies elsewhere.
            local subspace = { 'env', '-u', 'CARGO_HOME', vim.fn.expand('~/.cargo/bin/cargo-subspace') }
            local full = vim.env.RA_FULL == '1' or vim.fn.executable(subspace[4]) == 0
            -- rustup's proxies: Homebrew keeps them keg-only; a Linux rustup uses ~/.cargo/bin.
            local ra = '/opt/homebrew/opt/rustup/bin/rust-analyzer'
            if vim.fn.executable(ra) == 0 then ra = vim.fn.expand('~/.cargo/bin/rust-analyzer') end
            local rustCfg = {
                inlayHints = {
                    typeHints = {
                        enable = false,
                    },
                    parameterHints = {
                        enable = false,
                    },
                },
            }
            if full then
                rustCfg["check"] = { command = 'clippy' }
            else
                rustCfg["check"] = {
                    overrideCommand = vim.list_extend(vim.list_slice(subspace), { 'clippy', '$saved_file' }),

                }
                rustCfg["workspace"] = {
                    discoverConfig = {
                        command = vim.list_extend(vim.list_slice(subspace), { 'discover', '{arg}' }),
                        progressLabel = 'cargo-subspace',
                        filesToWatch = { 'Cargo.toml' },
                    },

                }
            end
            vim.lsp.config('rust_analyzer', {
                cmd = { 'lspmux', 'client', '--server-path', ra },
                settings = {
                    ['rust-analyzer'] = rustCfg,
                },
            })
            vim.lsp.enable('rust_analyzer')
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        codeLens = {
                            enable = true
                        },
                        hint = {
                            enable = false,
                            semicolon = "Disable",
                            paramName = "Disable",
                        },
                        workspace = {
                            library = {
                                vim.fn.expand("~/.config/dg/lua/types"),
                            },
                        },
                    }
                }
            })
            local configs = require('lspconfig.configs')
            local util = require('lspconfig.util')
            configs.protobuf_language_server = {
                default_config = {
                    cmd = { 'protobuf-language-server' },
                    filetypes = { 'proto' },
                    root_dir = util.root_pattern('.git'),
                    single_file_support = true,
                }
            }
            vim.lsp.config('protobuf_language_server', {})
            vim.lsp.config('harper_ls', {
                settings = {
                    ["harper-ls"] = {
                        linters = {
                            SentenceCapitalization = false,
                            -- SpellCheck = false,
                            ToDoHyphen = false,
                            Spaces = false,
                            PhrasalVerbAsCompoundNoun = false,
                            LongSentences = false,
                        }
                    }
                }
            })
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
                "gopls",
                "zls",
            },
        },
    },
    {
        -- Maintained fork of the deleted jose-elias-alvarez/null-ls.nvim; same module name.
        "nvimtools/none-ls.nvim",
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
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.keymap.set("n", "<Leader>f", function()
                            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                        end, { buffer = bufnr, desc = "[lsp] format" })

                        -- format on save
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

                    if client.supports_method("textDocument/rangeFormatting") then
                        vim.keymap.set("x", "<Leader>f", function()
                            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                        end, { buffer = bufnr, desc = "[lsp] format" })
                    end
                end,

            })
        end
    },
    {
        "MunifTanjim/prettier.nvim",
        ft = prettier_filetypes,
        config = function()
            local prettier = require("prettier")
            prettier.setup({
                opts = {
                    bin = 'prettier',
                    filetypes = prettier_filetypes,
                },
                ["null-ls"] = {
                    condition = function()
                        return prettier.config_exists({
                            check_package_json = true,
                        })
                    end,
                    runtime_condition = function()
                        -- return false to skip running prettier
                        return true
                    end,

                },
                -- cli_options = {
                --     arrow_parens = "always",
                --     bracket_spacing = true,
                --     bracket_same_line = false,
                --     embedded_language_formatting = "auto",
                --     end_of_line = "lf",
                --     html_whitespace_sensitivity = "css",
                --     -- jsx_bracket_same_line = false,
                --     jsx_single_quote = false,
                --     print_width = 80,
                --     prose_wrap = "preserve",
                --     quote_props = "as-needed",
                --     semi = true,
                --     single_attribute_per_line = false,
                --     single_quote = false,
                --     tab_width = 2,
                --     trailing_comma = "es5",
                --     use_tabs = false,
                --     vue_indent_script_and_style = false,
                -- },
            })
        end
    },
    {
        "mhartington/formatter.nvim",
        config = function()
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    if vim.lsp.buf_is_attached() then
                        vim.lsp.buf.format()
                    else
                        vim.cmd.Format()
                    end
                end
            })
            require("formatter").setup({
                filetype = {
                    bzl = {
                        {
                            exe = "buildifier",
                            stdin = true,
                        },
                    },
                }
            })
        end
    },
    {
        "rmagatti/goto-preview",
        dependencies = 'rmagatti/logger.nvim',
        opts = {},
    },
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
            vim.lsp.config('typescript-tools', {
                on_attach = disable_formatexpr,
            })
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
    {
        "onsails/lspkind.nvim",
        event = "VeryLazy",
        config = function()
            require('lspkind').init({
                -- DEPRECATED (use mode instead): enables text annotations
                --
                -- default: true
                -- with_text = true,

                -- defines how annotations are shown
                -- default: symbol
                -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                mode = 'text',

                -- default symbol map
                -- can be either 'default' (requires nerd-fonts font) or
                -- 'codicons' for codicon preset (requires vscode-codicons font)
                --
                -- default: 'default'
                preset = 'default',

                -- override preset symbols
                --
                -- default: {}
                symbol_map = {
                    Text = "󰉿",
                    Method = "󰊕",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",
                },
            })
        end
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("lsp_lines").setup()

            local lines = true
            local toggle = function()
                lines = not lines
                local virtual_text = lines
                if not virtual_text then
                    virtual_text = {
                        spacing = 4,
                        prefix = "",
                    }
                end
                vim.diagnostic.config({
                    underline = true,
                    virtual_lines = lines,
                    virtual_text = virtual_text,
                })
            end

            toggle()
            vim.keymap.set("n", "<Leader>xt", toggle, { desc = "Toggle multiline diagnostics" })
        end,
    },
}
