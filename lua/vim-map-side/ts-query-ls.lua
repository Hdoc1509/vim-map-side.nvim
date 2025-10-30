return {
  settings = {
    valid_predicates = {
      ["is-keymap-fn"] = {
        parameters = {
          { type = "capture", arity = "required" },
        },
        description = "Check if the captured node is a function call that is a keymap function",
      },
      ["is-modemap-fn"] = {
        parameters = {
          { type = "capture", arity = "required" },
        },
        description = "Check if the captured node is a function call that is a modemap function",
      },
    },
  },
}
