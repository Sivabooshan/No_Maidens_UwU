vim.opt.mouse = "a"
vim.opt.ruler = false
vim.g.mapleader = " "
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.smartindent = true

-- Search configs
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep 8 lines visible above/below the cursor
vim.opt.scrolloff = 8
vim.opt.wrap = true
vim.opt.breakindent = true

-- File Handling
vim.opt.swapfile = false
vim.opt.backup = false

-- Nerd Font Support
vim.g.have_nerd_font = true
vim.g.netrw_banner = 0

-- Some essentials
vim.keymap.set("n", "<leader>q", "<CMD>:q<CR>")
vim.keymap.set("n", "<leader>Q", "<CMD>:q!<CR>")
vim.keymap.set("n", "<leader>wq", "<CMD>:wqa<CR>")
vim.keymap.set("n", "<leader>s", "<CMD>:source %<CR>")
vim.keymap.set("n", "<leader>U", "<CMD>:lua vim.pack.update()<CR>")

-- Clipboard opts
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>dd", '"+dd')
vim.keymap.set("v", "<leader>d", '"+d')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

-- Clear search highlight with <Esc>
vim.keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR>")
vim.keymap.set("n", "<leader>h", ":%s/")

-- Keep cursor centered when navigating search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Autosave
vim.opt.updatetime = 300

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
            vim.cmd("silent write")
        end
    end,
})

-- Run current file
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("write")

    local ft = vim.bo.filetype
    local file = vim.fn.expand("%")
    local file_no_ext = vim.fn.expand("%:r")

    if ft == "python" then
        vim.cmd("!python3 " .. file)

    elseif ft == "c" then
        vim.cmd("!gcc " .. file .. " -o " .. file_no_ext .. " && ./" .. file_no_ext)

    elseif ft == "cpp" then
        vim.cmd("!g++ " .. file .. " -o " .. file_no_ext .. " && ./" .. file_no_ext)

    elseif ft == "lua" then
        vim.cmd("luafile " .. file)

    else
        print("No runner for " .. ft)
    end
end)
