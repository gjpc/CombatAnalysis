
--[[

A Combat Analysis Tree Node mimics the LOTRO tree
node style, but with some slight differences to keep
the Combat Analysis look & feel consistent.

If at depth 1, the node styles itself as a header node
(note that the default header color is gray - use color
overlays to change this).

If the node has children, it includes an expand/collapse
item.

Tree Nodes also include three labels. The standard
display label and (up to) two value labels.

]]--

_G.CombatAnalysisTreeNode = class(Turbine.UI.TreeNode);

function CombatAnalysisTreeNode:Constructor(panel,depth,text,hasChildren)
	Turbine.UI.TreeNode.Constructor(self);
	
	self.panel = panel;
	self.depth = depth;
	
	self:SetHeight(16);
	
	if (self.depth == 1) then
		self:SetBackground("CombatAnalysis/Resources/box_treelist_header_Gray.tga");
	end
	
	if (hasChildren) then
		self.icon = Turbine.UI.Control();
		self.icon:SetParent(self);
		self.icon:SetSize(16,16);
		self.icon:SetBackground(0x41007E26);
		self.icon:SetMouseVisible(false);
	end
	
	self.label = Turbine.UI.Label();
	self.label:SetParent(self);
	self.label:SetZOrder(2);
	self.label:SetLeft(self.icon and 27 or 10);
	self.label:SetHeight(16);
	self.label:SetMouseVisible(false);
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.label:SetMultiline(false);
	if (hasChildren) then
		self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		self.label:SetForeColor(control2Color);
		self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	else
		self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	end
		
	self.label:SetText(text);
	
	-- value 1 (the actual value)
	self.value1 = Turbine.UI.Label();
	self.value1:SetParent(self);
	self.value1:SetZOrder(3);
	self.value1:SetSize(CombatAnalysisTreePanel.valueLabelWidth,16);
	self.value1:SetMouseVisible(false);
	self.value1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.value1:SetMultiline(false);
	self.value1:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	
	-- value 2 (the percentage value, where applicable)
	self.value2 = Turbine.UI.Label();
	self.value2:SetParent(self);
	self.value2:SetZOrder(1);
	self.value2:SetHeight(16);
	self.value2:SetMouseVisible(false);
	self.value2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.value2:SetMultiline(false);
	self.value2:SetFont(Turbine.UI.Lotro.Font.Verdana12);
end

function CombatAnalysisTreeNode:Layout()
	local w = self:GetWidth();
	
	if (self.icon) then
		self.label:SetWidth(math.max(0,w-27));
		self.value2:SetWidth(CombatAnalysisTreePanel.valueLabelWidth);
	elseif (w < 25+CombatAnalysisTreePanel.minLabelWidth+2*CombatAnalysisTreePanel.valueLabelWidth+6*CombatAnalysisTreePanel.treeNodePadding-(self.depth-1)*CombatAnalysisTreePanel.indentationWidth) then
		self.label:SetWidth(math.max(0,w-(25+CombatAnalysisTreePanel.valueLabelWidth+6*CombatAnalysisTreePanel.treeNodePadding)));
		self.value2:SetWidth(0);
	else
		self.label:SetWidth(math.max(0,w-(25+2*CombatAnalysisTreePanel.valueLabelWidth+6*CombatAnalysisTreePanel.treeNodePadding)));
		self.value2:SetWidth(CombatAnalysisTreePanel.valueLabelWidth);
	end
	
	self.value1:SetLeft(w-10-CombatAnalysisTreePanel.valueLabelWidth-CombatAnalysisTreePanel.treeNodePadding);
	self.value2:SetLeft(w-10-2*CombatAnalysisTreePanel.valueLabelWidth-2*CombatAnalysisTreePanel.treeNodePadding);
end

-- we update the parent's expand/collapse icons on visible changed of its children since mouse events seem to come one frame too late
function CombatAnalysisTreeNode:VisibleChanged(sender,args)
	local parent = self:GetParentNode();
	-- check against if we think the parent is already expanded to avoid extra processing
	if (parent ~= nil and parent.expanded ~= parent:IsExpanded()) then
		parent.expanded = parent:IsExpanded();
		parent.icon:SetBackground(parent.expanded and 0x41007E26 or 0x41007E27);
    if (combatAnalysisLoaded) then self.panel.tab:SaveState() end
	end
end

-- we also override the set expanded method directly (which is called when the tree is expanded/collapsed from the settings)
function CombatAnalysisTreeNode:SetExpanded(expand)
	self.expanded = expand;
	
	Turbine.UI.TreeNode.SetExpanded(self,expand);
	self.icon:SetBackground(self.expanded and 0x41007E26 or 0x41007E27);
end

function CombatAnalysisTreeNode:SetText(text)
	self.label:SetText(text);
end

function CombatAnalysisTreeNode:MouseDown(args)
	WindowManager.MouseWasPressed(self.panel);
end
