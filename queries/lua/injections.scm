; extends

; NOTE: for lhs and rhs
(function_call
  name: (_) @_fn
  arguments: [
    ; format-ignore
    (arguments
      . (_) ; -- mode --
      .
      (string
        (string_content) @injection.content))
    ; format-ignore
    (arguments
      . (_) ; -- mode --
      . (_) ; -- lhs --
      (string
        (string_content) @injection.content))
  ]
  ; TODO: use is-keymap-fn? predicate
  (#any-of? @_fn "vim.keymap.set" "vim.api.nvim_set_keymap")
  (#lua-match? @injection.content "<.+>")
  (#set! injection.language "vim_map_side"))

(function_call
  name: (_) @_fn
  arguments: [
    ; format-ignore
    (arguments
      . (_) ; -- buffer --
      . (_) ; -- mode --
      .
      (string
        (string_content) @injection.content))
    ; format-ignore
    (arguments
      . (_) ; -- buffer --
      . (_) ; -- mode --
      . (_) ; -- lhs --
      (string
        (string_content) @injection.content))
  ]
  (#eq? @_fn "vim.api.nvim_buf_set_keymap")
  (#lua-match? @injection.content "<.+>")
  (#set! injection.language "vim_map_side"))

; NOTE: for `:` rhs without <cr>
(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content))
  (#any-of? @_fn "vim.keymap.set" "vim.api.nvim_set_keymap")
  (#not-lua-match? @injection.content "<.+>")
  (#lua-match? @injection.content "^:")
  (#set! injection.language "vim_map_side"))

(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- buffer --
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content))
  (#eq? @_fn "vim.api.nvim_buf_set_keymap")
  (#not-lua-match? @injection.content "<.+>")
  (#lua-match? @injection.content "^:")
  (#set! injection.language "vim_map_side"))

; NOTE: for expressions as rhs
(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content)
    .
    (table_constructor) @_options)
  (#any-of? @_fn "vim.keymap.set" "vim.api.nvim_set_keymap")
  ; NOTE: to avoid double injection
  (#not-lua-match? @injection.content "<.+>")
  (#lua-match? @_options "expr%s*=%s*true")
  (#set! injection.language "vim_map_side"))

(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- buffer --
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content)
    .
    (table_constructor) @_options)
  (#eq? @_fn "vim.api.nvim_buf_set_keymap")
  ; NOTE: to avoid double injection
  (#not-lua-match? @injection.content "<.+>")
  (#lua-match? @_options "expr%s*=%s*true")
  (#set! injection.language "vim_map_side"))
