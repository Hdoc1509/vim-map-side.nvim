; === lhs and rhs
(function_call
  name: (_) @_fn
  arguments: [
    (arguments
      .
      (string
        (string_content) @injection.content))
    (arguments
      .
      (_) ; -- lhs --
      .
      (string
        (string_content) @injection.content))
  ]
  (#is-modemap-fn? @_fn)
  (#lua-match? @injection.content "<%S+>")
  (#set! injection.language "vim_map_side"))

; === `:` rhs without <cr> ===
(function_call
  name: (_) @_fn
  arguments: (arguments
    .
    (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content))
  (#is-modemap-fn? @_fn)
  (#lua-match? @injection.content "^:")
  (#not-lua-match? @injection.content "<cr>")
  (#set! injection.language "vim"))

; === expressions as rhs ===
(function_call
  name: (_) @_fn
  arguments: (arguments
    .
    (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content)
    .
    (table_constructor) @_options)
  (#is-modemap-fn? @_fn)
  ; NOTE: to avoid double injection
  (#not-lua-match? @injection.content "<%S+>")
  (#lua-match? @_options "expr%s*=%s*true")
  (#set! injection.language "vim_map_side"))
