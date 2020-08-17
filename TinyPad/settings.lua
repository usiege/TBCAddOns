-- savedvar TinyPadSettings for window behavior settings; see TinyPadPages in misc\pages.lua for pages savedvar

local _,t = ...
t.settings = {}

-- if looking to replace one of the fonts with your own, look in panels\fontbar.lua

TinyPadSettings = {} -- savedvar

t.settings.defaults = {
    Lock = false,
    LargeScale = false,
    Transparency = false,
    ShowMinimapButton = false,
    FontFamily = 1, -- Serif
    FontSize = 2, -- Medium
    PinBookmarks = false,
}

t.init:Register("settings")

-- on player login, load defaults if they're undefined
function t.settings:LoginInit()
    t.settings.saved = TinyPadSettings
    for setting,value in pairs(t.settings.defaults) do
        if t.settings.saved[setting]==nil then
            t.settings.saved[setting] = value
        end
    end
end
