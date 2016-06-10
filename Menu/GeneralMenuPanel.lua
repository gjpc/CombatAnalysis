
_G.GeneralMenuPanel = class(Turbine.UI.Control);

function GeneralMenuPanel:Constructor(window)
	Turbine.UI.Control.Constructor(self);
	
	self.window = window;
	self.width = 420;
	self.height = 750;
	
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
  
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self);
	self.listBox:SetPosition(5,5);
	
	self.content = Turbine.UI.Control();
	self.content:SetParent(self.listBox);
	self.content:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.title = PanelDivider(L.GeneralSettingsTitle,self.content);
  self.title:SetTop(12);
  
	self.autoSelect = Turbine.UI.Lotro.CheckBox();
	self.autoSelect:SetTop(56);
	self.autoSelect:SetMultiline(false);
	self.autoSelect:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.autoSelect:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.autoSelect:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.autoSelect:SetForeColor(control2LightColor);
	self.autoSelect:SetText(" " .. L.AutoSelectNewEncounters);
	self.autoSelect:SetParent(self.content);
	self.autoSelect:SetSize(self.width-20,20);
  TooltipManager.SetTooltip(self.autoSelect,L.AutoSelectTooltip,TooltipStyle.LOTRO,500);
  
	self.autoSelect.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	self.autoSelect.MouseDoubleClick = function(sender,args)
		self.autoSelect:SetChecked(not self.autoSelect:IsChecked());
	end
	
	self.autoSelect.CheckedChanged = function(sender,args)
		if (autoSelectNewEncounters ~= self.autoSelect:IsChecked()) then
			Misc.SetValue(nil,"autoSelectNewEncounters",self.autoSelect:IsChecked());
			_G.settings.autoSelectNewEncounters = _G.autoSelectNewEncounters;
			SaveSettings();
		end
	end
	Misc.AddListener(nil, "autoSelectNewEncounters", function(sender)
		if (sender.autoSelect:IsChecked() ~= autoSelectNewEncounters) then
			sender.autoSelect:SetChecked(autoSelectNewEncounters);
		end
	end, self, self);
	
	self.confirmOnReset = Turbine.UI.Lotro.CheckBox();
	self.confirmOnReset:SetTop(self.autoSelect:GetTop()+27);
	self.confirmOnReset:SetMultiline(false);
	self.confirmOnReset:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.confirmOnReset:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.confirmOnReset:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.confirmOnReset:SetForeColor(control2LightColor);
	self.confirmOnReset:SetText(" " .. L.ConfirmDialogOnReset);
	self.confirmOnReset:SetParent(self.content);
	self.confirmOnReset:SetSize(self.width-20,20);
  TooltipManager.SetTooltip(self.confirmOnReset,L.ConfirmOnResetTooltip,TooltipStyle.LOTRO,500);
  
	self.confirmOnReset.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.confirmOnReset.CheckedChanged = function(sender,args)
		if (confirmOnReset ~= self.confirmOnReset:IsChecked()) then
			Misc.SetValue(nil,"confirmOnReset",self.confirmOnReset:IsChecked());
			_G.settings.confirmOnReset = _G.confirmOnReset;
			SaveSettings();
		end
	end
	Misc.AddListener(nil, "confirmOnReset", function(sender)
		if (sender.confirmOnReset:IsChecked() ~= confirmOnReset) then
			sender.confirmOnReset:SetChecked(confirmOnReset);
		end
	end, self, self);
  
  self.showCombatAnalysisIcon = Turbine.UI.Lotro.CheckBox();
	self.showCombatAnalysisIcon:SetTop(self.confirmOnReset:GetTop()+27);
	self.showCombatAnalysisIcon:SetMultiline(false);
	self.showCombatAnalysisIcon:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.showCombatAnalysisIcon:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.showCombatAnalysisIcon:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.showCombatAnalysisIcon:SetForeColor(control2LightColor);
	self.showCombatAnalysisIcon:SetText(" " .. L.ShowLogo);
	self.showCombatAnalysisIcon:SetParent(self.content);
	self.showCombatAnalysisIcon:SetSize(self.width-20,20);
  TooltipManager.SetTooltip(self.showCombatAnalysisIcon,L.ShowLogoTooltip,TooltipStyle.LOTRO,500);
  
	self.showCombatAnalysisIcon.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.showCombatAnalysisIcon.CheckedChanged = function(sender,args)
		if (showCombatAnalysisIcon ~= self.showCombatAnalysisIcon:IsChecked()) then
			Misc.SetValue(nil,"showCombatAnalysisIcon",self.showCombatAnalysisIcon:IsChecked());
      if (windowsHidden) then combatAnalysisIcon:ShowHideWindows(false) end -- make sure windows are showing before we hide the icon
      WindowManager.ShowHideWindows({combatAnalysisIcon},false,not showCombatAnalysisIcon,"combatAnalysisIcon");
      if (combatAnalysisIcon.dragBar) then combatAnalysisIcon.dragBar:SetBarVisible(combatAnalysisIcon:IsVisible()) end
			_G.settings.showCombatAnalysisIcon = _G.showCombatAnalysisIcon;
			SaveSettings();
		end
	end
	Misc.AddListener(nil, "showCombatAnalysisIcon", function(sender)
		if (sender.showCombatAnalysisIcon:IsChecked() ~= showCombatAnalysisIcon) then
			sender.showCombatAnalysisIcon:SetChecked(showCombatAnalysisIcon);
		end
	end, self, self);
    
    self.windowsLocked = Turbine.UI.Lotro.CheckBox();
	self.windowsLocked:SetTop(self.showCombatAnalysisIcon:GetTop()+27);
	self.windowsLocked:SetMultiline(false);
	self.windowsLocked:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.windowsLocked:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.windowsLocked:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.windowsLocked:SetForeColor(control2LightColor);
	self.windowsLocked:SetText(" " .. L.LockWindows);
	self.windowsLocked:SetParent(self.content);
	self.windowsLocked:SetSize(self.width-20,20);
    TooltipManager.SetTooltip(self.windowsLocked,L.LockWindowsTooltip,TooltipStyle.LOTRO,500);

	self.windowsLocked.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.windowsLocked.CheckedChanged = function(sender,args)
		if (windowsLocked ~= self.windowsLocked:IsChecked()) then
      combatAnalysisIcon:LockWindows(self.windowsLocked:IsChecked());
		end
	end
	Misc.AddListener(nil, "windowsLocked", function(sender)
		if (sender.windowsLocked:IsChecked() ~= windowsLocked) then
			sender.windowsLocked:SetChecked(windowsLocked);
		end
	end, self, self);
    
    self.largeFont = Turbine.UI.Lotro.CheckBox();
	self.largeFont:SetTop(self.windowsLocked:GetTop()+27);
	self.largeFont:SetMultiline(false);
	self.largeFont:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.largeFont:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.largeFont:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.largeFont:SetForeColor(control2LightColor);
	self.largeFont:SetText(" " .. L.largeFont);
	self.largeFont:SetParent(self.content);
	self.largeFont:SetSize(self.width-20,20);
    TooltipManager.SetTooltip(self.largeFont,L.LargeFontTooltip,TooltipStyle.LOTRO,500);
 
 	self.largeFont.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.largeFont.CheckedChanged = function(sender,args)
		if (_G.largeFont ~= self.largeFont:IsChecked()) then
			_G.largeFont = self.largeFont:IsChecked();
			_G.settings.largeFont = _G.largeFont;
			
			if ( _G.largeFont ) then
				_G.statFont = Turbine.UI.Lotro.Font.TrajanPro18;
			else
				_G_statFont = Turbine.UI.Lotro.Font.TrajanPro14;
			end;
			
			--_G.CombatAnalysisTreePanel:DepthFirstTraversal(CombatAnalysisTreePanel.LayoutNode);
			SaveSettings();
		end
	end
	
	Misc.AddListener(nil, "largeFont", function(sender)
		if (sender.largeFont:IsChecked() ~= largeFont) then
			sender.largeFont:SetChecked(largeFont);
		end
	end, self, self);
 
  self.maxEncountersSlider = Slider();
  self.maxEncountersSlider:SetParent(self.content);
  self.maxEncountersSlider:SetText(L.MaxStandardEncounters);
  self.maxEncountersSlider:SetTop(self.largeFont:GetTop()+42); -- 125
  self.maxEncountersSlider:SetSize(400,40);
  self.maxEncountersSlider:SetFormat("%d");
  self.maxEncountersSlider:SetStep(1);
  self.maxEncountersSlider:SetMax(100);
  self.maxEncountersSlider:SetMin(10);
  TooltipManager.SetTooltip(self.maxEncountersSlider.label,L.MaxEncountersTooltip,TooltipStyle.LOTRO,500);
  
  Misc.AddListener(combatData, "maxEncounters", function(sender)
    if (self.maxEncountersSlider:GetValue() ~= combatData.maxEncounters) then
      self.maxEncountersSlider:SetValue(combatData.maxEncounters);
    end
  end, self, self);
  
  self.maxEncountersSlider.ValueChanged = function(sender)
    if (combatData.maxEncounters ~= self.maxEncountersSlider:GetValue()) then
			Misc.SetValue(combatData,"maxEncounters",self.maxEncountersSlider:GetValue());
			_G.settings.maxEncounters = EncodeNumbers(combatData.maxEncounters);
			SaveSettings();
		end
  end
	
  self.maxLoadedEncountersSlider = Slider();
  self.maxLoadedEncountersSlider:SetParent(self.content);
  self.maxLoadedEncountersSlider:SetText(L.MaxLoadedEncounters);
  self.maxLoadedEncountersSlider:SetTop(self.maxEncountersSlider:GetTop()+45); -- 170
  self.maxLoadedEncountersSlider:SetSize(400,40);
  self.maxLoadedEncountersSlider:SetFormat("%d");
  self.maxLoadedEncountersSlider:SetStep(1);
  self.maxLoadedEncountersSlider:SetMax(10);
  self.maxLoadedEncountersSlider:SetMin(3);
  TooltipManager.SetTooltip(self.maxLoadedEncountersSlider.label,L.MaxLoadedEncountersTooltip,TooltipStyle.LOTRO,500);
  
  Misc.AddListener(combatData, "maxLoadedEncounters", function(sender)
    if (combatData.maxLoadedEncounters ~= self.maxLoadedEncountersSlider:GetValue()) then
      self.maxLoadedEncountersSlider:SetValue(combatData.maxLoadedEncounters);
    end
  end, self, self);
  
  self.maxLoadedEncountersSlider.ValueChanged = function(sender)
    if (combatData.maxLoadedEncounters ~= self.maxLoadedEncountersSlider:GetValue()) then
			Misc.SetValue(combatData,"maxLoadedEncounters",self.maxLoadedEncountersSlider:GetValue());
			_G.settings.maxLoadedEncounters = EncodeNumbers(combatData.maxLoadedEncounters);
			SaveSettings();
		end
  end
  
  self.timerTitle = PanelDivider(L.TimerConfigurationsTitle,self.content);
  self.timerTitle:SetTop(self.maxLoadedEncountersSlider:GetTop()+59); -- 229
  
  self.combatSlider = Slider();
  self.combatSlider:SetParent(self.content);
  self.combatSlider:SetText(L.CombatTimeout);
  self.combatSlider:SetTop(self.timerTitle:GetTop()+46); -- 275
  self.combatSlider:SetSize(400,40);
  TooltipManager.SetTooltip(self.combatSlider.label,L.CombatTimeoutTooltip,TooltipStyle.LOTRO,500);
  
  Misc.AddListener(combatData, "timer", function(sender)
    if (combatData.timer ~= self.combatSlider:GetValue()) then
      self.combatSlider:SetValue(combatData.timer);
    end
  end, self, self);
  
  self.combatSlider.ValueChanged = function(sender)
    if (self.combatSlider:GetValue() < 0.6) then self.combatSlider:SetValue(0.6); return end
    
    if (combatData.timer ~= self.combatSlider:GetValue()) then
      -- ensure minDuration < timer
      if (combatData.minDuration >= self.combatSlider:GetValue()) then
        Misc.SetValue(combatData,"minDuration",self.combatSlider:GetValue()-0.1);
        _G.settings.targetTimeout = EncodeNumbers(combatData.minDuration);
      end
      
			Misc.SetValue(combatData,"timer",self.combatSlider:GetValue());
			_G.settings.combatTimeout = EncodeNumbers(combatData.timer);
			SaveSettings();
		end
  end
	
  self.targetSlider = Slider();
  self.targetSlider:SetParent(self.content);
  self.targetSlider:SetText(L.TargetTimeout);
  self.targetSlider:SetTop(self.combatSlider:GetTop()+45); -- 320
  self.targetSlider:SetSize(400,40);
  TooltipManager.SetTooltip(self.targetSlider.label,L.TargetTimeoutTooltip,TooltipStyle.LOTRO,500);
  
  Misc.AddListener(combatData, "minDuration", function(sender)
    if (combatData.minDuration ~= self.targetSlider:GetValue()) then
      self.targetSlider:SetValue(combatData.minDuration);
    end
  end, self, self);
  
  self.targetSlider.ValueChanged = function(sender)
    -- ensure minDuration < timer
    if (self.targetSlider:GetValue() >= self.combatSlider:GetValue()) then self.targetSlider:SetValue(self.combatSlider:GetValue()-0.1); return end
    
    if (combatData.minDuration ~= self.targetSlider:GetValue()) then
			Misc.SetValue(combatData,"minDuration",self.targetSlider:GetValue());
			_G.settings.targetTimeout = EncodeNumbers(combatData.minDuration);
			SaveSettings();
		end
  end
  
  self.logDelay = Slider();
  self.logDelay:SetParent(self.content);
  self.logDelay:SetText(L.LogDelay);
  self.logDelay:SetTop(self.targetSlider:GetTop()+60); -- 380
  self.logDelay:SetSize(400,40);
  TooltipManager.SetTooltip(self.logDelay.label,L.LogDelayTooltip,TooltipStyle.LOTRO,500);
	
  Misc.AddListener(nil, "logDelay", function(sender)
    if (logDelay ~= self.logDelay:GetValue()) then
      self.logDelay:SetValue(logDelay);
    end
  end, self, self);
  
  self.logDelay.ValueChanged = function(sender)
    if (logDelay ~= self.logDelay:GetValue()) then
			Misc.SetValue(nil,"logDelay",self.logDelay:GetValue());
			_G.settings.logDelay = EncodeNumbers(logDelay);
			SaveSettings();
		end
  end
  
  self.effectDelay = Slider();
  self.effectDelay:SetParent(self.content);
  self.effectDelay:SetText(L.EffectDelay);
  self.effectDelay:SetTop(self.logDelay:GetTop()+45); -- 425
  self.effectDelay:SetSize(400,40);
  TooltipManager.SetTooltip(self.effectDelay.label,L.EffectDelayTooltip,TooltipStyle.LOTRO,500);
  
  Misc.AddListener(nil, "effectDelay", function(sender)
    if (effectDelay ~= self.effectDelay:GetValue()) then
      self.effectDelay:SetValue(effectDelay);
    end
  end, self, self);
  
  self.effectDelay.ValueChanged = function(sender)
    if (effectDelay ~= self.effectDelay:GetValue()) then
			Misc.SetValue(nil,"effectDelay",self.effectDelay:GetValue());
			_G.settings.effectDelay = EncodeNumbers(effectDelay);
			SaveSettings();
		end
  end
  
  self.saveLoadTitle = PanelDivider(L.SaveLoadTitle,self.content);
  self.saveLoadTitle:SetTop(self.effectDelay:GetTop()+63); -- 488
  
  self.autoSave = LabelledComboBox(self.window, L.AutoSaveData, 400);
  self.autoSave:SetParent(self.content);
	self.autoSave:SetTop(self.saveLoadTitle:GetTop()+56); -- 544
	self.autoSave:AddItem(L.Off,"Off");
  self.autoSave:AddItem(L.SaveOnExit,"SaveTotals");
  self.autoSave:AddItem(L.SaveEncounters,"SaveEncounters");
  TooltipManager.SetTooltip(self.autoSave.text,L.AutoSaveTooltip,TooltipStyle.LOTRO,500);
	
	self.autoSave.SelectionChanged = function(sender,args)
		if (autoSave ~= self.autoSave:GetSelection()) then
			Misc.SetValue(nil,"autoSave",self.autoSave:GetSelection());
			_G.settings.autoSave = _G.autoSave;
			SaveSettings();
		end
	end
	Misc.AddListener(nil, "autoSave", function(sender)    
		if (self.autoSave:GetSelection() ~= autoSave) then
			self.autoSave:SetSelection(autoSave);
		end
	end, self, self);
  
	self.saveButton = Turbine.UI.Lotro.Button();
	self.saveButton:SetTop(self.autoSave:GetTop()+52); -- 596
	self.saveButton:SetText(L.SaveData);
	self.saveButton:SetParent(self.content);
	self.saveButton:SetSize(120,30);
	self.saveButton.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.saveButton.Click = function(sender,args)
		fileSelectDialog:Show(true);
	end
	
	self.loadButton = Turbine.UI.Lotro.Button();
	self.loadButton:SetTop(self.autoSave:GetTop()+52); -- 596
	self.loadButton:SetText(L.LoadData);
	self.loadButton:SetParent(self.content);
	self.loadButton:SetSize(120,30);
	self.loadButton.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.loadButton.Click = function(sender,args)
		fileSelectDialog:Show(false);
	end
	
	self.listBox:AddItem(self.content);
	
	self.hScroll = Turbine.UI.Lotro.ScrollBar();
	self.hScroll:SetParent(self);
	self.hScroll:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.hScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.hScroll:SetHeight(10);
	self.listBox:SetHorizontalScrollBar(self.hScroll);
