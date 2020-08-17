local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local HBD = LibStub("HereBeDragons-2.0")
local HBDP = LibStub("HereBeDragons-Pins-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("BigBrainTanking")
local AceGUI = LibStub("AceGUI-3.0")
local addonName = ...
local _

local playerGUID = UnitGUID("player")
local playerClass, englishClass = UnitClass("player")

BBT = LibStub("AceAddon-3.0"):NewAddon("BigBrainTanking", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")
BBT.Version = GetAddOnMetadata(addonName, 'Version')
BBT.Author = GetAddOnMetadata(addonName, "Author") 
BBT.Translators = GetAddOnMetadata(addonName, "X-Translators")
BBT.Testers = GetAddOnMetadata(addonName, "X-Testers")
BBT.DebugPrintEnabled = false

BBT.AnnouncementChannels = {
	"say", "yell", "party", "raid", "raid_warning" 
}

function GetAnnounceChannels(info)
	return table.concat(BBT.db.profile.Warnings.AnnouncementCustomChannels, ", ")
end

function IsValuePresentInTable(tableIn, valueCompare) 
	for index, value in ipairs(tableIn) do
		if valueCompare == value then
			return true
		end
	end
	
	return false
end

function SetAnnounceChannels(info, value)
	local NewCustomAnnouncementChannels = {}
	
	-- get all the channels listed in input box
	for channel in string.gmatch(value, '([^,%s]+)') do
		table.insert(NewCustomAnnouncementChannels, channel)		
	end
	
	-- clear deleted channels
	for index, channel in ipairs(BBT.db.profile.Warnings.AnnouncementCustomChannels) do
		if not IsValuePresentInTable(NewCustomAnnouncementChannels) then
			BBT:ClearAllAnnouncementsForChannel(channel)
		end
	end
	
	BBT.db.profile.Warnings.AnnouncementCustomChannels = NewCustomAnnouncementChannels
end

BBT.Options = {
	name = L["BigBrainTanking"],
	type = "group",
	args = {
		General = {
			name = L["GeneralSettings"],
			desc = L["GeneralSettings"],
			type = "group",
			order = 1,
			args = {
				Description = {
					name = L["BBTDescription"],
					type = "description",
					order = 1,
				},
				Enabled = {
					name = L["EnableBBT"],
					desc = L["EnableBBTDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return BBT:IsEnabled()
					end,
					set = function(info, value)
						BBT:Enable(value)
					end,
				},
				SalvRemovalEnabled = {
					name = L["EnableBBTSalvRemoval"],
					desc = L["EnableBBTSalvRemovalDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return BBT:IsSalvRemovalEnabled()
					end,
					set = function(info, value)
						BBT:EnableSalvRemoval(value)
					end,
				},
				DescriptionFooter = {
					name = L["BBTDescriptionFooter"],
					type = "description",
					order = 4,
				},
				About = {
					name = "About",
					type = "group", inline = true,
					args = {
						VersionDesc = {
							order = 1,
							type = "description",
							name = "|cffffd700"..L["ABOUT_VERSION"]..": "
								.._G["GREEN_FONT_COLOR_CODE"]..BBT.Version,
							cmdHidden = true
						},
						AuthorDesc = {
							order = 2,
							type = "description",
							name = "|cffffd700"..L["ABOUT_AUTHOR"]..": "
								.."|cffff8c00"..BBT.Author,
							cmdHidden = true
						},
						TranslatorsDesc = {
							order = 3,
							type = "description",
							name = "|cffffd700"..L["ABOUT_TRANSLATORS"]..": "
								.."|cffffffff"..BBT.Translators,
							cmdHidden = true
						},
						TestersDesc = {
							order = 4,
							type = "description",
							name = "|cffffd700"..L["ABOUT_TESTERS"]..": "
								.."|cffffffff"..BBT.Testers,
							cmdHidden = true
						},
						InspireByDesc = {
							order = 5,
							type = "description",
							name = "|cffffd700"..L["INSPIRED_BY"]..": "
								.."|cffffffffTankWarningsClassic, NoSalv (benjen), TankBuddy, SimpleInterruptAnnounce",
							cmdHidden = true
						},
					}
				}
			},
		},
		WarningSettings = {
			name = L["WarningSettings"],
			desc = L["WarningSettings"],
			type = "group",
			order = 2,
			args = {
				Description = {
					name = L["WarningSettingsDescription"],
					type = "description",
					order = 1,
				},
				WarningsEnabled = {
					name = L["EnableBBTWarnings"],
					desc = L["EnableBBTWarningsDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return BBT:IsWarningsEnabled()
					end,
					set = function(info, value)
						BBT:EnableWarnings(value)
					end,
				},
				WarningsCustomChannels = {
					name = L["WS_CUSTOM_CHANNELS"],
					desc = L["WS_CUSTOM_CHANNELS_DESC"],
					type = "input",
					order = 3,
					width = "full",
					get = GetAnnounceChannels,
					set = SetAnnounceChannels
				},
				WarriorSettingsHeader = {
					name = L["AnnouncementSetup"],
					type = "header",
					order = 4,
					width = "full"
				},
				-- order = 5 filled with Class speicifc settings (Warrior/Druid)
				-- order = 6 filled with Item specific settings (Lifegiving Gem, etc)
			}
		},
		DebugSettings = {
			name = L["DebugSettings"],
			desc = L["DebugSettings"],
			type = "group",
			order = 3,
			args = {
				Description = {
					name = L["DebugDescription"],
					type = "description",
					order = 1,
				},
				Enabled = {
					name = L["EnableDebugPrint"],
					desc = L["EnableDebugPrint"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return BBT.DebugPrintEnabled
					end,
					set = function(info, value)
						BBT.DebugPrintEnabled = value
					end,
				},
				
				
			},
		},
	},
}

BBT.OptionsSlash = {
	name = L["SlashCommand"],
	order = -3,
	type = "group",
	args = {
		on = {
			name = L["On"],
			desc = L["OnDescription"],
			type = 'execute',
			order = 1,
			func = function()
				BBT:Enable(true)
			end,
		},
		off = {
			name = L["Off"],
			desc = L["OffDescription"],
			type = 'execute',
			order = 2,
			func = function()
				BBT:Enable(false)
			end,
		},
		salv = {
			name = L["SalvationCommand"],
			order = 3,
			type = "group",
			args = {
				on = {
					name = L["On"],
					desc = L["SalvRemovalOnDescription"],
					type = 'execute',
					order = 1,
					func = function()
						BBT:EnableSalvRemoval(true)
					end,
				},
				off = {
					name = L["Off"],
					desc = L["SalvRemovalOffDescription"],
					type = 'execute',
					order = 2,
					func = function()
						BBT:EnableSalvRemoval(false)
					end,
				},
			}
			
		},
		
	}
}

local Default_Profile = {
	profile = {
		IsEnabled = true,
		IsSalvRemovalEnabled = true,
		Warnings = {
			IsEnabled = true,
			AnnouncementCustomChannels = {
				-- filled by UI
			},
			Abilities = {
				Warrior = {
					[L["ABILITY_LASTSTAND"]] = { 
						Icon = "Interface\\Icons\\Spell_Holy_AshesToAshes", 
						Announce = { 
							Activated = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_LS_ACTIVATION"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },
							}, 
							Expiration = { 
								Enabled = true, 
								Text = L["ABILITY_EXPIRATION"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },
							},	
						},
					},
					[L["ABILITY_SHIELDWALL"]] = { 
						Icon = "Interface\\Icons\\Ability_Warrior_ShieldWall", 
						Announce = { 
							Activated = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_SW_ACTIVATION"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },
							},
							Expiration = { 
								Enabled = true, 
								Text = L["ABILITY_EXPIRATION"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },
							},	
						},
					},
					[L["ABILITY_CHALLENGINGSHOUT"]] = { 
						Icon = "Interface\\Icons\\Ability_BullRush", 
						Announce = { 
							Activated = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_CS_ACTIVATION"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },
							},		
						},					
					},
					[L["ABILITY_TAUNT"]] = { 
						Icon = "Interface\\Icons\\Spell_Nature_Reincarnation", 
						Announce = { 
							Hit = { 
								Enabled = false, 
								Text = L["ANNOUNCEMENT_TAUNT_HIT"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },					
							},
							Resisted = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_TAUNT_RESIST"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },					
							},
						},
					},
					[L["ABILITY_MOCKINGBLOW"]] = { 
						Icon = "Interface\\Icons\\Ability_Warrior_PunishingBlow", 
						Announce = { 
							Hit = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_MB_HIT"], 
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } } 
							},
							Failed = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_MB_FAIL"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } }
							},
						},
					},
					[L["ABILITY_SHIELDBASH"]] = { 
						Icon = "Interface\\Icons\\ability_warrior_shieldbash", 
						Announce = { 
							Hit = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_SB_HIT"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "say", "raid" } },	
							}, 
							Failed = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_SB_MISS"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "say", "raid" } },	
							}, 
						},
					},
					[L["ABILITY_PUMMEL"]] = { 
						Icon = "Interface\\Icons\\inv_gauntlets_04",
						Announce = { 
							Hit = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_PM_HIT"], 
								Channels = { Alone = { }, Party = { "party" }, Raid = { "say", "raid" } },	 
							}, 
							Failed = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_PM_MISS"], 
								Channels = { Alone = { }, Party = { "party" }, Raid = { "say", "raid" } },	
							},					
						},
					},
				},
				Druid = {
					[L["ABILITY_CHALLENGINGROAR"]] = { 
						Icon = "Interface\\Icons\\Ability_Druid_ChallangingRoar", 
						Announce = { 
							Activated = {
								Enabled = true, 
								Text = L["ANNOUNCEMENT_CR_ACTIVATION"], 
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },	
							},
						},
					},
					[L["ABILITY_GROWL"]] = { 
						Icon = "Interface\\Icons\\Ability_Physical_Taunt", 
						Announce = {
							Hit = { 
								Enabled = true, 
								Text = L["ANNOUNCEMENT_TAUNT_HIT"],
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },					
							},
							Activated = {
								Enabled = true, 
								Text = L["ANNOUNCEMENT_GROWL_RESIST"], 
								Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },	
							},
						},
					},
				}			
			},
			Items = {
				[L["ITEM_LIFEGIVINGGEM"]] = { 
					Icon = "Interface\\Icons\\INV_Misc_Gem_Pearl_05", 
					Announce = { 
						Activated = {
							Enabled = true, 
							Text = L["ANNOUNCEMENT_LG_ACTIVATION"], 
							Channels = { Alone = { }, Party = { "party" }, Raid = { "raid" } },	
						},
					},
				},
			}
		},
	},
}

