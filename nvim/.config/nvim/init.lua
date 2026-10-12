-- =============================================================================
-- Portable init.lua — Doug
-- Neovim configuration for Python, Ruby, C#, TypeScript, and JavaScript.
--
-- Install on a new machine:
--   1. ln -s <thisdir>/init.lua ~/.config/nvim/init.lua
--   2. launch nvim — lazy.nvim bootstraps itself and installs plugins
--   3. Mason installs the configured language servers on first launch.
--
-- Requires: nvim >= 0.11, git, curl, and a C compiler for Treesitter parsers.
-- Formatters such as prettier and rubocop must be installed separately.
-- =============================================================================

------------------------------------------------------------ leader + bootstrap
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------ options
local o = vim.opt
o.number = true
o.ruler = true
o.showcmd = true
o.hidden = true
o.wildmenu = true
o.wildignore:append({ "*/vendor/bundle/*", "*/node_modules/*", "*/.git/*", "*/dist/*", "*/build/*" })
o.lazyredraw = true
o.mouse = "a"
o.scrolloff = 3
o.sidescrolloff = 5
o.foldenable = false
o.splitbelow = true
o.splitright = true
o.updatetime = 300
o.signcolumn = "auto"

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

o.cursorline = false
o.listchars = { nbsp = "¬", eol = "¶", tab = ">-", extends = "»", precedes = "«", trail = "•" }
o.errorbells = false
o.visualbell = false
o.belloff = "all"

-- Keep editor state separate from configuration; create dirs on a fresh home.
local state = vim.fn.stdpath("state")
for option, name in pairs({
  backupdir = "backup", directory = "swap", undodir = "undo", viewdir = "view",
}) do
  local path = state .. "/" .. name
  vim.fn.mkdir(path, "p")
  o[option] = path .. (option == "viewdir" and "" or "//")
end
o.undofile = true

if vim.env.TMUX == nil or vim.env.TMUX == "" then
  o.clipboard = "unnamedplus"
end

if vim.fn.executable("rg") == 1 then
  o.grepprg = "rg --vimgrep --smart-case"
  o.grepformat = "%f:%l:%c:%m"
end

-- Colors: 24-bit + tokyonight (set after plugin loads, see plugin spec below).
o.termguicolors = true

------------------------------------------------------------ filetype tweaks
local ft_group = vim.api.nvim_create_augroup("dougvim_ft", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ft_group, pattern = "make",
  callback = function() vim.bo.expandtab = false end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft_group, pattern = "*.es6",
  callback = function() vim.bo.filetype = "javascript" end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft_group, pattern = "*.chamber",
  callback = function() vim.bo.syntax = "json" end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ft_group, pattern = { "python", "cs" },
  callback = function()
    vim.bo.tabstop, vim.bo.softtabstop, vim.bo.shiftwidth = 4, 4, 4
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ft_group, pattern = "go",
  callback = function()
    vim.bo.tabstop, vim.bo.softtabstop, vim.bo.shiftwidth = 4, 4, 4
    vim.bo.expandtab = false
  end,
})

------------------------------------------------------------ keymaps
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Window nav
map("n", "<C-J>", "<C-W><C-J>")
map("n", "<C-K>", "<C-W><C-K>")
map("n", "<C-L>", "<C-W><C-L>")
map("n", "<C-H>", "<C-W><C-H>")

-- Clear search highlight
map("n", "<leader><space>", ":nohlsearch<CR>", "clear hlsearch")

