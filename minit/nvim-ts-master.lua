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
      branch = "master",
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

        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "vim_map_side",
            "yaml",
          },
          highlight = { enable = true },
        })
      end,
    },
  },
})
