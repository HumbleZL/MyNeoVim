-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local nvim_lsp = require("lspconfig")

local opts = {
  cmd = { "clangd" },
  filetypes = { "c", "cpp" },
  root_dir = nvim_lsp.util.root_pattern(
          '.clangd',
          '.clang-tidy',
          '.clang-format',
          'compile_commands.json',
          'compile_flags.txt',
          'configure.ac',
          '.git',
          'Makefile'
        ),
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = function(client, bufnr)
    -- 禁用格式化功能，交给专门插件插件处理
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    -- 绑定快捷键
    require("keybindings").mapLSP(buf_set_keymap)
  end,
}

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- opts.capabilities = capabilities

-- 查看目录等信息
-- print(vim.inspect(server))

return {
  on_setup = function(server)
    server.setup(opts)
  end,
}
