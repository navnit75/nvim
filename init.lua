vim.g.mapleader = " "
require("config.lazy")
require("mason").setup()
-- require("rose-pine").setup({
--     styles = {
--         italic = true,
--     },
-- })
-- vim.cmd.colorscheme('OceanicNext')
-- vim.cmd([[
--                 hi Normal guibg=NONE ctermbg=NONE
--                 hi LineNr guibg=NONE ctermbg=NONE
--                 hi SignColumn guibg=NONE ctermbg=NONE
--                 hi EndOfBuffer guibg=NONE ctermbg=NONE
--         ]])
-- vim.cmd.colorscheme('rose-pine')

-- AYU SETUP
-- require('ayu').setup({
--     mirage = false,
--     terminal = true,
--     overrides = {}
-- })
-- vim.cmd.colorscheme("ayu")
vim.cmd.colorscheme("moonfly")
vim.opt.termguicolors = true

vim.opt.formatoptions:remove("c")
vim.opt.formatoptions:remove("r")
vim.opt.formatoptions:remove("o")

-- Set cursor to block in all modes
-- vim.opt.guicursor = ""
-- Some configurable settings
vim.opt.guicursor = {
    "n-v-c:block-Cursor", -- Normal, visual, command: block with normal cursor color
    "i-ci-ve:block-rCursor", -- Insert modes: block with insert cursor color
    "r-cr:block-iCursor", -- Replace modes: block with replace cursor color
}
-- Or if you want more control over different modes:
-- vim.opt.guicursor = {
--     "n-v-c:block", -- Normal, visual, command-line: block cursor
--     "i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor
--     "r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor
--     "o:hor50", -- Operator-pending: horizontal bar cursor
--     "a:blinkwait700-blinkoff400-blinkon250", -- All modes: blink settings
-- }

-- Color
-- vim.api.nvim_set_hl(0, "Cursor", { bg = "#f6f8fa", fg = "#24292f" })-- In my case this is decided by
-- vim.api.nvim_set_hl(0, "Cursor", { bg = "#ecf0f1", fg = "#2c3e50" }) -- Normal Mode Gray cursor with white text
-- vim.api.nvim_set_hl(0, "Cursor", { bg = "#ffffff", fg = "#ffffff" }) -- Normal mode: white
vim.api.nvim_set_hl(0, "iCursor", { bg = "#ff6b6b", fg = "#ffffff" }) -- Replace mode: red
vim.api.nvim_set_hl(0, "rCursor", { bg = "#4ecdc4", fg = "#ffffff" }) -- Insert mode: teal

-- Configuration which character to show and how
vim.opt.list = true
vim.opt.listchars = {
    space = "•",
    trail = "•",
}

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>", {})
local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = { "lua", "javascript", "typescript", "java", "cpp", "python" },
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = { enable = true },
})

require("toggleterm").setup({
    size = 100,
    open_mapping = [[<C-t>]],
    direction = "float",
    float_opts = {
        border = "curved",
        width = 150,
        height = 30,
    },
    shade_terminals = true,
    terminal_mappings = true,
    insert_mappings = true,
    start_in_insert = true,
    on_create = function(term)
        vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { buffer = 0 })
    end,
})

-- CALLING JDTLS
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function(args)
        require("jdtls.jdtls_setup").setup()
    end,
})

-- CONFORM
local conform = require("conform")
conform.setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        python = { "isort", "black" },
    },
})

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
    })
end, { desc = "Format file or range (in visual mode)" })
