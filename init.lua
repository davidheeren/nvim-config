-- requires neovim 12 (nightly version on windows)
-- pack update, 'gra' to remove package

vim.cmd.colorscheme("unokai")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.confirm = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.g.mapleader = " "

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- source: https://www.reddit.com/r/neovim/comments/1lyuz6k/autocmd_to_restore_cursor_position_after_saving/
vim.api.nvim_create_autocmd("BufWinEnter", {
    desc = "Auto jump to last position",
    group = vim.api.nvim_create_augroup("auto-last-position", { clear = true }),
    callback = function(args)
        local position = vim.api.nvim_buf_get_mark(args.buf, [["]])
        local winid = vim.fn.bufwinid(args.buf)
        pcall(vim.api.nvim_win_set_cursor, winid, position)
    end,
})

-- clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>e", vim.diagnostic.setqflist)

-- yank to system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v", "x" }, "<leader>Y", '"+Y', { remap = true })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d')
vim.keymap.set({ "n", "v", "x" }, "<leader>D", '"+D')
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v", "x" }, "<leader>P", '"+P')

local function toggle_quickfix()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    if qf_winid > 0 then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end

vim.keymap.set("n", "<Leader>c", toggle_quickfix, { desc = "Toggle Quickfix List" })

-- source: https://gist.github.com/smnatale/5372e4ef64b96e62a961eafc71cb670d
vim.pack.add {
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/Saghen/blink.cmp" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
}

local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep)
vim.keymap.set("n", "<leader>sb", builtin.buffers)

require('mason').setup()
require('mason-lspconfig').setup()

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = {
                    "vim",
                    "require",
                },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
    keymap = {
        preset = 'super-tab'
    },
    fuzzy = {
        implementation = "lua",
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
})
