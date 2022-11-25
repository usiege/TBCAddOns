local L = GUI_L
print('start this place')

GUI = {
	frameTypes = {}
}

DEBUG = true

local next, type, pairs, strsplit, tonumber, tostring, ipairs, tinsert, tsort, mfloor = next, type, pairs, strsplit, tonumber, tostring, ipairs, table.insert, table.sort, math.floor
local C_Timer, GetExpansionLevel, IsAddOnLoaded, GameFontNormal, GameFontNormalSmall, GameFontHighlight, GameFontHighlightSmall = C_Timer, GetExpansionLevel, IsAddOnLoaded, GameFontNormal, GameFontNormalSmall, GameFontHighlight, GameFontHighlightSmall
local RAID_DIFFICULTY1, RAID_DIFFICULTY2, RAID_DIFFICULTY3, RAID_DIFFICULTY4, PLAYER_DIFFICULTY1, PLAYER_DIFFICULTY2, PLAYER_DIFFICULTY3, PLAYER_DIFFICULTY6, PLAYER_DIFFICULTY_TIMEWALKER, CHALLENGE_MODE, ALL, SPECIALIZATION = RAID_DIFFICULTY1, RAID_DIFFICULTY2, RAID_DIFFICULTY3, RAID_DIFFICULTY4, PLAYER_DIFFICULTY1, PLAYER_DIFFICULTY2, PLAYER_DIFFICULTY3, PLAYER_DIFFICULTY6, PLAYER_DIFFICULTY_TIMEWALKER, CHALLENGE_MODE, ALL, SPECIALIZATION
local LibStub, DBM, GUI, OPTION_SPACER = _G["LibStub"], DBM, GUI, OPTION_SPACER

do
	local framecount = 0

	function GUI:GetNewID()
		framecount = framecount + 1
		return framecount
	end

	function GUI:GetCurrentID()
		return framecount
	end
end

function GUI:ShowHide(forceshow)
	local optionsFrame = _G["GUI_OptionsFrame"]
	if forceshow == true then
		self:UpdateModList()
		optionsFrame:Show()
	elseif forceshow == false then
		optionsFrame:Hide()
	else
		if optionsFrame:IsShown() then
			optionsFrame:Hide()
		else
			self:UpdateModList()
			optionsFrame:Show()
		end
	end
end

do
	local frames = {}

	function GUI:AddFrame(name)
		tinsert(frames, name)
	end

	function GUI:IsPresent(name)
		for _, v in ipairs(frames) do
			if v == name then
				return true
			end
		end
		return false
	end
end

do
	local function OnShowGetStats(bossid, statsType, top1value1, top1value2, top1value3, top2value1, top2value2, top2value3, top3value1, top3value2, top3value3, bottom1value1, bottom1value2, bottom1value3, bottom2value1, bottom2value2, bottom2value3, bottom3value1, bottom3value2, bottom3value3)
		return function(self)
			print("do nothing")
			top1value1:SetText("")
			top1value2:SetText("")
			top1value3:SetText("")
			top2value1:SetText("")
			top2value2:SetText("")
			top2value3:SetText("")
			top3value1:SetText("")
			top3value2:SetText("")
			top3value3:SetText("")
			bottom1value1:SetText("")
			bottom1value2:SetText("")
			bottom1value3:SetText("")
			bottom2value1:SetText("")
			bottom2value2:SetText("")
			bottom2value3:SetText("")
			bottom3value1:SetText("")
			bottom3value2:SetText("")
			bottom3value3:SetText("")
		end
	end

	local Categories = {}
	local subTabId = 0

	function GUI:UpdateModList()
		
		local optionsFrame = _G["GUI_OptionsFrame"]
		if optionsFrame:IsShown() then
			optionsFrame:Hide()
			optionsFrame:Show()
		end
	end
end
--]=]

SLASH_TM1 = "/tm"
SlashCmdList["TM"] = function(msg)
		if DEBUG then
			print("this is tm command!")
		end
		GUI:ShowHide()
	end

