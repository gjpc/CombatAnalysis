
--[[

A Stat Overview Tree Node is a Combat Analysis Tree Node
that includes color overlays for headers.

Additionally, functions are included to update the value
data in these nodes.

]]--

_G.StatOverviewTreeNode = class(CombatAnalysisTreeNode);

function StatOverviewTreeNode:Constructor(panel,depth,text,hasChildren)
	CombatAnalysisTreeNode.Constructor(self,panel,depth,text,hasChildren);
	
	if (self.depth == 1) then
		self.colorOverlay = Turbine.UI.Control();
		self.colorOverlay:SetParent(self);
		self.colorOverlay:SetLeft(16);
		self.colorOverlay:SetHeight(16);
		self.colorOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
		self.colorOverlay:SetMouseVisible(false);
	end
end

function StatOverviewTreeNode:Layout()
	CombatAnalysisTreeNode.Layout(self);
	
	if (self.depth == 1) then
		local w = self:GetWidth();
		self.colorOverlay:SetWidth(w-16);
	end
end

function StatOverviewTreeNode:UpdateColor(color)
  self.colorOverlay:SetBackColor(color);
end

function StatOverviewTreeNode:UpdateData(value1Text,value2Text)

	self.value1:SetFont(_G.statFont);
	self.value2:SetFont(_G.statFont);
	self.label:SetFont(_G.statFont);
	
	self.value1:SetText(value1Text);
	
	if (value2Text ~= nil) then
		self.value2:SetText(value2Text);
	end
end

function StatOverviewTreeNode:ClearData()
	self.value1:SetText("");
	self.value2:SetText("");
end
