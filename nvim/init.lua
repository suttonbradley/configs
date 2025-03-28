-- Tabs as 4 spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
-- Relative line numbers
vim.cmd("set rnu")
vim.cmd("set nu")

-- Center screen on half-page scrolls
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "<home>", "<S-^>", { noremap = true })

-- Alias qa and qa! (quicker to type)
vim.cmd("cnorea qq qa")
vim.cmd("cnorea qqq qa!")

require("config.lazy")
