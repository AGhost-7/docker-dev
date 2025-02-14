-- {{{ Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- }}}

vim.opt.foldmethod = "marker"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.g.clipboard = {
    name = 'xclip-nvim',
    copy = {
        ['+'] = {'xclip', '-quiet', '-i', '-selection', 'clipboard'},
        ['*'] = {'xclip', '-quiet', '-i', '-selection', 'primary'},
    },
    paste = {
        ['+'] = {'xclip', '-o', '-selection', 'clipboard'},
        ['*'] = {'xclip', '-o', '-selection', 'primary'},
    }
}

-- {{{ configure plugins
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  checker = { enabled = false },
  change_detection = { enabled = false },
})
--- }}}
