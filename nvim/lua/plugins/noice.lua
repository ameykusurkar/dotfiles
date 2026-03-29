return {
  "folke/noice.nvim",
  opts = {
    cmdline = {
      view = "cmdline",
    },
    -- Fix to make cmdline output visible
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = { "shell_out", "shell_err" },
        },
        view = "popup",
      },
    },
  },
}
