-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = vim.g.mapleader or ' '
vim.api.nvim_set_keymap('n', '<leader> Ab', ':lua AiderBackground()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader> Ab3', ':lua AiderBackground("-3")<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>  Ao', ':lua AiderOpen()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader> Ao3', ':lua AiderOpen("-3")<CR>', {noremap = true, silent = true})
