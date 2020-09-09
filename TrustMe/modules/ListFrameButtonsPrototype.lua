local setmetatable, type, ipairs, tinsert = setmetatable, type, ipairs, table.insert
local DBM, GUI = DBM, GUI

local ListFrameButtonsPrototype = {}

function ListFrameButtonsPrototype:CreateCategory(frame, parent)
	if not type(frame) == "table" then
		
		return false
	elseif not frame.name then
		
		return false
	elseif self:IsPresent(frame.name) then
	
		return false
	end
	frame.depth = parent and self:GetDepth(parent) or 1
	self:SetParentHasChilds(parent)
	tinsert(self.Buttons, {
		frame	= frame,
		parent	= parent
	})
	return #self.Buttons
end

function ListFrameButtonsPrototype:IsPresent(name)
	for _, v in ipairs(self.Buttons) do
		if v.frame.name == name then
			return true
		end
	end
	return false
end

function ListFrameButtonsPrototype:GetDepth(name, depth)
	depth = depth or 1
	for _, v in ipairs(self.Buttons) do
		if v.frame.name == name then
			if v.parent == nil then
				return depth + 1
			else
				depth = depth + self:GetDepth(v.parent, depth)
			end
		end
	end
	return depth
end

function ListFrameButtonsPrototype:SetParentHasChilds(parent)
	if not parent then
		return
	end
	for _, v in ipairs(self.Buttons) do
		if v.frame.name == parent then
			v.frame.haschilds = true
		end
	end
end

function ListFrameButtonsPrototype:GetVisibleTabs()
	local tabs = {}
	for _, v in ipairs(self.Buttons) do
		if v.parent == nil then
			tinsert(tabs, v)
			if v.frame.showSub then
				self:GetVisibleSubTabs(v.frame.name, tabs)
			end
		end
	end
	return tabs
end

function ListFrameButtonsPrototype:GetVisibleSubTabs(parent, tabs)
	for _, v in ipairs(self.Buttons) do
		if v.parent == parent then
			tinsert(tabs, v)
			if v.frame.showSub then
				self:GetVisibleSubTabs(v.frame.name, tabs)
			end
		end
	end
end

function GUI:CreateNewFauxScrollFrameList()
	local mt = setmetatable({
		Buttons = {}
	}, {
		__index = ListFrameButtonsPrototype
	})
	GUI.frameTypes[#GUI.frameTypes + 1] = mt
	return mt
end

-- TODO: Should this go somewhere else?
_G["GUI_Bosses"] = GUI:CreateNewFauxScrollFrameList()
_G["GUI_Options"] = GUI:CreateNewFauxScrollFrameList()
