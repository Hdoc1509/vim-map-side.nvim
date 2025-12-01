--# selene: allow(mixed_table)
-- BOOTSTRAP -- DO NOT CHANGE
local bootstrap_cmd =
  "curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"
vim.env.LAZY_STDPATH = "~/.repro/vim-map-side.nvim"
load(vim.fn.system(bootstrap_cmd))()
-- BOOTSTRAP -- DO NOT CHANGE

-- NOTE: update config below to match your use case
require("lazy.minit").repro({
  spec = {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      dependencies = {
        {
          "Hdoc1509/vim-map-side.nvim",
          -- branch = "branch",
          -- version = '*',
        },
      },
      config = function()
        require("vim-map-side.tree-sitter").setup({
          -- your options
        })

        require("nvim-treesitter").install({
          "lua",
          "vim",
          "vim_map_side",
        })

        -- ensure directory for parsers and queries in `rtp` after first
        -- installation of parsers. DO NOT CHANGE
        vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site")

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "yaml",
          callback = function()
            pcall(vim.treesitter.start)
          end,
        })
      end,
    },
  },
})
