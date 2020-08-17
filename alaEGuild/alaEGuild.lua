--[[--
	alex@0
--]]--
----------------------------------------------------------------------------------------------------
local ADDON, NS = ...;

local L = NS.L;
if not L then return;end
----------------------------------------------------------------------------------------------------
local math, table, string, pairs, type, select, tonumber, unpack = math, table, string, pairs, type, select, tonumber, unpack;
local _G = _G;
local GameTooltip = GameTooltip;
local _ = nil;
----------------------------------------------------------------------------------------------------
--[[
	GuildUninvite("name");
	GuildPromote("name");
	GuildDemote("name");
	C_GuildInfo.RemoveFromGuild("guid");
--]]
----------------------------------------------------------------------------------------------------main
local function _error_(...)
	print("\124cffff0000alaChat addon:\124r", ...);
end
local function _log_(...)
	print(...);
end
local function _noop_()
end

local guildRosterShowOffline = false;
--------------------------------------------------
local NAME = "alaEGuild";
local artwork_path = "Interface\\AddOns\\alaEGuild\\ARTWORK\\";
local mainFrameBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = nil;--"Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 2,
	edgeSize = 2,
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
};
local mainFrameBackdropColor = { 0.25, 0.25, 0.25, 0.75 };
local buttonBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 2,
	edgeSize = 2,
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
};
local buttonBackdropColor = { 0.25, 0.25, 0.25, 0.75 };
local buttonBackdropBorderColor = { 0.0, 0.0, 0.0, 1.0 };
local buttonHeight = 24;
local borderSize = 8;
local stepPerPage = 0;
local rosterElementIndex = {
	level	= 1,
	class	= 2,
	name	= 3,
	online	= 4,
	zone	= 5,
	rank	= 6,
	note	= 7,
	oNote	= 8,
};
local rosterElementEnabled = { true, true, true, true, true, true, true, true, };
local rosterElementName = {};
local rosterElementBaseOfs = 4;
local rosterElementWidth = {
	32,		--level
	32,		--class
	120,	--name
	150,	--online
	150,	--zone
	150,	--rank
	150,	--note
	150,	--oNote
};
local rosterElementOfs = {};
local function GenRosterElementInfo()
	for n, i in pairs(rosterElementIndex) do
		rosterElementName[i] = n;
	end
	rosterElementOfs[1] = rosterElementBaseOfs;
	local tempPos = rosterElementBaseOfs;
	for i = 2, #rosterElementWidth do
		if rosterElementEnabled[i] then
			rosterElementOfs[i] = rosterElementOfs[i - 1] + rosterElementWidth[i - 1];
		end
	end
end
local sumTextFormat = "\124cffff00ff%s\124r/\124cff00ff00%s\124r/\124cffffff00%s\124r";
local filterFrameFuncFormat = "return function(name, rankName, rankId, level, classLocale, zone, note, officerNote, online, class, GUID, y, m, d, h) return %s; end;"
local filterFrameLayout = {
	{
		"E1",		"name",		nil,	nil,	">>",	nil,
		nil,
		L.info.name,
		"(name and string.find(string.lower(name), \"#1\"))",
	},
	{
		"E2",		"level",	"int",	3,		">=",	"<=",
		nil,
		L.info.level,
		"(level >= #1)",
		"(level <= #1)",
	},
	{
		"E1",		"class",	nil,	nil,	">>",	nil,
		nil,
		L.info.class,
		"(class and string.find(string.lower(class), \"#1\")) or (classLocale and string.find(string.lower(classLocale), \"#1\"))",
	},
	{
		"E2",		"rank",		"int",	3,		">=",	"<=",
		nil,
		L.info.rank,
		"(rankId >= #1)",
		"(rankId <= #1)",
	},
	{
		"newline",
	},
	{
		"E1",		"zone",		nil,	nil,	">>",	nil,
		nil,
		L.info.zone,
		"(zone and string.find(string.lower(zone), \"#1\"))",
	},
	{
		"NONE",
	},
	{
		"P2E3",	"online",	"int",	4,		">=",	"<=",
		{ L.year,	L.month,	L.day },
		L.info.online,
		"((y > #1) or ((y == #1) and (m > #2)) or ((y == #1) and (m == #2) and (d >= #3)))",
		"((y < #1) or ((y == #1) and (m < #2)) or ((y == #1) and (m == #2) and (d <= #3)))",
		width = 2,
	},
};
--------------------------------------------------
local authority = {
	CanViewOfficerNote = true;
	
	CanEditPublicNote = false;
	CanEditOfficerNote = false;

	CanGuildRemove = false;
	CanGuildInvite = false;

	CanGuildDemote = false;
	CanGuildPromote = false;

	CanEditGuildInfo = false;
	CanEditMOTD = false;

};
--------------------------------------------------
local func = {  };

local mainFrame = CreateFrame("Frame", NAME .. "MainFrame", UIParent);
mainFrame:Hide();
local indicator = CreateFrame("Frame", NAME .. "Indicator", UIParent);
indicator:SetSize(32, 32);
local texture = indicator:CreateTexture(nil, "OVERLAY");
texture:SetAllPoints(true);
texture:SetTexture("interface\\minimap\\minimap-deadarrow");
texture:SetTexCoord(1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0);
indicator:Hide();

local first_shown = true;
local function select_member_index_ui(index)
	mainFrame.selectedGuildMember = index;
	if index == 0 then
		indicator:Hide();
	else
		local step = GuildListScrollFrameScrollBar:GetValueStep();
		local minVal, maxVal = GuildListScrollFrameScrollBar:GetMinMaxValues();
		maxVal = maxVal + 13 * step;
		local height = GuildListScrollFrameScrollBar:GetHeight() - 24 - 2;
		local y = - 12 - height  * index * step / maxVal;
		indicator:ClearAllPoints();
		indicator:SetPoint("LEFT", GuildListScrollFrameScrollBar, "TOPRIGHT", 4, y);
		indicator:Show();
	end
end
local function select_member_index(index)
	-- ToggleFriendsFrame(FRIEND_TAB_GUILD);
	SetGuildRosterSelection(index);
	-- GuildFrame.selectedGuildMember = index;
	-- --PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
	-- --GuildFramePopup_Show(GuildMemberDetailFrame);
	-- --CloseDropDownMenus();
	-- --GuildRoster_Update();
	-- -- GuildMemberDetailFrame:Show();
	-- GuildStatus_Update();
	-- HideUIPanel(GuildFrame);
	-- ShowUIPanel(GuildFrame);
	-- FriendsFrameTab3:Click();
	-- GuildStatus_Update();
	if first_shown then
		ShowUIPanel(FriendsFrame);
		FriendsFrame_ShowSubFrame("GuildFrame");
		SetGuildRosterShowOffline(not guildRosterShowOffline);
		SetGuildRosterShowOffline(guildRosterShowOffline);
	end
	HideUIPanel(FriendsFrame);
	ShowUIPanel(FriendsFrame);
	FriendsFrame_ShowSubFrame("GuildFrame");
	-- select_member_index_ui(index);
end

local function Info_OnEnter(self, motion)
	if self.information then
		GameTooltip:ClearAllPoints();
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(self.information, 1.0, 1.0, 1.0);
	end
end
local function Info_OnLeave(self, motion)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide();
	end
end

local filterFunc = nil;
local nMember = 0;
local filterMatching = {};
local function FilterGuildMembers()
	if filterFunc then
		table.wipe(filterMatching);

		local numFilterMatching = 0;
		local numMembers;
		if guildRosterShowOffline then
			numMembers = GetNumGuildMembers();
		else
			_, _, numMembers = GetNumGuildMembers();	--total,online,online&mobile
		end
		for i = 1, numMembers do
			local name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID = GetGuildRosterInfo(i);
			local y, m, d, h = 0, 0, 0, 0;
			if not online then
				y, m, d, h = GetGuildRosterLastOnline(i);
			end
			if filterFunc(name, rankName, rankId, level, classLocale, zone, note, officerNote, online, class, GUID, y, m, d, h) then
				numFilterMatching = numFilterMatching + 1;
				-------------------------------------0--1-----2---------3-------4------5------------6-----7-----8------------9-------10-11-----12-13-14-15-16-17----18-19-20-21-22
				filterMatching[numFilterMatching] = { i, name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID, y, m, d, h, date };
			end
		end

		_ = nil;
		return numFilterMatching;
	end

	return -1;