end

function GeneralMenuPanel:Layout()
	local w,h = self:GetSize();
	
	self.listBox:SetSize(w-10,h-12);
	self.content:SetSize(math.max(self.width,w-20),math.max(self.height,h-20));
  
  self.title:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  
	self.autoSelect:SetLeft(math.max(0,(w-20-self.width)/2)+15);
	self.confirmOnReset:SetLeft(math.max(0,(w-20-self.width)/2)+15);
  self.showCombatAnalysisIcon:SetLeft(math.max(0,(w-20-self.width)/2)+15);
  self.windowsLocked:SetLeft(math.max(0,(w-20-self.width)/2)+15);
  self.largeFont:SetLeft(math.max(0,(w-20-self.width)/2)+15);
  
  self.maxEncountersSlider:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  self.maxLoadedEncountersSlider:SetLeft(math.max(0,(w-20-self.width)/2)+10);
	
  self.timerTitle:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  
  self.combatSlider:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  self.targetSlider:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  
  self.logDelay:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  self.effectDelay:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  
  self.saveLoadTitle:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  
  self.autoSave:SetLeft(math.max(0,(w-20-self.width)/2)+15);
  
	self.saveButton:SetLeft(math.max(0,(w-20-self.width)/2)+70);
	self.loadButton:SetLeft(math.max(0,(w-20-self.width)/2)+self.width-120-70);
  
	self.hScroll:SetTop(h-10);
	self.hScroll:SetWidth(w);
end

function GeneralMenuPanel:MouseDown()
	if (self.window ~= nil) then WindowManager.MouseWasPressed(self.window) end
end