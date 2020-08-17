-- Author      : Kurapica
-- Create Date : 2019/08/31
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.HappinessIcon", version) then
	return
end

__Doc__[[The Happiness indicator]]
class "HappinessIcon"
	inherit "Frame"
	extend "IFHappiness"

	local GameTooltip = _G.GameTooltip

	local function OnEnter(self)
		if ( self.tooltip ) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltip)
			if ( self.tooltipDamage ) then
				GameTooltip:AddLine(self.tooltipDamage, "", 1, 1, 1)
			end
			if ( self.tooltipLoyalty ) then
				GameTooltip:AddLine(self.tooltipLoyalty, "", 1, 1, 1)
			end
			GameTooltip:Show()
		end
	end

	local function OnLeave(self)
		GameTooltip:Hide()
	end

	function UpdateHappiness(self)
		local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
		if not happiness then return self:Hide() end
		self:Show()
		if ( happiness == 1 ) then
			self.Icon:SetTexCoord(0.375, 0.5625, 0, 0.359375)
		elseif ( happiness == 2 ) then
			self.Icon:SetTexCoord(0.1875, 0.375, 0, 0.359375)
		elseif ( happiness == 3 ) then
			self.Icon:SetTexCoord(0, 0.1875, 0, 0.359375)
		end
		self.tooltip = _G["PET_HAPPINESS"..happiness]
		self.tooltipDamage = format(PET_DAMAGE_PERCENTAGE, damagePercentage)
		if ( loyaltyRate < 0 ) then
			self.tooltipLoyalty = _G["LOSING_LOYALTY"]
		elseif ( loyaltyRate > 0 ) then
			self.tooltipLoyalty = _G["GAINING_LOYALTY"]
		else
			self.tooltipLoyalty = nil
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function HappinessIcon(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.MouseEnabled = true
		self:SetSize(24, 23)

		local icon = Texture("Happiness", self, "BACKGROUND")
		icon.TexturePath = [[Interface\PetPaperDollFrame\UI-PetHappiness]]
		icon:SetAllPoints()
		icon:SetTexCoord(0, 0.1875, 0, 0.359375)

		self.Icon = icon

		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave
	end
endclass "HappinessIcon"