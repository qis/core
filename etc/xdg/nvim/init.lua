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
  end
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = 'ListToggle',
  pattern = 'n:*', -- when leaving normal mode
  callback = function()
    vim.opt.list = false
  end
})

-- Clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Font Support
vim.g.have_nerd_font = true

-- File Browser
vim.g.netrw_banner = 0

-- Keymap
local key = vim.keymap.set
local nos = { noremap = true, silent = true }

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

-- Smart '<Home>' binding to switch between '^' and '0'.
key({ 'n', 'i', 'v' }, '<Home>', function()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local line = vim.api.nvim_get_current_line()
  if col > 1 and col <= (line:find('%S') or #line + 1) then
    vim.cmd('normal! 0')
  else
    vim.cmd('normal! ^')
  end
end, nos)

-- Consistent '<C-Left>', '<C-Right>', '<S-Left>' and '<S-Right>' in all modes.
local function word_prev(s, e)
  local pos = vim.api.nvim_win_get_cursor(0)
  local str = vim.api.nvim_get_current_line()
  while pos[2] > 0 and str:sub(pos[2], pos[2]):match(s) do
    pos[2] = pos[2] - 1
  end
  while pos[2] > 0 and str:sub(pos[2], pos[2]):match(e) do
    pos[2] = pos[2] - 1
  end
  vim.api.nvim_win_set_cursor(0, pos)
end

local function word_next(s, e)
  local pos = vim.api.nvim_win_get_cursor(0)
  local str = vim.api.nvim_get_current_line()
  pos[2] = pos[2] + 1
  while pos[2] <= #str and str:sub(pos[2], pos[2]):match(s) do
    pos[2] = pos[2] + 1
  end
  while pos[2] <= #str and str:sub(pos[2], pos[2]):match(e) do
    pos[2] = pos[2] + 1
  end
  pos[2] = pos[2] - 1
  vim.api.nvim_win_set_cursor(0, pos)
end

key({ 'n', 'v', 'i' }, '<C-Left>',  function() word_prev('[%s%W]', '[%w_]') end, nos)
key({ 'n', 'v', 'i' }, '<C-Right>', function() word_next('[%w_]', '[%s%W]') end, nos)
key({ 'n', 'v', 'i' }, '<S-Left>',  function() word_prev('%s', '%S') end, nos)
key({ 'n', 'v', 'i' }, '<S-Right>', function() word_next('%S', '%s') end, nos)

-- Consistent '<C-Backspace>', '<C-Del>' in insert mode.
key('i', '<C-Backspace>', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local str = vim.api.nvim_get_current_line()
  local col = pos[2]
  while pos[2] > 0 and str:sub(pos[2], pos[2]):match('[%s%W]') do
    pos[2] = pos[2] - 1
  end
  while pos[2] > 0 and str:sub(pos[2], pos[2]):match('[%w_]') do
    pos[2] = pos[2] - 1
  end
  vim.api.nvim_buf_set_text(0, pos[1] - 1, pos[2], pos[1] - 1, col, {})
  vim.api.nvim_win_set_cursor(0, pos)
end, nos)

key('i', '<C-Del>', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local str = vim.api.nvim_get_current_line()
  local col = pos[2]
  pos[2] = pos[2] + 1
  while pos[2] <= #str and str:sub(pos[2], pos[2]):match('[%w_]') do
    pos[2] = pos[2] + 1
  end
  while pos[2] <= #str and str:sub(pos[2], pos[2]):match('[%s%W]') do
    pos[2] = pos[2] + 1
  end
  vim.api.nvim_buf_set_text(0, pos[1] - 1, col, pos[1] - 1, pos[2] - 1, {})
  vim.api.nvim_win_set_cursor(0, { pos[1], col })
end, nos)

-- Yank single character with 'y' in normal mode.
key('n', 'y', 'yl', nos)

-- Keep cursor position after 'y' in visual mode.
key('v', 'y', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! y')
  vim.cmd('normal! \\<Esc>')
  vim.api.nvim_win_set_cursor(0, pos)
end, nos)

-- Replace selected text with 'p' in visual mode.
key('v', 'p', '"_dP', nos)

-- Redo with 'U' in normal mode.
key('n', 'U', vim.cmd.redo, nos)

-- Move current or selected lines with '<S-Up>' and '<S-Down>'.
key('n', '<S-Up>', ':move -2<CR>', nos)
key('v', '<S-Up>', ':move \'<-2<CR>gv', nos)
key('i', '<S-Up>', function()
  feedkeys('<Esc>:move -2<CR>' .. (vim.api.nvim_win_get_cursor(0)[2] == 0 and 'i' or 'a'))
end, nos)

key('n', '<S-Down>', ':move +1<CR>', nos)
key('v', '<S-Down>', ':move \'>+1<CR>gv', nos)
key('i', '<S-Down>', function()
  feedkeys('<Esc>:move +1<CR>' .. (vim.api.nvim_win_get_cursor(0)[2] == 0 and 'i' or 'a'))
end, nos)

-- Go to next/previous buffer with '<A-Right>' and '<A-Left>'.
key({ 'n', 'v', 'i' }, '<A-Right>', function()
  if vim.api.nvim_get_option_value('buftype', { buf = 0 }) ~= 'terminal' then
    vim.cmd.bnext()
  end
end, nos)

key({ 'n', 'v', 'i' }, '<A-Left>', function()
  if vim.api.nvim_get_option_value('buftype', { buf = 0 }) ~= 'terminal' then
    vim.cmd.bprev()
  end
end, nos)

-- Focus next/previous window with '<A-Down>' and '<A-Up>'.
key({ 'n', 'v', 'i', 't' }, '<A-Down>', function()
  vim.cmd.wincmd('w')
end, nos)

key({ 'n', 'v', 'i', 't' }, '<A-Up>', function()
  vim.cmd.wincmd('W')
end, nos)

-- Close popup windows and remove highlight with '<Esc>'.
key('n', '<Esc>', function()
  local closed = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
      closed = true
    end
  end
  if not closed then
    vim.cmd.nohlsearch()
  end
end, nos)

-- Enter normal mode with '<Esc><Esc>' in terminal.
key('t', '<Esc><Esc>', '<C-\\><C-n>', nos)

-- Forward '<C-c>' to terminal.
key('n', '<C-c>', function()
  if vim.bo.buftype == 'terminal' then
    local code = vim.api.nvim_replace_termcodes('<C-c>', true, false, true)
    vim.api.nvim_feedkeys('i' .. code, 'n', false)
  end
end, nos)

-- Keymap: Leader
key('n', '<Leader>q', function()
  local cur = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_get_option(cur, 'buflisted') then
    return vim.api.nvim_buf_delete(cur, { force = false })
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= cur and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
      return vim.api.nvim_buf_delete(cur, { force = false })
    end
  end
  vim.cmd('qall')
end, nos)

key('n', '<Leader>e' --[[Explorer]],    vim.cmd.Neotree, nos)
key('n', '<Leader>f' --[[Files]],       function() vim.cmd.Telescope('fd') end, nos)
key('n', '<Leader>b' --[[Buffers]],     function() vim.cmd.Telescope('buffers') end, nos)
key('n', '<Leader>s' --[[Sources]],     function() vim.cmd.Telescope('cmake_tools', 'sources') end, nos)
key('n', '<Leader>/' --[[Search]],      function() vim.cmd.Telescope('current_buffer_fuzzy_find') end, nos)
key('n', '<Leader>d' --[[Diganostics]], function() vim.cmd.Telescope('diagnostics') end, nos)
key('n', '<Leader>a' --[[All Format]],  function() vim.lsp.buf.format({ async = false }) end, nos)
key('n', '<Leader>p' --[[Breakpoint]],  function() require('dap').toggle_breakpoint() end, nos)

--key('n', '<Leader>dr', function() require('dap').repl.open() end, nos)
--key('n', '<Leader>du', function() require('dapui').toggle() end, nos)

-- Keymap: Development
key('n', '<C-Space>', function() vim.lsp.buf.hover({ border = 'rounded' }) end, nos)

key('n', '<F5>', function() require('dap').continue() end, nos)
key('n', '<F6>', vim.cmd.CMakeRun, nos)
key('n', '<F7>', vim.cmd.CMakeBuild, nos)
key('n', '<F8>', vim.cmd.CMakeGenerate, nos)

key('n', '<F10>', function() require('dap').step_over() end, nos)
key('n', '<F11>', function() require('dap').step_into() end, nos)
key('n', '<F12>', function() require('dap').step_out() end, nos)

key('n', '<F17>' --[[<S-F5>]], vim.cmd.CMakeSelectLaunchTarget, nos)
key('n', '<F18>' --[[<S-F6>]], vim.cmd.CMakeSelectLaunchTarget, nos)
key('n', '<F19>' --[[<S-F7>]], vim.cmd.CMakeSelectBuildTarget, nos)
key('n', '<F20>' --[[<S-F8>]], vim.cmd.CMakeSelectConfigurePreset, nos)

key('n', '<F12>', vim.lsp.buf.declaration, nos)

-- Plugins
vim.opt.packpath:append(vim.fn.stdpath('data'))

local function install(repo)
  local path = vim.split(repo, '/')
  local plugin = vim.fn.stdpath('data') .. '/pack/plugins/opt/' .. path[#path]
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
  vim.cmd.packadd(path[#path])
end

-- Libraries
install('nvim-tree/nvim-web-devicons')
install('nvim-lua/plenary.nvim')
install('MunifTanjim/nui.nvim')
install('rcarriga/nvim-notify')

-- Color Scheme
install('navarasu/onedark.nvim')
local onedark = require('onedark')

onedark.setup({
  style = 'warmer',
  transparent = true,
  lualine = {
    transparent = true
  },
  colors = {
    title  = '#de5d68',
    border = '#57a5e5',
  },
  code_style = {
    comments = 'none',
  },
  highlights = {
    ['NormalFloat']            = { fg = '$border', bg = 'none' },
    ['FloatBorder']            = { fg = '$border', bg = 'none' },
    ['NeoTreeFloatTitle']      = { fg = '$title',  bg = 'none' },
    ['TelescopeTitle']         = { fg = '$title',  bg = 'none' },
    ['TelescopeBorder']        = { fg = '$title',  bg = 'none' },
    ['TelescopePromptBorder']  = { fg = '$border', bg = 'none' },
    ['TelescopeResultsBorder'] = { fg = '$border', bg = 'none' },
    ['TelescopePreviewBorder'] = { fg = '$border', bg = 'none' },
  }
})

onedark.load()

-- Treesitter
install('nvim-treesitter/nvim-treesitter')
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'markdown', 'markdown_inline' }
})

-- Notifications
install('folke/noice.nvim')
require('noice').setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true
    },
    hover = {
      enabled = true
    }
  },
  presets = {
    bottom_search = false,         -- use a classic bottom cmdline for search
    command_palette = true,        -- position the cmdline and popupmenu together
    long_message_to_split = true,  -- long messages will be sent to a split
    inc_rename = false,            -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true,         -- add a border to hover docs and signature help
  },
  views = {
    hover = {
      border = {
        style = 'rounded',
        padding = { 0, 0 }
      }
    }
  }
})

