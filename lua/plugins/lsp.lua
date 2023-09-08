return {
  "neovim/nvim-lspconfig",
  ft = { "lua", "rust", "ps1" },
  -- events = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim", -- neovim开发提示
    { -- 右下角lsp服务提示
      "j-hui/fidget.nvim",
      tag = "legacy",
    },
  },
  config = function()
    -- 设置lua lsp默认的lib位置
		local lua_lib = vim.api.nvim_get_runtime_file("", true)
    table.insert(lua_lib, "${3rd}/luassert/library")
    table.insert(lua_lib, "${3rd}/luv/library")
    -- lsp 配置
    local servers = {
      lua_ls = {
        Lua = {
          workspace = {
            library = lua_lib
          },
          telemetry = { enable = false },
        },
      },
      rust_analyzer = {

      }
    }
    -- 按键映射
    local on_attach = function(_, bufnr)
      local keymap_uitl = require("utils.keymap")
      local buf_map = keymap_uitl.buf_map

      -- 符号跳转
      buf_map("n", "gD", vim.lsp.buf.declaration, "LSP: Goto Declaration", bufnr)
      buf_map("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "LSP: Goto definition", bufnr)
      buf_map("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "LSP: Goto implementation", bufnr)
      buf_map("n", "gT", "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", "LSP: Type definition", bufnr)
      buf_map("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "LSP: Goto references", bufnr)

      -- 符号列表
      buf_map("n", "<leader>ls", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "LSP: list document symbols", bufnr)
      buf_map("n", "<leader>lS", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", "LSP: list workspace symbols", bufnr)

      -- 函数签名
      buf_map("n", "K", vim.lsp.buf.hover, "LSP: Hover documentation", bufnr)
      buf_map("n", "<M-k>", vim.lsp.buf.signature_help, "LSP: Signature documentation", bufnr)

      -- lsp工作区
      -- buf_map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, "LSP: Workspace add folder", bufnr)
      -- buf_map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "LSP: Workspace remove folder", bufnr)
      -- buf_map("n", "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP: Workspace list folders", bufnr)

      -- 代码重构
      buf_map("n", "<F2>", vim.lsp.buf.rename, "LSP: Rename", bufnr)
      buf_map("n", "<leader>lr", vim.lsp.buf.rename, "LSP: Rename", bufnr)
      buf_map("n", "<M-Enter>", vim.lsp.buf.code_action, "LSP: Code action", bufnr)
      buf_map("n", "<leader>la", vim.lsp.buf.code_action, "LSP: Code action", bufnr)
      -- buf_map("n", "gr", require("telescope.builtin").lsp_references, "LSP: Goto references", bufnr)
      buf_map("n", "<M-l>", function() vim.lsp.buf.format { async = true } end, "LSP: Format code", bufnr)

      -- 代码诊断
      buf_map("n", "<leader>lp", vim.diagnostic.open_float, "LSP: Open diagnostic float window", bufnr)
      buf_map("n", "]d", vim.diagnostic.goto_next, "LSP: Goto next diagnostic", bufnr)
      buf_map("n", "[d", vim.diagnostic.goto_prev, "LSP: Goto previous diagnostic", bufnr)
      buf_map("n", "<leader>ld", "<cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<cr>", "LSP: List current buffer diagnostics", bufnr)
      buf_map("n", "<leader>lD", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "LSP: List workspace diagnostics ", bufnr)
    end

    require("neodev").setup()
    require("fidget").setup()

    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            settings = servers[server_name],
            on_attach = on_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities() -- lsp相关补全
          }
        end,
      }
    })
    -- 修改默认提示符号
    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "" },
      { name = "DiagnosticSignInfo", text = "" },
    }
    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end
    -- set the style of lsp info
    local config = {
      -- disable virtual text
      -- the message show after the current line.
      virtual_text = false,
      -- show signs
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "single",
        source = "always",
        header = "",
        prefix = "",
      },
    }
    vim.diagnostic.config(config)
    -- set the popup window border
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
    })
  end
}
