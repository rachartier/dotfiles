require("git"):setup({
	order = 1500,
})

th.git = th.git or {}
th.git.unknown_sign = " "
th.git.modified_sign = ""
th.git.clean_sign = "✔"
th.git.added_sign = ""
th.git.untracked_sign = ""
th.git.ignored_sign = ""
th.git.deleted_sign = ""
th.git.updated_sign = "󰑕"
