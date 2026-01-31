vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    command = "silent !zellij action switch-mode normal"
})

return {
    {
    'https://github.com/fresh2dev/zellij.vim',
    -- Pin version to avoid breaking changes.
    -- tag = '0.3.*',
    lazy = false,
    keys = {
        { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left"  } },
        { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down"  } },
        { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up"    } },
        { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
    },
    init = function()
        -- Options:
        -- vim.g.zelli_navigator_move_focus_or_tab = 1
        -- vim.g.zellij_navigator_no_default_mappings = 1
    end,
    }
}
