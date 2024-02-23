-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("thecodetherapy.goto")

local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local surround_chars = "[\"'(){}%[%]]"

local function jump_right_on_surroundings()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(winnr)
  local line_num, col = cursor_pos[1], cursor_pos[2] + 1
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  for l = line_num, total_lines do
    local line_text = vim.api.nvim_buf_get_lines(bufnr, l - 1, l, false)[1]
    local start_index = l == line_num and col or 1
    local found_at_line_end = false
    for i = start_index, #line_text do
      if string.match(line_text:sub(i, i), surround_chars) then
        if i == #line_text then
          found_at_line_end = true
          break
        else
          vim.api.nvim_win_set_cursor(winnr, { l, i })
          return
        end
      end
    end

    if found_at_line_end then
      if l < total_lines then
        line_num = l + 1
        col = 1
      else
        return
      end
    else
      if l < total_lines then
        line_num = l + 1
        col = 1
      end
    end
  end
end

local function jump_left_on_surroundings()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(winnr)
  local line_num, col = cursor_pos[1], cursor_pos[2]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_num, false)

  for ln = #lines, 1, -1 do
    local line_text = lines[ln]
    local end_col = ln == line_num and col or #line_text
    for i = end_col, 1, -1 do
      local char = line_text:sub(i, i)
      if string.match(char, surround_chars) then
        vim.api.nvim_win_set_cursor(winnr, { ln, i - 2 })
        return
      end
    end
  end
end

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", "vb_d")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Move lines around
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)

-- New tab
keymap.set("n", "te", "tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Morse surroundings
keymap.set({ "n", "i", "v" }, ",,,", jump_left_on_surroundings, opts)
keymap.set({ "n", "i", "v" }, ",,", jump_right_on_surroundings, opts)

-- Move around
keymap.set("n", "<leader><Left>", "<C-w>h")
keymap.set("n", "<leader><Right>", "<C-w>l")
keymap.set("n", "<leader><Up>", "<C-w>k")
keymap.set("n", "<leader><Down>", "<C-w>j")
keymap.set("n", "<A-Right>", ":BufferLineCycleNext<CR>", opts)
keymap.set("n", "<A-Left>", ":BufferLineCyclePrev<CR>", opts)

-- Resize
keymap.set("n", "<C-w><Left>", "<C-w><")
keymap.set("n", "<C-w><Right>", "<C-w>>")

-- Disable default macro record
keymap.set("n", "q", "<Nop>", opts)

vim.api.nvim_set_keymap("n", "gg", "<cmd>lua require('thecodetherapy.goto').go_to_implementation()<CR>", opts)