-- File Browser
install('nvim-neo-tree/neo-tree.nvim')
require('neo-tree').setup({
  hide_root_node = true,
  popup_border_style = 'rounded',
  window = {
    position = 'float',
    popup = {
      size = { height = '90%' },
      title = function(state)
        if state.path then
          return vim.fn.fnamemodify(state.path, ':t')
        end
        return state.name
      end
    }
  }
})

-- Telescope
install('nvim-telescope/telescope.nvim')
local telescope = require('telescope')

telescope.setup()
telescope.load_extension('noice')

-- Diff View
install('sindrets/diffview.nvim')
require('diffview').setup()

-- Git Signs
install('lewis6991/gitsigns.nvim')
require('gitsigns').setup()

-- Terminal
install('akinsho/toggleterm.nvim')
require('toggleterm').setup({
  size = 16, direction = 'horizontal', open_mapping = ''  -- <Pause>
})

-- Buffers
install('akinsho/bufferline.nvim')
local bufferline = require('bufferline')

bufferline.setup({
  options = {
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    truncate_names = false,
    indicator = { icon = '', style = 'none' },
    modified_icon = '',
    left_trunc_marker = ' ',
    right_trunc_marker = ' ',
    separator_style = { '', '' },
    diagnostics = 'nvim_lsp',
    style_preset = {
      bufferline.style_preset.no_italic,
      bufferline.style_preset.minimal,
    },
    custom_filter = function(buf, bufs)
      if vim.bo[buf].filetype == 'neo-tree' then
        return false
      end
      if vim.bo[buf].filetype == 'toggleterm' then
        return false
      end
      return true
    end
  }
})

