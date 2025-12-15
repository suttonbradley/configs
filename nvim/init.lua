-- Set leader key for remappings later
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Harpoon - load default list
vim.schedule(function()
  require("harpoon"):list("default")
end)


-- Tabs as 4 spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
-- Relative line numbers
vim.cmd("set rnu")
vim.cmd("set nu")

-- Remap + center screen on half-page scrolls
vim.keymap.set("n", "<C-y>", "<C-u>zz", {
    noremap = true
})
vim.keymap.set("n", "<C-h>", "<C-d>zz", {
    noremap = true
})

-- Fix home in certain modes
vim.keymap.set({ "n", "v" }, "<home>", "<S-^>", {
    noremap = true
})

-- Move across buffers
vim.keymap.set("n", "<A-h>", "<C-w>h", {
    noremap = true
})
vim.keymap.set("n", "<A-j>", "<C-w>j", {
    noremap = true
})
vim.keymap.set("n", "<A-k>", "<C-w>k", {
    noremap = true
})
vim.keymap.set("n", "<A-l>", "<C-w>l", {
    noremap = true
})
vim.keymap.set("n", "<A-H>", "<cmd>vert res -8<cr>", {
    noremap = true
})
vim.keymap.set("n", "<A-L>", "<cmd>vert res +8<cr>", {
    noremap = true
})
vim.keymap.set("n", "<A-K>", "<cmd>res -8<cr>", {
    noremap = true
})
vim.keymap.set("n", "<A-J>", "<cmd>res +8<cr>", {
    noremap = true
})
-- Undo/Redo
vim.keymap.set("n", "<C-z>", "<cmd>undo<cr>", {
    noremap = true
})
vim.keymap.set("n", "<C-S-z>", "<cmd>redo<cr>", {
    noremap = true
})
-- yank to clipboard
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set({ "v", "x" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })

-- Alias qa and qa! (quicker to type)
vim.cmd("cnorea qq qa")
vim.cmd("cnorea qqq qa!")

-- Disable mouse
vim.cmd("set mouse=")

-- Set splits to go right and below
vim.cmd("set splitright")
vim.cmd("set splitbelow")

-- Disable .editorconfig files enforced on repos
-- This *can* be helpful, but sometimes causes large changes to whitespace that can get you git blame'd
vim.g.editorconfig = false

-- Make searching fwd/back also center the screen
vim.keymap.set('n', 'n', function()
    vim.cmd('normal! n')
    vim.cmd('normal! zz')
end, { noremap = true, silent = true })
vim.keymap.set('n', 'N', function()
    vim.cmd('normal! N')
    vim.cmd('normal! zz')
end, { noremap = true, silent = true })

-- Vim session settings recommended on auto-session github page
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Diagnostics in virtual lines
vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
require("config.lazy")
require("config.harpoon")
-- Remove some annoying format options (comment wrapping, etc.)
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        vim.schedule(function()
            vim.opt.formatoptions:remove({ "c", "r", "o" })
        end)
    end,
})



