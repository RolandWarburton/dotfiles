-- vim.highlight.create("TrailingSpaces", {ctermbg: "red", guibg: "red"})
-- vim.highlight.create("StatusLine", { ctermbg = "Red", ctermfg = 07 })

require('core.settings')
require('core.trailing')
-- require('core.eol')
require('core.space')
require('core.color')
require('keybindings.general')
require('plugins')
require('lsp.lsp')
require('neovide.config')
require('core.statusline')

-- color scheme
vim.cmd [[colorscheme darkplus]]

-- overwrites
-- get all colors with `:enew|pu=execute('hi')` or `:so $VIMRUNTIME/syntax/hitest.vim`
-- vim.cmd [[highlight StatusLine ctermfg='white' ctermbg='black' guifg='#333333' guibg='#ffffff']]
-- vim.cmd [[highlight DiagnosticVirtualTextError guifg='#F04E4A']]
-- vim.cmd [[highlight DiagnosticUnderlineError·xxx·cterm=underline·gui=underline·guisp='#F04E4A']]

-- vim lsp error and warning inline text
vim.highlight.create("DiagnosticVirtualTextError", { guifg = '#ff0000' })

-- color the tabs
vim.highlight.create("TabLineSel", { gui = 'none', cterm = 'none', guifg='#D4D4D4', guibg='#9D6BCD'})
vim.highlight.create("TabLine", { cterm = 'none', guifg='#808080', gui = 'none', guibg='#1E1E1E'})
vim.highlight.create("TabLineFill", { guibg = '#1E1E1E', guifg='#1E1E1E'})
vim.highlight.create("Title", { gui='none', cterm='none', guibg = 'none', guifg='#D4D4D4'})
-- vim.highlight.create("TabLine", { guibg = '#10D6BCD', guifg = '#252525'})

-- vim.highlight.create("WarningMsg", { guifg = '#ff0000' })
-- vim.highlight.create("LspDiagnosticsFloatingWarning", { guifg = '#ff0000' })
-- vim.highlight.create("LspDiagnosticsSignWarning", { guifg = '#ff0000' })
-- vim.highlight.create("LspDiagnosticsUnderlineWarning", { guifg = '#ff0000' })
-- vim.highlight.create("LspDiagnosticsVirtualTextWarning", { guifg = '#ff0000' })
-- vim.highlight.create("LspDiagnosticsWarning", { guifg = '#ff0000' })
-- vim.highlight.create("DiagnosticVirtualTextWarning", { guifg = '#ff0000' })

-- the active status line
vim.highlight.create("StatusLine", { guifg = '#9D6BCD' })

-- the inactive status line
vim.highlight.create("StatusLineNC", { guifg = '#848484' })

-- nvim tree
require 'nvim-tree'.setup {
  view = {
    mappings = {
      custom_only = false,
      list = {
        -- custom mappings go here
        -- https://github.com/kyazdani42/nvim-tree.lua#mappings
        -- ctrl + n create file (add trailing / to create directory)
        { key = {"<C-n>" }, action = "create", mode = "n"},
      }
    }
  }
}

-- automatically close nvim tree if its the last window open
-- https://github.com/kyazdani42/nvim-tree.lua/discussions/1115
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd "quit"
    end
  end
})

-- Apply the basic terminal colors for the theme
-- there are 15 colors, plus "terminal_color_foreground" and "terminal_color_background"
vim.g.terminal_color_4          = '#569CD6'

require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}

-- To get fzf loaded and working with telescope, you need to call load_extension('fzf')
require('telescope').load_extension('fzf')

-- tresitter config
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = 'all',
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  -- https://github.com/p00f/nvim-ts-rainbow
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 9999,
    colors = {
      -- vsc brackets colorizer 2 theme
      "#EAC502",
      "#DA70D6",
      "#179CFB",
    },
  }
}

vim.opt.completeopt:remove("noinsert")
vim.opt.completeopt:remove("menuone")
vim.opt.completeopt:append("preview") -- Doesn't reliably close

-- nvim cmp
local cmp = require'cmp'
local luasnip = require'luasnip'

