-- ~/.config/nvim/init.lua
-- Neovim 0.12.2 Configuration
-- Optimized for C (K&R style) and Python development

-------------------------------------------------------------------------------
-- Leader Key (must be set before any keymaps)
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------------------------------
-- General Behavior
-------------------------------------------------------------------------------
vim.opt.encoding     = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.hidden       = true          -- allow unsaved buffers in background
vim.opt.showcmd      = true
vim.opt.swapfile     = false
vim.opt.updatetime   = 300           -- faster CursorHold / LSP diagnostics
vim.opt.undofile     = true
vim.opt.undodir      = vim.fn.stdpath('data') .. '/undo'

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_matchparen    = 1       -- disable slow built-in matchparen

-- Python host for pynvim (used by some plugins; harmless if env missing)
vim.g.python3_host_prog = '/home/wga/.pyenv/versions/neovim-env/bin/python'

-------------------------------------------------------------------------------
-- UI & Appearance
-------------------------------------------------------------------------------
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.mouse          = "a"
vim.opt.mousehide      = true
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.termguicolors  = true
vim.opt.wrap           = false
vim.opt.scrolloff      = 6           -- keep context lines above/below cursor
vim.opt.sidescrolloff  = 8
vim.opt.signcolumn     = "yes"       -- always show; prevents layout shift on LSP diagnostics
vim.opt.cursorline     = true        -- highlight current line

vim.cmd.colorscheme("habamax")

-- Status line: buffer · full path · modified · RO | line,col · pct
vim.o.laststatus   = 2
vim.wo.statusline  = " buf %n: %F %m%r %=%l,%c        %p%% "

-------------------------------------------------------------------------------
-- Indentation & Tabs
-------------------------------------------------------------------------------
vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4              -- was missing — fixes >>, <<, autoindent
vim.opt.expandtab   = true
vim.opt.autoindent  = true
vim.opt.cindent     = true           -- C-aware indentation (supercedes smartindent)
vim.opt.cinoptions  = ""             -- K&R defaults
vim.opt.formatoptions = "croqnj"

-------------------------------------------------------------------------------
-- Search
-------------------------------------------------------------------------------
vim.opt.incsearch  = true
vim.opt.hlsearch   = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-------------------------------------------------------------------------------
-- Completion (0.12 native)
-------------------------------------------------------------------------------
vim.opt.completeopt = "menuone,noselect,popup"

-------------------------------------------------------------------------------
-- Clipboard
-------------------------------------------------------------------------------
vim.opt.clipboard = "unnamedplus"

-------------------------------------------------------------------------------
-- File Navigation
-------------------------------------------------------------------------------
vim.opt.tags       = "./tags,./.git/tags,tags,.git/tags"
vim.opt.wildmenu   = true
vim.opt.wildignore = {
    "*.o", "*.pyc", "*.pdf", "*.mod", "*.so", "*.h.gch",
    "*.bak", "*.swp", "*.tmp", "*.log",
    "*.git", "*.hg", "*.svn",
    "node_modules", "vendor", "__pycache__",
}

-------------------------------------------------------------------------------
-- Keymaps
-------------------------------------------------------------------------------

-- Clear search highlights
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>",
    { desc = "Clear search highlights" })

-- Visual-line navigation (natural movement on wrapped text)
vim.keymap.set("n", "j", "gj", { remap = true, desc = "Move down visual line" })
vim.keymap.set("n", "k", "gk", { remap = true, desc = "Move up visual line" })

-- Quick buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>",     { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>",   { desc = "Delete buffer" })

-- Open file explorer (built-in netrw)
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "File explorer" })

-- Split navigation (Ctrl+hjkl)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Save shortcut
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save file" })

-- Diagnostic navigation
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-------------------------------------------------------------------------------
-- Diagnostic display
-------------------------------------------------------------------------------
vim.diagnostic.config({
    virtual_text    = true,
    signs           = true,
    underline       = true,
    update_in_insert = false,        -- less noisy while typing
    severity_sort   = true,
})

-------------------------------------------------------------------------------
-- LSP (0.12 native — no lspconfig plugin needed)
-------------------------------------------------------------------------------
-- Requires servers installed:
--   C/C++  : sudo apt install clangd
--   Python : pip install pyright  OR  npm install -g pyright

vim.lsp.enable('clangd')
vim.lsp.enable('pyright')

-- LSP keymaps — attached only when an LSP client connects
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gr",         vim.lsp.buf.references,      vim.tbl_extend("force", opts, { desc = "Find references" }))
        vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,           vim.tbl_extend("force", opts, { desc = "Hover docs" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,     vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, vim.tbl_extend("force", opts, { desc = "Document symbols" }))
        vim.keymap.set("i", "<C-k>",      vim.lsp.buf.signature_help,  vim.tbl_extend("force", opts, { desc = "Signature help" }))
    end,
})

-------------------------------------------------------------------------------
-- Python filetype settings
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern  = "python",
    callback = function()
        -- PEP 8: 79-char line limit visual guide
        vim.opt_local.colorcolumn = "79"
        vim.opt_local.textwidth   = 79

        -- Run current script
        vim.keymap.set("n", "<leader>r",
            ":w <bar> :!/usr/bin/clear && python3 %<CR>",
            { buffer = true, desc = "Run Python script" })

        -- Format with black if available (LSP formatter used otherwise)
        if vim.fn.executable('black') == 1 then
            vim.keymap.set("n", "<leader>f",
                ":w<CR>:silent !black %<CR>:e<CR>",
                { buffer = true, desc = "Format with black" })
        end
    end,
})

-------------------------------------------------------------------------------
-- C/C++ filetype settings + clang-format
-------------------------------------------------------------------------------
if vim.fn.executable('clang-format') == 1 then

    local c_patterns = { "*.c", "*.cpp", "*.h", "*.hpp" }

    vim.api.nvim_create_autocmd("FileType", {
        pattern  = { "c", "cpp" },
        callback = function()
            vim.opt_local.colorcolumn = "80"   -- K&R conventional limit
            vim.opt_local.formatprg   = "clang-format"

            -- Format whole file or selection
            vim.keymap.set("n", "<leader>f", ":%!clang-format<CR>",
                { buffer = true, desc = "Format C file with clang-format" })
            vim.keymap.set("v", "<leader>f", ":!clang-format<CR>",
                { buffer = true, desc = "Format selection with clang-format" })

            -- Paste boilerplate macro then format
            vim.keymap.set("n", "<leader>a", "@a:%!clang-format<CR>",
                { buffer = true, desc = "Paste boilerplate + format" })
        end,
    })

    -- Auto-format on open and before write (skip empty new files)
    local function auto_format_c()
        if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then return end
        local view = vim.fn.winsaveview()
        vim.cmd("silent %!clang-format")
        vim.fn.winrestview(view)
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern  = c_patterns,
        callback = auto_format_c,
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern  = c_patterns,
        callback = auto_format_c,
    })
end

-------------------------------------------------------------------------------
-- Undo directory — create if missing
-------------------------------------------------------------------------------
local undodir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