-- Trim trailing whitespace.
map("n", "<leader>w", function()
  local view = vim.fn.winsaveview()
  vim.cmd([[silent! %s/\s\+$//e]])
  vim.fn.winrestview(view)
end, "trim trailing whitespace")

-- Reindent whole file
map("n", "<leader>fef", "gg=G``", "reindent file")

-- Buffers
map("n", "<leader>bd", ":bd<CR>", "delete buffer")
map("n", "<Tab>",      ":bnext<CR>", "next buffer")
map("n", "<S-Tab>",    ":bprev<CR>", "prev buffer")

-- Sign gutter toggle + gitsigns toggle
map("n", "<leader>g", function()
  vim.wo.signcolumn = (vim.wo.signcolumn == "no") and "auto" or "no"
end, "toggle sign column")
map("n", "<leader>G", ":Gitsigns toggle_signs<CR>", "toggle gitsigns")

-- (plugin maps are set in their plugin specs below)

------------------------------------------------------------ plugins
require("lazy").setup({
  ----------------------------------------------- colorscheme
  { "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  ----------------------------------------------- editing essentials
  { "tpope/vim-repeat" },
  { "tpope/vim-abolish" },
  { "tpope/vim-fugitive" },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs",  event = "InsertEnter", opts = {} },
  { "smoka7/hop.nvim", version = "*", opts = {},
    keys = {
      { "<leader>j", function() require("hop").hint_words() end, desc = "hop words" },
    },
  },
  { "mg979/vim-visual-multi", branch = "master" },
  { "godlygeek/tabular", cmd = "Tabularize" },
  { "gcmt/wildfire.vim" },
  { "rhysd/conflict-marker.vim" },
  { "mbbill/undotree",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "undotree" } },
  },

  ----------------------------------------------- UI
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "auto", icons_enabled = true } },
  },
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },
  { "HiPhish/rainbow-delimiters.nvim" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  ----------------------------------------------- file nav + fuzzy
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { renderer = { group_empty = true } },
    keys = {
      { "<leader>n", "<cmd>NvimTreeToggle<CR>",       desc = "tree toggle" },
      { "<leader>N", "<cmd>NvimTreeFindFile<CR>",     desc = "tree find file" },
    },
  },
  { "nvim-telescope/telescope.nvim", branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>",     function() require("telescope.builtin").find_files() end,           desc = "files" },
      { "<leader>b", function() require("telescope.builtin").buffers() end,              desc = "buffers" },
      { "<leader>/", function() require("telescope.builtin").live_grep() end,            desc = "live grep" },
      { "<leader>t", function() require("telescope.builtin").lsp_document_symbols() end, desc = "doc symbols" },
    },
  },

  ----------------------------------------------- syntax / treesitter
  { "nvim-treesitter/nvim-treesitter",
    branch = "main",            -- rewrite; required for nvim 0.11+ / 0.12
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "lua", "vim", "vimdoc", "bash", "json", "yaml", "toml", "markdown", "markdown_inline",
        "html", "css", "javascript", "typescript", "tsx", "vue",
        "python", "ruby", "c_sharp", "go", "rust", "sql", "regex", "dockerfile",
      }
      require("nvim-treesitter").install(parsers)

      -- Turn on highlight + indent whenever a buffer's filetype matches an installed parser.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dougvim_ts", { clear = true }),
        callback = function(args)
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          else
            -- parser not installed yet — fall back to vim's built-in syntax
            vim.bo[args.buf].syntax = "ON"
          end
        end,
      })
    end,
  },
  { "mattn/emmet-vim", ft = { "html", "css", "vue", "javascriptreact", "typescriptreact", "eruby" } },

  ----------------------------------------------- LSP + tooling
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "pyright", "ruff",
        "solargraph",
        "rust_analyzer",
        "omnisharp",
        "ts_ls", "eslint",
        "html", "cssls", "jsonls", "yamlls",
        "lua_ls",
      },
    },
  },
  { "neovim/nvim-lspconfig",
    config = function()
      -- nvim 0.11+ API: vim.lsp.config() + vim.lsp.enable(); on_attach via LspAttach.
      local servers = { "pyright", "ruff", "solargraph", "omnisharp", "rust_analyzer",
                        "ts_ls", "eslint", "html", "cssls", "jsonls", "yamlls", "lua_ls" }

      -- omnisharp has no default cmd in lspconfig; point at Mason's binary
      vim.lsp.config("omnisharp", {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/OmniSharp") },
      })

      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("dougvim_lsp", { clear = true }),
        callback = function(args)
          local b = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
          end
          b("gd", vim.lsp.buf.definition,    "go to definition")
          b("gr", vim.lsp.buf.references,    "find references")
          b("K",  vim.lsp.buf.hover,         "hover")
          b("[a", vim.diagnostic.goto_prev,  "prev diagnostic")
          b("]a", vim.diagnostic.goto_next,  "next diagnostic")
          b("<leader>rn", vim.lsp.buf.rename,      "rename")
          b("<leader>ca", vim.lsp.buf.code_action, "code action")
        end,
      })
    end,
  },

  ----------------------------------------------- completion
  { "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  ----------------------------------------------- formatting
  { "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        python              = { "ruff_format", "ruff_organize_imports" },
        ruby                = { "rubocop" },
        javascript          = { "prettier" },
        javascriptreact     = { "prettier" },
        typescript          = { "prettier" },
        typescriptreact     = { "prettier" },
        vue                 = { "prettier" },
        json                = { "prettier" },
        css                 = { "prettier" },
        html                = { "prettier" },
        markdown            = { "prettier" },
        ["_"]               = { "trim_whitespace" },
      },
      -- explicit :Format only; uncomment to format on save
      -- format_on_save = { lsp_fallback = true, timeout_ms = 2000 },
    },
  },

  ----------------------------------------------- editorconfig (built-in nvim ≥0.9, no plugin needed)
}, {
  install = { missing = true },
  ui = { border = "rounded" },
})

-- :Format command (uses conform)
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
