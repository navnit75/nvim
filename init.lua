vim.g.mapleader = " "
require("config.lazy")
require("mason").setup()
-- require("rose-pine").setup({
--   styles = {
--     italic = false,
--   },
-- })
vim.cmd.colorscheme("rose-pine")
vim.opt.termguicolors = true
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
    direction = "vertical",
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
