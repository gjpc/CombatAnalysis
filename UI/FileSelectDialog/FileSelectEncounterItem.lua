
--[[
	
	A file select encounter item.
	
	This kind of item contains a checkbox and is either selected (to save)
	or deselected (to not save).
	
]]

_G.FileSelectEncounterItem = class(Turbine.UI.Control);

function FileSelectEncounterItem:Constructor(name,index,deselected)
	Turbine.UI.Control.Constructor(self);
	
	self.name = name;
	self.index = index;
	
	self.saved = (fileSelectDialog.saveMode and encountersComboBox:GetValueAtLowerIndex(self.index).saved or false);	
	self:SetSize(FileSelectItem.itemWidth+2,24);
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	
	self.encounter = Turbine.UI.Lotro.CheckBox();
	self.encounter:SetParent(self);
	self.encounter:SetPosition(2,2);
	self.encounter:SetSize(FileSelectItem.itemWidth-2,20);
	self.encounter:SetBackColor((self.saved and Turbine.UI.Color(0.7,0.37,0.35,0.47) or Turbine.UI.Color(0.7,0.47,0.35,0.35)));
	self.encounter:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.encounter:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.encounter:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.encounter:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.encounter:SetForeColor(controlLightColor);
	self.encounter:SetMultiline(false);
	self.encounter:SetText(" "..self.name);
	self.encounter:SetMouseVisible(false);
	
	self.encounter.CheckedChanged = function(sender,args)
		self.encounter:SetBackColor(self.encounter:IsChecked() and Turbine.UI.Color(0.7,0.35,0.47,0.35) or (self.saved and Turbine.UI.Color(0.7,0.37,0.35,0.47) or Turbine.UI.Color(0.7,0.47,0.35,0.35)));
		fileSelectDialog.deselectedEncounters[self.index] = (not self.encounter:IsChecked() and true or false);
	end
	
	if (deselected ~= nil) then
		self.encounter:SetChecked(not deselected);
	else
		self.encounter:SetChecked(not self.saved);
	end
end

function FileSelectEncounterItem:SetName(name)
	self.name = name;
	self.encounter:SetText(" "..self.name);
end

function FileSelectEncounterItem:MouseClick(args)
	if (args.Button == Turbine.UI.MouseButton.Left) then
		self.encounter:SetChecked(not self.encounter:IsChecked());
	else
		fileSelectBox:MouseClick(args);
	end
end

function FileSelectEncounterItem:MouseDoubleClick(args)
	self:MouseClick(args);
end

function FileSelectEncounterItem:MouseWheel(args)
	fileSelectBox:MouseWheel(args);
end
