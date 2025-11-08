-- Python LSP configuration with priority order
local python_lsp_priority = {
  {
    name = 'ty',
    filetypes = { 'python' },
    root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    cmd = { 'ty', 'server' },
    settings = {}
  },
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
}

-- Find and return the first available Python LSP
local function get_python_lsp()
  for _, lsp in ipairs(python_lsp_priority) do
    -- Check if cmd exists and is executable, or if no cmd (use default)
    if not lsp.cmd or vim.fn.executable(lsp.cmd[1]) == 1 then
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
