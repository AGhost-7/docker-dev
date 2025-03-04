
local map = vim.keymap.set

local virtualenv_path = nil

local stat = vim.uv.fs_stat("./pyproject.toml")
if stat and stat.type == 'file' then
    vim.api.nvim_echo({ { "pyproject file exists" } }, true, {})
    local out = vim.fn.system({"poetry", "env", "info", "-p"})
    vim.api.nvim_echo({ { "out", out } }, true, {})
    if vim.v.shell_error == 0 then
        vim.api.nvim_echo({ { "virtualenv_path set" } }, true, {})
        virtualenv_path = out
    end
else
    stat = vim.uv.fs_stat("./.env")
    if stat then
        virtualenv_path = vim.uv.cwd() .. "/.env"
    end
end

vim.api.nvim_echo({ { "path", virtualenv_path } }, true, {})

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
        opts = {
          jedi_language_server = {
            before_init = function(init_params, _)
                if virtualenv_path then
                    init_params.initializationOptions.workspace = {
                        environmentPath = virtualenv_path .. '/bin/python',
                    }
                end
            end,
          }
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "jedi_language_server")
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            map('n', '<F5>', function() require('dap').continue() end)
            map('n', '<F10>', function() require('dap').step_over() end)
            map('n', '<F11>', function() require('dap').step_into() end)
            map('n', '<F12>', function() require('dap').step_out() end)
            map('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
            map('n', '<Leader>B', function() require('dap').set_breakpoint() end)
            map('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            map('n', '<Leader>dr', function() require('dap').repl.open() end)
            map('n', '<Leader>dl', function() require('dap').run_last() end)
            map({'n', 'v'}, '<Leader>dh', function()
              require('dap.ui.widgets').hover()
            end)
            map({'n', 'v'}, '<Leader>dp', function()
              require('dap.ui.widgets').preview()
            end)
            map('n', '<Leader>df', function()
              local widgets = require('dap.ui.widgets')
              widgets.centered_float(widgets.frames)
            end)
            map('n', '<Leader>ds', function()
              local widgets = require('dap.ui.widgets')
              widgets.centered_float(widgets.scopes)
            end)
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {"mfussenegger/nvim-dap"},
        config = function()
            if virtualenv_path then
                require("dap-python").setup(virtualenv_path .. '/bin/python')
            end
        end,
    },
}
