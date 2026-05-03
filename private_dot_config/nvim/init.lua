-- ~/.config/nvim/init.lua
-- Neovim Configuration (no plugin manager for now)

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General Behavior & Settings
vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.autoindent = true
vim.opt.cindent = true   -- Smarter C-aware indentation (replaces smartindent)
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.showcmd = true
vim.opt.swapfile = false
vim.opt.updatetime = 300
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo' -- Uncomment and create this dir
vim.o.laststatus = 2
vim.wo.statusline = "buf %n: %F %m%r %=%l,%c        %p%%"

-- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.mousehide = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- Indentation & Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- C formatting (K&R style)
vim.opt.cinoptions = ""
vim.opt.formatoptions = "croqnj"

-- Search Options
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clear search highlights (use <leader>n as in Vim)
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- File Type & Navigation
vim.opt.tags = "./tags,./.git/tags,tags,.git/tags"
vim.opt.wildmenu = true
vim.opt.wildignore = {
    "*.o", "*.pyc", "*.pdf", "*.mod", "*.so", "*.h.gch", "*.bak", "*.swp",
    "*.tmp", "*.log", "*.git", "*.hg", "*.svn",
    "node_modules", "vendor", "__pycache__"
}

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Python Host Program
vim.g.python3_host_prog = '/home/wga/.pyenv/versions/neovim-env/bin/python'

-- Disable Unused Providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Keymaps

-- Easier navigation for wrapped lines
vim.keymap.set("n", "j", "gj", { remap = true, desc = "Move down by visual line" })
vim.keymap.set("n", "k", "gk", { remap = true, desc = "Move up by visual line" })

-- Execute Python script from Neovim (after clearing console)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set("n", "<leader>r", ":w <bar> :!/usr/bin/clear && python3 %<CR>", { buffer = true, desc = "Run Python script" })
    end,
})

-- clang-format integration (C/C++ only, graceful if missing)
if vim.fn.executable('clang-format') == 1 then
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
            vim.opt_local.formatprg = "clang-format"
            vim.keymap.set("n", "<leader>f", ":%!clang-format<CR>", { buffer = true, desc = "Format C with clang-format" })
            vim.keymap.set("v", "<leader>f", ":!clang-format<CR>", { buffer = true, desc = "Format selection with clang-format" })
            vim.keymap.set("n", "<leader>a", "@a:%!clang-format<CR>", { buffer = true, desc = "Paste boilerplate macro + auto-format" })
        end,
    })
    -- Auto-format C/C++ files on open, new file, and before save
    local c_patterns = { "*.c", "*.cpp", "*.h", "*.hpp" }
    local function auto_format()
        -- Skip if buffer is empty (new file before template paste)
        if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then return end
        -- Save cursor position, format, restore cursor
        local view = vim.fn.winsaveview()
        vim.cmd("silent %!clang-format")
        vim.fn.winrestview(view)
    end
    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = c_patterns,
        callback = auto_format,
    })
    vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = c_patterns,
        callback = auto_format,
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = c_patterns,
        callback = auto_format,
    })
end

-- Plugin Management (currently disabled)
-- If you add a plugin manager, its setup would go here.
