require("config.base")
require("config.lazy")
require("config.lsp")

-- Enable LSP servers
vim.lsp.enable({'python', 'lua', 'html', 'typescript'})
