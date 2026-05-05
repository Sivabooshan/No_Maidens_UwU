return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    require("neo-tree").setup({
      window = {
        width = 30,
      },
    })

    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle filesystem reveal left<CR>")
  end,
}
