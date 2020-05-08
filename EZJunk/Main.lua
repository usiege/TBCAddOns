local _, core = ...; -- Namespace
local events = CreateFrame("Frame");

function core:Init(event, name)	
	if (event == "ADDON_LOADED") then
		if (name == "EZJunk") then
			events:UnregisterEvent("ADDON_LOADED");

			events:RegisterEvent("MERCHANT_SHOW");
		end
	elseif (event == "MERCHANT_SHOW") then
		core.OnMerchantShow();
	end
end

function core:OnMerchantShow()
	if ( MerchantFrame:IsVisible() and MerchantFrame.selectedTab == 1 ) then
		local link;
		local itemInfo;
		local containerItemInfo;
		local profitInCopper = 0;
		local itemsSold = 0;

		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				link = GetContainerItemLink(bag, slot);

				if (link) then
					itemInfo = core:GetItemInfo(link);
					containerItemInfo = core:GetContainerItemInfo(bag, slot);
					--print(containerItemInfo.Quality);

					if core:IsJunk(itemInfo) then
						-- DEBUG
						--print(itemInfo.Name);
						--print(itemInfo.Link);
						--print(itemInfo.Rarity);
						--print(itemInfo.Level);
						--print(itemInfo.MinLevel);
						--print(itemInfo.Type);
						--print(itemInfo.SubType);
						--print(itemInfo.StackCount);
						--print(itemInfo.EquipLocation);
						--print(itemInfo.Icon);
						--print(itemInfo.SellPrice);
						--print(itemInfo.ClassId);
						--print(itemInfo.SubClassId);
						--print(itemInfo.BindType);
						--print(itemInfo.ExpacId);
						--print(itemInfo.ItemSetId);
						--print(itemInfo.IsCraftingReagent);

						--sell item
						UseContainerItem(bag, slot);

						itemsSold = itemsSold + 1;
						profitInCopper = profitInCopper + (itemInfo.SellPrice * containerItemInfo.ItemCount);
					end
				end
			end
		end

		if (profitInCopper > 0 and itemsSold > 0) then
			local junkItemText = itemsSold > 1 and "items" or "item";

			print(GetCoinTextureString(profitInCopper) .. " 已从销售中获得 " .. itemsSold .. " 垃圾: " .. junkItemText);
		end
	end
end

function core:IsJunk(itemInfo)	
	if itemInfo.Rarity == 0 then
		return true
	end
	
	return false
end

function core:GetItemInfo(link)
	local name, link, rarity, level, minLevel, type, subType, stackCount, equipLoc, icon, sellPrice, classId, subClassId, bindType = GetItemInfo(link);

	return {
		Name = name,
		Link = link,
		Rarity = rarity,
		Level = level,
		MinLevel = minLevel,
		Type = type,
		SubType = subType,
		StackCount = stackCount,
		EquipLocation = equipLoc,
		Icon = icon,
		SellPrice = sellPrice,
		ClassId = classId,
		SubClassId = subClassId,
		BindType = bindType,
		ExpacId = expacId,
		ItemSetId = itemSetId,
		IsCraftingReagent = IsCraftingReagent,
	};
end

function core:GetContainerItemInfo(bag, slot)
	local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemId = GetContainerItemInfo(bag, slot);

	return {
		Icon = icon,
		ItemCount = itemCount,
		Locked = locked,
		Quality = quality,
		Readable = readable,
		Lootable = lootable,
		ItemLink = itemLink,
		IsFiltered = isFiltered,
		NoValue = noValue,
		ItemId = itemId,
	};
end

function core:InternalAttachItemValueTooltip(tooltip, checkStack)
	local link = select(2, tooltip:GetItem());

	if (link) then
		local itemInfo = core:GetItemInfo(link);

		if (itemInfo.SellPrice and itemInfo.SellPrice > 0) then
			local stackCount = 1;

			if (checkStack) then
				local frame = GetMouseFocus();
				local objectType = frame:GetObjectType();

				if (objectType == "Button") then
					stackCount = frame.count or 1;
				end
			end

			local totalValue = itemInfo.SellPrice * stackCount;
			local displayValue = GetCoinTextureString(totalValue);
			
			SetTooltipMoney(tooltip, totalValue, nil, format("%s:", SELL_PRICE));
		end
	end
end

local function AttachItemValueTooltip(tooltip, ...)
	if (not MerchantFrame:IsShown()) then
		core:InternalAttachItemValueTooltip(tooltip, true);
	end
end

local function AttachLinkedItemValueTooltip(tooltip, ...)
	core:InternalAttachItemValueTooltip(tooltip, false);
end

events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.Init);

GameTooltip:HookScript("OnTooltipSetItem", AttachItemValueTooltip);
ItemRefTooltip:HookScript("OnTooltipSetItem", AttachLinkedItemValueTooltip);