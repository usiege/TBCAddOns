local L = GUI_L
local GUI = GUI

--1基础设置
local BASIC_Frame = GUI:CreateNewPanel(L.BasicIntroduce)
local basic_area = BASIC_Frame:CreateArea(L.Basic_Title)
--basic_area.frame:SetSize(510, 100)

local basic_detail = basic_area:CreateText(L.Basic_Detial, 510, true, nil, "LEFT")
--basic_detail:SetPoint("TOPLEFT")

--2
local SKILL_Frame = GUI:CreateNewPanel(L.SkillRecordSettings)
local skill_area = SKILL_Frame:CreateArea(L.SkillRecordSettings)

local basic_set 	= SKILL_Frame:CreateNewPanel(L.SkillBasicSettings)
local basic_set_area 	= basic_set:CreateArea("基本设置")

local basic_set_mod 	= basic_set_area:CreateText("输出模式", 100, true, nil, "LEFT")
local basic_set_arrow 	= basic_set_area:CreateCheckButton("单体+AOE模式（智能识别）", true)
basic_set_arrow:SetPoint("LEFT", basic_set_mod, "RIGHT", 0, 0)
basic_set_arrow:SetScript("OnClick", function()
	 print("basic_set_arrow")
end)
--local basic_set_arrow2 	= basic_set_area:CreateCheckButton("单体模式", true)
--basic_set_arrow2:SetPoint("LEFT", basic_set_arrow, "RIGHT", 10, 0)
--basic_set_arrow2:SetScript("OnClick", function()
--	 print("basic_set_arrow2")
--end)
--basic_set_area:CreateText("当口kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk", 510, true, nil, "LEFT")


local warrior 		= SKILL_Frame:CreateNewPanel(L.WARRIOR)
local warrior_area = warrior:CreateArea("")

local paladin 		= SKILL_Frame:CreateNewPanel(L.PALADIN)
local paladin_area = paladin:CreateArea("")

local deathknight 	= SKILL_Frame:CreateNewPanel(L.DEATHKNIGHT)
local deathknight_area = deathknight:CreateArea("")

local rogue 		= SKILL_Frame:CreateNewPanel(L.ROGUE)
local rogue_area = rogue:CreateArea("")

local druid 		= SKILL_Frame:CreateNewPanel(L.DRUID)
local druid_area 	= druid:CreateArea("")

local monk 			= SKILL_Frame:CreateNewPanel(L.MONK)
local monk_area 	= monk:CreateArea("")

local demonhunter 	= SKILL_Frame:CreateNewPanel(L.DEMONHUNTER)
local demonhunter_area = demonhunter:CreateArea("")

local hunter 		= SKILL_Frame:CreateNewPanel(L.HUNTER)
local hunter_area 	= hunter:CreateArea("")

local shaman 		= SKILL_Frame:CreateNewPanel(L.SHAMAN)
local shaman_area 	= shaman:CreateArea("")

local mage 			= SKILL_Frame:CreateNewPanel(L.MAGE)
local mage_area 	= mage:CreateArea("")

local warlock 		= SKILL_Frame:CreateNewPanel(L.WARLOCK)
local warlock_area	= warlock:CreateArea("")

local priest 		= SKILL_Frame:CreateNewPanel(L.PRIEST)
local priest_area 	= priest:CreateArea("")


--3
local CAREER_Frame = GUI:CreateNewPanel(L.CareerEquipments)
local career_area = CAREER_Frame:CreateArea(L.CareerEquipments)

local warrior2 		= CAREER_Frame:CreateNewPanel(L.WARRIOR_E)
local warrior2_area = warrior2:CreateArea("")

local paladin2 		= CAREER_Frame:CreateNewPanel(L.PALADIN_E)
local paladin2_area = paladin2:CreateArea("")

local deathknight2 	= CAREER_Frame:CreateNewPanel(L.DEATHKNIGHT_E)
local deathknight2_area = deathknight2:CreateArea("")

local rogue2 		= CAREER_Frame:CreateNewPanel(L.ROGUE_E)
local rogue2_area = rogue2:CreateArea("")

local druid2 		= CAREER_Frame:CreateNewPanel(L.DRUID_E)
local druid2_area = druid2:CreateArea("")

local monk2 		= CAREER_Frame:CreateNewPanel(L.MONK_E)
local monk2_area	= monk2:CreateArea("")

local demonhunter2 	= CAREER_Frame:CreateNewPanel(L.DEMONHUNTER_E)
local demonhunter2_area = demonhunter2:CreateArea("")

local hunter2 		= CAREER_Frame:CreateNewPanel(L.HUNTER_E)
local hunter2_area = hunter2:CreateArea("")

local shaman2 		= CAREER_Frame:CreateNewPanel(L.SHAMAN_E)
local shaman2_area = shaman2:CreateArea("")

local mage2 		= CAREER_Frame:CreateNewPanel(L.MAGE_E)
local mage2_area = mage2:CreateArea("")

local warlock2 		= CAREER_Frame:CreateNewPanel(L.WARLOCK_E)
local warlock2_area = warlock2:CreateArea("")

local priest2 		= CAREER_Frame:CreateNewPanel(L.PRIEST_E)
local priest2_area = priest2:CreateArea("")

--4
local WECHAT_Frame = GUI:CreateNewPanel(L.WeChat)
local wechat_area = WECHAT_Frame:CreateArea(L.WeChat)
WECHAT_Frame:CreateNewPanel(L.WARRIOR)

--- 2 area detial
--basic_set:CreateArea()




-- 选项
--GUI_Frame = GUI:CreateNewPanel(GUI_L.TabCategory_Options, "option")

--local mobstyle = CreateFrame("PlayerModel", "BossPreview", _G["GUI_OptionsFramePanelContainer"])
--mobstyle:SetPoint("BOTTOMRIGHT", "GUI_OptionsFramePanelContainer", "BOTTOMRIGHT", -5, 5)
--mobstyle:SetSize(300, 230)
--mobstyle:SetPortraitZoom(0.4)
--mobstyle:SetRotation(0)
--mobstyle:SetClampRectInsets(0, 0, 24, 0)
