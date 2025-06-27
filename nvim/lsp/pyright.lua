return {
  name = "pyright",
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
  filetypes = { "python" },  -- Only attach to Python files (not .ipynb since we have a separate handler)
  root_dir = function(filename)
    -- Only attach if we find Python project files, not just .git
    local root = vim.fs.root(filename, {
      "pyproject.toml",
      "setup.py", 
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "pyrightconfig.json",
      ".venv",
      "venv",
    })
    
    -- If no Python project markers found, don't attach
    if not root then
      return nil
    end
    
    return root
  end,
  single_file_support = false,  -- Don't attach to standalone Python files
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
      },
    },
  },
  on_init = function(client)
    -- Find virtual environment
    local function find_venv(root_dir)
      -- Check VIRTUAL_ENV environment variable first
      local venv_env = vim.env.VIRTUAL_ENV
      if venv_env and vim.fn.isdirectory(venv_env) == 1 then
        return venv_env
      end
      -- Check for .venv in the project root
      local venv_path = root_dir .. "/.venv"
      if vim.fn.isdirectory(venv_path) == 1 then
        return venv_path
      end
      -- Check for venv in the project root
      venv_path = root_dir .. "/venv"
      if vim.fn.isdirectory(venv_path) == 1 then
        return venv_path
      end
      -- Check parent directories for .venv
      local parent = vim.fn.fnamemodify(root_dir, ":h")
      while parent ~= "/" and parent ~= "" do
        venv_path = parent .. "/.venv"
        if vim.fn.isdirectory(venv_path) == 1 then
          return venv_path
        end
        parent = vim.fn.fnamemodify(parent, ":h")
      end
      return nil
    end
    local root_dir = client.config.root_dir or vim.fn.getcwd()
    local venv = find_venv(root_dir)
    if venv then
      client.config.settings.python.pythonPath = venv .. "/bin/python"
      client.config.settings.python.venvPath = vim.fn.fnamemodify(venv, ":h")
      client.config.settings.python.venv = vim.fn.fnamemodify(venv, ":t")
      vim.notify("Pyright using venv: " .. venv, vim.log.levels.INFO)
    end
    return true
  end,
}

