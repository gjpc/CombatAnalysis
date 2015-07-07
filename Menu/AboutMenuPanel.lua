
_G.AboutMenuPanel = class(Turbine.UI.Control);

function AboutMenuPanel:Constructor(window)
	Turbine.UI.Control.Constructor(self);
	
	self.window = window;
	self.width = 420;
	self.height = (self.locale == "en" and 250 or 265);
	
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
  
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self);
	self.listBox:SetPosition(5,5);
	
	self.content = Turbine.UI.Control();
	self.content:SetParent(self.listBox);
	self.content:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.title = PanelDivider(L.AboutTitle,self.content);
  self.title:SetTop(12);
  
  self.pluginTitle = MenuLabel(self.content,56,self.width-50,30,"14");
	self.pluginTitle:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
	self.pluginTitle:SetText(L.CombatAnalysis[1]);
  
  self.versionNo = MenuLabel(self.content,56,150,30,"14");
	self.versionNo:SetTextAlignment(Turbine.UI.ContentAlignment.TopRight);
	self.versionNo:SetText(L.VersionNo..": "..versionNo);
  
  self.developedBy = MenuLabel(self.content,71,self.width-50,30,"14");
	self.developedBy:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
	self.developedBy:SetText("- "..L.DevelopedBy);
  
  if (locale ~= "en") then
    self.translatedBy = MenuLabel(self.content,86,self.width-50,30,"14");
    self.translatedBy:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
    self.translatedBy:SetText("- "..L.TranslatedBy);
  end
  
  self.about = MenuLabel(self.content,(locale == "en" and 101 or 116),self.width-50,100,"14");
	self.about:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
	self.about:SetText(L.PluginUsageMessage);
  
  self.url = Turbine.UI.Lotro.TextBox();
  self.url:SetParent(self.content);
  self.url:SetEnabled(false);
  self.url:SetTop(locale == "en" and 117 or 132);
  self.url:SetSize(self.width-40,33);
  self.url:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  self.url:SetForeColor(Turbine.UI.Color(1,0.94,0.85));
  self.url:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
	self.url:SetText("http://www.lotrointerface.com/downloads/info881-CombatAnalysis.html");
  
  self.bugMessage = MenuLabel(self.content,(locale == "en" and 162 or 177),self.width-50,100,"14");
  self.bugMessage:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
	self.bugMessage:SetText(L.FoundABugMessage);
  
  self.restoreSettingsButton = Turbine.UI.Lotro.Button();
	self.restoreSettingsButton:SetTop(locale == "en" and 212 or 227);
	self.restoreSettingsButton:SetText(L.RestoreSettings);
	self.restoreSettingsButton:SetParent(self.content);
	self.restoreSettingsButton:SetSize(140,30);
	self.restoreSettingsButton.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.restoreSettingsButton.Click = function(sender,args)
    dialog:ShowConfirmDialog(L.RestoreSettingsConfirmation,RestoreDefaultSettings);
	end
	
	self.restoreTraitsButton = Turbine.UI.Lotro.Button();
	self.restoreTraitsButton:SetTop(locale == "en" and 212 or 227);
	self.restoreTraitsButton:SetText(L.RestoreTraits);
	self.restoreTraitsButton:SetParent(self.content);
	self.restoreTraitsButton:SetSize(140,30);
	self.restoreTraitsButton.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	
	self.restoreTraitsButton.Click = function(sender,args)
		dialog:ShowConfirmDialog(L.RestoreTraitsConfirmation,RestoreDefaultTraits);
	end
  
	self.listBox:AddItem(self.content);
	
	self.hScroll = Turbine.UI.Lotro.ScrollBar();
	self.hScroll:SetParent(self);
	self.hScroll:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.hScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.hScroll:SetHeight(10);
	self.listBox:SetHorizontalScrollBar(self.hScroll);
end

function AboutMenuPanel:Layout()
	local w,h = self:GetSize();
	
	self.listBox:SetSize(w-10,h-12);
	self.content:SetSize(math.max(self.width,w-20),math.max(self.height,h-20));
  
  self.title:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  
  self.pluginTitle:SetLeft(math.max(0,(w-20-self.width)/2)+25);
  self.versionNo:SetLeft(math.max(0,(w-20-self.width)/2)+self.width-175);
	self.developedBy:SetLeft(math.max(0,(w-20-self.width)/2)+25);
  
  if (locale ~= "en") then
    self.translatedBy:SetLeft(math.max(0,(w-20-self.width)/2)+25);
  end
  
  self.about:SetLeft(math.max(0,(w-20-self.width)/2)+25);
  self.url:SetLeft(math.max(0,(w-20-self.width)/2)+20);
  self.bugMessage:SetLeft(math.max(0,(w-20-self.width)/2)+25);
  
  self.restoreSettingsButton:SetLeft(math.max(0,(w-20-self.width)/2)+60);
	self.restoreTraitsButton:SetLeft(math.max(0,(w-20-self.width)/2)+self.width-140-60);
  
	self.hScroll:SetTop(h-10);
	self.hScroll:SetWidth(w);
end

function AboutMenuPanel:MouseDown()
	if (self.window ~= nil) then WindowManager.MouseWasPressed(self.window) end
end