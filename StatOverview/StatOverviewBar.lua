
--[[

A Stat Overview Bar is a Combat Analysis Bar that determines
its length and values via data from a Stats Overview Tab.

]]--


_G.StatOverviewBar = class(CombatAnalysisBar);

function StatOverviewBar:Constructor(panel,hasTwoParts,topBar)
	CombatAnalysisBar.Constructor(self,panel,topBar);
	
  self.hasTwoParts = hasTwoParts;
	self.proportion1 = 1;
	
	if (self.hasTwoParts) then
		-- background2 (ie: temporary morale)
		self.background2 = Turbine.UI.Control();
		self.background2:SetParent(self);
		self.background2:SetPosition(CombatAnalysisWindow.border,topBar and CombatAnalysisWindow.border or 0);
		self.background2:SetHeight(CombatAnalysisBarsPanel.barThickness);
		self.background2:SetMouseVisible(false);
		self.background2:SetZOrder(1);
		
		self.SetProportion = function(sender,proportion)
			self.proportion = proportion;
	
			local w = self:GetWidth();
			w = math.max((self.proportion == 0 and 0 or CombatAnalysisWindow.border),Misc.Round(w*self.proportion));
			self.border:SetWidth(w);
		end
		self.SetDivision = function(sender,proportion1)
			self.proportion1 = proportion1;
			
			local w = math.max(0,self.border:GetWidth()-2*CombatAnalysisWindow.border);
			-- tiny space
			if (w <= CombatAnalysisWindow.border+2) then
				if (self.proportion1 >= 0.5) then
					self.background:SetWidth(w);
					self.background2:SetWidth(0);
				else
					self.background:SetWidth(0);
					self.background2:SetLeft(0);
					self.background2:SetWidth(w);
				end
			-- enough space for both bars
			else
				local w1 = (self.proportion1 == 1 and w or (self.proportion1 == 0 and 0 or math.max(math.min(Misc.Round((w-CombatAnalysisWindow.border)*self.proportion1),w-CombatAnalysisWindow.border-1),CombatAnalysisWindow.border+1)));
				self.background:SetWidth(w1);
				self.background2:SetLeft(w1+CombatAnalysisWindow.border+(self.proportion1 == 0 and 0 or CombatAnalysisWindow.border));
				self.background2:SetWidth(math.max(0,w-w1-(self.proportion1 == 0 and 0 or CombatAnalysisWindow.border)));
			end
		end
	end
	
	if (not self.panel.tab.isBuffTab) then
		-- lock info
		self.lockShowing = false;
		self.locked = false;
		
		-- lock icon
		self.lockIcon = Turbine.UI.Control();
		self.lockIcon:SetParent(self);
		self.lockIcon:SetTop((topBar and CombatAnalysisWindow.border or 0)+math.max(0,math.floor((CombatAnalysisBarsPanel.barThickness-19)/2)));
		self.lockIcon:SetSize(20,19);
		self.lockIcon:SetZOrder(4);
		self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_normal_normal.tga");
		self.lockIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
		self.lockIcon:SetMouseVisible(true);
		self.lockIcon:SetVisible(false);
		
		self.lockIcon.MouseEnter = function(sender, args)
			if (self.locked) then
				self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_highlight_rollover.tga");
			else
				self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_normal_"..(self.lockIcon.pressed and "pressed" or "rollover")..".tga");
			end
		end
		self.lockIcon.MouseLeave = function(sender, args)
			if (self.locked) then
				self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_highlight"..(self.lockIcon.pressed and "_rollover" or "_normal")..".tga");
			else
				self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_normal"..(self.lockIcon.pressed and "_rollover" or "_normal")..".tga");
			end
		end
		self.lockIcon.MouseDown = function(sender, args)
			WindowManager.MouseWasPressed(self.panel.tab.window);
			self.lockIcon.pressed = true;
			self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_"..(self.locked and "highlight_rollover" or "normal_pressed")..".tga");
		end
		self.lockIcon.MouseUp = function(sender, args)
			self.lockIcon.pressed = false;
			self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_"..(self.locked and "highlight" or "normal").."_normal.tga");
		end
		self.lockIcon.MouseClick = function(sender, args)
      self.panel.tab.statsPanel.window:SetLocked(not self.locked and self or nil,not self.locked and self.panel.tab.statsPanel or nil,not self.locked);
		end
		self.lockIcon.MouseDoubleClick = function(sender, args)
			self.lockIcon:MouseClick(args);
		end
	end
