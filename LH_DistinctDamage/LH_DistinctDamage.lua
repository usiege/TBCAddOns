local Module = LibStub("AceAddon-3.0"):NewAddon("LH_DistinctDamage", "AceEvent-3.0")

function Module:OnInitialize()
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

	self.unitToGuid = {}
	self.guidToUnit = {}
end

function Module:NAME_PLATE_UNIT_ADDED(event, unitID)
	local guid = UnitGUID(unitID);
	self.unitToGuid[unitID] = guid;
    self.guidToUnit[guid] = unitID;
end

function Module:NAME_PLATE_UNIT_REMOVED(event, unitID)
	local guid = self.unitToGuid[unitID];

    self.unitToGuid[unitID] = nil;
    self.guidToUnit[guid] = nil;
end

function Module:OnEnable()
	self.combatEventsModule = Parrot:GetModule("CombatEvents")
	self.originalHandleCombatlogEvent = self.combatEventsModule.HandleCombatlogEvent
	
	self.combatEventsModule.HandleCombatlogEvent = function(module, uid, timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
		if self.guidToUnit[destGUID] == nil then
			return self.originalHandleCombatlogEvent(module, uid, timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
		end
	end
end
