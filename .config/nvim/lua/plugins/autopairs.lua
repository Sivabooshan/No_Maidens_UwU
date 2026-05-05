return{
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require('nvim-autopairs')
            autopairs.setup({
                check_ts = true,  -- Treesitter integration (smarter)
                disable_filetype = { "TelescopePrompt" },
                fast_wrap = {
                    map = "<M-e>",  -- Alt+e to wrap quickly
                    chars = { "{", "[", "(", '"', "'" },
                    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                    offset = 0,
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_coms = true,
                    condition = function() end,
                    highlight = "PmenuSel",
                    jump = 0
                }
            })    
            -- Integrate with cmp (auto-closes after selection)
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-treesitter/nvim-treesitter",  -- Optional: smarter pairing
        },
    },
}
