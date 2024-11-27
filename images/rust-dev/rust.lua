
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {"williamboman/mason-lspconfig.nvim"},
        opts = {
          rust_analyzer = {}
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "rust_analyzer")
        end,
    }
}