-- changes the behaviour about the completion popups
-- see :help completeopt
vim.o.completeopt="menu,menuone,noselect"

-- util function for tabbing through nvim-cmp suggestions
-- taken from https://github.com/GabrieleStulzer/dotfiles/blob/master/.config/nvim/lua/plugins/nvim-cmp.lua
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

    -- tab to go to next suggestion
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends an already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    -- shift tab to go to previous change
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end, { "i", "s" }),
  }),

  -- the different sources for completion
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- from the language server
    { name = 'luasnip' }, -- from snippets
    { name = 'buffer' }, -- from keywords in the buffer
    { name = 'nvim_lsp_signature_help' }, -- enables showing signature help
    { name = 'path' }, -- completing file paths
  })
})

-- load in snippet plugin packs (mainly just rafamadriz/friendly-snippets for now)
-- other snippets can be defined by the user
require("luasnip.loaders.from_vscode").lazy_load()

-- load nvim-autopairs
require'nvim-autopairs'.setup {
  disable_filetype = { "TelescopePrompt" },
  disable_in_macro = true,
  disable_in_visualblock = false,
  enable_moveright = true,
  enable_afterquite = true,
  enable_check_brakcet_line = true,
  enable_bracket_in_quote = true,
  break_undo = true
}

-- load nvim-neoclip
require'neoclip'.setup {
  histour = 1000,
  enable_persistent_history = false, -- causes a startup error
  length_limit = 1048576,
  db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3", -- usually in $HOME/.local/share/nvim
  filter = nil,
  preview = true,
  default_register = {'"', '+', '*'},
  default_register_macros = 'a',
  enable_macro_history = true,
  content_spec_column = false,
  on_paste = {
    set_reg = false
  },
  keys = {
    telescope = {
      i = {
        select = '<cr>',
        paste = '<c-p>',
        paste_behind = '<c-k>',
        replay = '<c-q>',  -- replay a macro
        delete = '<c-d>',  -- delete an entry
        custom = {},
      },
      n = {
        select = '<cr>',
        paste = 'p',
        paste_behind = 'P',
        replay = 'q',
        delete = 'd',
        custom = {},
      },
      fzf = {
        select = 'default',
        paste = 'ctrl-p',
        paste_behind = 'ctrl-k',
        custom = {},
      },
    }
  }
}

-- load neoclip as an extension for telescope
require'telescope'.load_extension'neoclip'

-- neogit
local neogit = require'neogit'
neogit.setup {
  intergrations = {
    diffview = true
  }
}
-- load help
local function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

local home = require'os'.getenv('HOME')

-- check for local tags
if not file_exists(home .. '/.config/nvim/doc/tags') then
  local docsPath = home .. '/.config/nvim/doc'
  vim.cmd('helpt ' .. docsPath)
end

-- nvim-lint
local lint = require'lint'
lint.linters_by_fr = {
  javascript = {'eslint'},
  typescript = {'eslint'},
  js = {'eslint'},
  ts = {'eslint'}
}

lint.linters.eslint.cmd = '/home/roland/.config/nvm/versions/node/v17.9.0/bin/eslint /home/roland/Documents/projects/lint/src/index.ts --ext .ts'
vim.cmd([[au BufEnter,InsertLeave * lua require('lint').try_lint()]])


-- local util = require 'color.util'
-- local theme = require 'color.theme'

-- vim.o.background = 'dark'
-- vim.g.colors_name = 'darkplus'

-- util.load(theme)

-- function _G.put(...)
--   local objects = {}
--   for i = 1, select('#', ...) do
--     local v = select(i, ...)
--     table.insert(objects, vim.inspect(v))
--   end

--   print(table.concat(objects, '\n'))
--   return ...
-- end

-- vim.highlight.creatvim.cmd('hi SpecialKey=Red')


-- vim.cmd('highlight RedundantSpaces ctermbg=red guibg=red')
-- vim.cmd('match RedundantSpaces \/\s\+$/')
-- vim.opt.list = true
-- vim.cmd('set listchars+=trail:~')
-- vim.cmd('hi SpecialKey=Red')
-- vim.cmd('set listchar+=space:␣')

-- QOL for

-- open splits like tmux
