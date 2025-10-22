return {
	{
		"neovim/nvim-treesitter",
		event = "BufEnter",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function(_, opts)
			local theme_name = "auto"

			local theme = require("lualine.themes." .. theme_name)

			for _, section in pairs(theme) do
				if section.c == nil then
					goto continue
				end
				-- section.c.fg = section.c.bg
				section.c.bg = require("lualine.utils.utils").extract_highlight_colors("Normal", "bg")
				::continue::
			end

			local empty = require("lualine.component"):extend()
			function empty:draw(default_highlight)
				self.status = " "
				self.applied_separator = ""
				self:apply_highlights(default_highlight)
				self:apply_section_separators()
				return self.status
			end

			local function process_sections(sections)
				for name, section in pairs(sections) do
					for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
						table.insert(section, pos * 2, { empty, color = theme.normal.c })
					end
				end
				return sections
			end

			return vim.tbl_deep_extend("force", opts, {
				options = {
					globalstatus = true,
					theme = theme,
					component_separators = "",
					section_separators = "",
				},
				sections = process_sections({
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {},
					lualine_x = { "encoding" },
					lualine_y = {},
					lualine_z = { "location" },
				}),
			})
		end,
		lazy = false,
	},
	{
		"b0o/incline.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
		},
		config = function(_, opts)
			require("incline").setup(opts)
		end,
		-- Optional: Lazy load Incline
		opts = function(_, opts)
			local navic = require("nvim-navic")
			local devicons = require("nvim-web-devicons")
			local helpers = require("incline.helpers")
			local hl = require("ripped.highlights")

			opts.window = {
				overlap = {
					borders = true,
				},
				margin = {
					vertical = 0,
				},
			}

			opts.render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if filename == "" then
					filename = "[No Name]"
				end

				local ft_icon, ft_color = devicons.get_icon_color(filename)

				local ft_color_dim = hl.rgb_to_hex(hl.lab_to_rgb(hl.dim(hl.rgb_to_lab(hl.rgb(ft_color)))))
				-- Snacks.debug(hl.rgb(ft_color))
				local modified = vim.bo[props.buf].modified
				local res = {
					ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = ft_color_dim } or "",
					" ",
					{ filename, gui = modified and "bold,italic" or "bold" },
					-- guibg = '#44406e',
					guibg = ft_color_dim,
					guifg = ft_color,
					-- group = "UiPalette3",
				}
				if props.focused then
					for _, item in ipairs(navic.get_data(props.buf) or {}) do
						table.insert(res, {
							{ " > ", group = "NavicSeparator" },
							{ item.icon, group = "NavicIcons" .. item.type },
							{ item.name, group = "NavicText" },
						})
					end
				end
				table.insert(res, " ")
				return res
			end
			return opts
		end,

		event = "VeryLazy",
	},
	"folke/which-key.nvim",
	{
		"stevearc/quicker.nvim",
		event = "FileType qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {},
	},
	{
		"mcauley-penney/visual-whitespace.nvim",
		config = true,
		event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
		opts = {},
	},

	{
		"OXY2DEV/helpview.nvim",
		lazy = false,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			--refer to the configuration section below
		},
	},
	-- {
	--   "a-usr/nvchad_ui",
	--   name = "ui",
	-- },
	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	opts = function(_, opts)
	-- 		opts.hijack_netrw = true
	-- 		opts.disable_netrw = false
	-- 		return opts
	-- 	end,
	-- },
	-- {
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	opts = {
	-- 		source_selector = { winbar = true },
	-- 	},
	-- },
	{
		"a-usr/nui.nvim",
		name = "nui.nvim",
	},
	{
		-- enabled = false,
		"luukvbaal/statuscol.nvim",
		event = "BufEnter",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				--   -- configuration goes here, for example:
				-- relculright = true,
				segments = {
					{ sign = { namespace = { "gitsigns_signs_.*" }, colwidth = 1, maxwidth = 2, auto = true } },
					{
						text = { builtin.foldfunc },
						click = "v:lua.ScFa",
					},
					{
						sign = { name = { "todo%-sign%-.*" }, auto = true, maxwidth = 2 },
						click = "v:lua.ScSa",
					},
					{
						sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
						click = "v:lua.ScSa",
					},
					{
						sign = { name = { "Dap.*" }, auto = true },
						click = "v:lua.ScSa",
					},
					{
						text = { builtin.lnumfunc, " " },
						click = "v:lua.ScLa",
					},
					{
						sign = {
							namespace = { ".*" },
							name = { ".*" },
							maxwidth = 2,
							colwidth = 1,
							auto = true,
							wrap = true,
						},
						click = "v:lua.ScSa",
					},
				},

				clickhandlers = {
					---@param args (table): {
					---   minwid = minwid,            -- 1st argument to 'statuscolumn' %@ callback
					---   clicks = clicks,            -- 2nd argument to 'statuscolumn' %@ callback
					---   button = button,            -- 3rd argument to 'statuscolumn' %@ callback
					---   mods = mods,                -- 4th argument to 'statuscolumn' %@ callback
					---   mousepos = f.getmousepos()  -- getmousepos() table, containing clicked line number/window id etc.
					--- }
					["todo%-sign%-.*"] = function(args)
						print("a")
						print(vim.inspect(args))
						if args.button == "l" then
							vim.cmd("Trouble todo")
						end
					end,
				},
			})
		end,
	},
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		opts = function()
			local opts = {
				---@module "edgy"
				---@type (Edgy.View.Opts|string)[]
				left = {},
				---@type (Edgy.View.Opts|string)[]
				bottom = {
					{
						ft = "toggleterm",
						size = { height = 0.4 },
						-- dont exclude floating windows :)
						filter = function(buf, win)
							local wincfg = vim.api.nvim_win_get_config(win)
							return wincfg.relative ~= "" or wincfg.split == "below"
						end,
					},
					-- {
					--   ft = "NvTerm_sp",
					--   size = { height = 0.4 },
					-- },

					{ ft = "qf", title = "QuickFix" },
					{
						ft = "help",
						size = { height = 20 },
						-- only show help buffers
						filter = function(buf)
							return vim.bo[buf].buftype == "help"
						end,
					},
					{
						ft = "markdown", -- that exists, if it bothers you complain to lspconfig
						size = { height = 20 },
						-- only show help buffers
						filter = function(buf)
							return vim.bo[buf].buftype == "help"
						end,
					},
				},
				---@type (Edgy.View.Opts|string)[]
				---@type (Edgy.View.Opts|string)[]
				top = {},

				---@type table<Edgy.Pos, {size:(integer | fun():integer), wo?:vim.wo}>
				options = {
					left = { size = 30 },
					bottom = { size = 10 },
					right = { size = 30 },
					top = { size = 10 },
				},
				-- edgebar animations
				animate = {
					enabled = true,
					fps = 100, -- frames per second
					cps = 1200, -- cells per second
					on_begin = function()
						vim.g.minianimate_disable = true
					end,
					on_end = function()
						vim.g.minianimate_disable = false
					end,
					-- Spinner for pinned views that are loading.
					-- if you have noice.nvim installed, you can use any spinner from it, like:
					-- spinner = require("noice.util.spinners").spinners.circleFull,
					spinner = {
						frames = { " ⠋", " ⠙", " ⠹", " ⠸", " ⠼", " ⠴", " ⠦", " ⠧", " ⠇", " ⠏" },
						interval = 80,
					},
				},
				-- enable this to exit Neovim when only edgy windows are left
				exit_when_last = true,
				-- close edgy when all windows are hidden instead of opening one of them
				-- disable to always keep at least one edgy split visible in each open section
				close_when_all_hidden = true,
				-- global window options for edgebar windows
				---@type vim.wo
				wo = {
					-- Setting to `true`, will add an edgy winbar.
					-- Setting to `false`, won't set any winbar.
					-- Setting to a string, will set the winbar to that string.
					winbar = true,
					winfixwidth = true,
					winfixheight = false,
					winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
					spell = false,
					signcolumn = "no",
				},
				-- buffer-local keymaps to be added to edgebar buffers.
				-- Existing buffer-local keymaps will never be overridden.
				-- Set to false to disable a builtin.
				---@type table<string, fun(win:Edgy.Window)|false>
				keys = {
					-- close window
					["q"] = function(win)
						win:close()
					end,
					-- hide window
					["<c-q>"] = function(win)
						win:hide()
					end,
					-- close sidebar
					["Q"] = function(win)
						win.view.edgebar:close()
					end,
					-- next open window
					["]w"] = function(win)
						win:next({ visible = true, focus = true })
					end,
					-- previous open window
					["[w"] = function(win)
						win:prev({ visible = true, focus = true })
					end,
					-- next loaded window
					["]W"] = function(win)
						win:next({ pinned = false, focus = true })
					end,
					-- prev loaded window
					["[W"] = function(win)
						win:prev({ pinned = false, focus = true })
					end,
					-- increase width
					["<c-w>>"] = function(win)
						win:resize("width", 2)
					end,
					-- decrease width
					["<c-w><lt>"] = function(win)
						win:resize("width", -2)
					end,
					-- increase height
					["<c-w>+"] = function(win)
						win:resize("height", 2)
					end,
					-- decrease height
					["<c-w>-"] = function(win)
						win:resize("height", -2)
					end,
					-- reset all custom sizing
					["<c-w>="] = function(win)
						win.view.edgebar:equalize()
					end,
				},
				icons = {
					closed = "  ",
					open = "  ",
				},
				-- enable this on Neovim <= 0.10.0 to properly fold edgebar windows.
				-- Not needed on a nightly build >= June 5, 2023.
				fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
			}
			-- trouble
			for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
				opts[pos] = opts[pos] or {}
				table.insert(opts[pos], {
					ft = "trouble",
					filter = function(_buf, win)
						return vim.w[win].trouble
							and vim.w[win].trouble.position == pos
							and vim.w[win].trouble.type == "split"
							and vim.w[win].trouble.relative == "editor"
							and not vim.w[win].trouble_preview
					end,
				})
			end
			return opts
		end,
	},
	-- {
	-- 	"Bekaboo/dropbar.nvim",
	-- 	-- optional, but required for fuzzy finder support
	-- 	-- dependencies = {
	-- 	--   'nvim-telescope/telescope-fzf-native.nvim',
	-- 	--   build = 'make'
	-- 	-- },
	-- 	event = "FileType",
	-- 	config = function()
	-- 		local dropbar_api = require "dropbar.api"
	-- 		vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
	-- 		-- vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
	-- 		-- vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
	-- 	end,
	-- },
	{
		event = "LspAttach",
		"a-usr/nvim-navbuddy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"a-usr/nui.nvim",
		},
		opts = {
			lsp = { auto_attach = true },
			node_markers = {
				icons = {
					branch = " ",
				},
			},
			icons = {
				Enum = "󰕘 ",
				Interface = "󰕘 ",
			},
		},
	},
	{
		"sphamba/smear-cursor.nvim",
		event = "BufEnter",
		opts = {
			smear_to_cmd = false,
			stiffness = 0.7,
			trailing_stiffness = 0.70,
			-- cursor_color = "#ffffff",
			gradient_exponent = 0,
			never_draw_over_target = true,
			particles_enabled = true,
			particle_spread = 1.5,
			particles_per_second = 200,
			particles_per_length = 70,
			particle_max_lifetime = 2000,
			particle_max_initial_velocity = 10,
			particle_velocity_from_cursor = 0,
			particle_random_velocity = 300,
			particle_damping = 0.1,
			particle_gravity = 50,
		},
	},
	-- {
	--   -- enabled = false,
	--   "utilyre/barbecue.nvim",
	--   name = "barbecue",
	--   version = "*",
	--   event = "BufReadPost",
	--   dependencies = {
	--     "SmiteshP/nvim-navic",
	--     "nvim-tree/nvim-web-devicons", -- optional dependency
	--   },
	--   opts = {
	--     -- configurations go here
	--   },
	-- },
} ---@type LazySpec
