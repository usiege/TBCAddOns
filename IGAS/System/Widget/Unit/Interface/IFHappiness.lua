-- Author      : Kurapica
-- Create Date : 2019/08/31
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFHappiness", version) then
	return
end

_IFHappinessUnitList = _IFHappinessUnitList or UnitList(_Name)

function _IFHappinessUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_HAPPINESS")
	self.OnUnitListChanged = nil
end

function _IFHappinessUnitList:ParseEvent(event, unit)
	self:EachK("pet", OnForceRefresh)
end

function OnForceRefresh(self)
	self:UpdateHappiness()
end

__Doc__[[IFHappiness is used to handle the unit Happiness state's updating]]
interface "IFHappiness"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		if self.Unit == "pet" then
			_IFHappinessUnitList[self] = self.Unit
			self:Show()
		else
			_IFHappinessUnitList[self] = nil
			self:Hide()
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	__Doc__[[Update the Happiness to the element, overridable]]
	__Optional__() function UpdateHappiness(self) end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFHappinessUnitList[self] = nil
	end

	------------------------------------------------------
	-- Initializer
	------------------------------------------------------
	function IFHappiness(self)
		if select(2, UnitClass("player")) == "HUNTER" then
			self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
			self.OnForceRefresh = self.OnForceRefresh + OnForceRefresh
		else
			self:Hide()
		end
	end
endinterface "IFHappiness"