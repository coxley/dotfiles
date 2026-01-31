local function wrap()
    local normal_surround = require("nvim-surround").normal_surround
    local get_input = require("nvim-surround.config").get_input
    local get_selection = require("nvim-surround.config").get_selection

    -- Example:
    --
    -- someFunc(a, b, c)
    -- ^ (cursor)
    --
    -- Wrap with function: must
    --
    -- must(someFunc(a, b, c))
    local left = get_input("Wrap with function: ")
    if not left then
        return
    end
    if not left:find("%($") then
        left = left .. "("
    end

    -- Allow for "func1", "func1(func2", and "func1(func2("
    local depth = 0
    for _ in left:gmatch("%(") do
        depth = depth + 1
    end
    local right = string.rep(")", depth)
    local delimiters = { { left }, { right } }

    local selection = get_selection({
        query = {
            capture = "@call.outer",
            type = "textobjects",
        }
    })
    if not selection then
        vim.notify("selection not found", vim.log.levels.WARN)
        return
    end

    -- normal_surround doesn't expect us to call it with a selection, I guess, so init
    -- this to avoid an error.
    local cache = require("nvim-surround.cache")
    cache.normal = { line_mode = false, count = vim.v.count1 }
    require("nvim-surround").normal_curpos = require("nvim-surround.buffer").get_curpos()

    normal_surround({
        delimiters = delimiters,
        selection = selection,
        line_mode = false,
    })
end

return {
    "AndrewRadev/splitjoin.vim",
    {
        "kylechui/nvim-surround",
        lazy = false,
        keys = {
            { "<leader>wf", wrap, noremap = true, silent = true },
        },
        opts = {},
    },
}
