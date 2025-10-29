# vim-map-side.nvim

Plugin that improves support for [Vim's
map](https://vimhelp.org/map.txt.html#map.txt) side (`lhs` and `rhs`) in Neovim.

![lua injection](https://i.imgur.com/ftXsjMX.png)

> Lua injection

![vim injection](https://i.imgur.com/cPS7Jxr.png)

> Vim injection

## Features

- Syntax highlighting of `lhs` and `rhs` thanks to
  [`tree-sitter-vim-map-side`][ts-vim-map-side]. Compatible with
  [^beb2a51][ts-vim-map-side-version]
- [New predicate](#is-keymap-fn-predicate) with its [LSP
  configuration](#lsp-configuration)

## Requirements

- `Neovim >= 0.9.0`
- [`nvim-treesitter`][nvim-treesitter]
- [`lua` parser][lua]: injection to `lhs` and `rhs` of [keymap
  functions](#is-keymap-fn-predicate)
- [`printf` parser][printf] (optional): for `printf()` expression
- [`vim` parser][vim] (optional): for `rhs` that starts with `:` and `command`
  nodes of `tree-siter-vim-map-side`

## Install

### [`lazy.nvim`](https://github.com/folke/lazy.nvim)

```lua
{
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "Hdoc1509/vim-map-side.nvim" },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("vim-map-side.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", -- required
        "printf", -- optional
        "vim", -- optional
        "vim_map_side", -- required
      }
    })
  end,
}
```

### [`packer.nvim`](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "nvim-treesitter/nvim-treesitter",
  requires = { "Hdoc1509/vim-map-side.nvim" },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("vim-map-side.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", -- required
        "printf", -- optional
        "vim", -- optional
        "vim_map_side", -- required
      }
    })
  end,
})
```

## Default configuration

### `vim-map-side.tree-sitter` setup

```lua
---@type VimMapSideOpts
{
  from_grammar = false, -- whether to install from `grammar.js`
  revision = "release", -- specific version of `tree-sitter-vim-map-side`
  custom_fns = {
    -- custom functions with same parameters of `vim.keymap.set()`
    keymap = {},
  },
}
```

## `is-keymap-fn?` predicate

Check if the captured node is a function call that is a keymap function:

- `vim.keymap.set()`
- `vim.api.nvim_set_keymap()`
- custom functions defined in `custom_fns.keymap` of [`vim-map-side.tree-sitter`
  setup](#vim-map-sidetree-sitter-setup)

## LSP configuration

WIP

## Specific version of `tree-sitter-vim-map-side`

Use the `revision` option of the `vim-map-side.tree-sitter` module:

```lua
require("vim-map-side.tree-sitter").setup({
  revision = 'deploy-v0.1.0'
})
```

Check the [General Installation of
`tree-sitter-vim-map-side`][ts-vim-map-side-general] for more information.

> [!NOTE]
> Be sure to use any [compatible version](#features).

## Troubleshooting

> [!IMPORTANT]
> Be sure to run `:checkhealth vim.treesitter` before checking the following
> errors.

### Incompatible ABI version

If you found the following error:

```checkhealth
- ERROR Parser "vim_map_side" failed to load
  (path: .../vim_map_side.so): ...: ABI version mismatch for
  .../vim_map_side.so: supported between X and Y, found Z
```

<!-- prettier-ignore -->
> [!NOTE]
> `X` and `Y` are the interval of ABI versions supported by neovim. `Z` is the
> ABI version that was used to develop the parser.

1. Install the following tools:

   - [`Node.js`][nodejs]
   - [`tree-sitter cli`][tree-sitter-cli]

2. Add the `from_grammar` option to the `setup` function of the
   `vim-map-side.tree-sitter` module:

   ```lua
   require("vim-map-side.tree-sitter").setup({ from_grammar = true })
   ```

3. Reload your neovim config.

4. Run `:TSInstall vim_map_side` to re-install the parser with the correct ABI
   version.

## Updates

This plugin will follow changes of `tree-sitter-vim-map-side`:

- [`queries`][ts-vim-map-side-queries] updates
- [`grammar`][ts-vim-map-side-grammar] updates

[ts-vim-map-side]: https://github.com/Hdoc1509/tree-sitter-vim-map-side
[ts-vim-map-side-grammar]: https://github.com/hdoc1509/tree-sitter-vim-map-side/tree/master/grammar.js
[ts-vim-map-side-queries]: https://github.com/hdoc1509/tree-sitter-vim-map-side/tree/master/queries
[ts-vim-map-side-general]: https://github.com/Hdoc1509/tree-sitter-vim-map-side#in-general
[ts-vim-map-side-version]: https://github.com/Hdoc1509/tree-sitter-vim-map-side/commit/950bccaa82faa30372483e585186f1e41d5e9aad
[lua]: https://github.com/tree-sitter-grammars/tree-sitter-lua
[printf]: https://github.com/tree-sitter-grammars/tree-sitter-printf
[vim]: https://github.com/tree-sitter-grammars/tree-sitter-vim
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nodejs]: https://nodejs.org/en/download
[tree-sitter-cli]: https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli
