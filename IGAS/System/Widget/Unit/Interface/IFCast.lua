-- Author      : Kurapica
-- Create Date : 2012/07/29
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFCast", version) then
    return
end

local bit_band = bit.band
local COMBATLOG_OBJECT_TYPE_PLAYER = _G.COMBATLOG_OBJECT_TYPE_PLAYER

local HUNTER_AUTO   = 75
local HUNTER_AIM    = 19434

local _CastScanFrame = CreateFrame("Frame")

local _Cache        = {}
local recycle       = function(tbl) if tbl then tinsert(_Cache, wipe(tbl)) else return tremove(_Cache) or {} end end
local _CastingInfo  = {}
local _GUIDMap      = {}
local _PlayerGUID
local _CASTLINE     = 0
local average       = function(prev, now) if prev then return (prev + now) / 2 else return now end end
local scanTime      = 0

local _IsHunter     = false
local _IsAutoShot   = false
local _IsCastAutoShot = false
local _AutoStart
local _AutoEnd
local _AutoLine
local _ScanTip

_CastScanFrame:SetScript("OnEvent", function()
    local timestamp, eventType, hideCaster,
    srcGUID, srcName, srcFlags, srcFlags2,
    dstGUID, dstName, dstFlags, dstFlags2,
    spellID, spellName, spellSchool, auraType, amount = CombatLogGetCurrentEventInfo()

    if not srcGUID then return end

    if eventType == "SPELL_CAST_START" then
        _CASTLINE       = _CASTLINE + 1

        local info      = recycle()
        info.spellName  = spellName
        info.timestamp  = timestamp
        info.isplayer   = bit_band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
        info.LineID     = _CASTLINE
        info.start      = GetTime() * 1000

        local duration  = CAST_INFO_DB[info.isplayer and "Player" or "NPC"][spellName]
        if duration then
            info.endtime= info.start + duration
        end

        _CastingInfo[srcGUID] = info

        local map       = _GUIDMap[srcGUID]
        if map then
            for i = 1, #map do
                _IFCastUnitList:ParseEvent("UNIT_SPELLCAST_START", map[i], info.LineID)
            end
        end
    elseif eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_MISSED" then
        local info = _CastingInfo[srcGUID]
        if info and info.spellName == spellName then
            _CastingInfo[srcGUID] = nil

            local duration = (timestamp - info.timestamp) * 1000

            if info.isplayer then
                CAST_INFO_DB.Player[spellName] = average(CAST_INFO_DB.Player[spellName], duration)
            else
                CAST_INFO_DB.NPC[spellName] = average(CAST_INFO_DB.NPC[spellName], duration)
            end

            if not srcGUID == _PlayerGUID then
                local map       = _GUIDMap[srcGUID]
                if map then
                    for i = 1, #map do
                        _IFCastUnitList:ParseEvent("UNIT_SPELLCAST_STOP", map[i], info.LineID)
                    end
                end
            end

            recycle(info)
        end
    elseif eventType == "SPELL_CAST_FAILED" then
        local info = _CastingInfo[srcGUID]
        if info and info.spellName == spellName then
            _CastingInfo[srcGUID] = nil

            if not srcGUID == _PlayerGUID then
                local map       = _GUIDMap[srcGUID]
                if map then
                    for i = 1, #map do
                        _IFCastUnitList:ParseEvent("UNIT_SPELLCAST_FAILED", map[i], info.LineID)
                    end
                end
            end

            recycle(info)
        end
    elseif eventType == "SPELL_INTERRUPT" then
        local info = _CastingInfo[srcGUID]
        if info and info.spellName == spellName then
            _CastingInfo[srcGUID] = nil

            if not srcGUID == _PlayerGUID then
                local map       = _GUIDMap[srcGUID]
                if map then
                    for i = 1, #map do
                        _IFCastUnitList:ParseEvent("UNIT_SPELLCAST_INTERRUPTED", map[i], info.LineID)
                    end
                end
            end

            recycle(info)
        end
    end
end)

_CastScanFrame:SetScript("OnUpdate", function()
    local now       = GetTime()
    if now > scanTime then
        scanTime    = now + 10

        local limit = (now - 60) * 1000

        for k, v in pairs(_CastingInfo) do
            if v.start < limit then
                _CastingInfo[k] = nil
                recycle(v)
            end
        end
    end
end)

