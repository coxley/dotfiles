local options = { noremap = true, silent = true }
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                opts = {},
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
                dependencies = { "mfussenegger/nvim-dap" }
            },
            {
                "leoluz/nvim-dap-go",
                opts = {},
                dependencies = { "mfussenegger/nvim-dap" },
            },
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
        keys = {
            { '<leader>db', ":lua require'dap'.toggle_breakpoint()<CR>", desc = "DAP: Toggle Breakpoint", unpack(options) },
            { '<leader>dc', ":lua require'dap'.continue()<CR>",          desc = "DAP: Continue",          unpack(options) },
            { '<leader>dn', ":lua require'dap'.step_over()<CR>",         desc = "DAP: Step Over",         unpack(options) },
            { '<leader>di', ":lua require'dap'.step_into()<CR>",         desc = "DAP: Step Into",         unpack(options) },
            { '<leader>dr', ":lua require'dap'.repl()<CR>",              desc = "DAP: REPL",              unpack(options) },
        },
    },
}
