-- =========================
-- Leader
-- =========================
vim.g.mapleader = " "

-- =========================
-- UI / Core Options
-- =========================
local opt = vim.opt

opt.mouse = "a"
opt.ruler = false
opt.guicursor = ""
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true

opt.scrolloff = 10
opt.wrap = true
opt.breakindent = true

vim.g.have_nerd_font = true
vim.g.netrw_banner = 0

-- =========================
-- Indentation
-- =========================
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

opt.autoindent = true
opt.smartindent = true
opt.smarttab = true

-- =========================
-- Search
-- =========================
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- =========================
-- Files
-- =========================
opt.swapfile = false
opt.backup = false

-- =========================
-- Performance
-- =========================
opt.updatetime = 300

-- =========================
-- Autosave
-- =========================
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
	callback = function()
		if vim.bo.modified and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
			vim.cmd("silent write")
		end
	end,
})

-- =========================
-- Keymaps
-- =========================
local map = vim.keymap.set

map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })

map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force Quit" })
map("n", "<leader>wq", "<cmd>wqa<cr>", { desc = "Save & Quit All" })

map("n", "<leader>s", "<cmd>source %<cr>", { desc = "Source file" })

-- Clipboard
map("n", "<leader>cc", '"+yy')
map("v", "<leader>c", '"+y')
map("n", "<leader>xx", '"+dd')
map("v", "<leader>x", '"+d')
map({ "n", "v" }, "<leader>p", '"+p')

-- Search helpers
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<leader>h", ":%s/")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- =========================
-- VS Code Style Tmux Runner
-- =========================

local runner_pane_id = nil

local function is_tmux()
	return vim.env.TMUX ~= nil
end

local function tmux(cmd)
	vim.fn.system(cmd)
end

local function pane_alive(id)
	if not id then return false end
	local res = vim.fn.system("tmux list-panes -F '#{pane_id}'")
	return vim.fn.match(res, id) ~= -1
end

-- create or reuse bottom pane
local function ensure_runner()
	if not is_tmux() then
		print("Not inside tmux")
		return false
	end

	if pane_alive(runner_pane_id) then
		return true
	end

	-- create a persistent bottom pane
	local id = vim.fn.system("tmux split-window -v -l 10 -P -F '#{pane_id}'")
	runner_pane_id = vim.fn.trim(id)

	return true
end

-- VS Code style execution
local function run_in_runner(cmd)
	if not runner_pane_id then return end

	-- kill current running process (like VS Code terminal "stop")
	tmux("tmux send-keys -t " .. runner_pane_id .. " C-c")

	-- clear screen (VS Code-like clean run)
	tmux("tmux send-keys -t " .. runner_pane_id .. " clear Enter")

	-- run command
	tmux("tmux send-keys -t " .. runner_pane_id .. " " .. vim.fn.shellescape(cmd) .. " Enter")
end

-- toggle focus like VS Code terminal toggle
local function toggle_runner_focus()
	if not ensure_runner() then return end

	tmux("tmux select-pane -t " .. runner_pane_id)
	tmux("tmux resize-pane -Z")
end

-- =========================
-- Run current file (VS Code style)
-- =========================

local map = vim.keymap.set

map("n", "<leader>r", function()
	vim.cmd("write")

	local ft = vim.bo.filetype
	local file = vim.fn.expand("%:p")
	local file_no_ext = vim.fn.expand("%:p:r")

	local cmd

	if ft == "python" then
		cmd = "python3 " .. vim.fn.shellescape(file)

	elseif ft == "c" then
		cmd = "gcc "
			.. vim.fn.shellescape(file)
			.. " -o "
			.. vim.fn.shellescape(file_no_ext)
			.. " && "
			.. vim.fn.shellescape(file_no_ext)

	elseif ft == "cpp" then
		cmd = "g++ "
			.. vim.fn.shellescape(file)
			.. " -o "
			.. vim.fn.shellescape(file_no_ext)
			.. " && "
			.. vim.fn.shellescape(file_no_ext)

	elseif ft == "lua" then
		cmd = "lua " .. vim.fn.shellescape(file)

	else
		print("No runner for " .. ft)
		return
	end

	if not ensure_runner() then
		return
	end

	run_in_runner(cmd)
end)

-- VS Code style terminal toggle
map("n", "<leader>t", function()
	toggle_runner_focus()
end, { desc = "Toggle Terminal (VSCode style)" })