function OnLoad(self)
    CAST_INFO_DB        = IGAS_DB.CAST_INFO_DB or {
        Player          = {},
        NPC             = {},
    }
    IGAS_DB.CAST_INFO_DB = CAST_INFO_DB
end

_IFCastUnitList = _IFCastUnitList or UnitList(_Name)

function _IFCastUnitList:OnUnitListChanged()
    _PlayerGUID = UnitGUID("player")

    if select(2, UnitClass("player")) == "HUNTER" then
        _ScanTip        = CreateFrame("GameTooltip", "IGAS_IFCast_Scan", _G.UIParent, "GameTooltipTemplate")
        self:RegisterEvent("START_AUTOREPEAT_SPELL")
        self:RegisterEvent("STOP_AUTOREPEAT_SPELL")
        self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    end

    _CastScanFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    self:RegisterEvent("UNIT_NAME_UPDATE")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")

    self:RegisterEvent("UNIT_SPELLCAST_START")
    self:RegisterEvent("UNIT_SPELLCAST_FAILED")
    self:RegisterEvent("UNIT_SPELLCAST_STOP")
    self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    --self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
    --self:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
    self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

    self.OnUnitListChanged = nil
end

_IFCast_EVENT_HANDLER = {
    UNIT_SPELLCAST_START = "Start",
    UNIT_SPELLCAST_FAILED = "Fail",
    UNIT_SPELLCAST_STOP = "Stop",
    UNIT_SPELLCAST_INTERRUPTED = "Interrupt",
    --UNIT_SPELLCAST_INTERRUPTIBLE = "Interruptible",
    --UNIT_SPELLCAST_NOT_INTERRUPTIBLE = "UnInterruptible",
    UNIT_SPELLCAST_DELAYED = "Delay",
    UNIT_SPELLCAST_CHANNEL_START = "ChannelStart",
    UNIT_SPELLCAST_CHANNEL_UPDATE = "ChannelUpdate",
    UNIT_SPELLCAST_CHANNEL_STOP = "ChannelStop",
}

local function getUnmodifiedSpeed()
    local text, _, spd
    _ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
    _ScanTip:SetInventoryItem("player", 18)
    for i=1, 10 do
        local text = getglobal("IGAS_IFCast_ScanTextRight"..i)
        if text:IsVisible() then
            _, _, spd = string.find(text:GetText(), "([%,%.%d]+)")
            if spd then
                spd = string.gsub(spd, "%,", "%.")
                spd = tonumber(spd)
                break
            end
        end
    end
    return spd
end

local function checkStartAutoShot(self, spell)
    if _IsAutoShot then
        local spd, min, max = UnitRangedDamage("player")
        if spell == HUNTER_AIM then
            spd = getUnmodifiedSpeed() or spd
        end
        _CASTLINE = _CASTLINE + 1

        _AutoStart = GetTime() * 1000
        _AutoEnd = _AutoStart + spd * 1000
        _AutoLine = _CASTLINE

        _IsCastAutoShot = true

        self:EachK("player", OnForceRefresh)
    end
end

function _IFCastUnitList:ParseEvent(event, unit, ...)
    if event == "START_AUTOREPEAT_SPELL" then
        _IsAutoShot = true
    elseif event == "STOP_AUTOREPEAT_SPELL" then
        _IsAutoShot = false
        if _IsCastAutoShot then
            _IsCastAutoShot = false
            self:EachK("player", OnForceRefresh)
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        if unit == "player" then
            local line, spell = ...
            if spell == HUNTER_AUTO or spell == HUNTER_AIM then
                checkStartAutoShot(self, spell)
            end
        end
    elseif event == "UNIT_NAME_UPDATE" then
        self:EachK(unit, OnForceRefresh)
    elseif event == "GROUP_ROSTER_UPDATE" then
        for unit in pairs(self) do
            self:EachK(unit, OnForceRefresh)
        end
    else
        self:EachK(unit, _IFCast_EVENT_HANDLER[event], ...)
    end
end

