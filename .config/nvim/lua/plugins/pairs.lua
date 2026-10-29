return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({
                check_ts = true,
                enable_check_bracket_line = false,
            })
            local Rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")
            local ts_conds = require('nvim-autopairs.ts-conds')

            npairs.add_rules({
                Rule("{", "},", "lua")
                    :with_pair(cond.not_after_regex(","))
                    :with_pair(ts_conds.is_ts_node({ "table_constructor" })),
                Rule("'", "',", "lua")
                    :with_pair(cond.not_after_regex(","))
                    :with_pair(ts_conds.is_ts_node({ "table_constructor" })),
                Rule('"', '",', "lua")
                    :with_pair(cond.not_after_regex(","))
                    :with_pair(ts_conds.is_ts_node({ "table_constructor" })),
                Rule('```', '```', "markdown"),
            })
        end
    }
}
