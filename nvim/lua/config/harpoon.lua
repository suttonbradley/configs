-- From harpoon README: https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#basic-setup
local harpoon = require("harpoon")

harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    }
})

-- Open harpoon item in vsplit from menu
vim.api.nvim_create_autocmd("FileType", {
    pattern = "harpoon",
    callback = function()
        vim.keymap.set("n", "<leader>v", function()
            local line = vim.fn.line(".")
            vim.cmd("close")
            vim.cmd("vsplit")
            harpoon:list("default"):select(line)
        end, { buffer = true, noremap = true })
        vim.keymap.set("n", "<leader>h", function()
            local line = vim.fn.line(".")
            vim.cmd("close")
            vim.cmd("split")
            harpoon:list("default"):select(line)
        end, { buffer = true, noremap = true })
    end,
})

vim.keymap.set("n", "<leader>ha", function() harpoon:list("default"):add() end)
-- Done below in telescope section
vim.keymap.set("n", "<leader>hp", function() harpoon.ui:toggle_quick_menu(harpoon:list("default")) end,
    { desc = "Open harpoon window" })

-- Edited by Sutton for qwerty;
vim.keymap.set("n", "<C-j>", function() harpoon:list("default"):select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list("default"):select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list("default"):select(3) end)
vim.keymap.set("n", "<C-u>", function() harpoon:list("default"):select(4) end)
vim.keymap.set("n", "<C-i>", function() harpoon:list("default"):select(5) end)
vim.keymap.set("n", "<C-o>", function() harpoon:list("default"):select(6) end)
vim.keymap.set("n", "<C-p>", function() harpoon:list("default"):select(7) end)

-- Highlight current file in list
local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
