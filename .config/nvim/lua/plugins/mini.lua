return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.sessions").setup()
		require("mini.comment").setup()
		require("mini.surround").setup()
		require("mini.pairs").setup()
	end,
}
