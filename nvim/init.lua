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
