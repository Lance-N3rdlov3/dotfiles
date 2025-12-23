-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remap 'jj' to Esc in Insert mode
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
-- Remap 'kk' to Esc in Insert mode
vim.keymap.set("i", "kk", "<Esc>", { noremap = true, silent = true })
