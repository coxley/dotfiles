local M = {}

function M.run(opts)
    opts = opts or {}

    local blame = opts.blame or false
    local open = opts.open or false

    -- If called from a user command with :range, opts has line1/line2
    local line1 = opts.line1 or vim.fn.line(".")
    local line2 = opts.line2 or line1

    local line_range
    if line2 > line1 then
        line_range = string.format("%d-%d", line1, line2)
    else
        line_range = string.format("%d", line1)
    end

    local file_path = vim.fn.expand("%:p")
    local file_pos = string.format("%s:%s", file_path, line_range)

    local cmd
    if blame then
        cmd = string.format("link2code --blame %s 2> /dev/null", file_pos)
    else
        cmd = string.format("link2code %s 2> /dev/null", file_pos)
    end

    local link = vim.fn.system(cmd)
    link = link:gsub("%s*$", "")

    vim.fn.setreg("+", link)
    vim.cmd.redraw()
    vim.api.nvim_echo({ { "Copied to clipboard: " .. link, "None" } }, false, {})
    if open and link ~= "" then
        vim.ui.open(link)
    end
    return link
end

return M
