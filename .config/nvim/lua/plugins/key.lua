return {
	"NStefan002/screenkey.nvim",
	lazy = false,
	version = "*",
	config = function()
		vim.keymap.set("n", "<leader>sk", "<cmd>Screenkey toggle<cr>", { desc = "Toggle Screenkey" })
	end,
}
