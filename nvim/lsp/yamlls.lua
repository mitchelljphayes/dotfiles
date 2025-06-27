return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server", "--stdio" },
  root_markers = { ".git", "package.json", ".yaml-ls.yml", ".yamlls.yml" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.ansible" },
  settings = {
    yaml = {
      schemas = {
        -- Kubernetes schemas
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        -- GitHub Actions
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        -- Docker Compose
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/*docker-compose*.yaml",
        -- Ansible
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "/*playbook*.yaml",
      },
      validate = true,
      completion = true,
      hover = true,
      format = {
        enable = false, -- We use prettier for formatting
      },
    },
  },
}