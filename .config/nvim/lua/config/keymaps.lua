local map = vim.keymap.set

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

-- new file
map("n", "e", "<cmd>enew<cr>", { desc = "New File" })
-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Neotree
map("n", "<leader>n", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Search all files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Active buffers" })
map("n", "<leader>fh", "<cmd>Telescope oldfiles<cr>", { desc = "Recently opened files" })
map("n", "<leader>fr", "<cmd>Telescope frecency workspace=CWD<cr>", { desc = "Frecency files" })
map("n", "<leader>fm", "<cmd>Telescope bookmarks list<cr>", { desc = "List bookmarks" })

-- Lsp
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Format
map("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })

-- floating terminal
map("n", "<leader>fT", function()
	Snacks.terminal()
end, { desc = "Terminal (cwd)" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })

-- Dap Debugger
map("n", "<Leader>dt", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle Breakpoint" })
map("n", "<Leader>dc", "<cmd>DapContinue<cr>", { desc = "Continue Debugger" })

-- Sessions
map("n", "<leader>sl", "<cmd>SessionManager load_last_session<cr>", { desc = "Load last session" })
map("n", "<leader>sd", "<cmd>SessionManager delete_session<cr>", { desc = "Select and delete session" })
map("n", "<leader>ss", "<cmd>SessionManager load_session<cr>", { desc = "Select and load session" })
