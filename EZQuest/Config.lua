local ADDON_NAME = ...;
local DEFAULT_SAVED_VARS = { AutoTurnInQuests = true, AutoAcceptQuests = true, AutoTrackQuests = true, IsEnabled = true };
local SAVED_VARS_VERSION = 1;

EZQuestConfigMixin = {};

function EZQuestConfigMixin:OnLoad()
	self:RegisterEvent("ADDON_LOADED");
	self.name = "EZ Quest";
	
	InterfaceOptions_AddCategory(self);
end

function EZQuestConfigMixin:OnEvent(event, ...)
	if (event == "ADDON_LOADED") then
		if (ADDON_NAME == ...) then
			self:UnregisterEvent("ADDON_LOADED");

			self:RegisterEvent("VARIABLES_LOADED");

			if not EZQuest_SavedVars or not EZQuest_SavedVars.version then
				EZQuest_SavedVars = CopyTable(DEFAULT_SAVED_VARS);
			end

			EZQuest_SavedVars.version = SAVED_VARS_VERSION;
		end
	else
		self.savedVars = EZQuest_SavedVars;
			
		EZQuestConfigFrameIsEnabled:SetChecked(self.savedVars.IsEnabled);
		EZQuestConfigFrameAutoTurnInQuests:SetChecked(self.savedVars.AutoTurnInQuests);
		EZQuestConfigFrameAutoAcceptQuests:SetChecked(self.savedVars.AutoAcceptQuests);
		EZQuestConfigFrameAutoTrackQuests:SetChecked(self.savedVars.AutoTrackQuests);
	end
end

function EZQuestConfigMixin:OnEnabledChanged()
	if (EZQuest_SavedVars.IsEnabled) then
		print("|cFF0dea38EZ|r Quest |cFF0dea38enabled|r");

		EZQuestConfigFrameAutoTurnInQuests:Enable();
		EZQuestConfigFrameAutoAcceptQuests:Enable();
		EZQuestConfigFrameAutoTrackQuests:Enable();
	else
		print("|cFF0dea38EZ|r Quest |cFF696969disabled|r");

		EZQuestConfigFrameAutoTurnInQuests:Disable();
		EZQuestConfigFrameAutoAcceptQuests:Disable();
		EZQuestConfigFrameAutoTrackQuests:Disable();
	end
	
	if (EZQuest_SavedVars.IsEnabled ~= EZQuestConfigFrameIsEnabled:GetChecked()) then
		EZQuestConfigFrameIsEnabled:SetChecked(EZQuest_SavedVars.IsEnabled);
	end
end

function ToggleIsEnabledButton_OnShow(checkButton)
	getglobal(checkButton:GetName() .. 'Text'):SetText("Enabled Addon?");
end

function ToggleIsEnabledButton_OnClick(checkButton)
	EZQuest_SavedVars.IsEnabled = checkButton:GetChecked();

	EZQuestConfigMixin:OnEnabledChanged();
end

function ToggleAutoTurnInQuestsButton_OnShow(checkButton)
	getglobal(checkButton:GetName() .. 'Text'):SetText("Auto turn in quests?");
end

function ToggleAutoTurnInQuestsButton_OnClick(checkButton)
	EZQuest_SavedVars.AutoTurnInQuests = checkButton:GetChecked();
end

function ToggleAutoAcceptQuestsButton_OnShow(checkButton)
	getglobal(checkButton:GetName() .. 'Text'):SetText("Auto accept quests?");
end

function ToggleAutoAcceptQuestsButton_OnClick(checkButton)
	EZQuest_SavedVars.AutoAcceptQuests = checkButton:GetChecked();
end

function ToggleAutoTrackQuestsButton_OnShow(checkButton)
	getglobal(checkButton:GetName() .. 'Text'):SetText("Auto track quests?");
end

function ToggleAutoTrackQuestsButton_OnClick(checkButton)
	EZQuest_SavedVars.AutoTrackQuests = checkButton:GetChecked();
end

SLASH_EZQUEST1 = "/ezquest";
SLASH_EZQUEST2 = "/ezq";
SlashCmdList["EZQUEST"] = function(option)
	local comparableOption = string.lower(option);
	
	if (comparableOption == "") then
		InterfaceOptionsFrame_OpenToCategory("EZ Quest");
		InterfaceOptionsFrame_OpenToCategory("EZ Quest");
	else
		local enabledChanged = false;
		if (comparableOption == "toggle") then
			EZQuest_SavedVars.IsEnabled = not EZQuest_SavedVars.IsEnabled;
			enabledChanged = true;
		elseif (comparableOption == "on") then
			enabledChanged = EZQuest_SavedVars.IsEnabled ~= true;
			EZQuest_SavedVars.IsEnabled = true;
		elseif (comparableOption == "off") then
			enabledChanged = EZQuest_SavedVars.IsEnabled ~= false;
			EZQuest_SavedVars.IsEnabled = false;
		end
	
		if (enabledChanged) then
			EZQuestConfigMixin:OnEnabledChanged();
		end
	end
end