
--[[

A Combat Analysis Tree Panel contains a Tree View with
a scrollable bar. It expects to have Combat Analysis
Tree Nodes added, which mimic the LOTRO tree style.

]]--


_G.CombatAnalysisTreePanel = class(Turbine.UI.Control);

-- configuration parameters
CombatAnalysisTreePanel.indentationWidth = 16;
CombatAnalysisTreePanel.treeNodePadding = 2;
CombatAnalysisTreePanel.valueLabelWidth = 50;
CombatAnalysisTreePanel.minLabelWidth = 42;

function CombatAnalysisTreePanel:Constructor(indentationWidth,fullScrollbar,paddingLeft,paddingTop,paddingRight,paddingBottom)
	Turbine.UI.Control.Constructor(self);
	
  self.fullScrollbar = fullScrollbar;
  self.indentationWidth = (indentationWidth or CombatAnalysisTreePanel.indentationWidth);
  self.paddingLeft = (paddingLeft or 0);
  self.paddingTop = (paddingTop or self.paddingLeft);
  self.paddingRight = (paddingRight or self.paddingTop);
  self.paddingBottom = (paddingBottom  or self.paddingRight);
  
	self.treeView = Turbine.UI.TreeView();
	self.treeView:SetParent(self);
  self.treeView:SetPosition(self.paddingLeft,self.paddingTop);
	self.treeView:SetIndentationWidth(self.indentationWidth);
	self.treeView:SetMouseVisible(false);

	-- Give the tree view a scroll bar.
	self.scrollBar = Turbine.UI.Lotro.ScrollBar();
	self.scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.scrollBar:SetParent(self);
	self.scrollBar:SetTop(paddingTop or 1);
	self.scrollBar:SetWidth(10);
	
	self.treeView:SetVerticalScrollBar(self.scrollBar);
	
	self.rootNodes = self.treeView:GetNodes();
end

function CombatAnalysisTreePanel:Layout()
	local w,h = self:GetSize();
	
	self.treeView:SetSize(w-self.paddingLeft-self.paddingRight-10,h-self.paddingTop-self.paddingBottom);
	self.scrollBar:SetLeft(w-10-self.paddingLeft-self.paddingRight);
	self.scrollBar:SetHeight(h-(self.fullScrollbar and 0 or 14)-self.paddingTop-self.paddingBottom);
	self:DepthFirstTraversal(CombatAnalysisTreePanel.LayoutNode);
end

function CombatAnalysisTreePanel:LayoutNode(node,depth)
	local w = self:GetWidth();
	
	node:SetWidth(w-(self.fullScrollbar and 10 or 0)-4*self.paddingRight-(depth-1)*self.indentationWidth);
	node:Layout();
end

function CombatAnalysisTreePanel:DepthFirstTraversal(operation)
	-- traverse children
	for i=1,self.rootNodes:GetCount() do
		self:DepthFirstTraversalInternal(operation,self.rootNodes:Get(i),1);
	end
end

function CombatAnalysisTreePanel:DepthFirstTraversalInternal(operation,node,depth)
	-- perform operation on node
	operation(self,node,depth);
	-- traverse children
	local children = node:GetChildNodes();
	for i=1,children:GetCount() do
		self:DepthFirstTraversalInternal(operation,children:Get(i),depth+1);
	end
end
