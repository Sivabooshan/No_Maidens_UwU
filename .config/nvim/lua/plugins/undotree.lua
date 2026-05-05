return {
	"mbbill/undotree",
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
	},
	config = function()
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_TreeNodeShape = "▢"
		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_DiffAutoOpen = 1
		vim.g.undotree_SplitWidth = 40
	end,
}
