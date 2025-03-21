-- Tabs as 4 spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
-- Relative line numbers
vim.cmd("set rnu")

-- Center screen on half-page scrolls
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true})
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true})

require("config.lazy")