-- Strings used to insert a raid icon in chat message
BBT.RaidIconChatStrings = {
	'{rt1}', '{rt2}', '{rt3}', '{rt4}',
	'{rt5}', '{rt6}', '{rt7}', '{rt8}',
}

-- Table for looking up raid icon id from destFlags
BBT.RaidIconLookup = {
	[COMBATLOG_OBJECT_RAIDTARGET1]=1,
	[COMBATLOG_OBJECT_RAIDTARGET2]=2,
	[COMBATLOG_OBJECT_RAIDTARGET3]=3,
	[COMBATLOG_OBJECT_RAIDTARGET4]=4,
	[COMBATLOG_OBJECT_RAIDTARGET5]=5,
	[COMBATLOG_OBJECT_RAIDTARGET6]=6,
	[COMBATLOG_OBJECT_RAIDTARGET7]=7,
	[COMBATLOG_OBJECT_RAIDTARGET8]=8,
}

-- Get string for raid icon
function BBT:GetRaidIconString(raidIcon)
	local s = ''

	if raidIcon then
		s = BBT.RaidIconChatStrings[raidIcon]
	end

	return s
end

function BBT:ResetProfile()
	BBT.db.profile = Default_Profile.profile
end

function BBT:HandleProfileChanges()
end

function BBT:OnInitialize()
	self:Print("Initializing v" .. BBT.Version .. "...")
	
	local acedb = LibStub:GetLibrary("AceDB-3.0")
	self.db = acedb:New("BigBrainTankingDB", Default_Profile)
	self.db.RegisterCallback(self, "OnNewProfile", "ResetProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetProfile")
	self.db.RegisterCallback(self, "OnProfileChanged", "HandleProfileChanges")
	self.db.RegisterCallback(self, "OnProfileCopied", "HandleProfileChanges")
	self:SetupOptions()
	
	self:Print("Initializing finished!")
