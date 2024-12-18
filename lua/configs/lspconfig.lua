require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local cwd = vim.fn.getcwd()
local lsputils = require "lspconfig.util"
local root_dir = lsputils.root_pattern ".yarn"(cwd)

-- EXAMPLE
local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
-- lsps with default configq
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.ts_ls.setup(cwd:match "web%-code" and {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    maxTsServerMemory = 16384,
    tsserver = {
      path = root_dir .. "/.yarn/sdks/typescript/lib/tsserver.js",
    },
  },
} or {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

lspconfig.eslint.setup(cwd:match "web%-code" and {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  workingDirectory = { mode = "auto" },
  settings = {
    nodePath = root_dir .. "/.yarn/sdks",
  },
} or {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})
