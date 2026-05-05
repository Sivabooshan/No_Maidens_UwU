return {
	"folke/snacks.nvim",
	lazy = false, -- load early (important for UI)

	opts = {
		indent = {
			enabled = true,
			char = "┊", -- you can change to "▏" or "│"
		},

		scope = {
			enabled = true,
			underline = true,
			only_current = true,
		},

		-- 🔔 Advanced notifications
		notifier = {
			enabled = true,
			timeout = 3000, -- how long messages stay
		},

		-- ✍️ Better input UI
		input = {
			enabled = true,
		},
	},

	config = function(_, opts)
		require("snacks").setup(opts)

		-- 🔑 Keymaps

		-- Notification history
		vim.keymap.set("n", "<leader>n", function()
			require("snacks").notifier.show_history()
		end, { desc = "Notification History" })
	end,
}