-- CMake
install('Civitasv/cmake-tools.nvim')
local cmake = require('cmake-tools')

cmake.setup({
  cmake_soft_link_compile_commands = false,
  cmake_compile_commands_from_lsp = true,
  cmake_build_directory = function()
    return 'build/${variant:buildType}'
  end,
  cmake_executor = {
    name = 'toggleterm',
    opts = {
      direction = 'horizontal',
      start_in_insert = true
    }
  },
  cmake_runner = {
    name = 'toggleterm',
    opts = {
      direction = 'horizontal',
      start_in_insert = true
    }
  }
})

local function is_cmake_directory()
  return cmake.is_cmake_project() and cmake.has_cmake_preset()
end

local cmake_status_preset = {
  function()
    local preset = cmake.get_configure_preset()
    return preset and preset or '[preset]'
  end,
  on_click = function(n, mouse)
    if n == 1 then
      if mouse == 'l' then
        vim.cmd('CMakeSelectConfigurePreset')
      elseif mouse == 'r' then
        vim.cmd('CMakeGenerate')
      end
    end
  end,
  cond = is_cmake_directory,
  icon = ''  -- ''
}

local cmake_status_build_target = {
  function()
    local target = cmake.get_build_target()
    return target and target or '[build]'
  end,
  on_click = function(n, mouse)
    if n == 1 and mouse == 'l' then
      vim.cmd('CMakeSelectBuildTarget')
    end
  end,
  cond = is_cmake_directory,
  icon = ''
}

