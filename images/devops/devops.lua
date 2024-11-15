return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
        opts = {
          terraformls = {},
          ansiblels = {},
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "terraformls")
            table.insert(opts.ensure_installed, "ansiblels")
        end,
    }
}
