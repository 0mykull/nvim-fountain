-- nvim-fountain syntax module
local M = {}

local default_highlights = {
	FountainTitlePage = { link = "Title" },
	FountainSceneHeading = { link = "Title" },
	FountainCharacter = { link = "Identifier" },
	FountainDialogue = { link = "Statement" },
	FountainParenthetical = { link = "Function" },
	FountainTransition = { link = "Todo" },
	FountainTransitionForced = { link = "Todo" },
	FountainCentered = { link = "Character" },
	FountainUnderlined = { underline = true },
	FountainItalic = { italic = true },
	FountainBold = { bold = true },
	FountainBoldItalic = { bold = true, italic = true },
	FountainPagebreak = { link = "Conditional" },
	FountainNotes = { link = "Comment" },
	FountainBoneyard = { link = "NonText" },
	FountainHeader1 = { link = "htmlH1" },
	FountainHeader2 = { link = "htmlH2" },
	FountainHeader3 = { link = "htmlH3" },
	FountainHeader4 = { link = "htmlH4" },
	FountainHeader5 = { link = "htmlH5" },
	FountainHeader6 = { link = "htmlH6" },
	FountainSynopses = { link = "Number" },
	FountainSceneNumber = { link = "Number" },
}

-- Define (or refresh) the highlight groups used by syntax/fountain.vim.
function M.setup(overrides)
	local groups = overrides and type(overrides) == "table" and vim.tbl_extend("force", default_highlights, overrides)
		or default_highlights

	for name, settings in pairs(groups) do
		vim.api.nvim_set_hl(0, name, settings)
	end
end

return M
