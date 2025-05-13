-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Leader Timeout
vim.opt.timeoutlen = 900

-- Encoding
vim.opt.fileencoding = 'utf-8'

-- Tabs
vim.opt.tabstop = 8
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Indent
vim.opt.breakindent = true
vim.opt.smartindent = false

-- Case Sensitivity
-- Prefix with '\C' to disable.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Mouse
vim.opt.mouse = 'a'

-- Scroll
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

-- Split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Interface
vim.opt.confirm = true
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.updatetime = 250

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Tabline
vim.opt.showtabline = 2

-- Gutter
vim.opt.foldcolumn = '1'
vim.opt.signcolumn = 'yes'  -- 'yes:1'

-- Completion
vim.opt.pumheight = 10
vim.opt.completeopt = 'menuone,noselect,fuzzy,popup'
vim.opt.shortmess:append('c')
vim.opt.winborder = 'none'

-- Diff
vim.opt.diffopt:append('linematch:60')

-- Files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- Special Characters
vim.opt.list = true
vim.opt.fillchars:append('stl: ,stlnc: ,')
vim.opt.listchars = 'tab:»·,trail:·,extends:»,precedes:«,nbsp:␣'

vim.api.nvim_create_augroup('ListToggle', {
  clear = true
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = 'ListToggle',
  pattern = '*:n', -- when entering normal mode
  callback = function()
    vim.opt.list = true
  end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = 'ListToggle',
  pattern = 'n:*', -- when leaving normal mode
  callback = function()
    vim.opt.list = false
  end,
})

-- Clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Font Support
vim.g.have_nerd_font = true

-- File Browser
vim.g.netrw_banner = 0

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end
})

-- Keymap
local key = vim.keymap.set
local nos = { noremap = true, silent = true }

-- Keymap: Buffers
key('n', '<A-Right>', vim.cmd.bnext, nos)
key('i', '<A-Right>', vim.cmd.bnext, nos)

key('n', '<A-Left>', vim.cmd.bprev, nos)
key('i', '<A-Left>', vim.cmd.bprev, nos)

-- Keymap: Windows
key('i', '<A-Down>', function() vim.cmd.wincmd('w') end, nos)
key('n', '<A-Down>', function() vim.cmd.wincmd('w') end, nos)
key('t', '<A-Down>', function() vim.cmd.wincmd('w') end, nos)

key('i', '<A-Up>', function() vim.cmd.wincmd('W') end, nos)
key('n', '<A-Up>', function() vim.cmd.wincmd('W') end, nos)
key('t', '<A-Up>', function() vim.cmd.wincmd('W') end, nos)

-- Keymap: Highlights
key('n', '<Esc>', vim.cmd.nohlsearch, nos)

-- Keymap: Leader
key('n', '<Leader>q', function()
  local listed_buffers_count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
      listed_buffers_count = listed_buffers_count + 1
    end
  end
  if listed_buffers_count > 1 then
    vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = false })
  else
    vim.cmd('qall')
  end
end, nos)

key('n', '<Leader>f', vim.cmd.Neotree, nos)
key('n', '<Leader>o', function() vim.cmd.Telescope('fd') end, nos)
key('n', '<Leader>b', function() vim.cmd.Telescope('buffers') end, nos)
key('n', '<Leader>s', function() vim.cmd.Telescope('current_buffer_fuzzy_find') end, nos)
key('n', '<Leader>d', function() vim.cmd.Telescope('diagnostics') end, nos)

-- Plugins
local function install(name, repo)
  local plugin = vim.fn.stdpath('data') .. '/plugins/' .. name
  if not vim.uv.fs_stat(plugin) then
    vim.api.nvim_echo({{ 'Cloning ' .. repo .. ' ...' }}, false, {})
    local out = vim.fn.system({
      'git', 'clone', '--filter=blob:none', '--depth', '1', 'https://github.com/' .. repo, plugin
    })
    if vim.v.shell_error ~= 0 then
      error(out)
    end
    vim.api.nvim_echo({{''}}, false, {})
    vim.cmd('redraw')
  end
  vim.opt.rtp:append(plugin)
end

local function load(name, repo, branch)
  install(name, repo, branch)
  return require(name)
end

-- Libraries
install('nui', 'MunifTanjim/nui.nvim')
install('plenary', 'nvim-lua/plenary.nvim')
install('nvim-web-devicons', 'nvim-tree/nvim-web-devicons')

-- Color Scheme
local onedark = load('onedark', 'navarasu/onedark.nvim')

onedark.setup({
  style = 'warmer',
  transparent = true,
  lualine = {
    transparent = true
  },
  colors = {
    title     = '#de5d68',
    border    = '#57a5e5',
    filename  = '#57a5e5',
    separator = '#818387',
  },
  code_style = {
    comments = 'none',
  },
  highlights = {
    -- windows
    ['NeoTreeFloatTitle']      = { fg = '$title',     bg = 'none' },
    ['TelescopeTitle']         = { fg = '$title',     bg = 'none' },
    ['TelescopeBorder']        = { fg = '$title',     bg = 'none' },
    ['TelescopePromptBorder']  = { fg = '$border',    bg = 'none' },
    ['TelescopeResultsBorder'] = { fg = '$border',    bg = 'none' },
    ['TelescopePreviewBorder'] = { fg = '$border',    bg = 'none' },
    ['FloatBorder']            = { fg = '$border',    bg = 'none' },
    ['NormalFloat']            = { fg = '$border',    bg = 'none' },
  },
  --toggle_style_key = '<A-c>',
})

