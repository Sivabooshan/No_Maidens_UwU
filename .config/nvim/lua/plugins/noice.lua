return {
  "folke/noice.nvim",
  event = "VeryLazy",

  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = {
    -- LSP UI improvements
    lsp = {
      progress = { enabled = true },
      hover = { enabled = true },
      signature = { enabled = true },

      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },

    -- Filter annoying messages
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },

    -- UI presets (VS Code-like feel)
    presets = {
      bottom_search = false,        -- center search
      command_palette = true,       -- cmdline + popupmenu together
      long_message_to_split = true, -- large messages in split
      lsp_doc_border = true,        -- bordered hover docs
    },

    -- Command line UI
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },

    -- Messages
    messages = {
      enabled = true,
      view = "notify",
    },

    -- Popup menu
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
  },

  keys = {
    { "<leader>sn", "", desc = "+noice" },

    -- redirect cmdline
    {
      "<S-Enter>",
      function()
        require("noice").redirect(vim.fn.getcmdline())
      end,
      mode = "c",
      desc = "Redirect Cmdline",
    },

    -- message history
    {
      "<leader>snl",
      function() require("noice").cmd("last") end,
      desc = "Noice Last Message",
    },
    {
      "<leader>snh",
      function() require("noice").cmd("history") end,
      desc = "Noice History",
    },
    {
      "<leader>sna",
      function() require("noice").cmd("all") end,
      desc = "Noice All",
    },
    {
      "<leader>snd",
      function() require("noice").cmd("dismiss") end,
      desc = "Dismiss All",
    },
    {
      "<leader>snt",
      function() require("noice").cmd("pick") end,
      desc = "Noice Picker",
    },

    -- scroll LSP hover
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end,
      silent = true,
      expr = true,
      mode = { "i", "n", "s" },
      desc = "Scroll Forward",
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end,
      silent = true,
      expr = true,
      mode = { "i", "n", "s" },
      desc = "Scroll Backward",
    },
  },

  config = function(_, opts)
    -- clear lazy.nvim install messages
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end

    require("noice").setup(opts)

    -- use notify as default UI
    vim.notify = require("notify")
  end,
}
