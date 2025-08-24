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
        width = 100,
        height = 20,
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