onedark.load()

-- File Browser
load('neo-tree', 'nvim-neo-tree/neo-tree.nvim').setup({
  hide_root_node = true,
  popup_border_style = "rounded",
  use_default_mappings = false,
  window = {
    position = "float",  -- https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
    popup = {
      position = "50%",
      relative = "editor",
      size = { height = "80%", width = "63" },
      title = function(state)
        if state.path then
          return vim.fn.fnamemodify(state.path, ':t')
        end
        return state.name
      end
    },
    mapping_options = { noremap = true, nowait = true },
    mappings = {
      ["<space>"] = { "toggle_node", nowait = false },
      ["<2-LeftMouse>"] = "open_drop",
      ["<cr>"] = "open_drop",
      ["<esc>"] = "cancel",
      ["z"] = "expand_all_subnodes",
      ["Z"] = "expand_all_nodes",
      ["R"] = "refresh",
      ["a"] = {
        "add",
        config = {
          show_path = "relative"
        }
      },
      ["A"] = "add_directory",  -- also accepts the config.show_path and config.insert_as options
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy",  -- takes text input for destination, also accepts the config.show_path and config.insert_as options
      ["m"] = "move",  -- takes text input for destination, also accepts the config.show_path and config.insert_as options
      ["q"] = "close_window",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source"
    }
  },
  filesystem = {
    window = {
      mappings = {
        ["h"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter",
        ["<C-x>"] = "clear_filter",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["["] = "prev_git_modified",
        ["]"] = "next_git_modified",
        ["i"] = "show_file_details",  -- see `:h neo-tree-file-actions` for options to customize the window
        ["b"] = "rename_basename",
        ["o"] = {
          "show_help",
          nowait = false,
          config = {title = "Order by", prefix_key = "o"}
        },
        ["oc"] = {"order_by_created", nowait = false},
        ["od"] = {"order_by_diagnostics", nowait = false},
        ["og"] = {"order_by_git_status", nowait = false},
        ["om"] = {"order_by_modified", nowait = false},
        ["on"] = {"order_by_name", nowait = false},
        ["os"] = {"order_by_size", nowait = false},
        ["ot"] = {"order_by_type", nowait = false}
      },
      fuzzy_finder_mappings = {
        ["<down>"] = "move_cursor_down",
        ["<C-n>"] = "move_cursor_down",
        ["<up>"] = "move_cursor_up",
        ["<C-p>"] = "move_cursor_up",
        ["<esc>"] = "close"
      }
    },
  },
})

-- Telescope
load('telescope', 'nvim-telescope/telescope.nvim').setup()

-- Diff View
load('diffview', 'sindrets/diffview.nvim').setup()

-- Git Signs
load('gitsigns', 'lewis6991/gitsigns.nvim').setup({
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged_enable = true,
  signcolumn = true,   -- toggle with `:Gitsigns toggle_signs`
  numhl      = false,  -- toggle with `:Gitsigns toggle_numhl`
  linehl     = false,  -- toggle with `:Gitsigns toggle_linehl`
  word_diff  = false,  -- toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false,  -- toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',  -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,  -- use default
  max_file_length = 40000,  -- disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to `nvim_open_win`.
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
})

-- Terminal
load('toggleterm', 'akinsho/toggleterm.nvim').setup({
  size = 16,
  open_mapping = '',  -- <Pause>
  direction = 'horizontal',  -- 'horizontal' | 'tab' | 'float'
  float_opts = {
    border = 'rounded',
  },
})

-- Status
load('lualine', 'nvim-lualine/lualine.nvim').setup({
  options = {
    theme = 'auto',
    globalstatus = true,
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})

-- Buffers
local bufferline = load('bufferline', 'akinsho/bufferline.nvim')

bufferline.setup({
  options = {
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = false,
    buffer_close_icon = '×',
    left_trunc_marker = ' ',
    right_trunc_marker = ' ',
    separator_style = { '', '' },
    diagnostics = 'nvim_lsp',
    style_preset = {
      bufferline.style_preset.minimal,
      bufferline.style_preset.no_italic,
    },
    enforce_regular_tabs = true,
    custom_filter = function(buf, bufs)
      if vim.bo[buf].filetype ~= 'neo-tree' then
        return true
      end
      if vim.bo[buf].filetype ~= 'toggleterm' then
        return true
      end
      return false
    end,
  },
})

-- Globally disable the italic font style.
local hl_groups = vim.api.nvim_get_hl(0, {})
for key, hl_group in pairs(hl_groups) do
  if hl_group.italic then
    vim.api.nvim_set_hl(0, key, vim.tbl_extend('force', hl_group, { italic = false }))
  end
end
