
-------------------------------------
-- @DepandsOn: LibStub, LibItemStats
-------------------------------------

local LibItemStats = LibStub:GetLibrary("LibItemStats.1000")

local GetStatsName = LibItemStats.GetStatsName
local GetStatsValue = LibItemStats.GetStatsValue

STAT_RESISTANCE_ATTRIBUTES = GetStatsName("Resistance")

local function SetStats(self, data)
    self.data = data or {}
    return self
end

local function CreateStatFrame(parent, index, key, option)
    local frame = CreateFrame("Frame", nil, parent, "CharacterStatFrameTemplate")
    frame:EnableMouse(false)
    frame:SetWidth(168)
    frame.key = key
    frame.Background:SetShown((index%2) ~= 1)
    parent["stat" .. index] = frame
    return frame
end

local function GetStatFrame(self)
    local index = self.maxStaticIndex + 1
    while (self["stat"..index]) do
        if (not self["stat"..index]:IsShown()) then
            return self["stat"..index]
        end
        index = index + 1
    end
    return CreateStatFrame(self, index)
end

function ClassicStatsFrameTemplate_Onload(self)
    self.SetStats = SetStats
    local index, keys = 1, ","
    local frame, anchor
    self.ItemLevelFrame.Value:SetFont(self.ItemLevelFrame.Value:GetFont(), 13, "THINOUTLINE")
    self.ItemLevelFrame.Value:SetTextColor(1, 0.82, 0)
    --基础 力/敏/耐/智/精/护甲
    self.AttributesCategory:SetScale(0.8528)
    self.AttributesCategory.Background:SetAlpha(0.6)
    self.AttributesCategory.Title:SetTextColor(0.1, 1, 0)
    anchor = self.AttributesCategory
    for _, key in ipairs({"Strength","Agility","Stamina","Intellect","Spirit","Armor"}) do
        frame = CreateStatFrame(self, index, key)
        frame:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, 0)
        anchor = frame
        index = index + 1
        keys = keys .. key .. ","
    end
    --抗性 奥/火/自然/冰霜/暗影/神圣
    self.ResistanceCategory:SetScale(0.8528)
    self.ResistanceCategory.Background:SetAlpha(0.6)
    self.ResistanceCategory.Title:SetTextColor(0.1, 1, 0)
    self.ResistanceCategory:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, 0)
    anchor = self.ResistanceCategory
    for _, key in ipairs({"Resistance_Arcane","Resistance_Fire","Resistance_Nature","Resistance_Frost","Resistance_Shadow","Resistance_Holy"}) do
        frame = CreateStatFrame(self, index, key)
        frame:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, 0)
        anchor = frame
        index = index + 1
        keys = keys .. key .. ","
    end
    --记录固值的index值
    self.maxStaticIndex = index - 1
    self.allStaticKeys = keys
    --其他属性
    self.EnhancementsCategory:SetScale(0.8528)
    self.EnhancementsCategory.Background:SetAlpha(0.6)
    self.EnhancementsCategory.Title:SetTextColor(0.1, 1, 0)
    self.EnhancementsCategory:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, 0)
    anchor = self.EnhancementsCategory
    for i = index, self.maxStaticIndex + 16 do
        CreateStatFrame(self, i)
    end
end

function ClassicStatsFrameTemplate_OnShow(self)
    local button
    local height = 30 + 34*3 + 15*self.maxStaticIndex + 8
    local data = self.data.static and self.data.static or self.data
    if (data.Itemlevel) then
        self.ItemLevelFrame.Value:SetText(format((ITEM_LEVEL_ABBR or "ItemLevel") .. " |cff03eeff%.1f|r", data.Itemlevel))
    elseif (self.data.Itemlevel) then
        self.ItemLevelFrame.Value:SetText(format((ITEM_LEVEL_ABBR or "ItemLevel") .. " |cff03eeff%.1f|r", self.data.Itemlevel))
    else
        self.ItemLevelFrame.Value:SetText("")
    end
    for i = 1, self.maxStaticIndex do
        button = self["stat"..i]
        button.Label:SetText(GetStatsName(button.key))
        button.Value:SetText(GetStatsValue(button.key, data))
        button:Show()
    end
    local hasAdvanced = false
    local offset = 0
    for k, v in pairs(data) do
        if (not strfind(self.allStaticKeys, ","..k..",")) then
            button = GetStatFrame(self)
            button.Label:SetText(GetStatsName(k))
            button.Value:SetText(GetStatsValue(k, data))
            button:Show()
            button:SetPoint("TOPLEFT", self.EnhancementsCategory, "BOTTOMLEFT", 0, offset)
            height = height + 15
            offset = offset - 15
            hasAdvanced = true
        end
    end
    if (hasAdvanced) then
        self.EnhancementsCategory:Show()
    else
        self.EnhancementsCategory:Hide()
    end
    height = max(height, 422)
    self:SetHeight(height)
end

function ClassicStatsFrameTemplate_OnHide(self)
    local index = 1
    while (self["stat"..index]) do
        self["stat"..index].Label:SetText("")
        self["stat"..index].Value:SetText("")
        self["stat"..index]:Hide()
        index = index + 1
    end
end
