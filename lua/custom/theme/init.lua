local lush = require 'lush'

local hsl = lush.hsl

local purple_dark = hsl(273, 43, 34)
local purple_light = hsl(273, 63, 72)

local green_dark = hsl(93, 43, 34)
local green_light = hsl(93, 83, 82)

local orange_dark = hsl(20, 87, 40)
local orange_light = hsl(20, 87, 70)

local bg_dark = hsl(20, 20, 12)
local bg_light = hsl(20, 30, 50)

local white = hsl(0, 0, 100)

local theme = lush(function()
  return {
    Normal { bg = bg_dark, fg = bg_light },
    Function { fg = orange_light },
    Statement { fg = green_light },
    CursorLine { bg = Normal.bg.lighten(10)},
    Comment { fg = Normal.bg.de(25).li(25).ro(-10) },
    LineNr { Comment },
    StatusLine { bg = purple_dark }
    Visual { 
      
    }
  }
end)

return theme