end

function BBT:GetClassAbilitiesDefaultTable() 
	if englishClass == "WARRIOR" then
		return Default_Profile.profile.Warnings.Abilities.Warrior
	elseif englishClass == "DRUID" then
		return Default_Profile.profile.Warnings.Abilities.Druid
	end
end

function BBT:GetClassAbilitiesTable() 
	if englishClass == "WARRIOR" then
		return BBT.db.profile.Warnings.Abilities.Warrior
	elseif englishClass == "DRUID" then
		return BBT.db.profile.Warnings.Abilities.Druid
	end
end

function BBT:RegisterModuleOptions(name, optionTbl, displayName)
	BBT.Options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.OptionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BigBrainTanking", displayName, L["BBT Option"], name)
end

function BBT:FindActiveChannelIndex(ability, announceVerb, presence, channel) 
	local ActiveChannels = BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Channels[presence]

	for index, value in ipairs(ActiveChannels) do
		if value == channel then
			return index
		end
	end
end

function BBT:IsAnnouncementActive(ability, announceVerb, presence, channel)
	local ActiveChannels = BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Channels[presence]
	
	for index, value in ipairs(ActiveChannels) do
		if value == channel then
			return true
		end
	end
	
	return false
end

function BBT:SetAnnouncementActive(ability, announceVerb, presence, channel, state)
	local ActiveChannels = BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Channels[presence]
	
	local index = self:FindActiveChannelIndex(ability, announceVerb, presence, channel)
	--self:Print("Index: " .. index)
	--self:Print("State: " .. tostring(state))
	
	if index == nil and state == true then
		--self:Print("Checked")
		table.insert(ActiveChannels, channel)
	end
	
	if index ~= nil and state == false then
		--self:Print("Unckecked")
		table.remove(ActiveChannels, index)
	end
