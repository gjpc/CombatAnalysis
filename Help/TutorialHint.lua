
-- A Tutorial hint

_G.TutorialHint = class(Window);

function TutorialHint:Constructor(title, text, icon)
	Window.Constructor(self);
  
  table.insert(allWindows,self);
  
  self:SetZOrder(1);
  self:SetMouseVisible(false);
  
  self.w = 365;
  self.padding = 10;
  
  self.iconW = 40; -- TODO: use the stretch hack to determine icon size
  self.iconH = 40; -- TODO: use the stretch hack to determine icon size
  
  self.tutorialIcon = Turbine.UI.Control();
  self.tutorialIcon:SetParent(self);
  self.tutorialIcon:SetMouseVisible(false);
  self.tutorialIcon:SetPosition(15,35);
  self.tutorialIcon:SetSize(38,38);
  self.tutorialIcon:SetBackground("CombatAnalysis/Resources/tutorial_icon.tga");
  self.tutorialIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  
  self.titleText = Turbine.UI.Label();
  self.titleText:SetParent(self);
  self.titleText:SetMouseVisible(false);
  self.titleText:SetPosition(15+38+5,35+7);
  self.titleText:SetSize(self.w-self.titleText:GetLeft()-20,24);
  self.titleText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.titleText:SetFont(Turbine.UI.Lotro.Font.TrajanPro18);
  self.titleText:SetForeColor(controlYellowColor);
  self.titleText:SetFontStyle(Turbine.UI.FontStyle.Outline);
  self.titleText:SetOutlineColor(Turbine.UI.Color(0.1,0.1,0.1));
  self.titleText:SetText(title);
  
  self.label = Turbine.UI.Label();
  self.label:SetParent(self);
  self.label:SetMouseVisible(false);
  self.label:SetPosition(5+self.padding,self.tutorialIcon:GetTop()+38+5);
  self.label:SetWidth(self.w-2*self.padding-10);
  self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
  self.label:SetText(text);
  
  self.image = Turbine.UI.Control();
  self.image:SetParent(self);
  self.image:SetMouseVisible(false);
  self.image:SetLeft(self.padding+30);
  self.image:SetSize(self.iconW,self.iconH); 
  self.image:SetBackground(icon);
  self.image:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  
  self.okButton = Turbine.UI.Lotro.Button();
  self.okButton:SetParent(self);
  self.okButton:SetLeft((self.w-80)/2);
  self.okButton:SetSize(80,20);
  self.okButton:SetText(L.OK);
  
  self.okButton.MouseClick = function(sender,args)
    if (self.dontShowAgainCheckBox:IsChecked()) then
      settings.combatAnalysisLogoTutorialViewed = true;
      SaveSettings();
    end
    
    self:Close();
  end
  
  self.dontShowAgainCheckBox = Turbine.UI.Lotro.CheckBox();
  self.dontShowAgainCheckBox:SetParent(self);
  self.dontShowAgainCheckBox:SetLeft((self.w-80)/2+80+self.padding);
  self.dontShowAgainCheckBox:SetSize(self.w-80/2-2*self.padding,20);
  self.dontShowAgainCheckBox:SetFont(Turbine.UI.Lotro.Font.Verdana10);
  self.dontShowAgainCheckBox:SetText(L.DoNotShowHintInFuture);
  self.dontShowAgainCheckBox:SetChecked(true);
  
  Misc.DetermineLength(text,Turbine.UI.Lotro.Font.TrajanPro13,TutorialHint.Display,self,self.w-2*self.padding,true);
end

function TutorialHint:Display(dimensions)
  local w = dimensions[1];
  local h = dimensions[2];
  
  self.label:SetHeight(h);
  
  self.image:SetTop(self.label:GetTop()+h+10);
  
  self.okButton:SetTop(self.image:GetTop()+self.iconH+2);
  self.dontShowAgainCheckBox:SetTop(self.image:GetTop()+self.iconH+2);
  
  self:SetPosition((Turbine.UI.Display.GetWidth()*3/4)-self.w/2,Turbine.UI.Display.GetHeight()/2);
  self:SetSize(self.w,self.label:GetTop()+h+self.iconH+42);
  self:SetVisible(true);
end
