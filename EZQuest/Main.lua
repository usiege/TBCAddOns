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

			self:RegisterEvent("QUEST_ACCEPTED");
			self:RegisterEvent("QUEST_ACCEPT_CONFIRM");
			self:RegisterEvent("QUEST_COMPLETE");
			--self:RegisterEvent("QUEST_POI_UPDATE");
			--self:RegisterEvent("QUEST_QUERY_COMPLETE");
			self:RegisterEvent("QUEST_DETAIL");
			--self:RegisterEvent("QUEST_FINISHED");
			self:RegisterEvent("QUEST_GREETING");
			--self:RegisterEvent("QUEST_ITEM_UPDATE");
			self:RegisterEvent("QUEST_LOG_UPDATE");
			self:RegisterEvent("QUEST_PROGRESS");
			--self:RegisterEvent("QUEST_WATCH_UPDATE");
			self:RegisterEvent("GOSSIP_SHOW");
		end
	end

	if (EZQuest_SavedVars.IsEnabled) then
		if (event == "QUEST_ACCEPTED") then
			local questIndex, questId = ...;
			
			self:OnQuestAccepted(questIndex, questId);
		elseif (event == "QUEST_ACCEPT_CONFIRM") then
			-- Escort quest started by another player
			self:OnQuestAcceptConfirm();
		elseif (event == "QUEST_COMPLETE") then
			-- Quest dialog shown with rewards and with the complete button available
			self.OnQuestComplete();
		elseif (event == "QUEST_DETAIL") then
			-- New quest selected
			self.OnQuestDetail();
		elseif (event == "QUEST_LOG_UPDATE") then
			self:OnQuestLogUpdate();
		elseif (event == "QUEST_PROGRESS") then
			-- Quest dialog shown with the complete button available
			self:OnQuestProgress();
		elseif (event == "GOSSIP_SHOW" or event == "QUEST_GREETING") then
			-- NPC dialog shown with multiple quest options
			self.OnQuestList();
		end
	end
end

function EZQuestMixin:OnQuestAccepted(questIndex, questId)
	if (EZQuest_SavedVars.AutoTrackQuests) then
		-- if no objectives skip
		if ( GetNumQuestLeaderBoards(questIndex) == 0 ) then
			return;
		end

		-- if trying to show too many quests skip
		if ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
			return;
		end
		
		-- Add the quest to the watch list, then update the watch list
		AddQuestWatch(questIndex);
		QuestWatch_Update();
		-- Set the selected quest in the quest log, so the user will see it when they open the log
		QuestLog_SetSelection(questIndex);
		QuestLog_Update();
	end
end

function EZQuestMixin:OnQuestAcceptConfirm()
	if (EZQuest_SavedVars.AutoAcceptQuests) then
		ConfirmAcceptQuest();
		AddQuestWatch()
	end
end

function EZQuestMixin:OnQuestComplete()
	if (EZQuest_SavedVars.AutoTurnInQuests) then
		if GetNumQuestChoices() <= 1 then
			GetQuestReward(1);
		end
	end
end

function EZQuestMixin:OnQuestDetail()
	if (EZQuest_SavedVars.AutoAcceptQuests) then
		AcceptQuest();
	end
end

function EZQuestMixin:OnQuestProgress()
	if (EZQuest_SavedVars.AutoTurnInQuests) then
		if (IsQuestCompletable()) then
			CompleteQuest();
		end
	end
end

function EZQuestMixin:OnQuestList()
	local activeQuestCount = GetNumActiveQuests();
	local gossipActiveQuestCount = GetNumGossipActiveQuests();
	local gossipActiveQuests = { GetGossipActiveQuests() };
	
	local availableQuestCount = GetNumAvailableQuests();
	local gossipAvailableQuestCount = GetNumGossipAvailableQuests();
	local gossipAvailableQuests = { GetGossipAvailableQuests() };
	
	if (EZQuest_SavedVars.AutoTurnInQuests) then
		for i=1, activeQuestCount do
			local title, isComplete = GetActiveTitle(i);

			if (isComplete) then
				SelectActiveQuest(i);
			end
		end
	
		for i=1, gossipActiveQuestCount do
			-- title, level, isLowLevel, isComplete, isLegendary, isIgnored
			local propertyOffset = 6 * (i - 1);
			local isComplete = gossipActiveQuests[4 + propertyOffset];
		
			if (isComplete) then
				SelectGossipActiveQuest(i);
			end
		end
	end
	
	if (EZQuest_SavedVars.AutoAcceptQuests) then
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
end

function EZQuestMixin:OnQuestLogUpdate()
	if (EZQuest_SavedVars.AutoTrackQuests) then
		for questWatchIndex=1, GetNumQuestWatches() do
			
			local questIndex = GetQuestIndexForWatch(questWatchIndex);
			if (questIndex) then
				local numQuestLogLeaderBoards  = GetNumQuestLeaderBoards(questIndex);
				
				if (numQuestLogLeaderBoards > 0) then
					local objectivesCompleted = 0;
					
					for questLogLeaderBoardIndex=1, numQuestLogLeaderBoards  do
						local text, type, finished = GetQuestLogLeaderBoard(questLogLeaderBoardIndex, questIndex);

						if (finished) then
							objectivesCompleted = objectivesCompleted + 1;
						end
					end

					if (objectivesCompleted == numQuestLogLeaderBoards) then
						-- Remove the quest from the watch list, then update the watch list
						RemoveQuestWatch(questIndex);
						QuestWatch_Update();
						QuestLog_Update();
					end
				end
			end
		end
	end
end