end

function BBT:ClearAllAnnouncementsForChannel(channel)
	local AbilitiesTable = BBT:GetClassAbilitiesTable()
	
	for abilityName, abilityValue in pairs(AbilitiesTable) do
		for announceName, announceValue in pairs(abilityValue.Announce) do
			for presenceName, channels in pairs(announceValue.Channels) do
				local channelIndex = BBT:FindActiveChannelIndex(abilityName, announceName, presenceName, channel)
				
				if channelIndex ~= nil then
					self:PrintDebug("Removed channel from announcement: " .. channel)
					table.remove(channels, channelIndex)
				end
			end
		end
	end
end


function GetAnnounceText(info) 
	announceVerb = info[#info-2] -- Activated/Hit/Failed/etc
	ability = info[#info-3] -- Pummel/Life Giving Gem/etc

	return BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Text
end


function SetAnnounceText(info, value) 
	nnounceVerb = info[#info-2] -- Activated/Hit/Failed/etc
	ability = info[#info-3] -- Pummel/Life Giving Gem/etc

	BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Text = value
end

function ResetAnnounceText(info) 
	nnounceVerb = info[#info-2] -- Activated/Hit/Failed/etc
	ability = info[#info-3] -- Pummel/Life Giving Gem/etc

	BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Text = BBT:GetClassAbilitiesDefaultTable()[ability].Announce[announceVerb].Text
end

function GetAnnouncementSetting(keys, index) 
	presenceType = keys[#keys] -- Alone/Party/Raid
	announceVerb = keys[#keys-1] -- Activated/Hit/Failed/etc
	keyName = keys[#keys-2] -- Pummel/Life Giving Gem/etc
	
	--BBT:PrintDebug("presenceType: " .. keys[#keys] .. " | announceVerb" .. announceVerb .. " | keyName: " .. keyName .. " | index: " .. index)
	
	local ChannelCheckbox = GetAllAnnouncementChannels()[index]
	--BBT:PrintDebug("channelCheckbox: " .. ChannelCheckbox)

	return BBT:IsAnnouncementActive(keyName, announceVerb, presenceType, ChannelCheckbox)
end

function SetAnnouncementSetting(keys, index, state)
	presenceType = keys[#keys] -- Alone/Party/Raid
	announceVerb = keys[#keys-1] -- Activated/Hit/Failed/etc
	keyName = keys[#keys-2] -- Pummel/Life Giving Gem/etc
	
	local ChannelCheckbox = GetAllAnnouncementChannels()[index]
	--self:Print("channelCheckbox: " .. ChannelCheckbox)
	
	BBT:SetAnnouncementActive(keyName, announceVerb, presenceType, ChannelCheckbox, state)
end

function IsAnnounceEnabled(info)
	announceVerb = info[#info-1] -- Activated/Hit/Failed/etc
	ability = info[#info-2] -- Pummel/Life Giving Gem/etc
	return BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Enabled
end

function SetAnnounceEnabled(info, value)
	announceVerb = info[#info-1] -- Activated/Hit/Failed/etc
	ability = info[#info-2] -- Pummel/Life Giving Gem/etc
	BBT:GetClassAbilitiesTable()[ability].Announce[announceVerb].Enabled = value
end

function GetAllAnnouncementChannels()
	local AnnounceChannels = {}
	
	for index, value in ipairs(BBT.AnnouncementChannels) do
		table.insert(AnnounceChannels, value)
	end
	
	for index, value in ipairs(BBT.db.profile.Warnings.AnnouncementCustomChannels) do
		table.insert(AnnounceChannels, value)
	end

	return AnnounceChannels
end

function BBT:GenerateAnnounceSettings(itemTable) 
	local AnnounceSettingsTable = {}

	for key, value in pairs(itemTable) do
		local AnnounceSetting = {
			name = key,
			desc = key,
			type = "group",
			order = #AnnounceSettingsTable+1,
			width = "full",
			icon = value.Icon, 
			childGroups = "tab",
			args = {},
		}
		
		for key, value in pairs(value.Announce) do
			AnnounceSetting.args[key] = {
				name = key,
				desc = key,
				type = "group",
				width = "full",
				order = #AnnounceSetting.args+1,
				args = {
					IsEnabled = {
						name = "Enabled",
						type = "toggle",
						order = 1,
						tristate = false,
						get = IsAnnounceEnabled,
						set = SetAnnounceEnabled,						
					},
					TextGrp = {
						name = L["ANNOUNCEMENT_TEXT"],
						type = "group",
						width = "full",
						inline = true,
						order = 2,
						args = {
							Text = {
								name = L["ANNOUNCEMENT_TEXT_MESSAGE"],
								desc = L["ANNOUNCEMENT_TEXT_DESCRIPTION"],
								type = "input",
								order = 1,
								width = "full",
								get = GetAnnounceText,
								set = SetAnnounceText
							},
							ResetText = {
								name = "Reset",
								type = "execute",
								width = "full",
								order = 2,
								func = ResetAnnounceText,						
							},
						},
					},
					Alone = { 
						name = "Alone",
						type = "multiselect",
						order = 3,
						tristate = false,
						values = GetAllAnnouncementChannels,
						get = GetAnnouncementSetting,
						set = SetAnnouncementSetting,
					},
					Party = { 
						name = "Party",
						type = "multiselect",
						order = 4,
						tristate = false,
						values = GetAllAnnouncementChannels,
						get = GetAnnouncementSetting,
						set = SetAnnouncementSetting,
					},
					Raid = { 
						name = "Raid",
						type = "multiselect",
						order = 5,
						tristate = false,
						values = GetAllAnnouncementChannels,
						get = GetAnnouncementSetting,
						set = SetAnnouncementSetting,
					},
				},
			}
			
		end
		
		AnnounceSettingsTable[key] = AnnounceSetting
	end
	
	return AnnounceSettingsTable
end

function BBT:SetupOptions()
	-- Dynamic	
	local playerClass, englishClass = UnitClass("player")
	
	local AnnounceSettingsTable = {}
	
	if englishClass == "WARRIOR" then
		AnnounceSettingsTable = self:GenerateAnnounceSettings(Default_Profile.profile.Warnings.Abilities.Warrior)
	end
	
	if englishClass == "DRUID" then
		AnnounceSettingsTable = self:GenerateAnnounceSettings(Default_Profile.profile.Warnings.Abilities.Druid)
	end

	BBT.Options.args.WarningSettings.args["Abilities"] =  {
		name = "Abilities",
		desc = L["WS_ABILITIES"],
		--disabled = true,
		type = "group",
		order = 5,
		width = "full",
		args = AnnounceSettingsTable
	}
	
	
	local ItemAnnounceTable = self:GenerateAnnounceSettings(Default_Profile.profile.Warnings.Items)
	
	BBT.Options.args.WarningSettings.args["Items"] =  {
		name = "Items",
		desc = L["WS_ITEMS"],
		disabled = true,
		type = "group",
		order = 6,
		width = "full",
		args = ItemAnnounceTable
	}
	
	-- 
	self.OptionsFrames = {}	

	local ACD3 = LibStub("AceConfigDialog-3.0")
 	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BigBrainTanking", BBT.Options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("BigBrainTanking Commands", BBT.OptionsSlash, "bbt")
	
	self.OptionsFrames.BBT = ACD3:AddToBlizOptions("BigBrainTanking", L["BBT Option"], nil, "General")
	self.OptionsFrames.WarningSettings = ACD3:AddToBlizOptions("BigBrainTanking", L["WarningSettings"], L["BBT Option"], "WarningSettings")
	self.OptionsFrames.WarningSettings = ACD3:AddToBlizOptions("BigBrainTanking", L["DebugSettings"], L["BBT Option"], "DebugSettings")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), L["Profiles"])
end

function BBT:Enable(value)
	BBT.db.profile.IsEnabled = value
	
	if value then
		BBT:OnEnable()
		DEFAULT_CHAT_FRAME:AddMessage(L["BBTEnabled"])
	else
		BBT:OnDisable()
		DEFAULT_CHAT_FRAME:AddMessage(L["BBTDisabled"])
	end
end

function BBT:EnableSalvRemoval(value)
	BBT.db.profile.IsSalvRemovalEnabled = value
	
	if value then
		BBT:OnEnable()
		DEFAULT_CHAT_FRAME:AddMessage(L["SalvRemovalEnabled"])
	else
		BBT:OnDisable()
		DEFAULT_CHAT_FRAME:AddMessage(L["SalvRemovalDisabled"])
	end
end

function BBT:IsEnabled()
	return BBT.db.profile.IsEnabled
end

function BBT:IsSalvRemovalEnabled() 
	return BBT.db.profile.IsSalvRemovalEnabled
end

function BBT:CancelSalvBuff()
	local counter = 1
	while UnitBuff("player", counter) do
		local name = UnitBuff("player", counter)
		if string.find(name, L["SalvBuffName"]) then
			-- CancelUnitBuff not working in combat
			if InCombatLockdown() then
				DEFAULT_CHAT_FRAME:AddMessage(L["SalvLock"])
				return
			end
			
			CancelUnitBuff("player", counter)
			DEFAULT_CHAT_FRAME:AddMessage(L["SalvRemoved"])
			return
		end
		counter = counter + 1
	end
end

function BBT:OnUnitAuraEvent(eventName, unitTarget)
	--self:PrintDebug(string.format("OnUnitAuraEvent, untitTarget: %s", unitTarget))

	if self:IsSalvRemovalEnabled() and unitTarget == "player" then
		self:CancelSalvBuff()
	end
end

function BBT:IsWarningsEnabled()
	return BBT.db.profile.Warnings.IsEnabled
end

function BBT:EnableWarnings(value)
	BBT.db.profile.Warnings.IsEnabled = value
end

function BBT:GetAbilityAnnounce(ability, announceVerb) 
	local presence = IsInRaid() and "Raid" or (IsInGroup() and "Party" or "Alone")

	if ability == nil then
		ability = "{empty}"
	end

	if announceVerb == nil then
		announceVerb = "{empty}"
	end

	BBT:PrintDebug(string.format("BBT:GetAbilityAnnounce(ability: %s, announceVerb: %s)", ability, announceVerb))
	
	local AbilityAnnounce = BBT:GetClassAbilitiesTable()[ability]

	if AbilityAnnounce == nil then
		BBT:PrintDebug(string.format("Invalid ability %s", ability))
		return "", {}
	end

	local Announce = AbilityAnnounce.Announce[announceVerb]
	
	if Announce == nil then
		BBT:PrintDebug(string.format("Invalid announce verb %s", announceVerb))
		return "", {}
	end
	
	if not Announce.Enabled then
		return Announce.Text, {} -- No channels to announce to
	end
	
	return Announce.Text, Announce.Channels[presence]
end

function BBT:IsDefaultChannel(channelName) 
	for index, value in ipairs(BBT.AnnouncementChannels) do
		if value == channelName then
			return true
		end
	end
	
	return false
end

function BBT:SendWarningMessage(message, channels)
	if not self:IsWarningsEnabled() then
		return
	end
	
	if channels == nil or #channels == 0 then
		self:PrintDebug("no channels to warn")
		return
	end

	for index, channelName in ipairs(channels) do
		self:PrintDebug("channel to warn (" .. index .. "): " .. channelName)
		
		if BBT:IsDefaultChannel(channelName) then
			SendChatMessage(message, channelName, "COMMON")		
		else
			local channelID = GetChannelName(channelName);
			
			if channelID > 0 then
				SendChatMessage(message, "CHANNEL", nil, channelID)			
			end
		end
	end
end

BBT.BuffTimers = {}

function BBT:KillBuffExpirationTimer(buffName) 
	if BBT.BuffTimers[buffName] ~= nil then
		self:PrintDebug(string.format("Removed %s from expiration timers, since it was canceled", buffName))
		self:CancelTimer(BBT.BuffTimers[buffName])
		BBT.BuffTimers[buffName] = nil
	end
end

function BBT:KillBuffExpirationTimers() 
	for key, timerID in pairs(BBT.BuffTimers) do
		self:KillBuffExpirationTimer(key)
	end
end

function BBT:OnPlayerDead()
	self:PrintDebug("BBT:OnPlayerDead")

	self:KillBuffExpirationTimers()
end

function BBT:OnBuffExpiration(spellName, warnSecBeforeExpire)
	self:PrintDebug(string.format("BBT:OnBuffExpiration(%s, %f)", spellName, warnSecBeforeExpire))

	BBT.BuffTimers[spellName] = nil -- remove from timer handles

	if UnitIsDeadOrGhost("player") ~= true then
		local message, channels = BBT:GetAbilityAnnounce(spellName, "Expiration")
		message = string.gsub(message, "$sn", spellName)
		message = string.gsub(message, "$se", warnSecBeforeExpire)
	
		self:SendWarningMessage(message, channels)
	end
end

function BBT:PrintDebug(...)
	if self.DebugPrintEnabled ~= true then
		return
	end

	self:Print(...)
end

function BBT:GetBuffDuration(spellName)
	local counter = 1
	while UnitBuff("player", counter) do
		local buffName, icon, count, debuffType, buffDuration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitBuff("player", counter) 
		
		if buffName == spellName then
			return buffDuration
		end
		counter = counter + 1
	end
end

function BBT:OnCombatLogEventUnfiltered() 
	local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSchool = CombatLogGetCurrentEventInfo()
	
	-- Get id of raid icon on target, or nil if none
	local raidIcon = BBT.RaidIconLookup[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)]
	
	local destEntityName = ""
	if self:GetRaidIconString(raidIcon) ~= "" then
		destEntityName = string.format("%s %s", self:GetRaidIconString(raidIcon), destName)
	else
		destEntityName = destName
	end
	
	if sourceGUID == playerGUID then
		if subevent == 'SPELL_INTERRUPT' then 
			self:PrintDebug(string.format("Spell interrupt (dest: %s, spellname: %s, extraSpellName: %s)", destName, spellName, extraSpellName))
			
			local message, channels = BBT:GetAbilityAnnounce(spellName, "Hit")			
			message = string.gsub(message, "$tn", destEntityName)
			message = string.gsub(message, "$is", extraSpellName)
			message = string.gsub(message, "$sn", spellName)
			
			self:PrintDebug(string.format("MSG: %s", message))
			
			self:SendWarningMessage(message, channels)
		elseif subevent == "SPELL_AURA_REMOVED" then
			self:KillBuffExpirationTimer(spellName)
		elseif subevent == "SPELL_CAST_SUCCESS" then
			--Casts with critical expirations
			if spellName == L["ABILITY_LASTSTAND"] or spellName == L["ABILITY_SHIELDWALL"] then
				local spellDuration = BBT:GetBuffDuration(spellName)
				
				-- expiration timer
				local warnSecBeforeExpire = 3
				local timeToWarn = spellDuration - warnSecBeforeExpire
			
				self:PrintDebug(string.format("Scheduling buff expiration timer %f (spellDuration: %f)", timeToWarn, spellDuration))
				BBT.BuffTimers[spellName] = self:ScheduleTimer(self.OnBuffExpiration, timeToWarn, self,  spellName, warnSecBeforeExpire)
				
				-- message
				local message, channels = BBT:GetAbilityAnnounce(spellName, "Activated")
				message = string.gsub(message, "$sn", spellName)
				message = string.gsub(message, "$sd", spellDuration)
				
				if spellName == L["ABILITY_LASTSTAND"] then
					message = string.gsub(message, "$lshp", math.floor(UnitHealthMax("player")*0.3))
				end
				
				self:PrintDebug(string.format("MSG: %s", message))
			
				self:SendWarningMessage(message, channels)
			
			--Casts without critical expirations
			elseif spellName == L["ABILITY_CHALLENGINGSHOUT"] or spellName == L["ABILITY_CHALLENGINGROAR"] then
				local spellDuration = 6 -- Both Shout and Roar last 6 seconds
				
				local message, channels = BBT:GetAbilityAnnounce(spellName, "Activated")
				message = string.gsub(message, "$sn", spellName)
				message = string.gsub(message, "$sd", spellDuration)
				
				self:SendWarningMessage(message, channels)
			elseif spellName == L["ABILITY_TAUNT"] or spellName == L["ABILITY_GROWL"] then
				local message, channels = BBT:GetAbilityAnnounce(spellName, "Hit")
				message = string.gsub(message, "$tn", destEntityName)
				
				self:SendWarningMessage(message, channels)
			end
		--Failures
		elseif subevent == "SPELL_MISSED" then		
			--We COULD look for the 15th argument of ... here for the type, but we'll just declare any miss as "resisted"
			if spellName == L["ABILITY_TAUNT"] or spellName == L["ABILITY_GROWL"] then
				local message, channels = BBT:GetAbilityAnnounce(spellName, "Resisted")
				message = string.gsub(message, "$tn", destEntityName)
				message = string.gsub(message, "$sn", spellName)
				
				self:SendWarningMessage(message, channels)
			else -- Mocking Blow, Pummel, Shield Bash, etc
				local message, channels = BBT:GetAbilityAnnounce(spellName, "Failed")
				if message ~= nil then
					message = string.gsub(message, "$tn", destEntityName)
					message = string.gsub(message, "$sn", spellName)
					--[[
					if spellname == L["ABILITY_PUMMEL"] or spellName == L["ABILITY_SHIELDBASH"] then
						message = string.gsub(message, "$is", extraSpellName)
					end
					--]]
				
					self:SendWarningMessage(message, channels)
				end
			end
		end
	end
end

function BBT:OnPlayerLeaveCombat()
	if self:IsSalvRemovalEnabled() then
		self:CancelSalvBuff() -- Since we can't cancel while in battle, do it just right after
	end
end

function BBT:OnEnable()
	if self:IsSalvRemovalEnabled() then
		self:CancelSalvBuff() -- Cancel existing one if present
	end
	
	BBT:RegisterEvent("PLAYER_DEAD", "OnPlayerDead")
	BBT:RegisterEvent("UNIT_AURA", "OnUnitAuraEvent")
	BBT:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombatLogEventUnfiltered")
	BBT:RegisterEvent("PLAYER_LEAVE_COMBAT", "OnPlayerLeaveCombat")
end

function BBT:OnDisable()
	BBT:UnregisterEvent("PLAYER_DEAD")
	BBT:UnregisterEvent("UNIT_AURA")
	BBT:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	BBT:UnregisterEvent("PLAYER_LEAVE_COMBAT")
end

--- IS THIS WORKING/NEEDED?
function BBT:SetDataDb(val)
    db = val
end