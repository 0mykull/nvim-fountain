local h = require("tests.harness")
local commands = require("nvim-fountain.commands")
local patterns = require("nvim-fountain.patterns")

h.test("get_stats counts headings, cues and dialogue correctly", function()
  local lines = {
    "Title: Test Script",
    "",
    "INT/EXT. CAR - DAY",
    "",
    "A busy street. People hurry past.",
    "",
    "PROTAGONIST (V.O.)",
    "They say the city never sleeps.",
    "(a beat)",
    "it's not even awake.",
    "",
    "BARISTA",
    "The usual?",
    "",
    "FADE TO BLACK.",
    "",
    "CUT TO:",
    "",
    "EST. MANOR - DAWN",
    "",
    "i/e ROOFTOP - NIGHT",
    "",
    "SHADOWY FIGURE",
    "(whispering)",
    "Found you.",
  }
  local buf = h.scratch(lines, "fountain")
  local stats = commands.get_stats(buf)

  h.eq(stats.scenes, 3, "scene count")
  h.eq(stats.unique_characters, 3, "unique character count")
  h.eq(stats.characters["PROTAGONIST"], 1, "PROTAGONIST appearances")
  h.eq(stats.characters["BARISTA"], 1, "BARISTA appearances")
  h.eq(stats.characters["SHADOWY FIGURE"], 1, "SHADOWY FIGURE appearances")
  h.eq(stats.dialogue_lines, 4, "dialogue line count")
  h.eq(stats.action_lines, 2, "action line count")
  h.eq(stats.total_lines, #lines, "total line count")
end)

h.test("get_stats does not treat headings or transitions as characters", function()
  vim.cmd("edit " .. vim.env.NVIM_FOUNTAIN_ROOT .. "/examples/template.fountain")
  local stats = commands.get_stats()

  for name in pairs(stats.characters) do
    h.ok(not patterns.is_scene_heading(name), "scene heading counted as character: " .. name)
    h.ok(not name:find("FADE", 1, true), "transition counted as character: " .. name)
    h.ok(not name:find("INT", 1, true), "heading counted as character: " .. name)
  end
  h.eq(stats.characters["PROTAGONIST"] > 0, true, "PROTAGONIST not counted")
  h.eq(stats.characters["MYSTERIOUS VOICE"], 1, "cue with (O.S.) not normalised")
end)
