return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",

  opts = {
    options = {
      mode = "buffers",

      -- VS Code style
      separator_style = "thin",
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      numbers = "none",

      -- diagnostics
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = {
          error = " ",
          warning = " ",
        }
        local ret = (diag.error and icons.error .. diag.error .. " " or "")
          .. (diag.warning and icons.warning or "")
        return vim.trim(ret)
      end,

      -- hover
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },

      -- Neo-tree offset (fix sidebar overlap)
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
        },
      },

      -- ✅ SMART CLOSE (FIXED BUG)
      close_command = function(bufnr)
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })

        if #buffers > 1 then
          vim.cmd("BufferLineCycleNext")
          vim.api.nvim_buf_delete(bufnr, { force = false })
        else
          -- delete FIRST, then create new buffer
          vim.api.nvim_buf_delete(bufnr, { force = false })
          vim.cmd("enew")
        end
      end,

      right_mouse_command = function(bufnr)
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })

        if #buffers > 1 then
          vim.cmd("BufferLineCycleNext")
          vim.api.nvim_buf_delete(bufnr, { force = false })
        else
          vim.api.nvim_buf_delete(bufnr, { force = false })
          vim.cmd("enew")
        end
      end,
    },
  },

  config = function(_, opts)
    require("bufferline").setup(opts)

    -- Keymaps (VS Code feel)
    vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

    -- Keyboard close uses SAME logic
    vim.keymap.set("n", "<leader>w", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local buffers = vim.fn.getbufinfo({ buflisted = 1 })

      if #buffers > 1 then
        vim.cmd("BufferLineCycleNext")
        vim.api.nvim_buf_delete(bufnr, { force = false })
      else
        vim.api.nvim_buf_delete(bufnr, { force = false })
        vim.cmd("enew")
      end
    end, { desc = "Close buffer" })
  end,
}
