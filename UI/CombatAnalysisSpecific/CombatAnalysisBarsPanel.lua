
--[[

A Combat Analysis Bars Panel is a scrollable list of
Combat Analysis Bars, whose lengths are determined by
the relative values of each bar.

]]--


_G.CombatAnalysisBarsPanel = class(Turbine.UI.Control);

CombatAnalysisBarsPanel.barThickness = 18;
CombatAnalysisBarsPanel.valueTextLength = 52;

function CombatAnalysisBarsPanel:Constructor()
	Turbine.UI.Control.Constructor(self);
	
	self.bars = {};
	
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self);
	self.listBox:SetPosition(CombatAnalysisWindow.border,CombatAnalysisWindow.border);
	self.listBox:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.listBox:SetMaxItemsPerLine(1);
	self.listBox.MouseDown = function(sender,args)
		self:MouseDown(args);
	end
	self.listBox.MouseClick = function(sender,args)
		self:MouseClick(args);
	end
	self.listBox.MouseDoubleClick = function(sender,args)
		self:MouseClick(args);
	end
	
	self.scrollBar = Turbine.UI.Lotro.ScrollBar();
	self.scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.scrollBar:SetParent(self);
	
	self.listBox:SetVerticalScrollBar(self.scrollBar);
end

function CombatAnalysisBarsPanel:Layout()
	local w,h = self:GetSize();
	
	self.listBox:SetSize(w-10-CombatAnalysisWindow.border,h-2*CombatAnalysisWindow.border);
	self.scrollBar:SetPosition(w-10-CombatAnalysisWindow.border,CombatAnalysisWindow.border);
	self.scrollBar:SetSize(10,h-CombatAnalysisWindow.border);
	
	for i=1,self.listBox:GetItemCount() do
		self.listBox:GetItem(i):SetWidth(w-10-CombatAnalysisWindow.border);
		self.listBox:GetItem(i):Layout();
	end
end

function CombatAnalysisBarsPanel:UpdateColor(color)
  self.backColor = color;
end

function CombatAnalysisBarsPanel:Clear()
	for i=1,self.listBox:GetItemCount() do
		self.bars[i]:Clear();
	end
	self.listBox:ClearItems();
end

-- add a new bar to the panel - bar is expected to be of the type CombatAnalysisBar
function CombatAnalysisBarsPanel:AddBar(bar)
	table.insert(self.bars,bar);
	self:RestoreBar(#self.bars);
end

-- restore a bar from the bars list by adding it to the listbox and laying it out accordingly
function CombatAnalysisBarsPanel:RestoreBar(index)
	self.listBox:AddItem(self.bars[index]);
	self.bars[index]:SetWidth(self.listBox:GetWidth());
	self.bars[index]:Layout();
end

-- ensure mouse events activate window
function CombatAnalysisBarsPanel:MouseDown(args)
	WindowManager.MouseWasPressed(self.tab.window);
end
