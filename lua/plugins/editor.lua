return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        window = {
          mappings = {
            ["L"] = "open_nofocus",
          },
        },
        commands = {
          open_nofocus = function(state)
            require("neo-tree.sources.filesystem.commands").open(state)
            vim.schedule(function()
              vim.cmd([[Neotree focus]])
            end)
          end,
        },
      },
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      auto_close = true,
      close_if_last_window = true,
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },
  {
    "mg979/vim-visual-multi",
    init = function()
      -- I'm not sure why I need to defer this to the next available
      -- opportunity after startup
      vim.defer_fn(function()
        vim.cmd("VMTheme paper")
      end, 0)
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
      }
      vim.api.nvim_command("hi VM_Mono guibg=Grey60 guifg=Black gui=NONE")
    end,
  },
}