end

function func.CreateCheckBox(parentFrame, label)
	local checkBox = CreateFrame("CheckButton", nil, parentFrame, "OptionsBaseCheckButtonTemplate");

	checkBox:Show();
	checkBox:EnableMouse(true);
	checkBox:SetHitRectInsets(0, 0, 0, 0);

	local fontString = checkBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	fontString:SetText(label);
	fontString:SetPoint("LEFT", checkBox, "RIGHT", 4, 0);

	checkBox.fontString = fontString;

	return checkBox;
end

do		-- FILTER FRAME
	local filterFrameElementWidth = 150;
	local filterFrameElementHeight = 80;
	local filterFrameElement_InfoSize = 24;
	local filterFrameElement_EditBoxWidth = 80;
	local filterFrameElement_EditBoxHeight = 18;
	local filterFrameElement_EditBox3Width = 58;
	local filterFrameElements = {};
	local filterFrame_FilterFunc_Sub = {};
	function func.SetFilterFunc(func)
		filterFunc = func;
	end
	function func.filterFrame_ResetElements()
		for _, element in pairs(filterFrameElements) do
			if element.editBox then
				for _, b in pairs(element.editBox) do
					b:SetText("");
					b.value = "";
					b.texture:SetVertexColor(1.0, 1.0, 1.0);
					b:ClearFocus();
				end
			end
		end
	end
	function func.filterFrame_ResetFilterFunc()
		table.wipe(filterFrame_FilterFunc_Sub);
		func.SetFilterFunc(nil);
	end
	function func.filterFrame_FilterFunc(name, rankName, rankId, level, classLocale, zone, note, officerNote, online, GUID, y, m, d, h)
		for _, func in pairs(filterFrame_FilterFunc_Sub) do
			if not func(name, rankName, rankId, level, classLocale, zone, note, officerNote, online, GUID, y, m, d, h) then
				return false;
			end
		end
		return true;
	end
	local function filterFrameUpdateFilter()
		func.SetFilterFunc(nil);
		for _, _ in pairs(filterFrame_FilterFunc_Sub) do
			func.SetFilterFunc(func.filterFrame_FilterFunc);
			break;
		end
		func.Refresh();
	end
	local function filterFrameApplyFilter(self)
		local key = self.key;
		local element = filterFrameElements[key];
		if element.type == "E1" then
			if self.value and self.value ~= "" then
				local subString = string.format(filterFrameFuncFormat, string.gsub(element.func[1], "#1", string.lower(self.value)));
				local sub = loadstring(subString);
				if sub then
					sub = sub();
					if sub then
						filterFrame_FilterFunc_Sub[key] = sub;
						func.SetFilterFunc(func.filterFrame_FilterFunc);
						func.Refresh();
					else
						_log_(subString, 2);
					end
				else
					_log_(subString, 1);
				end
			end
		elseif element.type == "E2" then
			local editBox = element.editBox;
			local subString = nil;
			if editBox[1].value and editBox[1].value ~= "" then
				if editBox[2].value and editBox[2].value ~= "" then
					subString = string.format(filterFrameFuncFormat, string.gsub(element.func[1], "#1", string.lower(editBox[1].value)) .. " and " .. string.gsub(element.func[2], "#1", string.lower(editBox[2].value)));
				else
					subString = string.format(filterFrameFuncFormat, string.gsub(element.func[1], "#1", string.lower(editBox[1].value)));
				end
			elseif editBox[2].value and editBox[2].value ~= "" then
				subString = string.format(filterFrameFuncFormat, string.gsub(element.func[2], "#1", string.lower(editBox[2].value)));
			end
			if subString ~= nil then
				local sub = loadstring(subString);
				if sub then
					sub = sub();
					if sub then
						filterFrame_FilterFunc_Sub[key] = sub;
						func.SetFilterFunc(func.filterFrame_FilterFunc);
						func.Refresh();
					else
						_log_(subString, 2);
					end
				else
					_log_(subString, 1);
				end
			end
		elseif element.type == "P2E3" then
			local e31 = element.editBoxes[1];
			local e32 = element.editBoxes[2];
			local d1, d2 = {}, {};
			local e31_set, e32_set = false, false;
			for i = 1, 3 do
				local value = e31[i].value;
				if not value or value == "" then
					d1[i] = "0";
				else
					d1[i] = string.lower(value) or "0";
				end
				if d1[i] ~= "0" then
					e31_set = true;
				end
			end
			for i = 1, 3 do
				local value = e32[i].value;
				if not value or value == "" then
					d2[i] = "0";
				else
					d2[i] = string.lower(value) or "0";
				end
				if d2[i] ~= "0" then
					e32_set = true;
				end
			end
			local subString = nil;
			if e31_set then
				if e32_set then
					subString = string.format(
						filterFrameFuncFormat, 
						string.gsub(string.gsub(string.gsub(element.func[1], "#1", d1[1]), "#2", d1[2]), "#3", d1[3])
						.. " and " .. 
						string.gsub(string.gsub(string.gsub(element.func[2], "#1", d2[1]), "#2", d2[2]), "#3", d2[3])
					);
				else
					subString = string.format(filterFrameFuncFormat, string.gsub(string.gsub(string.gsub(element.func[1], "#1", d1[1]), "#2", d1[2]), "#3", d1[3]));
				end
			elseif e32_set then
				subString = string.format(filterFrameFuncFormat,  string.gsub(string.gsub(string.gsub(element.func[2], "#1", d2[1]), "#2", d2[2]), "#3", d2[3]));
			end
			if subString ~= nil then
				local sub = loadstring(subString);
				if sub then
					sub = sub();
					if sub then
						filterFrame_FilterFunc_Sub[key] = sub;
						func.SetFilterFunc(func.filterFrame_FilterFunc);
						func.Refresh();
					else
						_log_(subString, 2);
					end
				else
					_log_(subString, 1);
				end
			end
		end
	end
	local function filterFrameEditBox_Reset(self)
		self:SetText("");
		self.value = "";
		self.texture:SetVertexColor(1.0, 1.0, 1.0);

		filterFrame_FilterFunc_Sub[self.key] = nil;
		-- filterFrameApplyFilter(self);
		filterFrameUpdateFilter();
	end
	local function filterFrameEditBox_OnEnterPressed(self)
		self:ClearFocus();
		self.value = self:GetText();
		if self.value == "" then
			self.texture:SetVertexColor(1.0, 1.0, 1.0);
			filterFrame_FilterFunc_Sub[self.key] = nil;
			filterFrameUpdateFilter();
		else
			self.texture:SetVertexColor(0.0, 1.0, 0.0);
			filterFrameApplyFilter(self);
		end
	end
	local function filterFrameEditBox_OnEscapePressed(self)
		if self.value == "" then
			self.texture:SetVertexColor(1.0, 1.0, 1.0);
		else
			self.texture:SetVertexColor(0.0, 1.0, 0.0);
		end
		self:SetText(self.value or "");
		self:ClearFocus();
	end
	local function filterFrameEditBox_OnChar(self)
		self.texture:SetVertexColor(1.0, 0.0, 0.0);
		if self.charType == "int" then
			self:SetText(self:GetText():gsub("[^0-9]+",""));
		--elseif self.charType == "float" then
		--	self:SetText(self:GetText():gsub("[^%.0-9]+",""):gsub("(%..*)%.","%1"))
		--elseif self.charType == "non_int" then
		--	self:SetText(self:GetText():gsub("[0-9]+",""));
		end
	end
	local function filterFrameEditBoxReset_OnClick(self)
		if self.editBoxes then
			for i = 1, #self.editBoxes do
				filterFrameEditBox_Reset(self.editBoxes[i]);
			end
		else
			filterFrameEditBox_Reset(self.editBox);
		end
		self.editBox:ClearFocus();
	end
	local function filterFrameEditBoxOk_OnClick(self)
		if self.editBoxes then
			for i = 1, #self.editBoxes do
				filterFrameEditBox_OnEnterPressed(self.editBoxes[i]);
			end
		else
			filterFrameEditBox_OnEnterPressed(self.editBox);
		end
	end
	local function filterFrameCheckBox_OnClick(self)
	end
	local function filterFrame_OnShow(self)
		mainFrame.filterBox:Hide();
		filterFrameUpdateFilter();
		func.Sound_Show();
	end
	local function filterFrame_OnHide(self)
		mainFrame.filterBox:Show();
		if mainFrame.filterBox.value ~= "" then
			func.SetFilterFunc(func.mainFrameFilterBox_FilterFunc);
			func.Refresh();
		else
			if filterFunc then
				func.SetFilterFunc(nil);
				func.Refresh();
			end
		end
		func.Sound_Hide();
	end
	function func.CreateFilterFrameE3(filterFrame, key, index, charType, maxLetter, label, prefixUnit)
		local editBoxes = {};
		for i = 1, 3 do
			local editBox = CreateFrame("EditBox", nil, filterFrame);
			editBox:SetSize(filterFrameElement_EditBox3Width, filterFrameElement_EditBoxHeight);
			editBox:SetFontObject(GameFontHighlightSmall);
			editBox:SetAutoFocus(false);
			editBox:SetJustifyH("LEFT");
			if maxLetter and maxLetter > 0 then
				editBox:SetMaxLetters(maxLetter);
			end

			editBox:Show();
			editBox:EnableMouse(true);
			editBox:SetScript("OnEnterPressed", filterFrameEditBox_OnEnterPressed);
			editBox:SetScript("OnEscapePressed", filterFrameEditBox_OnEscapePressed);
			editBox:SetScript("OnChar", filterFrameEditBox_OnChar);

			local texture = editBox:CreateTexture(nil, "ARTWORK");
			texture:SetPoint("TOPLEFT");
			texture:SetPoint("BOTTOMRIGHT");
			texture:SetTexture(artwork_path .. "editBoxBorder");
			texture:SetAlpha(0.36);
			texture:SetVertexColor(1.0, 1.0, 1.0);
			editBox.texture = texture;

			if prefixUnit and type(prefixUnit) == "table" and prefixUnit[i] then
				local fontString = editBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
				fontString:SetText(prefixUnit[i]);
				fontString:SetPoint("LEFT", editBox, "RIGHT", 2, 0);
				editBox.prefixUnit = fontString;
				if i ~=1 then
					if editBoxes[i - 1].prefixUnit then
						editBox:SetPoint("LEFT", editBoxes[i - 1].prefixUnit, "RIGHT", 2, 0);
					else
						editBox:SetPoint("LEFT", editBoxes[i - 1], "RIGHT", 2, 0);
					end
				end
			else
				if i ~= 1 then
					if editBoxes[i - 1].prefixUnit then
						editBox:SetPoint("LEFT", editBoxes[i - 1].prefixUnit, "RIGHT", 2, 0);
					else
						editBox:SetPoint("LEFT", editBoxes[i - 1], "RIGHT", 2, 0);
					end
				end
			end

			editBox.key = key;
			editBox.index = index;
			editBox.subIndex = i;
			editBox.charType = charType;

			editBox.value = "";

			editBoxes[i] = editBox;
		end

		local reset = CreateFrame("Button", nil, editBoxes[1]);
		reset:SetSize(filterFrameElement_EditBoxHeight, filterFrameElement_EditBoxHeight);
		if editBoxes[3].prefixUnit then
			reset:SetPoint("LEFT", editBoxes[3].prefixUnit, "RIGHT", 2, 0);
		else
			reset:SetPoint("LEFT", editBoxes[3], "RIGHT", 2, 0);
		end
		reset:Show();
		reset:EnableMouse(true);
		reset:SetScript("OnClick", filterFrameEditBoxReset_OnClick);
		reset:SetScript("OnEnter", Info_OnEnter);
		reset:SetScript("OnLeave", Info_OnLeave);
		reset:SetBackdrop(buttonBackdrop);
		reset:SetBackdropColor(buttonBackdropColor[1], buttonBackdropColor[2], buttonBackdropColor[3], buttonBackdropColor[4]);
		reset:SetBackdropBorderColor(buttonBackdropBorderColor[1], buttonBackdropBorderColor[2], buttonBackdropBorderColor[3], buttonBackdropBorderColor[4]);
		reset:SetNormalTexture("Interface\\Buttons\\ui-stopbutton");
		reset:SetPushedTexture("Interface\\Buttons\\ui-stopbutton");
		reset:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
		reset:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");

		reset.information = L.editBox_Reset;

		local ok = CreateFrame("Button", nil, editBoxes[1]);
		ok:SetSize(filterFrameElement_EditBoxHeight, filterFrameElement_EditBoxHeight);
		ok:SetPoint("LEFT", reset, "RIGHT", 2, 0);
		ok:Show();
		ok:EnableMouse(true);
		ok:SetScript("OnClick", filterFrameEditBoxOk_OnClick);
		ok:SetScript("OnEnter", Info_OnEnter);
		ok:SetScript("OnLeave", Info_OnLeave);
		ok:SetBackdrop(buttonBackdrop);
		ok:SetBackdropColor(buttonBackdropColor[1], buttonBackdropColor[2], buttonBackdropColor[3], buttonBackdropColor[4]);
		ok:SetBackdropBorderColor(buttonBackdropBorderColor[1], buttonBackdropBorderColor[2], buttonBackdropBorderColor[3], buttonBackdropBorderColor[4]);
		ok:SetNormalTexture("Interface\\Buttons\\ui-checkbox-check");
		ok:SetPushedTexture("Interface\\Buttons\\ui-checkbox-check-disabled");
		ok:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
		ok:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");

		ok.information = L.editBox_Ok;


		editBoxes[1].ok = ok;
		ok.editBox = editBoxes[1];
		ok.editBoxes = editBoxes;
		editBoxes[1].reset = reset;
		reset.editBox = editBoxes[1];
		reset.editBoxes = editBoxes;

		local fontString = editBoxes[1]:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
		fontString:SetText(label);
		fontString:SetPoint("RIGHT", editBoxes[1], "LEFT", -4, 0);

		editBoxes[1].fontString = fontString;

		return editBoxes;
	end
	function func.CreateFilterFrameEditBox(filterFrame, key, index, charType, maxLetter, label)
		local editBox = CreateFrame("EditBox", nil, filterFrame);
		editBox:SetSize(filterFrameElement_EditBoxWidth, filterFrameElement_EditBoxHeight);
		editBox:SetFontObject(GameFontHighlightSmall);
		editBox:SetAutoFocus(false);
		editBox:SetJustifyH("LEFT");
		if maxLetter and maxLetter > 0 then
			editBox:SetMaxLetters(maxLetter);
		end

		editBox:Show();
		editBox:EnableMouse(true);
		editBox:SetScript("OnEnterPressed", filterFrameEditBox_OnEnterPressed);
		editBox:SetScript("OnEscapePressed", filterFrameEditBox_OnEscapePressed);
		editBox:SetScript("OnChar", filterFrameEditBox_OnChar);

		local fontString = editBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
		fontString:SetText(label);
		fontString:SetPoint("RIGHT", editBox, "LEFT", -4, 0);

		editBox.fontString = fontString;

		local texture = editBox:CreateTexture(nil, "ARTWORK");
		texture:SetPoint("TOPLEFT");
		texture:SetPoint("BOTTOMRIGHT");
		texture:SetTexture(artwork_path .. "editBoxBorder");
		texture:SetAlpha(0.36);
		texture:SetVertexColor(1.0, 1.0, 1.0);

		local reset = CreateFrame("Button", nil, editBox);
		reset:SetSize(filterFrameElement_EditBoxHeight, filterFrameElement_EditBoxHeight);
		reset:SetPoint("LEFT", editBox, "RIGHT", 2, 0);
		reset:Show();
		reset:EnableMouse(true);
		reset:SetScript("OnClick", filterFrameEditBoxReset_OnClick);
		reset:SetScript("OnEnter", Info_OnEnter);
		reset:SetScript("OnLeave", Info_OnLeave);
		reset:SetBackdrop(buttonBackdrop);
		reset:SetBackdropColor(buttonBackdropColor[1], buttonBackdropColor[2], buttonBackdropColor[3], buttonBackdropColor[4]);
		reset:SetBackdropBorderColor(buttonBackdropBorderColor[1], buttonBackdropBorderColor[2], buttonBackdropBorderColor[3], buttonBackdropBorderColor[4]);
		reset:SetNormalTexture("Interface\\Buttons\\ui-stopbutton");
		reset:SetPushedTexture("Interface\\Buttons\\ui-stopbutton");
		reset:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
		reset:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");

		reset.information = L.editBox_Reset;

		local ok = CreateFrame("Button", nil, editBox);
		ok:SetSize(filterFrameElement_EditBoxHeight, filterFrameElement_EditBoxHeight);
		ok:SetPoint("LEFT", reset, "RIGHT", 2, 0);
		ok:Show();
		ok:EnableMouse(true);
		ok:SetScript("OnClick", filterFrameEditBoxOk_OnClick);
		ok:SetScript("OnEnter", Info_OnEnter);
		ok:SetScript("OnLeave", Info_OnLeave);
		ok:SetBackdrop(buttonBackdrop);
		ok:SetBackdropColor(buttonBackdropColor[1], buttonBackdropColor[2], buttonBackdropColor[3], buttonBackdropColor[4]);
		ok:SetBackdropBorderColor(buttonBackdropBorderColor[1], buttonBackdropBorderColor[2], buttonBackdropBorderColor[3], buttonBackdropBorderColor[4]);
		ok:SetNormalTexture("Interface\\Buttons\\ui-checkbox-check");
		ok:SetPushedTexture("Interface\\Buttons\\ui-checkbox-check-disabled");
		ok:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
		ok:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");

		ok.information = L.editBox_Ok;

		editBox.key = key;
		editBox.charType = charType;
		editBox.texture = texture;
		editBox.ok = ok;
		editBox.reset = reset;
		ok.editBox = editBox;
		reset.editBox = editBox;

		editBox.value = "";

		return editBox;
	end
	function func.CreateFilterFrameLabel(filterFrame, label, information)
		local info = CreateFrame("Button", nil, filterFrame);
		info:SetSize(filterFrameElement_InfoSize, filterFrameElement_InfoSize);

		info:SetNormalTexture("Interface\\Buttons\\AdventureGuideMicroButtonAlert");
		--info:SetPushedTexture("Interface\\Buttons\\AdventureGuideMicroButtonAlert");
		--info:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5);
		info:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");
		info:Show();
		info:SetScript("OnEnter", Info_OnEnter);
		info:SetScript("OnLeave", Info_OnLeave);
		info.information = information;

		local fontString = filterFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
		fontString:SetPoint("LEFT", info, "RIGHT", 4, 0);
		fontString:SetText(label);

		return info;
	end
	function func.CreateFilterFrame(mainFrame)
		local filterFrame = CreateFrame("Frame", nil, mainFrame);
		filterFrame:SetPoint("BOTTOMLEFT", mainFrame, "TOPLEFT", 0, 0);
		filterFrame:SetPoint("BOTTOMRIGHT", mainFrame, "TOPRIGHT", 0, 0);
		filterFrame:SetHeight(filterFrameElementHeight);
		filterFrame:SetBackdrop(mainFrameBackdrop);
		filterFrame:SetBackdropColor(mainFrameBackdropColor[1], mainFrameBackdropColor[2], mainFrameBackdropColor[3], mainFrameBackdropColor[4]);
		mainFrame.filterFrame = filterFrame;

		filterFrame:Hide();
		filterFrame:EnableMouse(true);
		filterFrame:SetMovable(true);
		filterFrame:RegisterForDrag("LeftButton");
		filterFrame:SetScript("OnShow", filterFrame_OnShow);
		filterFrame:SetScript("OnHide", filterFrame_OnHide);
		filterFrame:SetScript("OnDragStart", function(self, button)
				if not mainFrame.isMoving and not mainFrame.isResizing and mainFrame:IsMovable() then
					mainFrame:StartMoving();
				end
			end
		);
		filterFrame:SetScript("OnDragStop", function(self, button)
				mainFrame:StopMovingOrSizing();
			end
		);

		local vsep =filterFrame:CreateTexture(nil, "ARTWORK");
		vsep:SetHeight(4);
		vsep:SetPoint("TOPLEFT", 0, 0);
		vsep:SetPoint("TOPRIGHT", 0, 0);
		vsep:SetTexture("interface\\chatframe\\ui-chatframe-bordertop");
		vsep:SetTexCoord(0.0, 1.0, 0.125, 0.375);
		
		local pos = 1;
		local line = 1;
		for i, layout in pairs(filterFrameLayout) do
			if layout[1] == "newline" then

				local sep = filterFrame:CreateTexture(nil, "ARTWORK");
				sep:SetWidth(4);
				sep:SetHeight(filterFrameElementHeight);
				sep:SetPoint("TOP", filterFrame, "TOPLEFT", filterFrameElementWidth * (pos - 1), - filterFrameElementHeight * (line - 1));
				sep:SetTexture("interface\\chatframe\\ui-chatframe-borderleft");
				sep:SetTexCoord(0.125, 0.375, 0.0, 1.0);

				local vsep =filterFrame:CreateTexture(nil, "ARTWORK");
				vsep:SetHeight(4);
				vsep:SetPoint("TOPLEFT", 0, - filterFrameElementHeight * line);
				vsep:SetPoint("TOPRIGHT", 0, - filterFrameElementHeight * line);
				vsep:SetTexture("interface\\chatframe\\ui-chatframe-bordertop");
				vsep:SetTexCoord(0.0, 1.0, 0.125, 0.375);

				pos = 1;
				line = line + 1;
			else
				layout.width = layout.width or 1;
				local info = func.CreateFilterFrameLabel(filterFrame, L.sortLabel[layout[2]], layout[8]);
				info:SetPoint("TOPLEFT", filterFrame, "TOPLEFT", filterFrameElementWidth * (pos - 1) + 8, - filterFrameElementHeight * (line - 1) - 4);
				filterFrameElements[i] = { type = layout[1], };
				filterFrameElements[i].info = info;
				if layout[1] == "E1" then
					local editBox = func.CreateFilterFrameEditBox(filterFrame, i, 1, layout[3], layout[4], layout[5]);
					editBox:SetPoint("TOPLEFT", filterFrame, "TOPLEFT", filterFrameElementWidth * (pos - 1) + 28, - filterFrameElementHeight * (line - 1) - 30);
					filterFrameElements[i].editBox = { editBox, };
					filterFrameElements[i].func = { layout[9], };
				elseif layout[1] == "E2" then
					local editBox1 = func.CreateFilterFrameEditBox(filterFrame, i, 1, layout[3], layout[4], layout[5]);
					editBox1:SetPoint("TOPLEFT", filterFrame, "TOPLEFT", filterFrameElementWidth * (pos - 1) + 28, - filterFrameElementHeight * (line - 1) - 30);
					local editBox2 = func.CreateFilterFrameEditBox(filterFrame, i, 2, layout[3], layout[4], layout[6]);
					editBox2:SetPoint("TOPLEFT", editBox1, "BOTTOMLEFT", 0, -4);
					filterFrameElements[i].editBox = { editBox1, editBox2, };
					filterFrameElements[i].func = { layout[9], layout[10], };
				elseif layout[1] == "P2E3" then
					filterFrameElements[i].func = { layout[9], layout[10], };
					local e31 = func.CreateFilterFrameE3(filterFrame, i, 1, layout[3], layout[4], layout[5], layout[7]);
					e31[1]:SetPoint("TOPLEFT", filterFrame, "TOPLEFT", filterFrameElementWidth * (pos - 1) + 28, - filterFrameElementHeight * (line - 1) - 30);
					local e32 = func.CreateFilterFrameE3(filterFrame, i, 1, layout[3], layout[4], layout[6], layout[7]);
					e32[1]:SetPoint("TOPLEFT", e31[1], "BOTTOMLEFT", 0, -4);
					filterFrameElements[i].editBoxes = { e31, e32 };
					filterFrameElements[i].func = { layout[9], layout[10], };
				else
				end
				local sep = filterFrame:CreateTexture(nil, "ARTWORK");
				sep:SetWidth(4);
				sep:SetHeight(filterFrameElementHeight);
				sep:SetPoint("TOP", filterFrame, "TOPLEFT", filterFrameElementWidth * (pos - 1), - filterFrameElementHeight * (line - 1));
				sep:SetTexture("interface\\chatframe\\ui-chatframe-borderleft");
				sep:SetTexCoord(0.125, 0.375, 0.0, 1.0);

				pos = pos + layout.width;
			end
		end

		local sep = filterFrame:CreateTexture(nil, "ARTWORK");
		sep:SetWidth(4);
		sep:SetHeight(filterFrameElementHeight);
		sep:SetPoint("TOP", filterFrame, "TOPLEFT", filterFrameElementWidth * (pos - 1), - filterFrameElementHeight * (line - 1));
		sep:SetTexture("interface\\chatframe\\ui-chatframe-borderleft");
		sep:SetTexCoord(0.125, 0.375, 0.0, 1.0);

		local vsep =filterFrame:CreateTexture(nil, "ARTWORK");
		vsep:SetHeight(4);
		vsep:SetPoint("TOPLEFT", 0, - filterFrameElementHeight * line);
		vsep:SetPoint("TOPRIGHT", 0, - filterFrameElementHeight * line);
		vsep:SetTexture("interface\\chatframe\\ui-chatframe-bordertop");
		vsep:SetTexCoord(0.0, 1.0, 0.125, 0.375);

		filterFrame:SetHeight(filterFrameElementHeight * line);

		return filterFrame;
	end