end

function StatOverviewBar:Layout()
	CombatAnalysisBar.Layout(self);
	
	if (not self.panel.tab.isBuffTab) then
		if (self.hasTwoParts) then
			local w = math.max(0,self.border:GetWidth()-2*CombatAnalysisWindow.border);
			-- tiny space
			if (w <= CombatAnalysisWindow.border+2) then
				if (self.proportion1 >= 0.5) then
					self.background:SetWidth(w);
					self.background2:SetWidth(0);
				else
					self.background:SetWidth(0);
					self.background2:SetLeft(0);
					self.background2:SetWidth(w);
				end
			-- enough space for both bars
			else
				local w1 = (self.proportion1 == 1 and w or (self.proportion1 == 0 and 0 or math.max(math.min(Misc.Round((w-CombatAnalysisWindow.border)*self.proportion1),w-CombatAnalysisWindow.border-1),CombatAnalysisWindow.border+1)));
				self.background:SetWidth(w1);
				self.background2:SetLeft(w1+CombatAnalysisWindow.border+(self.proportion1 == 0 and 0 or CombatAnalysisWindow.border));
				self.background2:SetWidth(math.max(0,w-w1-(self.proportion1 == 0 and 0 or CombatAnalysisWindow.border)));
			end
		end
			
		local w = self:GetWidth();
		self.lockIcon:SetLeft(w-3*CombatAnalysisWindow.border-2*CombatAnalysisBarsPanel.valueTextLength-20);
		if (self.lockShowing) then
			self.label:SetWidth(math.max(0,w-7*CombatAnalysisWindow.border-2*CombatAnalysisBarsPanel.valueTextLength-15-CombatAnalysisWindow.border));
		end
	end
end

function StatOverviewBar:UpdateColor(color)
  CombatAnalysisBar.UpdateColor(self,color);
end

function StatOverviewBar:UpdateColor2(color)
  if (self.hasTwoParts) then
    self.backColor2 = color;
    self.background2:SetBackColor(self.backColor2);
  end
end

function StatOverviewBar:SetClickable(clickable)
	self.clickable = clickable;
end

function StatOverviewBar:UpdateData(name,data,duration,maxValue,myValue)
	self.amount = (self.panel.tab.isBuffTab and data or data:TotalAmount());
	local oldName = self.label:GetText();
	
	self.label:SetText(name);
	
	-- Buff Update (width based on durations)
	if (self.panel.tab.isBuffTab) then
		local perc = self.amount:CurrentDuration(Turbine.Engine.GetGameTime())/duration;
		self:SetProportion(perc);
		self.value1:SetText(Misc.FormatPerc(perc));
		self.value2:SetText(data.applications == nil and "" or Misc.FormatValue(data.applications));
		-- self.value3:SetText(  Misc.FormatValue( math.floor(self.amount / data.attacks) ) );
		
	-- Standard Update
	else
		self:SetProportion(self.amount/maxValue);
		if (self.hasTwoParts) then
			self:SetDivision(data.amount/self.amount);
		end
		
		self.value1:SetText(Misc.FormatValue(self.amount));
		self.value2:SetText(self.panel.selectedPlayer == nil and Misc.FormatPs(self.amount/(duration == 0 and 1 or duration)) or Misc.FormatValue(data.attacks));
		self.value3:SetText(  Misc.FormatValue( math.floor(self.amount / data.attacks) ) );
		
    if (self.panel.tab.statsPanel.window ~= nil) then
      -- update stats panel if applicable
      if (not self.panel.tab.statsPanel.window.isLocked and self.panel.hoverBar == self and name ~= oldName) then
        self.panel.tab.statsPanel:FullUpdate(nil,true,false,(self.clickable and name or self.panel.selectedPlayer),(not self.clickable and name or nil));
      end
      
      -- update bar lock status if bar order/view level has changed
      if (self.locked) then
        if (self.clickable) then
          if (name ~= self.panel.tab.statsPanel.selectedPlayer or self.panel.tab.statsPanel.selectedSkill ~= nil) then
            self.panel.tab.statsPanel.window:SetLocked(nil,self.panel.tab.statsPanel.window.lockedPanel);
          end
        else
          if (self.panel.selectedPlayer ~= self.panel.tab.statsPanel.selectedPlayer or name ~= self.panel.tab.statsPanel.selectedSkill) then
            self.panel.tab.statsPanel.window:SetLocked(nil,self.panel.tab.statsPanel.window.lockedPanel);
          end
        end
      elseif (not self.locked and self.panel.tab.statsPanel.window.lockedPanel == self.panel.tab.statsPanel) then
        if (self.clickable) then
          if (name == self.panel.tab.statsPanel.selectedPlayer and self.panel.tab.statsPanel.selectedSkill == nil) then
            self.panel.tab.statsPanel.window:SetLocked(self,self.panel.tab.statsPanel.window.lockedPanel);
          end
        else
          if (self.panel.selectedPlayer == self.panel.tab.statsPanel.selectedPlayer and name == self.panel.tab.statsPanel.selectedSkill) then
            self.panel.tab.statsPanel.window:SetLocked(self,self.panel.tab.statsPanel.window.lockedPanel);
          end
        end
      end
    end
	
	end