local cmake_status_launch_target = {
  function()
    local target = cmake.get_launch_target()
    return target and target or '[run]'
  end,
  on_click = function(n, mouse)
    if n == 1 and mouse == 'l' then
      vim.cmd('CMakeSelectLaunchTarget')
    end
  end,
  cond = is_cmake_directory,
  icon = ''
}

-- Status
install('nvim-lualine/lualine.nvim')
require('lualine').setup({
  options = {
    globalstatus = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    ignore_focus = { 'toggleterm' }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      'diff',
      'diagnostics',
      cmake_status_preset,
      cmake_status_build_target,
      cmake_status_launch_target,
    },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { 'neo-tree' }
})

-- CMP
install('hrsh7th/nvim-cmp')
install('hrsh7th/cmp-nvim-lsp')
install('hrsh7th/cmp-nvim-lsp-signature-help')

local cmp = require('cmp')

local cmp_icons = {
  Text = '',
  Method = 'm',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

local completion = cmp.config.window.bordered()
completion.max_width = 40

local documentation = cmp.config.window.bordered()
documentation.max_width = 80

cmp.setup({
  enabled = function()
    return vim.bo.buftype ~= 'prompt' and vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'terminal'
  end,
  window = {
    completion = completion,
    documentation = documentation,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Left>'] = cmp.mapping.scroll_docs(-4),
    ['<Right>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<Esc>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
  },
  {
    { name = 'buffer' },
  }),
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, item)
      item.kind = string.format('%s', cmp_icons[item.kind])
      item.menu = ({
        nvim_lsp_signature_help = '[S]',
        nvim_lsp = '[C]',
        buffer = '[B]',
        path = '[P]',
      })[entry.source.name]
      item.abbr = string.sub(item.abbr, 1, completion.max_width)
      return item
    end,
  },
  completion = {
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
    },
  },
})

-- LSP
install('neovim/nvim-lspconfig')
local lspconfig = require('lspconfig')

lspconfig.clangd.setup({
  cmd = {
    '/opt/ace/bin/clangd',          -- executable
    '--clang-tidy',                 -- enable clang-tidy diagnostics
    '--background-index',           -- index project code in the background and persist index on disk
    '--completion-style=detailed',  -- granularity of code completion suggestions: bundled, detailed
    '--function-arg-placeholders',  -- completions contain placeholders for method parameters
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  single_file_support = false,
  on_new_config = function(config, cwd)
    local cmake_config = cmake.get_config()
    if cmake_config.build_directory and cmake_config.build_directory.filename then
      config.init_options = config.init_options or {}
      config.init_options.compilationDatabasePath = cmake_config.build_directory.filename
    end
    cmake.clangd_on_new_config(config)
  end
})

-- DAP
install('nvim-neotest/nvim-nio')
install('mfussenegger/nvim-dap')
local dap = require('dap')

dap.adapters.lldb = {
  name = 'lldb',
  type = 'executable',
  command = '/opt/ace/bin/lldb-dap'
}

dap.configurations.cpp = {
  {
    name = 'lldb',
    type = 'lldb',
    request = 'launch',
    runInTerminal = false,
    cwd = '${workspaceFolder}',
    program = function()
      local target = cmake.get_launch_target_path()
      return target and target or vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {},
  }
}

dap.configurations.c = dap.configurations.cpp

install('rcarriga/nvim-dap-ui')
local dapui = require('dapui')

dapui.setup({
  layouts = {
    {
      elements = {
        { id = 'repl', size = 0.75 },
        { id = 'watches', size = 0.25 },
      },
      position = 'bottom',
      size = 10
    }
  },
  mappings = {
    edit = 'e',
    expand = { '<Space>', '<2-LeftMouse>' },
    open = '<CR>',
    remove = 'r',
    toggle = 't',
    repl = 'c'
  }
})

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- Globally disable the italic font style.
local hl_groups = vim.api.nvim_get_hl(0, {})
for key, hl_group in pairs(hl_groups) do
  if hl_group.italic then
    vim.api.nvim_set_hl(0, key, vim.tbl_extend('force', hl_group, { italic = false }))
  end
end
