-- Plugins


lvim.colorscheme = "nightfox"

lvim.builtin.lualine.options.theme = "dracula"
lvim.plugins = {

  -- Colchetes coloridos (rainbow)

  { 'echasnovski/mini.nvim', version = '*' },
  { "EdenEast/nightfox.nvim" },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  -- Hop: saltar por palavras/caracteres
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup()
      vim.keymap.set("n", "s", ":HopChar2<cr>", { silent = true, noremap = true })
    end,
  },

  -- Leap: salto inteligente entre palavras
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- -- Lightspeed: navegação por caracteres/strings (pode ser redundante com leap)
  -- {
  --   "ggandor/lightspeed.nvim",
  -- },
  --
  -- Snap: substituto para telescope (requer `make`, pode estar desatualizado)
  {
    "camspiers/snap",
    rocks = { "fzy" },
    config = function()
      local snap = require("snap")
      local layout = snap.get("layout").bottom
      local file = snap.config.file:with({ layout = layout })
      vim.keymap.set("n", "<Leader>ff", file, { silent = true })
    end,
  },

  -- -- Tema Everforest
  -- {
  --   "sainnhe/everforest",
  --   config = function()
  --     vim.cmd("colorscheme everforest")
  --   end,
  --   lazy = false,
  --   priority = 1000,
  -- },

  -- Glow: renderizar markdown
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
  },

  -- Prettier
  -- {
  --   "MunifTanjim/prettier.nvim",
  --   config = function()
  --     require("prettier").setup({
  --       bin = 'prettier',
  --       filetypes = {
  --         "css", "graphql", "html", "javascript", "javascriptreact",
  --         "json", "less", "markdown", "scss", "typescript",
  --         "typescriptreact", "yaml",
  --       },
  --     })
  --   end,
  -- },

  -- Plugin para comentar com `gc`
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Plugin para abrir arquivos recentes com Telescope
  {
    "cbochs/portal.nvim",
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
    config = function()
      require("portal").setup()
    end,
  },

  -- Plugin de persistência de sessões
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.stdpath("state") .. "/sessions/",
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })

      -- atalhos úteis
      vim.keymap.set("n", "<leader>qs", function()
        require("persistence").load()
      end, { desc = "Restore session" })

      vim.keymap.set("n", "<leader>ql", function()
        require("persistence").load({ last = true })
      end, { desc = "Restore last session" })

      vim.keymap.set("n", "<leader>qd", function()
        require("persistence").stop()
      end, { desc = "Don't save session" })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  "lewis6991/gitsigns.nvim",
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

}


-- lvim.builtin.nvimtree.setup.open_on_setup_file = true
