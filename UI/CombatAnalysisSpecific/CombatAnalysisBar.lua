
--[[

A Combat Analysis Bar is a simple horizontal bar that
displays a (presumably name) label, and (up to) three other
values.

]]--


_G.CombatAnalysisBar = class(Turbine.UI.Control);

function CombatAnalysisBar:Constructor(panel,topBar)
	Turbine.UI.Control.Constructor(self);
	
	self.panel = panel;
	self.topBar = topBar;
	
	self.proportion = 1;
	
	self:SetParent(panel);
	self:SetHeight(CombatAnalysisBarsPanel.barThickness+CombatAnalysisWindow.border + (topBar and CombatAnalysisWindow.border or 0) + 1);
	
	self:SetMouseVisible(true);
	
	-- border
	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetHeight(CombatAnalysisBarsPanel.barThickness+CombatAnalysisWindow.border + (topBar and CombatAnalysisWindow.border or 0));
	self.border:SetBackColor(borderColor);
	self.border:SetMouseVisible(false);
	
	-- background
	self.background = Turbine.UI.Control();
	self.background:SetParent(self);
	self.background:SetPosition(CombatAnalysisWindow.border,topBar and CombatAnalysisWindow.border or 0);
	self.background:SetHeight(CombatAnalysisBarsPanel.barThickness);
	self.background:SetMouseVisible(false);
	self.background:SetZOrder(1);
	
	-- background underlay (for highlighting)
	self.backgroundUnderlay = Turbine.UI.Control();
	self.backgroundUnderlay:SetParent(self);
	self.backgroundUnderlay:SetPosition(CombatAnalysisWindow.border,topBar and CombatAnalysisWindow.border or 0);
	self.backgroundUnderlay:SetHeight(CombatAnalysisBarsPanel.barThickness);
	self.backgroundUnderlay:SetBackColor(Turbine.UI.Color(0,0,0,0));
	self.backgroundUnderlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.backgroundUnderlay:SetMouseVisible(false);
	self.backgroundUnderlay:SetZOrder(-1);
	
	-- label
	self.label = Turbine.UI.Label();
	self.label:SetParent(self);
	self.label:SetPosition(2*CombatAnalysisWindow.border,topBar and CombatAnalysisWindow.border or 0);
	self.label:SetHeight(CombatAnalysisBarsPanel.barThickness);
	self.label:SetFont(_G.statFont);
	self.label:SetForeColor(controlLightColor);
	self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.label:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.label:SetMultiline(false);
	self.label:SetMouseVisible(false);
	self.label:SetZOrder(2);
	
	-- value label 1
	self.value1 = Turbine.UI.Label();
	self.value1:SetParent(self);
	self.value1:SetTop(topBar and CombatAnalysisWindow.border or 0);
	self.value1:SetSize(CombatAnalysisBarsPanel.valueTextLength,CombatAnalysisBarsPanel.barThickness);
	self.value1:SetFont(_G.statFont);
	self.value1:SetForeColor(controlLightColor);
	self.value1:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.value1:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.value1:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter);
	self.value1:SetMultiline(false);
	self.value1:SetMouseVisible(false);
	self.value1:SetZOrder(3);
	
	-- value label 2
	self.value2 = Turbine.UI.Label();
	self.value2:SetParent(self);
	self.value2:SetTop(topBar and CombatAnalysisWindow.border or 0);
	self.value2:SetSize(CombatAnalysisBarsPanel.valueTextLength,CombatAnalysisBarsPanel.barThickness);
	self.value2:SetFont(_G.statFont);
	self.value2:SetForeColor(controlLightColor);
	self.value2:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.value2:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.value2:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter);
	self.value2:SetMultiline(false);
	self.value2:SetMouseVisible(false);
	self.value2:SetZOrder(3);

	-- value label 3
	self.value3 = Turbine.UI.Label();
	self.value3:SetParent(self);
	self.value3:SetTop(topBar and CombatAnalysisWindow.border or 0);
	self.value3:SetSize(CombatAnalysisBarsPanel.valueTextLength,CombatAnalysisBarsPanel.barThickness);
	self.value3:SetFont(_G.statFont);
	self.value3:SetForeColor(controlLightColor);
	self.value3:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.value3:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.value3:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter);
	self.value3:SetMultiline(false);
	self.value3:SetMouseVisible(false);
	self.value3:SetZOrder(3);
end

function CombatAnalysisBar:Layout()
	local w = self:GetWidth();

	self.label:SetFont(_G.statFont);
	self.label:SetText( self.label:GetText() );

	self.value1:SetFont(_G.statFont);
	self.value1:SetText( self.value1:GetText() );
	
	self.value2:SetFont(_G.statFont);
	self.value2:SetText( self.value2:GetText() );

	self.value3:SetFont(_G.statFont);
	self.value3:SetText( self.value3:GetText() );
	
	self.label:SetWidth(math.max(0,w-7*CombatAnalysisWindow.border-2*CombatAnalysisBarsPanel.valueTextLength));
	
	self.value3:SetLeft(w-CombatAnalysisWindow.border-CombatAnalysisBarsPanel.valueTextLength);
	self.value1:SetLeft(w-2*CombatAnalysisWindow.border-2*CombatAnalysisBarsPanel.valueTextLength);
	self.value2:SetLeft(w-3*CombatAnalysisWindow.border-3*CombatAnalysisBarsPanel.valueTextLength);
	
	self.backgroundUnderlay:SetWidth(w-2*CombatAnalysisWindow.border);
	
	w = math.max((self.proportion == 0 and 0 or CombatAnalysisWindow.border),Misc.Round(w*self.proportion));
	self.border:SetWidth(w);
	self.background:SetWidth(math.max(0,w-2*CombatAnalysisWindow.border));
end

function CombatAnalysisBar:UpdateColor(color)
  self.backColor = color;
  
  self.background:SetBackColor(self.backColor);
end

function CombatAnalysisBar:Clear()
	self.background:SetWidth(0);
end

function CombatAnalysisBar:SetProportion(proportion)
	self.proportion = proportion;
	
	local w = self:GetWidth();
	w = math.max((self.proportion == 0 and 0 or CombatAnalysisWindow.border),Misc.Round(w*self.proportion));
	self.border:SetWidth(w);
	self.background:SetWidth(math.max(0,w-2*CombatAnalysisWindow.border));
end

-- mouse events

function CombatAnalysisBar:MouseEnter(args)
	self.background:SetBackColor(Misc.Shade(Misc.ToGray(self.backColor.A+0.05,0.8,self.backColor,0.9),-4));
	self.backgroundUnderlay:SetBackColor(Turbine.UI.Color(0.15,0.5,0.5,0.5));
end

function CombatAnalysisBar:MouseLeave(args)
	self.background:SetBackColor(self.backColor);
	self.backgroundUnderlay:SetBackColor(Turbine.UI.Color(0,0,0,0));
end

function CombatAnalysisBar:MouseDown(args)
	WindowManager.MouseWasPressed(self.panel.tab.window);
end

function CombatAnalysisBar:MouseDoubleClick(args)
	self:MouseClick(args); -- pass on to mouse click which can be overridden by subclasses if desired
end
