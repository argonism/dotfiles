-- Python LSP configuration with priority order
local python_lsp_priority = {
  {
    name = 'pyright',
    cmd = { 'pyright-langserver', '--stdio' },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    }
  },
  {
    name = 'pylsp',
    cmd = { 'pylsp' },
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = { enabled = false },
          mccabe = { enabled = false },
          pyflakes = { enabled = false },
          flake8 = { enabled = true },
        },
      },
    }
  },
  {
    name = 'jedi_language_server',
    cmd = { 'jedi-language-server' },
    settings = {}
  }
}

-- Find and return the first available Python LSP
local function get_python_lsp()
  for _, lsp in ipairs(python_lsp_priority) do
    local cmd = lsp.cmd[1]
    if vim.fn.executable(cmd) == 1 then
      return {
        name = lsp.name,
        cmd = lsp.cmd,
        filetypes = { 'python' },
        root_markers = { 
          'pyproject.toml', 
          'setup.py', 
          'setup.cfg', 
          'requirements.txt', 
          'Pipfile', 
          'pyrightconfig.json',
          '.git'
        },
        settings = lsp.settings,
      }
    end
  end
  return nil
end

return get_python_lsp()