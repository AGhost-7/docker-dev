local os = require('os')

if os.getenv("TMUX") then
  vim.g.slime_default_config = {
    target_pane = ":.1",
    socket_name = "0"
  }
end

vim.g.slime_no_mappings = true
vim.g.slime_target = "tmux"

-- skip certain file types
vim.g.EditorConfig_exclude_patterns = {"fugitive://.*", "scp://.*"}

-- faster hover for diagnostics (default is 4000ms)
vim.o.updatetime = 300

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      scope = "cursor",
    })
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local map = vim.keymap.set

return {
    -- color theme
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            vim.cmd([[colorscheme gruvbox]])
        end,
        priority = 1000,
    },
    {'nvim-tree/nvim-web-devicons'},
    -- bottom status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require('lualine').setup({
                options = { theme = "gruvbox" }
            })
        end,
    },
    -- top status line
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require('bufferline').setup({
                options = {
                    numbers = "buffer_id"
                }
            })
        end,
    },
    -- dims code
    {"junegunn/limelight.vim"},
    -- minimalist mode
    {'junegunn/goyo.vim'},
    -- file tree browser
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup({})
            vim.cmd('abbreviate t NvimTreeOpen')
        end,
    },
    -- file finder and much more
    {
        "nvim-telescope/telescope.nvim",
        branch = '0.1.x',
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function()
            local builtin = require('telescope.builtin')
            map('n', '<leader>ff', builtin.find_files, {})
            map('n', '<leader>fg', builtin.live_grep, {})
            map('n', '<leader>fb', builtin.buffers, {})
            map('n', '<leader>fh', builtin.help_tags, {})
            map('n', '<leader>ft', builtin.builtin, {})
        end,
    },
    -- partial file diffs
    {
        "AndrewRadev/linediff.vim",
        config = function()
            vim.cmd('abbreviate ldiffthis Linediff')
            vim.cmd('abbreviate ldiffoff LinediffReset')
        end,
    },
    -- terminal integration
    {
        "jpalardy/vim-slime",
        config = function()
            map('n', '<c-s>', '<Plug>SlimeLineSend', {})
            map('x', '<c-s>', '<Plug>SlimeRegionSend', {})
        end,
    },
    -- project-specific editor configuration
    {"editorconfig/editorconfig-vim"},
    -- Adds the ability to close all except the current buffer
    {
        "vim-scripts/BufOnly.vim",
        config = function()
            vim.cmd('abbreviate bdo BufOnly')
        end,
    },
    -- Allows you to run git commands from vim
    {"tpope/vim-fugitive"},
    -- Github integration for fugitive
    {"tpope/vim-rhubarb"},
    -- browse file history
    {"junegunn/gv.vim"},
    -- git integration
    {'tpope/vim-fugitive'},
    -- Github integration for fugitive
    {'tpope/vim-rhubarb'},
    -- diagnostics list
    {
        'folke/trouble.nvim',
        config = function()
            map('n', '<leader>t', function() require("trouble").open("diagnostics") end)
        end,
    },
    -- autocomplete and stuff
    {
        "neovim/nvim-lspconfig",
        dependencies = "hrsh7th/cmp-nvim-lsp",
        opts = {
            lua_ls = {
              on_init = function(client)

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                  runtime = {
                    version = 'LuaJIT'
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME
                    }
                  }
                })
              end,
              settings = {
                Lua = {}
              }
            }
        },
        keys = {
            { "gd", vim.lsp.buf.definition },
            { "gD", vim.lsp.buf.references },
            { "gi", vim.lsp.buf.implementation },
            { "K", vim.lsp.buf.hover, },
        },
        config = function(_, opts)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            for name, cfg in pairs(opts) do
                local base = vim.lsp.config[name] or {}
                vim.lsp.config(name, vim.tbl_deep_extend("force", {}, base, cfg, {
                    capabilities = capabilities,
                }))

                vim.lsp.enable(name)
            end
        end,
    },
    -- lsp installer
    {
        "williamboman/mason.nvim",
        config = function(_, opts)
            require("mason").setup(opts)
        end,
    },
    -- mason integration with lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls" },
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end,
    },
    -- autocomplete
    {
        "hrsh7th/nvim-cmp",
        config = function(_, _)
            local cmp = require("cmp")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end

            cmp.setup({
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }),
                mapping = {
                    ['<C-Space>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },
                    ['<Tab>'] = function(fallback)
                        if not cmp.select_next_item() then
                            if vim.bo.buftype ~= 'prompt' and has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end
                    end,
                    ['<S-Tab>'] = function(fallback)
                        if not cmp.select_prev_item() then
                            if vim.bo.buftype ~= 'prompt' and has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end
                    end,
                },
            })

        end,
    },
    -- autocomplete source for lsp
    {"hrsh7th/cmp-nvim-lsp"},
}
