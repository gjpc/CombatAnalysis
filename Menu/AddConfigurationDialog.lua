local AddConfigurationDialog = class(Window);

function AddConfigurationDialog:Constructor(text)
	Window.Constructor(self);
	
  local width = 400;
  local height = 200;
  
  self:SetText(L.AddConfiguration);
  
  self.configNameLabel = MenuLabel(self,60,140,20,"14");  
  self.configNameLabel:SetLeft(25);
  self.configNameLabel:SetMultiline(false);
  self.configNameLabel:SetForeColor(control2LightColor);
  self.configNameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.configNameLabel:SetText(L.ConfigurationName..":");
  self.configNameLabel:SetMouseVisible(true);
  self.configNameLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.configNameLabel,L.ConfigurationNameTooltip,TooltipStyle.LOTRO,500);
  
  self.configNameTextBox = Turbine.UI.Lotro.TextBox();
  self.configNameTextBox:SetParent(self);
  self.configNameTextBox:SetPosition(180,60);
  self.configNameTextBox:SetSize(196,20);
  self.configNameTextBox:SetBackColor(blueBorderColor);
  self.configNameTextBox:SetForeColor(control2LightColor);
  self.configNameTextBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  self.configNameTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.configNameTextBox:SetMultiline(false);
  
  self.copyFrom = ColoredLabelledComboBox(nil, L.CopyDebuffsFrom..":", 196+180-25, LabelledComboBox.TextOnLeft, Turbine.UI.ContentAlignment.MiddleLeft, 20, "14", 1, blueBorderColor, Turbine.UI.ContentAlignment.MiddleCenter, 196);
  self.copyFrom:SetParent(self);
	self.copyFrom:SetPosition(25,88);
  TooltipManager.SetTooltip(self.copyFrom.text,L.CopyDebuffsFromTooltip,TooltipStyle.LOTRO,500);
  
  self.colorLabel = MenuLabel(self,116,140,20,"14");  
  self.colorLabel:SetLeft(25);
  self.colorLabel:SetForeColor(control2LightColor);
  self.colorLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.colorLabel:SetText(L.ColorScheme..":");
  self.colorLabel:SetMouseVisible(true);
  self.colorLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.colorLabel,L.ConfigurationColorSchemeTooltip,TooltipStyle.LOTRO,500);
  
  self.colorPicker = TraitColorPicker(self,180,116,196);
  
	self.addButton = Turbine.UI.Lotro.Button();
	self.addButton:SetParent(self);
	self.addButton:SetSize(106,25);
	self.addButton:SetText(L.Add);
	self.addButton.MouseClick = function(sender,args)
    local success, errorMsg = Traits.AddTraitConfiguration(self.configNameTextBox:GetText(),self.colorPicker:GetSelected(),self.copyFrom:GetSelection());
    
    if (success) then
      self:Close();
    else
      dialog:ShowInfoDialog(errorMsg);
    end
	end
	
	-- no button (confirm/option dialog)
	self.cancelButton = Turbine.UI.Lotro.Button();
	self.cancelButton:SetParent(self);
	self.cancelButton:SetSize(106,25);
	self.cancelButton:SetText(L.Cancel);
	self.cancelButton.MouseClick = function(sender,args)
		self:Close();
	end
  
  self.addButton:SetPosition(width/2-112, height-42);
  self.cancelButton:SetPosition(width/2+7, height-42);
  
  self:SetSize(width,height);
  self:SetPosition((Turbine.UI.Display.GetWidth()-width)/2,(Turbine.UI.Display.GetHeight()-height)/2);
  self:Layout();
end

function AddConfigurationDialog:KeyDown(args)
	-- do not respond to the key event that was potentially used to show this dialog
	if (DialogManager.timestamp == Turbine.Engine.GetGameTime()) then
		return;
	end
  
  -- add on enter
	if (args.Action == 162) then
		if (not self.configNameTextBox:HasFocus()) then
			self.addButton:MouseClick();
		end
    KeyManager.TakeFocus();
	-- cancel on escape
	elseif (args.Action == 145) then
		self.cancelButton:MouseClick();
	end
end

function AddConfigurationDialog:MouseDown(args)
  KeyManager.TakeFocus();
end

function AddConfigurationDialog:SetVisible(visible,dontActivate)
	Window.SetVisible(self,visible,dontActivate);
  
  if (visible and not dontActivate) then
    self.configNameTextBox:Focus();
  end
end

function AddConfigurationDialog:Close()
	DialogManager.HideDialog(self);
end

function AddConfigurationDialog:Layout()
	Window.Layout(self);
end

-- Shows a confirm window with the specified text and listener function
function AddConfigurationDialog:Show()
	self:Layout();
  
  self.configNameTextBox:SetText("");
  
  if (self.colorPicker.selected ~= nil) then
    self.colorPicker:SetSelected(self.colorPicker.selected,false);
    self.colorPicker.selected = nil;
  end
  
  self.copyFrom:Clear();
  local sortedConfigurations = {}
  for name,configInfo in pairs(traits.configurations) do
    table.insert(sortedConfigurations,{name,configInfo.color});
  end
  table.sort(sortedConfigurations, function(a,b) return a[1] < b[1] end);
  self.copyFrom:AddItem(L.None,"");
  for _,info in ipairs(sortedConfigurations) do
    local color = TraitConfigTextToColor(info[2]);
    self.copyFrom:AddItem(info[1],info[1],nil,nil,nil,
        --Misc.SetShade(Misc.SimpleToGray(1,color,1/6),0.4/3,0.8/3),
        Misc.SetShade(Misc.SimpleToGray(1,color,0.125/0.8),0/3,3/3),
        Misc.SetShade(Misc.SimpleToGray(1,color,0.1/0.65),0/3,3/3),
        Misc.SetShade(Misc.SimpleToGray(1,color,0.09/0.67),0/3,3/3));
  end
  self.copyFrom:SetSelection("");
  
	DialogManager.ShowDialog(self);
end

_G.addConfigurationDialog = AddConfigurationDialog();


