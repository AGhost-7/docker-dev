return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
        opts = {
          terraformls = {},
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "terraformls")
        end,
    }
}
