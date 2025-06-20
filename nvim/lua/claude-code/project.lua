-- Project awareness for Claude Code
local M = {}

local project_info = {
  root = nil,
  type = nil, -- git, npm, cargo, python, etc.
  files = {},
  structure = {},
}

function M.setup(config)
  -- Initialize project info
  M.detect_project()
end

-- Detect project type and root
function M.detect_project()
  local markers = {
    { pattern = ".git", type = "git" },
    { pattern = "package.json", type = "npm" },
    { pattern = "Cargo.toml", type = "cargo" },
    { pattern = "pyproject.toml", type = "python" },
    { pattern = "setup.py", type = "python" },
    { pattern = "setup.cfg", type = "python" },
    { pattern = "go.mod", type = "go" },
    { pattern = "dbt_project.yml", type = "dbt" },
    { pattern = "Gemfile", type = "ruby" },
    { pattern = "pom.xml", type = "maven" },
    { pattern = "build.gradle", type = "gradle" },
  }
  
  -- Find project root by looking for markers
  local current_path = vim.fn.expand("%:p:h")
  if current_path == "" then
    current_path = vim.fn.getcwd()
  end
  
  for _, marker in ipairs(markers) do
    local found = vim.fs.find(marker.pattern, {
      upward = true,
      path = current_path,
      limit = 1,
    })[1]
    
    if found then
      project_info.root = vim.fn.fnamemodify(found, ":h")
      project_info.type = marker.type
      break
    end
  end
  
  -- If no root found, use current directory
  if not project_info.root then
    project_info.root = vim.fn.getcwd()
    project_info.type = "unknown"
  end
end

-- Get project information
function M.get_info()
  return project_info
end

-- Update file in project structure
function M.update_file(filepath)
  if not filepath or filepath == "" then return end
  
  local relative_path = vim.fn.fnamemodify(filepath, ":.")
  project_info.files[relative_path] = {
    last_modified = os.time(),
    filetype = vim.fn.fnamemodify(filepath, ":e"),
  }
end

-- Get project context for Claude
function M.get_context()
  local context = string.format(
    "Project type: %s\nProject root: %s\n",
    project_info.type,
    project_info.root
  )
  
  -- Add project-specific context based on what files exist
  if project_info.type == "npm" then
    local package_json_path = project_info.root .. "/package.json"
    if vim.fn.filereadable(package_json_path) == 1 then
      local ok, package_json = pcall(vim.fn.json_decode,
        table.concat(vim.fn.readfile(package_json_path), "\n")
      )
      if ok and package_json then
        context = context .. "\nProject name: " .. (package_json.name or "unknown")
        if package_json.dependencies then
          local deps = vim.tbl_keys(package_json.dependencies)
          context = context .. "\nKey dependencies: " .. table.concat(deps, ", ")
        end
      end
    end
  elseif project_info.type == "python" then
    -- Look for various Python dependency files
    local dep_files = {
      "requirements.txt",
      "requirements/base.txt",
      "requirements/requirements.txt",
      "pyproject.toml",
      "Pipfile",
    }
    
    for _, dep_file in ipairs(dep_files) do
      local full_path = project_info.root .. "/" .. dep_file
      if vim.fn.filereadable(full_path) == 1 then
        context = context .. "\nFound dependency file: " .. dep_file
        
        -- For pyproject.toml, try to parse it
        if dep_file == "pyproject.toml" then
          local content = table.concat(vim.fn.readfile(full_path), "\n")
          local project_name = content:match('%[project%].-name%s*=%s*"([^"]+)"')
          if project_name then
            context = context .. "\nProject name: " .. project_name
          end
        end
        break
      end
    end
  elseif project_info.type == "dbt" then
    local dbt_project_path = project_info.root .. "/dbt_project.yml"
    if vim.fn.filereadable(dbt_project_path) == 1 then
      local content = table.concat(vim.fn.readfile(dbt_project_path), "\n")
      local name = content:match("name:%s*['\"]?([^'\"]+)")
      if name then
        context = context .. "\ndbt project: " .. name
      end
    end
  end
  
  return context
end

-- Get related files for current file
function M.get_related_files(filepath)
  local related = {}
  local ext = vim.fn.fnamemodify(filepath, ":e")
  local base = vim.fn.fnamemodify(filepath, ":r")
  local dir = vim.fn.fnamemodify(filepath, ":h")
  
  -- Test files
  if not (filepath:match("test") or filepath:match("spec")) then
    -- Look for test files
    local test_patterns = {
      base .. "_test." .. ext,
      base .. "_spec." .. ext,
      base .. ".test." .. ext,
      base .. ".spec." .. ext,
      dir .. "/__tests__/" .. vim.fn.fnamemodify(filepath, ":t"),
      dir .. "/tests/test_" .. vim.fn.fnamemodify(filepath, ":t"),
    }
    
    for _, pattern in ipairs(test_patterns) do
      if vim.fn.filereadable(pattern) == 1 then
        table.insert(related, pattern)
      end
    end
  else
    -- This is a test file, find the source
    local source_patterns = {
      base:gsub("_test$", "") .. "." .. ext,
      base:gsub("_spec$", "") .. "." .. ext,
      base:gsub("%.test$", "") .. "." .. ext,
      base:gsub("%.spec$", "") .. "." .. ext,
    }
    
    for _, pattern in ipairs(source_patterns) do
      if vim.fn.filereadable(pattern) == 1 then
        table.insert(related, pattern)
      end
    end
  end
  
  return related
end

return M