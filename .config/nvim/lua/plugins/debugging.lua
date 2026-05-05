return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- DAP UI
			dapui.setup()

			-- Auto UI listeners
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.after.event_terminated["dapui_config"] = function()
				vim.schedule(function()
					dapui.close()
				end)
			end
			dap.listeners.after.event_exited["dapui_config"] = function()
				vim.schedule(function()
					dapui.close()
				end)
			end

			-- GDB ADAPTER
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}

			-- AUTO-DETECT EXECUTABLE
			local function get_exe()
				local cwd = vim.fn.getcwd()
				local fname = vim.fn.expand("%:t:r")
				local exe = cwd .. "/" .. fname
				return vim.fn.filereadable(exe) == 1 and exe or vim.fn.input("Path to exe: ", exe, "file")
			end

			dap.configurations.cpp = {
				{
					name = "Launch C++ (auto)",
					type = "gdb",
					request = "launch",
					program = get_exe,
					args = {},
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Attach C++ process",
					type = "gdb",
					request = "attach",
					program = get_exe,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
			}

			-- KEYS
			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end, { desc = "Continue" })
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end, { desc = "Step Over" })
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, { desc = "Step Into" })
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end, { desc = "Step Out" })
			vim.keymap.set("n", "<Leader>b", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>dr", function()
				dap.repl.open()
			end, { desc = "DAP REPL" })
		end,
	},
}
