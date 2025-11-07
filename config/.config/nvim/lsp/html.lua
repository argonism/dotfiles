-- HTML LSP configuration
if vim.fn.executable('vscode-html-language-server') == 1 then
  return {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_markers = { 'package.json', '.git' },
    settings = {}
  }
end

return nil