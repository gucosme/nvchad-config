-- read :h vim.lsp.config for changing options of lsp servers 

require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "eslint" }

local cwd = vim.fn.getcwd()
local lsputils = require "lspconfig.util"
local root_dir = lsputils.root_pattern ".yarn"(cwd)
local default_config = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

vim.lsp.config.ts_ls = cwd:match "web%-code" and {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    maxTsServerMemory = 16384,
    tsserver = {
      path = root_dir .. "/.yarn/sdks/typescript/lib/tsserver.js",
    },
  },
} or default_config

vim.lsp.config.eslint = cwd:match "web%-code" and {
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
} or default_config

vim.lsp.enable(servers)
