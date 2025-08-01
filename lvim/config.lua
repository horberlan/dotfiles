lvim.colorscheme = "pywal16"

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.tabstop = 2        -- a tab is two spaces
vim.opt.shiftwidth = 2     -- indentation is two spaces
vim.opt.expandtab = true   -- no tab char in the files, use spaces
vim.opt.autoindent = true  -- keep current indentation after pressing <cr>
vim.opt.smartindent = true -- indent accordingly to the syntax
vim.opt.smarttab = true    -- indent by shiftwidth spaces when pressing tab
vim.opt.showmode = false
vim.o.autoread = true
vim.o.cmdheight = 0

lvim.builtin.lualine.options.theme = 'pywal16-nvim'
lvim.transparent_window = false

lvim.plugins = {
  defaults = {
    lazy = false,
    -- version = false, -- commented to prevent error messages at nvim startup
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css" } },
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        nextls = { enable = true },
        elixirls = {
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          end,
        },
        projectionist = {
          enable = true
        }
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { "norcalli/nvim-colorizer.lua" },
  {
    'uZer/pywal16.nvim',
    -- for local dev replace with:
    -- dir = '~/your/path/pywal16.nvim',
    config = function()
      vim.cmd.colorscheme("pywal16")
    end,
  },
  { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
  {
    'LhKipp/nvim-nu',
    build = ':TSInstall nu',
    opts = {}
  },
  {
    'topaxi/pipeline.nvim',
    keys = {
      { '<leader>ci', '<cmd>Pipeline<cr>', desc = 'Open pipeline.nvim' },
    },
    -- optional, you can also install and use `yq` instead.
    build = 'make',
    ---@type pipeline.Config
    opts = {},
  },
  { 'echasnovski/mini.nvim',      version = '*' },
  { "norcalli/nvim-colorizer.lua" },
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
  -- {
  --     "nvzone/floaterm",
  --     dependencies = "nvzone/volt",
  --     opts = {
  --       terminals = {
  --         { name = "poisnada", cmd = "neofetch" },
  --       },
  --     },
  --     cmd = "FloatermToggle",
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
require 'colorizer'.setup()
-- lvim.builtin.tabnine = { active = true }

local function animal()
  local selection = { '🐶', '🐼', '🐸', '🦊', '🦁', '🐵', '🐮', '🐷', '🐨', '🐔', '🐈', '🦌', '🫎', '🐹', '🦝', '🐊', '🦠' }
  return selection[math.random(#selection)]
end
lvim.builtin.lualine.sections.lualine_z = lvim.builtin.lualine.sections.lualine_z or {}
table.insert(lvim.builtin.lualine.sections.lualine_z, { animal })

-- lvim.builtin.lualine.sections = {
--   lualine_a = { '', 'mode', 'selectioncount', 'searchcount' },
--   lualine_b = { 'branch', 'diff', 'diagnostics' },
--   lualine_c = { 'filename', 'filesize' },
--   lualine_x = { 'fileformat', 'filetype', 'encoding' },
--   lualine_y = { 'location', 'progress' },
--   lualine_z = { "os.date('%a - %d/%m/%y - %H:%M:%S')", { animal } }
-- }
--
-- lvim.builtin.lualine.inactive_sections = {
--   lualine_a = {},
--   lualine_b = {},
--   lualine_c = {},
--   lualine_x = {},
--   lualine_y = {},
--   lualine_z = {}
-- }
-- require 'colorizer'.setup()

-- require 'colorizer'.setup({
--   css = { rgb_fn = true },
--   'javascript',
--   html = { mode = 'background' },
-- }, { mode = 'background' })

-- lvim.builtin.nvimtree.setup.open_on_setup_file = true
