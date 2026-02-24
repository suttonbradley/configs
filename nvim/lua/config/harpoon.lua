-- From harpoon README: https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#basic-setup
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()

-- Open harpoon item in vsplit from menu
vim.api.nvim_create_autocmd("FileType", {
    pattern = "harpoon",
    callback = function()
        vim.keymap.set("n", "<leader>sv", function()
            local line = vim.fn.line(".")
            vim.cmd("close")
            vim.cmd("vsplit")
            harpoon:list():select(line)
        end, { buffer = true, noremap = true })
        vim.keymap.set("n", "<leader>sh", function()
            local line = vim.fn.line(".")
            vim.cmd("close")
            vim.cmd("split")
            harpoon:list():select(line)
        end, { buffer = true, noremap = true })
    end,
})

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hp", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Open harpoon window" })

-- Edited by Sutton for qwerty;
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-u>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-i>", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<C-o>", function() harpoon:list():select(6) end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():select(7) end)

-- Highlight current file in list
local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