function UnitCastingInfo(unit)
    local guid = UnitGUID(unit)
    if guid == _PlayerGUID then
        if _IsCastAutoShot then
            if CastingInfo() then return CastingInfo() end
            local name, _, texture = GetSpellInfo(HUNTER_AUTO)
            return name, _, texture, _AutoStart, _AutoEnd, nil, _AutoLine
        end
        return CastingInfo()
    end

    local info = _CastingInfo[guid]
    if info and info.endtime then
        return info.spellName, "", select(3, GetSpellInfo(info.spellName)), info.start, info.endtime, nil, info.LineID
    end
end

function UnitChannelInfo(unit)
    local guid = UnitGUID(unit)
    if guid == _PlayerGUID then
        return ChannelInfo()
    end
end

function OnForceRefresh(self)
    if self.Unit then
        local guid = UnitGUID(self.Unit)
        local oldguid = _GUIDMap[self.Unit]

        if guid ~= oldguid then
            local map = oldguid and _GUIDMap[oldguid]
            if map then
                for i, unit in ipairs(map) do
                    if unit == self.Unit then
                        tremove(map, i)
                    end
                end
                if #map == 0 then
                    recycle(map)
                    _GUIDMap[oldguid] = nil
                end
                _GUIDMap[self.Unit] = nil
            end
            if guid then
                map = _GUIDMap[guid] or recycle()
                _GUIDMap[guid] = map
                _GUIDMap[self.Unit] = guid
                tinsert(map, self.Unit)
            end
        end

        if UnitCastingInfo(self.Unit) then
            local name, _, _, _, _, _, castID, notInterruptible = UnitCastingInfo(self.Unit)
            self:Start(castID)
        elseif UnitChannelInfo(self.Unit) then
            self:ChannelStart()
        else
            self:Stop()
        end
    else
        self:Stop()
    end
end

__Doc__[[IFCast is used to handle the unit's spell casting]]
interface "IFCast"
    extend "IFUnitElement"

    __Static__() UnitCastingInfo = UnitCastingInfo
    __Static__() UnitChannelInfo = UnitChannelInfo

    ------------------------------------------------------
    -- Method
    ------------------------------------------------------
    __Doc__[[
        <desc>Be called when unit begins casting a spell</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function Start(self, lineID, spellID)
    end

    __Doc__[[
        <desc>Be called when unit's spell casting failed</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function Fail(self, lineID, spellID)
    end

    __Doc__[[
        <desc>Be called when the unit stop or cancel the spell casting</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function Stop(self, lineID, spellID)
    end

    __Doc__[[
        <desc>Be called when the unit's spell casting is interrupted</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function Interrupt(self, lineID, spellID)
    end

    __Doc__[[Be called when the unit's spell casting becomes interruptible]]
    __Optional__() function Interruptible(self)
    end

    __Doc__[[Be called when the unit's spell casting become uninterruptible]]
    __Optional__() function UnInterruptible(self)
    end

    __Doc__[[
        <desc>Be called when the unit's spell casting is delayed</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function Delay(self, lineID, spellID)
    end

    __Doc__[[
        <desc>Be called when the unit start channeling a spell</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function ChannelStart(self, lineID, spellID)
    end

    __Doc__[[
        <desc>Be called when the unit's channeling spell is interrupted or delayed</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function ChannelUpdate(self, lineID, spellID)
    end

    __Doc__[[
        <desc>Be called when the unit stop or cancel the channeling spell</desc>
        <param name="lineID">number, spell lineID counter</param>
        <param name="spellID">number, the id of the spell that's being casted</param>
    ]]
    __Optional__() function ChannelStop(self, lineID, spellID)
    end

    ------------------------------------------------------
    -- Event Handler
    ------------------------------------------------------
    local function OnUnitChanged(self)
        _IFCastUnitList[self] = self.Unit
    end

    ------------------------------------------------------
    -- Dispose
    ------------------------------------------------------
    function Dispose(self)
        _IFCastUnitList[self] = nil
    end

    ------------------------------------------------------
    -- Initializer
    ------------------------------------------------------
    function IFCast(self)
        self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
        self.OnForceRefresh = self.OnForceRefresh + OnForceRefresh
    end
endinterface "IFCast"