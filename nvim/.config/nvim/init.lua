vim.cmd('source ~/.vimrc')

-- Put all bookkeeping files in neovim's standard data directory.
vim.o.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.o.undodir = vim.fn.stdpath('data') .. '/undo'
vim.o.directory = vim.fn.stdpath('data') .. '/swap'

-- Show substitutions as you type; no split preview for offscreen subs.
vim.o.inccommand = "nosplit"

-- Load lua/plugins.lua
require("plugins")
