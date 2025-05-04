lvim.colorscheme = "nightfox"

lvim.builtin.lualine.options.theme = "dracula"
lvim.transparent_window = false
lvim.plugins = {
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

lvim.builtin.tabnine = { active = true }

lvim.builtin.lualine.options = {
  icons_enabled = true,
  theme = 'nightfox',
  component_separators = { left = '', right = '' },
  section_separators = { left = '', right = '' },
  disabled_filetypes = {
    statusline = {},
    winbar = {},
  },
  ignore_focus = {},
  always_divide_middle = true,
  globalstatus = false,
  refresh = {
    statusline = 1000,
    tabline = 1000,
    -- winbar = 1000,
  }
}

local function animal()
  local selection = { '🐶', '🐼', '🐸', '🦊', '🦁', '🐵', '🐮', '🐷', '🐨', '🗿' }
  return selection[math.random(#selection)]
end

lvim.builtin.lualine.sections = {
  lualine_a = { '', 'mode', 'selectioncount', 'searchcount' },
  lualine_b = { 'branch', 'diff', 'diagnostics' },
  lualine_c = { 'filename', 'filesize' },
  lualine_x = { 'fileformat', 'filetype', 'encoding' },
  lualine_y = { 'location', 'progress' },
  lualine_z = { "os.date('%a - %d/%m/%y - %H:%M:%S')", { animal } }
}

lvim.builtin.lualine.inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {}
}
-- lvim.builtin.nvimtree.setup.open_on_setup_file = true
