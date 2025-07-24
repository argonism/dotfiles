vim.scriptencoding = "utf-8"

vim.cmd("language en_US")

-- LINE NUMBER
vim.opt.number = true

-- KEY MAPPING
vim.g.mapleader = " "
vim.api.nvim_set_keymap("i", "jj", "<esc>", { noremap = true })
vim.api.nvim_set_keymap("i", "kk", "<esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":bprev<CR>", {noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":bnext<CR>", {noremap = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":bd<CR>", {noremap = true })
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {noremap = true })

-- INDENTATION AND FORMATTING
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true

-- SEARCH AND HIGHLIGHTING
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- CURSORLINE AND CURSORCOLUMN

-- MOUSE AND SPELLCHECK
vim.opt.mouse = "a"
vim.opt.spell = true
vim.opt.spelllang = { "en", "cjk" }

-- ENABLE TRUE COLOR SUPPORT
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
