local dapPlugins = {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            local ui = require("dapui")

            require("dapui").setup()
            require("dap-go").setup()

            dap.listeners.before.attach["dapui_config"] = function()
                ui.open()
            end
            dap.listeners.before.launch["dapui_config"] = function()
                ui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                ui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                ui.close()
            end

            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)
            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)

            dap.configurations.python = { {
                type = "python",
                request = "attach",
                connect = {
                    port = 5678,
                    host = function()
                        return vim.fn.input("Host: ")
                    end,
                },
                mode = "remote",
                name = "Remote Python: Attach",
                cwd = vim.fn.getcwd(),
                pathMappings = {
                    {
                        localRoot = vim.fn.getcwd(),
                        remoteRoot = function()
                            return vim.fn.input("Remote root: ")
                        end,
                    },
                },
            } }
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, _)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/lib/python"
            require("dap-python").setup(path)
        end,
    },
}
return dapPlugins
