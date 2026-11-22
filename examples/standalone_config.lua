-- Standalone configuration for nvim-fountain
-- Use this with require("nvim-fountain").setup(...)

-- For use in your init.lua:
-- require("nvim-fountain").setup(require("path/to/this/file"))

return {
  -- Keyboard mappings (these are fully implemented)
  keymaps = {
    -- Navigation between scene headings
    next_scene = "]]",
    prev_scene = "[[",
    
    -- Make line uppercase and move to next line
    uppercase_line = "<S-CR>",
  },
  
  -- Export settings (these are fully implemented)
  export = {
    -- Default export directory (nil means same as source file)
    output_dir = nil,
    
    -- PDF export options
    pdf = {
      -- Options passed to afterwriting
      options = "--overwrite",
    },
  },
}
