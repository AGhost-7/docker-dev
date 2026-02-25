return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
        opts = function(_, opts)
            opts.jedi_language_server = {
                before_init = function(init_params, _)
                    local interpreter_path = vim.fn.fnamemodify("./.venv/bin/python", ":p")
                    if vim.fn.executable(interpreter_path) then
                        init_params.initializationOptions = init_params.initializationOptions or {}
                        init_params.initializationOptions.workspace = {
                            environmentPath = interpreter_path
                        }
                    end
                end
            }
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "jedi_language_server")
        end,
    }
}
