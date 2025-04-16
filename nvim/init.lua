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

-- Fix home in certain modes
vim.keymap.set({ "n", "v" }, "<home>", "<S-^>", { noremap = true })

-- Move across buffers
vim.keymap.set("n", "<A-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<A-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<A-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<A-l>", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<A-H>", "<cmd>vert res -8<cr>", { noremap = true })
vim.keymap.set("n", "<A-L>", "<cmd>vert res +8<cr>", { noremap = true })
vim.keymap.set("n", "<A-K>", "<cmd>res -8<cr>", { noremap = true })
vim.keymap.set("n", "<A-J>", "<cmd>res +8<cr>", { noremap = true })

-- Alias qa and qa! (quicker to type)
vim.cmd("cnorea qq qa")
vim.cmd("cnorea qqq qa!")

vim.cmd("set mouse=")

-- Vim session settings recommended on auto-session github page
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("config.lazy")
