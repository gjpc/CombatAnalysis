
--[[ A series of custom "resize" cursors that will follow the true cursor location ]]--

-- horizontal cursor
_G.cursorHorizontal = Turbine.UI.Window();
cursorHorizontal:SetMouseVisible(false);
cursorHorizontal:SetZOrder(100);
cursorHorizontal:SetBackground("CombatAnalysis/Resources/cursor_horizontal.tga");
cursorHorizontal:SetSize(31,10);
function cursorHorizontal:Update()
	x,y = Turbine.UI.Display.GetMousePosition();
	cursorHorizontal:SetPosition(x-cursorHorizontal:GetWidth()/2,y-cursorHorizontal:GetHeight()/2);
end

-- vertical cursor
_G.cursorVertical = Turbine.UI.Window();
cursorVertical:SetMouseVisible(false);
cursorVertical:SetZOrder(100);
cursorVertical:SetBackground("CombatAnalysis/Resources/cursor_vertical.tga");
cursorVertical:SetSize(10,30);
function cursorVertical:Update()
	x,y = Turbine.UI.Display.GetMousePosition();
	cursorVertical:SetPosition(x-cursorVertical:GetWidth()/2,y-cursorVertical:GetHeight()/2);
end

-- diagonal upward cursor
_G.cursorDiagonalUpward = Turbine.UI.Window();
cursorDiagonalUpward:SetMouseVisible(false);
cursorDiagonalUpward:SetZOrder(100);
cursorDiagonalUpward:SetBackground("CombatAnalysis/Resources/cursor_diagonal_upward.tga");
cursorDiagonalUpward:SetSize(23,23);
function cursorDiagonalUpward:Update()
	x,y = Turbine.UI.Display.GetMousePosition();
	cursorDiagonalUpward:SetPosition(x-cursorDiagonalUpward:GetWidth()/2,y-cursorDiagonalUpward:GetHeight()/2);
end

-- diagonal downward cursor
_G.cursorDiagonalDownward = Turbine.UI.Window();
cursorDiagonalDownward:SetMouseVisible(false);
cursorDiagonalDownward:SetZOrder(100);
cursorDiagonalDownward:SetBackground("CombatAnalysis/Resources/cursor_diagonal_downward.tga");
cursorDiagonalDownward:SetSize(22,23);
function cursorDiagonalDownward:Update()
	x,y = Turbine.UI.Display.GetMousePosition();
	cursorDiagonalDownward:SetPosition(x-cursorDiagonalDownward:GetWidth()/2,y-cursorDiagonalDownward:GetHeight()/2);
end

-- move cursor
_G.cursorMove = Turbine.UI.Window();
cursorMove:SetMouseVisible(false);
cursorMove:SetZOrder(100);
cursorMove:SetBackground(0x410000dd);
cursorMove:SetSize(32,32);
function cursorMove:Update()
	x,y = Turbine.UI.Display.GetMousePosition();
	cursorMove:SetPosition(x-cursorMove:GetWidth()/2,y-cursorMove:GetHeight()/2);
end
