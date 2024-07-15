local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_mapping = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    return {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }
end

return {
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({}),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp_mapping(),
                sources = cmp.config.sources(
                    {
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' },
                    },
                    {
                        { name = 'buffer' },
                        { name = 'nvim_lsp_signature_help' },
                    }
                )
            })


            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
                }, {
                    { name = 'buffer' },
                })
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end,
        dependencies = {
            {
                "hrsh7th/cmp-buffer",
                event = "VeryLazy",
            },
            {
                "hrsh7th/cmp-cmdline",
                event = "VeryLazy",
            },
            {
                "hrsh7th/cmp-nvim-lsp",
                event = "VeryLazy",
                dependencies = {
                    "neovim/nvim-lspconfig",
                },
                config = function()
                    require("cmp_nvim_lsp").setup()
                    -- Default capabilities
                    local capabilities = require('cmp_nvim_lsp').default_capabilities()
                    require('lspconfig').util.default_config =
                        vim.tbl_deep_extend('force', require('lspconfig').util.default_config, {
                            capabilities = capabilities,
                        })
                end
            },
            {
                "hrsh7th/cmp-nvim-lsp-signature-help",
                event = "VeryLazy",
            },
            {
                "hrsh7th/cmp-path",
                event = "VeryLazy",
            },
            {
                "saadparwaiz1/cmp_luasnip",
                event = "VeryLazy",
                dependencies = {
                    {
                        "L3MON4D3/LuaSnip",
                        event = "VeryLazy",
                        tag = "v2.3.0",
                        build = "make install_jsregexp",
                    },
                    {
                        event = "VeryLazy",
                        "rafamadriz/friendly-snippets",
                    },
                },
                config = function()
                    local ls = require("luasnip")
                    local luasnip = ls
                    ls.filetype_extend("go", {})
                    require("luasnip.loaders.from_vscode").lazy_load()
                    vim.keymap.set(
                        { "i" },
                        "<leader>.",
                        function() ls.expand() end, { silent = true }
                    )
                    vim.keymap.set(
                        { "i" },
                        "<leader>.",
                        function() ls.expand() end,
                        { silent = true }
                    )
                    vim.keymap.set(
                        { "i", "s" },
                        "<C-L>",
                        function() ls.jump(1) end,
                        { silent = true }
                    )
                    vim.keymap.set(
                        { "i", "s" },
                        "<C-H>",
                        function() ls.jump(-1) end,
                        { silent = true }
                    )

                    vim.keymap.set(
                        { "i", "s" },
                        "<C-E>",
                        function()
                            if ls.choice_active() then
                                ls.change_choice(1)
                            end
                        end,
                        { silent = true }
                    )
                    local fmt = require("luasnip.extras.fmt").fmt
                    local fmta = require("luasnip.extras.fmt").fmta
                    local rep = require("luasnip.extras").rep
                    local ai = require("luasnip.nodes.absolute_indexer")
                    local snips = require("go.snips")
                    local log = require("go.utils").log
                    local in_test_fn = {
                        show_condition = snips.in_test_function,
                        condition = snips.in_test_function,
                    }

                    local in_test_file = {
                        show_condition = snips.in_test_file_fn,
                        condition = snips.in_test_file_fn,
                    }

                    local in_fn = {
                        show_condition = snips.in_function,
                        condition = snips.in_function,
                    }

                    local not_in_fn = {
                        show_condition = snips.in_func,
                        condition = snips.in_func,
                    }

                    snips.go_err_snippet = function(args, _, _, spec)
                        local err_name = args[1][1]
                        local index = spec and spec.index or nil
                        local msg = spec and spec[1] or ''

                        if spec and spec[2] then
                            err_name = err_name .. spec[2]
                        end

                        if err_name == 'nil' then
                            return ls.sn(index, ls.sn(nil, ls.i(1, 'nil')))
                        end

                        return ls.sn(index, {
                            ls.c(1, {
                                ls.sn(nil, fmt('fmt.Errorf("{}: %w", {})', { ls.i(1, msg), ls.t(err_name) })),
                                ls.t(err_name),
                            }),
                        })
                    end

                    -- stylua: ignore start
                    local snippets = {
                        -- Main
                        luasnip.s(
                            { trig = "main", name = "Main", dscr = "Create a main function" },
                            fmta("func main() {\n\t<>\n}", luasnip.i(0)),
                            not_in_fn
                        ),
                        luasnip.s("ret", {
                                luasnip.t("return "), luasnip.i(1), luasnip.t { "" },
                                luasnip.d(2, snips.make_default_return_nodes, { 1 })
                            },
                            snips.in_fn
                        ),

                        -- If call error
                        luasnip.s(
                            { trig = "ifc", name = "if call", dscr = "Call a function and check the error" },
                            fmt(
                                [[
        {val}, {err1} := {func}({args})
        if {err2} != nil {{
          return {err3}
        }}
        {finally}
      ]], {
                                    val     = luasnip.i(1, { "val" }),
                                    err1    = luasnip.i(2, { "err" }),
                                    func    = luasnip.i(3, { "func" }),
                                    args    = luasnip.i(4),
                                    err2    = rep(2),
                                    err3    = luasnip.d(5, snips.make_return_nodes, { 2 }),
                                    finally = luasnip.i(0),
                                }),
                            snips.in_fn
                        ),

                        -- if err:=call(); err != nil { return err }
                        luasnip.s(
                            {
                                trig = "ifce",
                                name = "if call err inline",
                                dscr =
                                "Call a function and check the error inline"
                            },
                            fmt(
                                [[
        if {err1} := {func}({args}); {err2} != nil {{
          return {err3}
        }}
        {finally}
      ]], {
                                    err1    = luasnip.i(1, { "err" }),
                                    func    = luasnip.i(2, { "func" }),
                                    args    = luasnip.i(3, { "args" }),
                                    err2    = rep(1),
                                    err3    = luasnip.d(4, snips.make_return_nodes, { 1 }),
                                    finally = luasnip.i(0),
                                }),
                            snips.in_fn
                        ),
                        -- If error
                        luasnip.s(
                            {
                                trig = "ife",
                                name = "If error, choose me!",
                                dscr =
                                "If error, return wrapped with dynamic node"
                            },
                            fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
                                luasnip.i(1, "err"),
                                luasnip.d(2, snips.make_return_nodes, { 1 }, { user_args = { { "a1", "a2" } } }),
                                luasnip.i(0),
                            }),
                            in_fn
                        ),

                        -- errors.Wrap
                        luasnip.s(
                            { trig = "wrap", dscr = "fmt.Errof" },
                            fmt([[fmt.Errorf("{}: %w", {})]], {
                                luasnip.i(1, ""),
                                luasnip.i(2, "err"),
                            })
                        ),


                        -- Function
                        luasnip.s(
                            { trig = "fn", name = "Function", dscr = "Create a function or a method" },
                            fmt(
                                [[
        // {name1} {desc}
        func {rec}{name2}({args}) {ret} {{
          {finally}
        }}
      ]], {
                                    name1   = rep(2),
                                    desc    = luasnip.i(5, "description"),
                                    rec     = luasnip.c(1, {
                                        luasnip.t(""),
                                        luasnip.sn(nil, fmt("({} {}) ", {
                                            luasnip.i(1, "r"),
                                            luasnip.i(2, "receiver"),
                                        })),
                                    }),
                                    name2   = luasnip.i(2, "Name"),
                                    args    = luasnip.i(3),
                                    ret     = luasnip.c(4, {
                                        luasnip.i(1, "error"),
                                        luasnip.sn(nil, fmt("({}, {}) ", {
                                            luasnip.i(1, "ret"),
                                            luasnip.i(2, "error"),
                                        })),
                                    }),
                                    finally = luasnip.i(0),
                                }),
                            not_in_fn
                        ),

                        -- for select
                        luasnip.s(
                            { trig = "fsel", dscr = "for select" },
                            fmt([[
for {{
	  select {{
        case {} <- {}:
			      {}
        default:
            {}
	  }}
}}
]], {
                                luasnip.c(1, { luasnip.i(1, "ch"), luasnip.i(2, "ch := ") }),
                                luasnip.i(2, "ch"),
                                luasnip.i(3, "break"),
                                luasnip.i(0, ""),
                            })
                        ),

                        luasnip.s(
                            { trig = "for([%w_]+)", regTrig = true, hidden = true },
                            fmt(
                                [[
for  {} := 0; {} < {}; {}++ {{
  {}
}}
{}
    ]],
                                {
                                    luasnip.d(1, function(_, snip)
                                        return luasnip.sn(1, luasnip.i(1, snip.captures[1]))
                                    end),
                                    rep(1),
                                    luasnip.c(2,
                                        { luasnip.i(1, "num"), luasnip.sn(1,
                                            { luasnip.t("len("), luasnip.i(1, "arr"), luasnip.t(")") }) }),
                                    rep(1),
                                    luasnip.i(3, "// TODO:"),
                                    luasnip.i(4),
                                }
                            ), in_fn
                        ),

                        -- type switch
                        luasnip.s(
                            { trig = "tysw", dscr = "type switch" },
                            fmt([[
switch {} := {}.(type) {{
    case {}:
        {}
    default:
        {}
}}
]], {
                                luasnip.i(1, "v"),
                                luasnip.i(2, "i"),
                                luasnip.i(3, "int"),
                                luasnip.i(4, 'fmt.Println("int")'),
                                luasnip.i(0, ""),
                            })
                        ),

                        -- Nolint
                        luasnip.s(
                            { trig = "nolt", dscr = "ignore linter" },
                            fmt([[// nolint:{}{}]], {
                                luasnip.i(1, "funlen"),
                                luasnip.i(2, ",cyclop"),
                            })
                        ),

                        -- defer recover
                        luasnip.s(
                            { trig = "dfr", dscr = "defer recover" },
                            fmt(
                                [[
        defer func() {{
            if err := recover(); err != nil {{
       	        {}
            }}
        }}()]], {
                                    luasnip.i(1, ""),
                                })
                        ),

                        -- Allocate Slices and Maps
                        luasnip.s(
                            { trig = "mk", name = "Make", dscr = "Allocate map or slice" },
                            fmt("{} {}= make({})\n{}", {
                                luasnip.i(1, "name"),
                                luasnip.i(2),
                                luasnip.c(3, {
                                    fmt("[]{}, {}", { luasnip.r(1, "type"), luasnip.i(2, "len") }),
                                    fmt("[]{}, 0, {}", { luasnip.r(1, "type"), luasnip.i(2, "len") }),
                                    fmt("map[{}]{}, {}",
                                        { luasnip.r(1, "type"), luasnip.i(2, "values"), luasnip.i(3, "len") }),
                                }, {
                                    stored = { -- FIXME: the default value is not set.
                                        type = luasnip.i(1, "type"),
                                    },
                                }),
                                luasnip.i(0),
                            }),
                            in_fn
                        ),

                        luasnip.s(
                            { trig = "hf", name = "http.HandlerFunc", dscr = "http handler" },
                            fmt([[
    func {}(w http.ResponseWriter, r *http.Request) {{
        {}
    }}
]], {
                                luasnip.i(1, "handler"),
                                luasnip.i(2, [[fmt.Fprintf(w, "hello world")"]]),
                            })
                        ),

                        -- Http request with defer close
                        luasnip.s(
                            {
                                trig = 'hreq',
                                name = "http request with defer close",
                                dscr =
                                "create a http request with defer body close"
                            },
                            fmt([[
  {}, {} := http.{}("http://{}:" + {} + "/{}")
	if {} != nil {{
		log.Fatalln({})
	}}
	_ = {}.Body.Close()

    ]], {
                                luasnip.i(1, "resp"),
                                luasnip.i(2, "err"),
                                luasnip.c(3, { luasnip.i(1, "Get"), luasnip.i(2, "Post"), luasnip.i(3, "Patch") }),
                                luasnip.i(4, "localhost"),
                                luasnip.i(5, [["8080"]]),
                                luasnip.i(6, "path"),
                                rep(2),
                                rep(2),
                                rep(1),
                            }
                            ),
                            in_test_fn
                        ),

                        -- Go CMP
                        luasnip.s(
                            { trig = "gocmp", dscr = "Create an if block comparing with cmp.Diff" },
                            fmt(
                                [[
        if diff := cmp.Diff({}, {}); diff != "" {{
        	t.Errorf("(-want +got):\\n%s", diff)
        }}
      ]], {
                                    luasnip.i(1, "want"),
                                    luasnip.i(2, "got"),
                                }),
                            in_test_fn
                        ),

                        -- Require NoError
                        luasnip.s(
                            { trig = "noerr", name = "Require No Error", dscr = "Add a require.NoError call" },
                            luasnip.c(1, {
                                luasnip.sn(nil, fmt("require.NoError(t, {})", { luasnip.i(1, "err") })),
                                luasnip.sn(nil,
                                    fmt('require.NoError(t, {}, "{}")', { luasnip.i(1, "err"), luasnip.i(2) })),
                                luasnip.sn(nil,
                                    fmt('require.NoErrorf(t, {}, "{}", {})',
                                        { luasnip.i(1, "err"), luasnip.i(2), luasnip.i(3) })),
                            }),
                            in_test_fn
                        ),

                        -- Assert equal
                        luasnip.s(
                            { trig = "aeq", name = "Assert Equal", dscr = "Add assert.Equal" },
                            luasnip.c(1, {
                                luasnip.sn(nil,
                                    fmt('assert.Equal(t, {}, {})', { luasnip.i(1, "got"), luasnip.i(2, "want") })),
                                luasnip.sn(nil,
                                    fmt('assert.Equalf(t, {}, {}, "{}", {})',
                                        { luasnip.i(1, "got"), luasnip.i(2, "want"), luasnip.i(3,
                                            "got %v not equal to want"), luasnip.i(
                                            4,
                                            "got") })),
                            }),
                            in_test_fn
                        ),

                        -- Subtests
                        luasnip.s(
                            { trig = "test", name = "Test & Subtest", dscr = "Create subtests and their function stubs" },
                            fmta("func <>(t *testing.T) {\n<>\n}\n\n <>", {
                                luasnip.i(1),
                                luasnip.d(2, snips.create_t_run, ai({ 1 })),
                                luasnip.d(3, snips.mirror_t_run_funcs, ai({ 2 })),
                            }),
                            in_test_file
                        ),

                        -- bench test
                        luasnip.s(
                            { trig = "bench", name = "bench test cases ", dscr = "Create benchmark test" },
                            fmt([[
	    func Benchmark{}(b *testing.B) {{
	        for i := 0; i < b.N; i++ {{
	     	    {}({})
	        }}
	    }}]]
                            , {
                                luasnip.i(1, "MethodName"),
                                rep(1),
                                luasnip.i(2, "args")
                            }),
                            in_test_file
                        ),
                    }

                    log('creating snippet')
                    luasnip.add_snippets("go", snippets)
                    -- stylua: ignore end
                end,
            },
            {
                "onsails/lspkind-nvim",
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
                        mode = 'symbol_text',

                        -- default symbol map
                        -- can be either 'default' (requires nerd-fonts font) or
                        -- 'codicons' for codicon preset (requires vscode-codicons font)
                        --
                        -- default: 'default'
                        preset = 'codicons',

                        -- override preset symbols
                        --
                        -- default: {}
                        symbol_map = {
                            Text = "󰉿",
                            Method = "󰆧",
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
        },
    },
}
