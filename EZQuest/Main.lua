local ADDON_NAME = ...;

EZQuestMixin = {};

function EZQuestMixin:OnLoad()
	self:RegisterEvent("ADDON_LOADED");
end

function EZQuestMixin:OnEvent(event, ...)
	--print(event) -- DEBUG

	if (event == "ADDON_LOADED") then
		if (ADDON_NAME == ...) then
			self:UnregisterEvent("ADDON_LOADED");

			--self.RegisterEvent("QUEST_ACCEPTED");
			self:RegisterEvent("QUEST_ACCEPT_CONFIRM");
			self:RegisterEvent("QUEST_COMPLETE");
			--self:RegisterEvent("QUEST_POI_UPDATE");
			--self:RegisterEvent("QUEST_QUERY_COMPLETE");
			self:RegisterEvent("QUEST_DETAIL");
			--self:RegisterEvent("QUEST_FINISHED");
			self:RegisterEvent("QUEST_GREETING");
			--self:RegisterEvent("QUEST_ITEM_UPDATE");
			--self:RegisterEvent("QUEST_LOG_UPDATE");
			self:RegisterEvent("QUEST_PROGRESS");
			--self:RegisterEvent("QUEST_WATCH_UPDATE");
			self:RegisterEvent("GOSSIP_SHOW");
		end
	elseif (event == "QUEST_ACCEPT_CONFIRM") then
		-- Escort quest started by another player
		self:OnQuestAcceptConfirm();
	elseif (event == "QUEST_COMPLETE") then
		-- Quest dialog shown with rewards and with the complete button available
		self.OnQuestComplete();
	elseif (event == "QUEST_DETAIL") then
		-- New quest selected
		self.OnQuestDetail();
	elseif (event == "QUEST_PROGRESS") then
		-- Quest dialog shown with the complete button available
		self:OnQuestProgress();
	elseif (event == "GOSSIP_SHOW" or event == "QUEST_GREETING") then
		-- NPC dialog shown with multiple quest options
		self.OnQuestList();
	end
end

function EZQuestMixin:OnQuestAcceptConfirm()
	ConfirmAcceptQuest();
end

function EZQuestMixin:OnQuestComplete()
	if GetNumQuestChoices() <= 1 then
		GetQuestReward(1);
	end
end

function EZQuestMixin:OnQuestDetail()
	AcceptQuest();
end

function EZQuestMixin:OnQuestProgress()
	if (IsQuestCompletable()) then
		CompleteQuest();
	end
end

function EZQuestMixin:OnQuestList()
	local activeQuestCount = GetNumActiveQuests();
	local gossipActiveQuestCount = GetNumGossipActiveQuests();
	local gossipActiveQuests = { GetGossipActiveQuests() };
	
	local availableQuestCount = GetNumAvailableQuests();
	local gossipAvailableQuestCount = GetNumGossipAvailableQuests();
	local gossipAvailableQuests = { GetGossipAvailableQuests() };

	-- TODO: Find a way to determine if active quest is complete
--	for i=1, activeQuestCount do
--		SelectActiveQuest(i);
--	end
	
	for i=1, gossipActiveQuestCount do
		-- title, level, isLowLevel, isComplete, isLegendary, isIgnored
		local propertyOffset = 6 * (i - 1);
        local isComplete = gossipActiveQuests[4 + propertyOffset];
		
		if (isComplete) then
			SelectGossipActiveQuest(i);
		end
	end

	for i=1, availableQuestCount do
		local isTrivial = IsAvailableQuestTrivial(i);

		if (not isTrivial) then
			SelectAvailableQuest(i);
		end
	end

	for i=1, gossipAvailableQuestCount do
		-- title, level, isTrivial, frequency, isRepeatable, isLegendary, isIgnored
		local propertyOffset = 7 * (i - 1);
		local isTrivial = gossipAvailableQuests[3 + propertyOffset];

		if (not isTrivial) then
			SelectGossipAvailableQuest(i);
		end
	end
end