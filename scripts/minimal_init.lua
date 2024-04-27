local on_windows = vim.loop.os_uname().version:match("Windows")
local path_sep = on_windows and "\\" or "/"

local function join_paths(...)
    return table.concat({...}, path_sep)
end

vim.g.loaded_remote_plugins = ""
vim.cmd([[set runtimepath=$VIMRUNTIME]])

local temp_dir = vim.loop.os_getenv("TEMP") or "/tmp"
local pack_path = join_paths(temp_dir, "nvim", "site", "pack")
local install_path = join_paths(pack_path, "packer", "start", "packer.nvim")
local compile_path = join_paths(install_path, "plugin", "packer_compiled.lua")

local null_ls_config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {},
        debug = true,
    })
end

local function load_plugins()
    require("packer").startup({
        {
            "wbthomason/packer.nvim",
            {
                "nvimtools/none-ls.nvim",
                requires = { "nvim-lua/plenary.nvim" },
                config = null_ls_config,
            },
        },
        config = {
            package_root = pack_path,
            compile_path = compile_path,
        },
    })
end

local function clone_packer()
    if vim.fn.isdirectory(install_path) == 0 then
        vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
    end
end

clone_packer()
load_plugins()
require("packer").sync()