end

do		-- MAIN FRAME
	function func.mainFrameFilterBox_FilterFunc(name, rankName, rankId, level, classLocale, zone, note, officerNote, online, class, GUID, y, m, d, h)
		local val = string.lower(mainFrame.filterBox.value);
		return (
					(name			and string.find(string.lower(name),			val)) or 
					(rankName		and string.find(string.lower(rankName),		val)) or 
					(class			and string.find(string.lower(class),		val)) or 
					(classLocale	and string.find(string.lower(classLocale),	val)) or 
					(zone			and string.find(string.lower(zone),			val)) or 
					(note			and string.find(string.lower(note),			val)) or 
					(officerNote	and string.find(string.lower(officerNote),	val)) or 
					(tonumber(val) == level)
				);
	end
	local function mainFrameFilterBox_Reset(self)
		self:SetText("");
		self.value = "";
		self.texture:SetVertexColor(1.0, 1.0, 1.0);
		func.filterFrame_ResetElements();
		func.filterFrame_ResetFilterFunc();
		func.Refresh();
	end
	local function mainFrameFilterBox_OnEnterPressed(self)
		self:ClearFocus();
		self.value = self:GetText();
		if self.value == "" then
			self.texture:SetVertexColor(1.0, 1.0, 1.0);
			func.SetFilterFunc(nil);
		else
			self.texture:SetVertexColor(0.0, 1.0, 0.0);
			func.SetFilterFunc(func.mainFrameFilterBox_FilterFunc);
		end
		func.Refresh();
	end
	local function mainFrameFilterBox_OnEscapePressed(self)
		if self.value == "" then
			self.texture:SetVertexColor(1.0, 1.0, 1.0);
		else
			self.texture:SetVertexColor(0.0, 1.0, 0.0);
		end
		self:SetText(self.value or "");
		self:ClearFocus();
		self.texture:SetVertexColor(1.0, 1.0, 1.0);
	end
	local function mainFrameFilterBox_OnChar(self)
		self.texture:SetVertexColor(1.0, 0.0, 0.0);
	end
	local function mainFrameFilterBoxReset_OnClick(self)
		mainFrameFilterBox_Reset(self.editBox);
		self.editBox:ClearFocus();
	end
	local function mainFrameFilterBoxOk_OnClick(self)
		mainFrameFilterBox_OnEnterPressed(self.editBox);
	end
	local function mainFrameFilterButton_OnClick(self)
		if mainFrame.filterFrame:IsShown() then
			self:SetNormalTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrollupbutton-up");
			self:SetPushedTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrollupbutton-down");
			self:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
			self:SetHighlightTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrollupbutton-highlight");
			mainFrame.filterFrame:Hide();
		else
			self:SetNormalTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrolldownbutton-up");
			self:SetPushedTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrolldownbutton-down");
			self:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
			self:SetHighlightTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrolldownbutton-highlight");
			mainFrame.filterFrame:Show();
		end
	end


	local function CreateMainFrameButton(mainFrame)
		local lockButton = CreateFrame("Button", nil, mainFrame);
		lockButton:SetSize(18, 18);
		lockButton:SetNormalTexture("Interface\\petbattles\\petbattle-lockicon");
		lockButton:SetPushedTexture("Interface\\petbattles\\petbattle-lockicon");
		lockButton:GetNormalTexture():SetVertexColor(0.5, 0.5, 0.5, 0.75)
		lockButton:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");
		lockButton:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 6, -6);
		lockButton:SetScript("OnClick", func.Lock);
		lockButton:SetScript("OnEnter", Info_OnEnter);
		lockButton:SetScript("OnLeave", Info_OnLeave);
		lockButton.information = L.lockButton;
		mainFrame.lockButton = lockButton;

		local filterBox = func.CreateFilterFrameEditBox(mainFrame, nil, nil, nil);
		filterBox:SetPoint("LEFT", lockButton, "RIGHT", 10, 0);
		filterBox:SetWidth(120);
		filterBox:SetScript("OnEnterPressed", mainFrameFilterBox_OnEnterPressed);
		filterBox:SetScript("OnEscapePressed", mainFrameFilterBox_OnEscapePressed);
		filterBox:SetScript("OnChar", mainFrameFilterBox_OnChar);
		filterBox.ok:SetScript("OnClick", mainFrameFilterBoxOk_OnClick);
		filterBox.reset:SetScript("OnClick", mainFrameFilterBoxReset_OnClick);
		mainFrame.filterBox = filterBox;

		local filterButton = CreateFrame("Button", nil, mainFrame);
		filterButton:SetSize(18, 18);
		filterButton:SetNormalTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrollupbutton-up");
		filterButton:SetPushedTexture("Interface\\MAINMENUBAR\\ui-mainmenu-scrollupbutton-down");
		filterButton:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");
		filterButton:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.25, 0.75);
		filterButton:GetPushedTexture():SetTexCoord(0.25, 0.75, 0.25, 0.75);
		filterButton:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
		filterButton:GetHighlightTexture():SetTexCoord(0.25, 0.75, 0.25, 0.75);
		filterButton:SetPoint("LEFT", filterBox.ok, "RIGHT", 6, 0);
		filterButton:SetScript("OnClick", mainFrameFilterButton_OnClick);
		filterButton:SetScript("OnEnter", Info_OnEnter);
		filterButton:SetScript("OnLeave", Info_OnLeave);
		filterButton.information = L.filterButton;
		mainFrame.filterButton = filterButton;

		local resetButton = CreateFrame("Button", nil, mainFrame);
		resetButton:SetSize(18, 18);
		resetButton:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton");
		resetButton:SetPushedTexture("Interface\\Buttons\\UI-RefreshButton");
		resetButton:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
		resetButton:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");
		resetButton:SetPoint("LEFT", filterButton, "RIGHT", 6, 0);
		resetButton:SetScript("OnClick", func.Reset);
		resetButton:SetScript("OnEnter", Info_OnEnter);
		resetButton:SetScript("OnLeave", Info_OnLeave);
		resetButton.information = L.resetButton;
		mainFrame.resetButton = resetButton;

		local closeButton = CreateFrame("Button", nil, mainFrame);
		closeButton:SetSize(18, 18);
		closeButton:SetNormalTexture("Interface\\Buttons\\UI-StopButton");
		closeButton:SetPushedTexture("Interface\\Buttons\\UI-StopButton");
		closeButton:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
		closeButton:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");
		closeButton:SetPoint("TOPRIGHT", -6, -6);
		closeButton:SetScript("OnClick", function(self, button)
				mainFrame:Hide();
			end
		);
		closeButton:SetScript("OnEnter", Info_OnEnter);
		closeButton:SetScript("OnLeave", Info_OnLeave);
		closeButton.information = L.closeButton;
		mainFrame.closeButton = closeButton;

		local showOffLine = func.CreateCheckBox(mainFrame, L.showOffLine);
		showOffLine:SetChecked(guildRosterShowOffline);
		showOffLine:SetScript("OnClick", function(self)
				ShowUIPanel(FriendsFrame);
				FriendsFrame_ShowSubFrame("GuildFrame");
				guildRosterShowOffline = self:GetChecked();
				if guildRosterShowOffline then
					SetGuildRosterShowOffline(true);
					-- if GuildRosterShowOfflineButton and not GuildRosterShowOfflineButton:GetChecked() then
					-- 	GuildRosterShowOfflineButton:Click()
					-- end
					-- if not GuildFrameLFGButton:GetChecked() then
					-- 	GuildFrameLFGButton:Click();
					-- end
				else
					SetGuildRosterShowOffline(false);
					-- if GuildRosterShowOfflineButton and GuildRosterShowOfflineButton:GetChecked() then
					-- 	GuildRosterShowOfflineButton:Click()
					-- end
					-- if GuildFrameLFGButton:GetChecked() then
					-- 	GuildFrameLFGButton:Click();
					-- end
				end
				func.Refresh();
				HideUIPanel(FriendsFrame);
				ShowUIPanel(FriendsFrame);
				FriendsFrame_ShowSubFrame("GuildFrame");
			end
		);
		showOffLine:SetPoint("BOTTOMLEFT", 6, 4);
		mainFrame.showOffLine = showOffLine;

		local sumText = mainFrame:CreateFontString(nil, "ARTWORK","GameFontHighlight");
		sumText:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -6, 10);
		sumText:SetText("");
		mainFrame.sumText = sumText;

		local sumLabel = mainFrame:CreateFontString(nil, "ARTWORK","GameFontHighlight");
		sumLabel:SetPoint("BOTTOMRIGHT", sumText, "BOTTOMLEFT", -32, 0);
		sumLabel:SetText(string.format(sumTextFormat, L.sumLabel_Shown, L.sumLabel_Online, L.sumLabel_All));
		mainFrame.sumLabel = sumLabel;
	end
	local function CreateRosterSortButton(mainFrame)
		mainFrame.sortElements = {};

		for i, n in pairs(rosterElementName) do
			local button = CreateFrame("Button", NAME .. "RosterElement_" .. n, mainFrame);
			if i == 1 then
				button:SetSize(rosterElementWidth[i] + rosterElementBaseOfs, 18);
				button:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 8, -28);
			else
				button:SetSize(rosterElementWidth[i], 18);
				button:SetPoint("LEFT", mainFrame.sortElements[#mainFrame.sortElements], "RIGHT", 0, 0);
			end
			button:Show();
			button:EnableMouse(true);
			button:SetScript("OnClick", func.Sort);
			local name = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			name:SetPoint("LEFT", 1, 0);
			name:SetText(L.elements[n]);
			button:SetBackdrop(buttonBackdrop);
			button:SetBackdropColor(buttonBackdropColor[1], buttonBackdropColor[2], buttonBackdropColor[3], buttonBackdropColor[4]);
			button:SetBackdropBorderColor(buttonBackdropBorderColor[1], buttonBackdropBorderColor[2], buttonBackdropBorderColor[3], buttonBackdropBorderColor[4]);
			--button:SetNormalTexture("Interface\\Buttons\\UI-StopButton");
			--button:SetPushedTexture("Interface\\Buttons\\UI-StopButton");
			button:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar");
			
			button.sortType = n;
			mainFrame.sortElements[i] = button;
		end
		--mainFrame.sortElements[rosterElementIndex.oNote]:SetBackdropColor(1.0, 1.0, 1.0, 0.0);
		mainFrame.sortElements[rosterElementIndex.oNote]:Disable();

	end
	local function OnSizeChanged(self, width, height)
		local sortElements = mainFrame.sortElements;
		local ofs = 0;
		for i = #sortElements, 1, -1 do
			if rosterElementEnabled[i] then
				if ofs + rosterElementOfs[i] + rosterElementWidth[i] < width then
					sortElements[i]:Show();
				elseif ofs + rosterElementOfs[i] < width then
					sortElements[i]:Show();
					sortElements[i]:SetWidth(width - rosterElementOfs[i] - ofs - 16);
				else
					sortElements[i]:Hide();
				end
			end
		end
	end


	local function scrollChildButton_OnClick(self, button)
		if button == "LeftButton" then
			if mainFrame.selectedGuildMember == self.rosterId then
				select_member_index(0);
				mainFrame.scrollFrame:CallButtonFuncByDataIndex(self.rosterId, "Deselect");
			else
				mainFrame.scrollFrame:CallButtonFuncByDataIndex(mainFrame.selectedGuildMember, "Deselect");
				select_member_index(self.rosterId);
				self:Select();
			end
			func.Sound_Clicked();
		elseif button == "RightButton" then
			local data_index = self:GetDataIndex();
			-- local rosterId, name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID;
			-- local y, m, d, h, date;
			local name, online;
			if filterFunc then
				-- rosterId, name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID, y, m, d, h = unpack(filterMatching[data_index]);
				name = filterMatching[data_index][2];
				online = filterMatching[data_index][10];
			else
				-- name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID = GetGuildRosterInfo(data_index);
				-- y, m, d, h = GetGuildRosterLastOnline(rosterId);
				name, _, _, _, _, _, _, _, online = GetGuildRosterInfo(data_index);
			end
			local meta = {
				handler = _noop_,
				elements = {
					{
						handler = function()
							local editBox = ChatEdit_ChooseBoxForSend();
							ChatEdit_ActivateChat(editBox);
							editBox:Insert(name);
						end,
						text = L["COPY_NAME"],
						para = {  },
					},
				},
			};
			if online and strsplit("-", name) ~= strsplit("-", UnitName('player')) then
				tinsert(meta.elements, 1, {
						handler = function() InviteUnit(name); end,
						text = L["INVITE"],
						para = {  },
					});
				tinsert(meta.elements, 1, {
						handler = function()
							local editBox = ChatEdit_ChooseBoxForSend();
							if editBox:HasFocus() then
								local text = editBox:GetText();
								editBox:SetText("/w " .. name .. " ");
								editBox:Insert(text);
							else
								editBox:Show();
								editBox:SetFocus();
								editBox:Insert("/w " .. name .. " ");
							end
						end,
						text = L["WHISPER"],
						para = {  },
					});
			end
			if IsAddOnLoaded("alaTalentEmu") and ATEMU and ATEMU.Query then
				tinsert(meta.elements, 1, {
					handler = function() ATEMU.Query(name); end,
					text = L["INSPECT_TALENT"],
					para = {  },
				});
			end
			ALADROP(self, "BOTTOMLEFT", meta);
			func.Sound_Clicked();
		end
	end
	local function funcToCreateButton(scrollChild, i, buttonHeight)
		
		local button = CreateFrame("Button", NAME .. "ScrollChildButton" .. i, scrollChild);
		button:SetHeight(buttonHeight);

		local level = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		level:SetPoint("LEFT", rosterElementOfs[1], 0);

		local class = button:CreateTexture(nil, "ARTWORK");
		class:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
		class:SetSize(20, 20);
		class:SetPoint("LEFT", rosterElementOfs[2], 0);
		class:SetTexCoord(0.75, 1.0, 0.75, 1.0);

		local name = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		name:SetPoint("LEFT", rosterElementOfs[3], 0);

		local online = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		online:SetPoint("LEFT", rosterElementOfs[4], 0);

		local zone = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		zone:SetPoint("LEFT", rosterElementOfs[5], 0);

		local rank = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		rank:SetPoint("LEFT", rosterElementOfs[6], 0);

		local note = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		note:SetPoint("LEFT", rosterElementOfs[7], 0);

		local oNote = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		oNote:SetPoint("LEFT", rosterElementOfs[8], 0);

		button.elements = {
			level = level,
			class = class,
			name = name,
			online = online,
			zone = zone,
			rank = rank,
			note = note,
			oNote = oNote,
		};

		button:Show();
		button:EnableMouse(true);
		button:RegisterForClicks("AnyUp");
		button:SetScript("OnClick", scrollChildButton_OnClick);

		button:SetBackdrop(buttonBackdrop);
		button:SetBackdropColor(buttonBackdropColor[1], buttonBackdropColor[2], buttonBackdropColor[3], buttonBackdropColor[4]);
		button:SetBackdropBorderColor(buttonBackdropBorderColor[1], buttonBackdropBorderColor[2], buttonBackdropBorderColor[3], buttonBackdropBorderColor[4]);
		--button:SetNormalTexture("Interface\\Buttons\\UI-StopButton");
		--button:SetPushedTexture("Interface\\Buttons\\UI-StopButton");
		button:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar");

		button.id = i;

		function button:Select()
			self.selected = true;
			self:LockHighlight();
		end
		function button:Deselect()
			self.selected = nil;
			self:UnlockHighlight();
		end
		function button:IsSelected()
			return self.selected;
		end

		return button;
	end
	local function functToSetButton(button, data_index)
		if data_index <= nMember then
			button:Show();
			local rosterId, name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID;
			local y, m, d, h, date;

			if filterFunc then
				rosterId, name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID, y, m, d, h = unpack(filterMatching[data_index]);
				if online then
					date = L.online;
				else
					if y ~= 0 then
						date = y .. L.year .. m .. L.month .. d .. L.day .. h .. L.hour;
					elseif m ~= 0 then
						date = m .. L.month .. d .. L.day .. h .. L.hour;
					elseif d ~= 0 then
						date = d .. L.day .. h .. L.hour;
					elseif h ~= 0 then
						date = h .. L.hour;
					else
						date = L.lessThanOneHour;
					end
				end
			else
				rosterId = data_index;
				name, rankName, rankId, level, classLocale, zone, note, officerNote, online, _, class, _, _, _, _, _, GUID = GetGuildRosterInfo(rosterId);
				if online then
					date = L.online;
				else
					y, m, d, h = GetGuildRosterLastOnline(rosterId);
					if y ~= 0 then
						date = y .. L.year .. m .. L.month .. d .. L.day .. h .. L.hour;
					elseif m ~= 0 then
						date = m .. L.month .. d .. L.day .. h .. L.hour;
					elseif d ~= 0 then
						date = d .. L.day .. h .. L.hour;
					elseif h ~= 0 then
						date = h .. L.hour;
					else
						date = L.lessThanOneHour;
					end
				end
			end

			if button:IsSelected() and rosterId ~= mainFrame.selectedGuildMember then
				button:Deselect();
			elseif not button:IsSelected() and rosterId == mainFrame.selectedGuildMember then
				button:Select();
			end

			button.rosterId = rosterId;

			local elements = button.elements;

			if online then
				elements.level:SetTextColor(1.0, 1.0, 1.0);
				local colorTable = RAID_CLASS_COLORS[class];
				if colorTable then
					elements.name:SetTextColor(colorTable.r, colorTable.g, colorTable.b);
				end
					elements.online:SetTextColor(1.0, 1.0, 1.0);
				elements.zone:SetTextColor(1.0, 1.0, 1.0);
				elements.rank:SetTextColor(1.0, 1.0, 1.0);
				elements.note:SetTextColor(1.0, 1.0, 1.0);
				elements.oNote:SetTextColor(1.0, 1.0, 1.0);
			else
				elements.level:SetTextColor(0.5, 0.5, 0.5);
				elements.name:SetTextColor(0.5, 0.5, 0.5);
				elements.online:SetTextColor(0.5, 0.5, 0.5);
				elements.zone:SetTextColor(0.5, 0.5, 0.5);
				elements.rank:SetTextColor(0.5, 0.5, 0.5);
				elements.note:SetTextColor(0.5, 0.5, 0.5);
				elements.oNote:SetTextColor(0.5, 0.5, 0.5);
			end

			elements.level:SetText(level);
			elements.class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
			elements.name:SetText(string.split("-", name));
			elements.online:SetText(date);
			elements.zone:SetText(zone);
			elements.rank:SetText(rankId .. "-" .. rankName);
			elements.note:SetText(note);
			elements.oNote:SetText(officerNote);
		else
			button:Hide();
		end
	end

	function func.SetMainFrame()
		mainFrame:SetPoint("CENTER");
		mainFrame:SetSize(600, 360);
		mainFrame:SetMinResize(600, 360);
		mainFrame:SetMaxResize(rosterElementOfs[#rosterElementOfs] + rosterElementWidth[#rosterElementWidth], 4096);
		mainFrame:SetBackdrop(mainFrameBackdrop);
		mainFrame:SetBackdropColor(mainFrameBackdropColor[1], mainFrameBackdropColor[2], mainFrameBackdropColor[3], mainFrameBackdropColor[4]);

		mainFrame.filterFrame = func.CreateFilterFrame(mainFrame);

		CreateMainFrameButton(mainFrame);
		CreateRosterSortButton(mainFrame);

		local scrollFrame = ALASCR(mainFrame, nil, nil, buttonHeight, funcToCreateButton, functToSetButton);
		scrollFrame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 8, -48);
		scrollFrame:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", - 8, 30);
		mainFrame.scrollFrame = scrollFrame;

		mainFrame:EnableMouse(true);
		mainFrame:SetMovable(true);
		mainFrame:SetResizable(true);

		mainFrame:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" and not self.isMoving and not self.isResizing and self:IsMovable() then
					local x, y = GetCursorPosition();
					local s = self:GetEffectiveScale();
					x = x / s;
					y = y / s;
					local bottom = self:GetBottom();
					local top = self:GetTop();
					local left = self:GetLeft();
					local right = self:GetRight();

					if x < left + borderSize then
						if y < bottom + borderSize then
							self:StartSizing("BOTTOMLEFT");
						elseif y > top - borderSize then
							self:StartSizing("TOPLEFT");
						else
							self:StartSizing("LEFT");
						end
						self.isResizing = true;
					elseif x > right - borderSize then
						if y < bottom + borderSize then
							self:StartSizing("BOTTOMRIGHT");
						elseif y > top - borderSize then
							self:StartSizing("TOPRIGHT");
						else
							self:StartSizing("RIGHT");
						end
						self.isResizing = true;
					elseif y < bottom + borderSize then
						self:StartSizing("BOTTOM");
						self.isResizing = true;
					elseif y > top - borderSize then
						self:StartSizing("TOP");
						self.isResizing = true;
					else
						self:StartMoving();
						self.isMoving = true;
					end
				end
			end
		);
		mainFrame:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" then
				if self.isMoving then
					self:StopMovingOrSizing()
					self.isMoving = false
					--recordPos();
				elseif self.isResizing then
					self:StopMovingOrSizing()
					self.isResizing = false
				end
			end
		end
		);
		mainFrame:SetScript("OnSizeChanged", OnSizeChanged);
		mainFrame:SetScript("OnShow", function(self)
				func.Refresh();
				mainFrame.scrollFrame:Update();
			end
		);
		mainFrame:SetScript("OnHide", function(self)
				if self.isMoving then
					self:StopMovingOrSizing();
					self.isMoving = false;
				end
				if self.isResizing then
					self:StopMovingOrSizing();
					self.isResizing = false;
				end
			end
		);

		mainFrame:Hide();

		OnSizeChanged(mainFrame, mainFrame:GetWidth(), mainFrame:GetHeight());

		mainFrame.selectedGuildMember = 0;
	end
end

do		-- FUNCTION
	function func.Sound_Show()
		PlaySound(841);
	end
	function func.Sound_Hide()
		PlaySound(851);
	end
	function func.Sound_Clicked()
		PlaySound(842);
	end
	function func.Refresh()
		GuildRoster();
		guildRosterShowOffline = GetGuildRosterShowOffline();

		if guildRosterShowOffline then
			mainFrame.showOffLine:SetChecked(true);
		else
			mainFrame.showOffLine:SetChecked(false);
		end

		if filterFunc then
			nMember = FilterGuildMembers();
			local total, _, onlineAndMobile = GetNumGuildMembers();
			mainFrame.sumText:SetText(string.format(sumTextFormat, nMember, onlineAndMobile, total));
		elseif guildRosterShowOffline then
			local onlineAndMobile;
			nMember, _, onlineAndMobile = GetNumGuildMembers();
			mainFrame.sumText:SetText(string.format(sumTextFormat, onlineAndMobile, onlineAndMobile, nMember));
		else
			local total;
			total, _, nMember = GetNumGuildMembers();	--total,online,online&mobile
			mainFrame.sumText:SetText(string.format(sumTextFormat, nMember, nMember, total));
		end

		mainFrame.scrollFrame:SetNumValue(nMember);
		mainFrame.scrollFrame:Update();

		authority.CanEditPublicNote = CanEditPublicNote();
		authority.CanEditOfficerNote = CanEditOfficerNote();

		authority.CanGuildRemove = CanGuildRemove();
		authority.CanGuildInvite = CanGuildInvite();

		authority.CanGuildDemote = CanGuildDemote();
		authority.CanGuildPromote = CanGuildPromote();

		authority.CanEditGuildInfo = CanEditGuildInfo();
		authority.CanEditMOTD = CanEditMOTD();

		if authority.CanViewOfficerNote ~= CanViewOfficerNote() then
			authority.CanViewOfficerNote = not authority.CanViewOfficerNote;

			-- if authority.CanViewOfficerNote then
			-- 	local buttons = mainFrame.scrollFrame.scrollChild.buttons;
			-- 	for i = 1, #buttons do
			-- 		buttons[i].elements.oNote:Show();
			-- 	end
			-- 	rosterElementEnabled[rosterElementIndex.oNote] = false;
			-- else
			-- 	local buttons = mainFrame.scrollFrame.scrollChild.buttons;
			-- 	for i = 1, #buttons do
			-- 		buttons[i].elements.oNote:Hide();
			-- 	end
			-- 	mainFrame.sortElements[rosterElementIndex.oNote]:Hide();
			-- 	rosterElementEnabled[rosterElementIndex.oNote] = true;
			-- end
		end
	end
	function func.Lock(self)
		if mainFrame:IsMovable() then
			self:GetNormalTexture():SetVertexColor(0.5, 0.5, 0.5, 0.75);
			mainFrame:SetMovable(false);
			--setting.isLocked = false;
		else
			self:GetNormalTexture():SetVertexColor(1, 1, 1, 1);
			mainFrame:SetMovable(true);
			--setting.isLocked = true;
		end
	end
	local prevSort = nil;
	local buttonCheckedBackdropColor = { 1.0, 0.0, 0.0, 1.0 };
	function func.Sort(self)
		if self.sortType then
			SortGuildRoster(self.sortType);

			if prevSort and prevSort ~= self then
				prevSort:SetBackdropColor(buttonBackdropColor[1], buttonBackdropColor[2], buttonBackdropColor[3], buttonBackdropColor[4]);
				--prevSort:SetBackdropBorderColor(buttonBackdropBorderColor[1], buttonBackdropBorderColor[2], buttonBackdropBorderColor[3], buttonBackdropBorderColor[4]);
			end
			self:SetBackdropColor(buttonCheckedBackdropColor[1], buttonCheckedBackdropColor[2], buttonCheckedBackdropColor[3], buttonCheckedBackdropColor[4]);
			--self:SetBackdropBorderColor(buttonCheckedBackdropBorderColor[1], buttonCheckedBackdropBorderColor[2], buttonCheckedBackdropBorderColor[3], buttonCheckedBackdropBorderColor[4]);
			prevSort = self;
			mainFrame.scrollFrame:Update();
		end
	end
	function func.Toggle()
		if not mainFrame.initialized then
			return;
		end
		if mainFrame:IsShown() then
			HideUIPanel(mainFrame);
			func.Sound_Hide();
		else
			ShowUIPanel(mainFrame);
			func.Sound_Hide();
		end
	end
	function func.hook_SetGuildRosterSelection(rosterId)
		select_member_index_ui(rosterId);
	end
end


local function init(self)
	guildRosterShowOffline = GetGuildRosterShowOffline();

	GenRosterElementInfo();

	func.SetMainFrame();

	LoadAddOn("blizzard_guildui");
	C_Timer.After(1.0, function()
		if GuildFrame then
			GuildFrame:HookScript("OnShow", function() first_shown = false; end);
			indicator:SetParent(GuildFrame);
			hooksecurefunc("SetGuildRosterSelection", func.hook_SetGuildRosterSelection);
		end
	end);

	if LibStub then
		local icon = LibStub("LibDBIcon-1.0", true);
		if icon then
			icon:Register("alaEGuild",
				{
					icon = artwork_path .. "ICON",
					OnClick = func.Toggle,
					text = L.DBIcon_Text,
					OnTooltipShow = function(tt)
							tt:AddLine("alaEGuild");
							tt:AddLine(" ");
							tt:AddLine(L.DBIcon_Text);
						end
				},
				{
					minimapPos = -15,
				}
			);
		end
	end
end

local function OnEvent(self, event, ...)
	if event == "GUILD_ROSTER_UPDATE" then
		if not self.initialized then
			if IsInGuild() then
				init();
				self.initialized = true;
			end
		else
			if IsInGuild() then
				C_Timer.After(0.1, function()
					func.Refresh();
				end);
			else
				--
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		self:RegisterEvent("GUILD_ROSTER_UPDATE");

		if not IsInGuild() then
			return;
		end

		init();
		self.initialized = true;
	end
end


mainFrame:SetScript("OnEvent", OnEvent);
mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD");


SLASH_ALAGUILD1 = "/alag";
SLASH_ALAGUILD2 = "/alaguild";
SlashCmdList["ALAGUILD"] = func.Toggle;
_G["alaEGuild_Toggle"] = func.Toggle;

--UIPanelWindows[NAME .. "MainFrame"] = { area = "left", pushable = 1, whileDead = 1 };


--[[
	1_name, 2_rankName, 3_rankId(0,1,...), 4_level, 5_classLocale, 6_zone, 7_note, 8_officerNote, 9_online, 10_unk_int(status), 11_class, 12_achivementPoint, 13_achivementRank, 14_unk(isMobile), 15_unk(canSoR), 16_unk(repStanding), 17_GUID
		 = GetGuildRosterInfo

	GuildUninvite("name")

	GuildRosterSetPublicNote(index, "note")
	GuildRosterSetOfficerNote(index, "note")

	RecentTimeDate( GetGuildRosterLastOnline(guildIndex) );

	/run GuildRosterShowOfflineButton:Disable()
	SetGuildRosterShowOffline(bool);
	SortGuildRoster("sort")  { "name", "rank", "note", "online", "zone", "level", "class" } "achievementpoints

	CanEditGuildInfo()
	CanEditMOTD()
	CanEditPublicNote()
	CanGuildDemote()
	CanGuildInvite()
	CanGuildPromote()
	CanGuildRemove()

	CanEditOfficerNote()
	CanViewOfficerNote()

	GetGuildInfo("unit")

	GetGuildRosterMOTD()
	GetGuildRosterShowOffline()
	GuildDemote("name")
	GuildInfo()
	GuildPromote("name")
	GuildRosterSetOfficerNote(index, "note")
	GuildRosterSetPublicNote(index, "note")
	GuildSetMOTD("note")
	GuildUninvite("name")

	IsInGuild()
	SetGuildInfoText("text")
	SetGuildMemberRank(player index, rank index)
	SetGuildRosterShowOffline(enabled)

]]
