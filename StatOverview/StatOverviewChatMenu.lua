
--[[

A Tab Menu for the chat window specifies which chat
channel the send to chat text should be displayed in,
as well as what info should be displayed.

]]--

_G.StatOverviewChatMenu = class(Turbine.UI.ContextMenu);

function StatOverviewChatMenu:Constructor()
	Turbine.UI.ContextMenu.Constructor(self);
	
	self.selectedChannel = 1; -- 1 = say, 2 = fellow, 3 = raid, 4 = kin
	
	self.items = self:GetItems();
	
	self.say = Turbine.UI.MenuItem(L.Say[2],true,true);
		self.say.Click = function(sender,args)
		self:UpdateChannel(self.say,1,panel);
	end
	
	self.fellowship = Turbine.UI.MenuItem(L.Fellowship[2],true,false);
	self.fellowship.Click = function(sender,args)
		self:UpdateChannel(self.fellowship,2,panel);
	end
	
	self.raid = Turbine.UI.MenuItem(L.Raid[2],true,false);
	self.raid.Click = function(sender,args)
		self:UpdateChannel(self.raid,3,panel);
	end
	
	self.kinship = Turbine.UI.MenuItem((player.isCreep and L.Tribe or L.Kinship)[2],true,false);
	self.kinship.Click = function(sender,args)
		self:UpdateChannel(self.kinship,4,panel);
	end
	
	self.items:Add(self.say);
	self.items:Add(self.fellowship);
	self.items:Add(self.raid);
	self.items:Add(self.kinship);
	
	self.gap = Turbine.UI.MenuItem(L.Gap,false);
	self.allPlayers = Turbine.UI.MenuItem(L.AllPlayers,true,false);
end

function StatOverviewChatMenu:PopulateMenu(panel)
	-- clear old menu
	while (self.items:GetCount() > 4) do
		self.items:RemoveAt(5);
	end
	
	-- get relevant data and sort
	local dataSummary = (panel.tab:GetData());
	local sortedData = Misc.SortData(dataSummary,panel.tab.isBuffTab);
	
	if (#sortedData > 0) then
		self.items:Add(self.gap);
		
		if (#sortedData > 1) then
			if (panel.tab.isBuffTab) then
				self.allPlayers:SetText(L.AllSkills);
			else
				self.allPlayers:SetText(L.AllPlayers);
			end
			self.allPlayers:SetChecked(panel.selectedInfo == nil);
			self.allPlayers.Click = function(sender,args)
				self:UpdateInfo(nil,panel);
			end
			self.items:Add(self.allPlayers);
		end
		
		-- build new menu
		for _,info in ipairs(sortedData) do
			if (#sortedData == 1) then
				panel.selectedInfo = info[1];
			end
		
			local infoItem = Turbine.UI.MenuItem(string.sub(info[1],0,18),true,false);
			infoItem:SetChecked(panel.selectedInfo == info[1]);
			infoItem.Click = function(sender,args)
				self:UpdateInfo(info[1],panel);
			end
			self.items:Add(infoItem);
		end
	end
end

function StatOverviewChatMenu:UpdateChannel(menuItem,channelIndex)
	-- uncheck all (other) items
	self.say:SetChecked(false);
	self.fellowship:SetChecked(false);
	self.raid:SetChecked(false);
	self.kinship:SetChecked(false);
	-- check new item
	menuItem:SetChecked(true);
	-- update selected index
	self.selectedChannel = channelIndex;
	-- update all chat buttons
	for _,tab in pairs(statOverviewTabs) do
		if (not combatData.inCombat) then
			tab:UpdateChatSendButton();
		end
	end
	-- save settings
	self:SaveState();
end

function StatOverviewChatMenu:UpdateInfo(info,panel)
	-- update selected info
	panel.selectedInfo = info;
	-- update all chat buttons
	for _,tab in pairs(statOverviewTabs) do
		if (not combatData.inCombat) then
			tab:UpdateChatSendButton();
		end
	end
end

function StatOverviewChatMenu:SaveState()
	settings.chatChannel = EncodeNumbers(self.selectedChannel);
	SaveSettings();
end

function StatOverviewChatMenu:RestoreState(savedState)
	self.selectedChannel = savedState;
	
	self.say:SetChecked(self.selectedChannel == 1);
	self.fellowship:SetChecked(self.selectedChannel == 2);
	self.raid:SetChecked(self.selectedChannel == 3);
	self.kinship:SetChecked(self.selectedChannel == 4);
end