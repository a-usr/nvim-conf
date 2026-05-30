vim.filetype.add({
	extension = {
		xaml = "xaml",
		csx = "csx",
		razor = "razorcomponent",
		cshtml = "cshtml",
	},
	pattern = {
		["(.*%.%a+)%.bak$"] = function(_path, _bufnr, sub, ...)
			local ft = { vim.filetype.match({ filename = sub }) }
			ft[1] = ft[1] and (ft[1] .. ".backup") or ft[1]
			return unpack(ft)
		end,
	},
})