end

function StatOverviewBar:UpdateDuration(duration)
	if (self.panel.tab.isBuffTab) then
		local perc = self.amount:CurrentDuration(Turbine.Engine.GetGameTime())/duration;
		
		self:SetProportion(perc);
		self.value1:SetText(Misc.FormatPerc(perc));
		
	elseif (self.panel.selectedPlayer == nil) then
		self.value2:SetText(Misc.FormatPs(self.amount/duration));
	end
end

-- locking

function CombatAnalysisBar:SetLocked(lock)
	self.locked = lock;
	-- update the lock icon
	self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_"..(self.locked and "highlight" or "normal").."_rollover.tga");
	if (self.panel.hoverBar ~= self) then
		self:SetLockShowing(self.locked);
	end
end

function CombatAnalysisBar:SetLockShowing(show)
	self.lockShowing = show;
	self.lockIcon:SetVisible(show);
	
	self.label:SetWidth(math.max(0,self:GetWidth()-7*CombatAnalysisWindow.border-2*CombatAnalysisBarsPanel.valueTextLength-(self.lockShowing and 15+CombatAnalysisWindow.border or 0)));
end


-- mouse events

function StatOverviewBar:MouseEnter(args)
	CombatAnalysisBar.MouseEnter(self,args);
	self.panel.hoverBar = self;
	
	if (not self.panel.tab.isBuffTab and self.panel.tab.statsPanel.window ~= nil) then
		-- ensure lock is showing
		self:SetLockShowing(true);
		-- update stats panel
		if (not self.panel.tab.statsPanel.window.isLocked) then
			self.panel.tab.statsPanel:EnsureShowing(true,true);
			self.panel.tab.statsPanel:FullUpdate(self.panel.tab:Duration(),true,false,(self.clickable and self.label:GetText() or self.panel.selectedPlayer),(not self.clickable and self.label:GetText() or nil));
		end
	end
end

function StatOverviewBar:MouseLeave(args)
	CombatAnalysisBar.MouseLeave(self,args);
	self.panel.hoverBar = nil;
	
	if (not self.panel.tab.isBuffTab and self.panel.tab.statsPanel.window ~= nil) then
		-- hide lock (if unlocked)
		self:SetLockShowing(self.locked);
		-- update stats panel
		if (not self.panel.tab.statsPanel.window.isLocked) then
			self.panel.tab.statsPanel:EnsureShowing(false,true);
			self.panel.tab.statsPanel:FullUpdate(self.panel.tab:Duration(),true,false,(not self.clickable and self.panel.selectedPlayer or nil),nil);
		end
	end
end

function StatOverviewBar:MouseClick(args)
	if (args.Button ~= Turbine.UI.MouseButton.Left) then
		self.panel:MouseClick(args);
		return;
	end
	
	-- if the bar was control-clicked, update the lock status
	if (self:IsControlKeyDown() and not self.panel.tab.isBuffTab) then
		self.lockIcon:MouseClick(args);
		return;
	end
	
	-- if the bar is not clickable, return
	if not self.clickable or self.panel.tab.isBuffTab then return end
	
	-- otherwise, update bars panel to reflect deeper view level (which will also update stats panel if necessary)
	self.panel.tab.panel:FullUpdate(nil,true,self.label:GetText(),false);
end
