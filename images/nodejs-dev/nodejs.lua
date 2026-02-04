return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
        opts = function(_, opts)
            opts.ts_ls = {}
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "ts_ls")
        end,
    }
}
