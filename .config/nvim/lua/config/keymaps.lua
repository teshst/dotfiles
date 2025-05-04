local map = vim.keymap.set
local wk = require("which-key")

wk.add({
  { "<leader>f", group = "file" },
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File", mode = "n" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search Files", mode = "n" },
  { "<leader>b", "<cmd>Telescope buffers<cr>", group = "buffers"},
})

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Neotree
map("n", "<leader>n", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" })

-- Lsp
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Format
map("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })

-- floating terminal
map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })

