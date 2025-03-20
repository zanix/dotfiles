-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.mapleader = " "

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.swapfile = false

vim.opt.autoindent = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.backup = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.breakindent = true
vim.opt.cmdheight = 1
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.inccommand = "split"
vim.opt.laststatus = 3
vim.opt.mouse = "a"
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.scrolloff = 10
vim.opt.shell = "fish"
vim.opt.shiftwidth = 2
vim.opt.showcmd = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "cursor"
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = 2
vim.opt.title = true
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.wrap = false -- No Wrap lines

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

if vim.fn.has("nvim-0.8") == 1 then
	vim.opt.cmdheight = 0
end

vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"