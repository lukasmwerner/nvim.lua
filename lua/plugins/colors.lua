return { {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		local function get_macos_appearance()
			local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null')
			if handle == nil then return 'light' end

			local result = handle:read("*a")
			handle:close()

			-- Trim any whitespace/newlines
			result = result:gsub("^%s*(.-)%s*$", "%1")

			-- If the result is exactly "Dark", we're in dark mode
			-- If it's empty or contains the error message, we're in light mode
			return result == "Dark" and 'dark' or 'light'
		end


		if os.getenv("system_appearance") ~= "present" then
			-- load the colorscheme here
			vim.cmd("set termguicolors")
			if get_macos_appearance() == 'dark' then
				vim.cmd("set background=" .. 'dark')
			else
				vim.cmd("set background=light") -- can also be light / dark
			end
			vim.cmd("let g:everforest_background = 'hard'")
			vim.cmd([[colorscheme everforest]])
		end
	end,
}, {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		if os.getenv("system_appearance") == "present" then
			vim.cmd.colorscheme "catppuccin-latte"
		end
	end
} }
