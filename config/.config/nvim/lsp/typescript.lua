-- TypeScript/JavaScript LSP configuration
if vim.fn.executable('typescript-language-server') == 1 then
  return {
    name = 'ts_ls',
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    settings = {}
  }
end

return nil