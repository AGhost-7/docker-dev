return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
        opts = function(_, opts)
          opts.jdtls = {}
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "jdtls")
        end,
    }
}
