require("plugins")

vim.cmd([[colorscheme tokyonight]])

-- Leader Key
vim.g.mapleader = ","

-- File settings
vim.o.hidden = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.wrap = false
vim.o.scrolloff = 2
vim.o.clipboard = "unnamedplus"

-- Tabbing
vim.o.smarttab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.copyindent = true
vim.o.autoindent = true

-- Display
vim.o.termguicolors = true
vim.o.number = true
vim.o.cursorline = true
