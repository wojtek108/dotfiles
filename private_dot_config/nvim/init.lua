-- ~/.config/nvim/init.lua
-- Neovim Configuration (Chezmoi Managed)

-- Leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- =============================================================================
-- General Behavior & Settings
-- =============================================================================
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.g.loaded_matchparen = 1
vim.opt.autoindent = true
vim.opt.cindent = true       -- Smarter C-aware indentation
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.showcmd = true
vim.opt.swapfile = false
vim.opt.updatetime = 300
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- Matching your Vim setup
vim.o.laststatus = 2
vim.opt.statusline = "buf %n: %F %m%r %=%l,%c        %p%%"

-- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.mousehide = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax") -- Feel free to change to "slate" or others

-- Indentation & Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Search Options
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- =============================================================================
-- Keymaps
-- =============================================================================

-- Clear search highlights
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>", { silent = true })

-- Easier navigation for wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- =============================================================================
-- Python Specific Configuration
-- =============================================================================
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 235, bg = "#2c2d27" })

local python_group = vim.api.nvim_create_augroup("python_env", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = python_group,
    pattern = "python",
    callback = function()
        -- Indentation & Logic
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.smartindent = true
        
        -- Visual Aids
        vim.opt_local.colorcolumn = "80"
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldlevel = 99
        
        -- Mapping: Run script with ,r
        vim.keymap.set("n", "<leader>r", ":w<CR>:!clear && python3 %<CR>", { buffer = true, silent = true })
    end,
})

-- =============================================================================
-- C/C++ Specific Configuration (clang-format)
-- =============================================================================
if vim.fn.executable('clang-format') == 1 then
    local c_group = vim.api.nvim_create_augroup("c_format", { clear = true })
    local c_patterns = { "*.c", "*.cpp", "*.h", "*.hpp" }

    local function auto_format()
        -- Skip if buffer is empty
        if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then return end
        
        -- Save cursor position, format, restore position
        local view = vim.fn.winsaveview()
        vim.cmd("silent %!clang-format")
        vim.fn.winrestview(view)
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = c_group,
        pattern = { "c", "cpp" },
        callback = function()
            vim.opt_local.formatprg = "clang-format"
            -- Manual format shortcuts
            vim.keymap.set("n", "<leader>f", auto_format, { buffer = true, desc = "Format Buffer" })
            vim.keymap.set("v", "<leader>f", ":!clang-format<CR>", { buffer = true, desc = "Format Selection" })
        end,
    })

    -- Auto-format hooks
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePre" }, {
        group = c_group,
        pattern = c_patterns,
        callback = auto_format,
    })
end

-- =============================================================================
-- File Type & Navigation
-- =============================================================================
vim.opt.wildmenu = true
vim.opt.wildignore:append({ "*.o", "*.pyc", "*.pdf", "*.so", "*.bak", "*.swp", "*.tmp", "*.log" })
vim.opt.tags = "./tags,./.git/tags,tags,.git/tags"
