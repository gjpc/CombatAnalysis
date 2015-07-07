
--[[
	
	A non-resizable LOTRO Window (Dialog) with no title bar.
	
	Note this class is forced to be a singleton, to ensure there
	can only be one confirm dialog open at once.
	
]]--

local Dialog = class(Turbine.UI.Window);

function Dialog:Constructor(text)
	Turbine.UI.Window.Constructor(self);
	
	-- top left corner
	self.topLeft = Turbine.UI.Control();
	self.topLeft:SetParent(self);
	self.topLeft:SetSize(36,36);
	self.topLeft:SetZOrder(-1);
	self.topLeft:SetMouseVisible(false);
	self.topLeft:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.topLeft:SetBackground("CombatAnalysis/Resources/box_silver_upper_left.tga");

	-- topRight
	self.topRight = Turbine.UI.Control();
	self.topRight:SetParent(self);
	self.topRight:SetSize(36,36);
	self.topRight:SetZOrder(-1);
	self.topRight:SetMouseVisible(false);
	self.topRight:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.topRight:SetBackground("CombatAnalysis/Resources/box_silver_upper_right.tga");
	
	-- bottomLeft
	self.bottomLeft = Turbine.UI.Control();
	self.bottomLeft:SetParent(self);
	self.bottomLeft:SetSize(36,36);
	self.bottomLeft:SetZOrder(-1);
	self.bottomLeft:SetMouseVisible(false);
	self.bottomLeft:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.bottomLeft:SetBackground("CombatAnalysis/Resources/box_silver_bottom_left.tga");

	-- bottomRight
	self.bottomRight = Turbine.UI.Control();
	self.bottomRight:SetParent(self);
	self.bottomRight:SetSize(36,36);
	self.bottomRight:SetZOrder(-1);
	self.bottomRight:SetMouseVisible(false);
	self.bottomRight:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.bottomRight:SetBackground("CombatAnalysis/Resources/box_silver_lower_right.tga");

	-- top side
	self.top = Turbine.UI.Control();
	self.top:SetParent(self);
	self.top:SetSize(36,36);
	self.top:SetZOrder(-1);
	self.top:SetMouseVisible(false);
	self.top:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.top:SetBackground("CombatAnalysis/Resources/box_silver_upper.tga");

	-- left side
	self.left = Turbine.UI.Control();
	self.left:SetParent(self);
	self.left:SetSize(36,36);
	self.left:SetZOrder(-1);
	self.left:SetMouseVisible(false);
	self.left:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.left:SetBackground("CombatAnalysis/Resources/box_silver_side_left.tga");

	-- right side
	self.right = Turbine.UI.Control();
	self.right:SetParent(self);
	self.right:SetSize(36,36);
	self.right:SetZOrder(-1);
	self.right:SetMouseVisible(false);
	self.right:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.right:SetBackground("CombatAnalysis/Resources/box_silver_side_right.tga");
	
	-- bottom side
	self.bottom = Turbine.UI.Control();
	self.bottom:SetParent(self);
	self.bottom:SetSize(36,36);
	self.bottom:SetZOrder(-1);
	self.bottom:SetMouseVisible(false);
	self.bottom:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.bottom:SetBackground("CombatAnalysis/Resources/box_silver_bottom.tga");
	
	-- center
	self.center = Turbine.UI.Control();
	self.center:SetParent(self);
	self.center:SetZOrder(-1);
	self.center:SetMouseVisible(false);
	self.center:SetBackColor(Turbine.UI.Color(.925, 0, 0, 0));
	
	-- label
	self.label = Turbine.UI.Label();
	self.label:SetParent(self);
	self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro18);
	self.label:SetForeColor(controlYellowColor);
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.label:SetMouseVisible(false);
	
	-- yes/ok button (info/confirm/option dialog)
	self.yesButton = Turbine.UI.Lotro.Button();
	self.yesButton:SetParent(self);
	self.yesButton:SetSize(106,25);
	self.yesButton:SetText(L.Yes);
	self.yesButton.MouseClick = function(sender,args)
		self:Close();
		
    if (self.listenerFunction) then
      if (self.listenerParameter) then
        self.listenerFunction(self.listenerParameter,true);
      else
        self.listenerFunction(true);
      end
    end
	end
	
	-- no button (confirm/option dialog)
	self.noButton = Turbine.UI.Lotro.Button();
	self.noButton:SetParent(self);
	self.noButton:SetSize(106,25);
	self.noButton:SetText(L.No);
	self.noButton.MouseClick = function(sender,args)
		self:Close();
		
		if (self.listenerParameter) then
			self.listenerFunction(self.listenerParameter,false);
		else
			self.listenerFunction(false);
		end
	end
	
	-- cancel button (option dialog)
	self.cancelButton = Turbine.UI.Lotro.Button();
	self.cancelButton:SetParent(self);
	self.cancelButton:SetSize(106,25);
	self.cancelButton:SetText(L.Cancel);
	self.cancelButton.MouseClick = function(sender,args)
		self:Close();
	end
	
	-- center on screen & position all elements
	self.defaultWidth = 512;
	self.defaultHeight = 192;
  
	self:SetSize(self.defaultWidth,self.defaultHeight);
end

function Dialog:KeyDown(args)
	-- do not respond to the key event that was potentially used to show this dialog
	if (DialogManager.timestamp == Turbine.Engine.GetGameTime()) then
		return;
	end

	-- yes on enter
	if (args.Action == 162) then
		if (self.dialogType == "confirm" or self.dialogType == "confirmCancel" or self.dialogType == "info") then
			self.yesButton:MouseClick();
      KeyManager.TakeFocus();
		end
	-- no/cancel on escape
	elseif (args.Action == 145) then
		if (self.dialogType == "option") then
			self.cancelButton:MouseClick();
		elseif (self.dialogType == "confirm" or self.dialogType == "confirmCancel") then
			self.noButton:MouseClick();
		else
			self:Close();
		end
	end
end

function Dialog:Close()
  if (self.content) then
    self.content:SetParent(nil);
    self.content = nil;
  end
  
	DialogManager.HideDialog(self);
end

function Dialog:SetSize(width,height)
	Turbine.UI.Window.SetSize(self,width,height);
	self:Layout();
end

function Dialog:Layout()
	local w,h = self:GetSize();
  
  local offset = 20;
	
  self:SetPosition((Turbine.UI.Display.GetWidth()-w)/2,(Turbine.UI.Display.GetHeight()-20-h)/2);
	
	self.topLeft:SetPosition(0, offset);
	self.top:SetPosition(36, offset);
	self.topRight:SetPosition(w - 36, offset);
	self.bottomLeft:SetPosition(0, h - 36);
	self.bottom:SetPosition(36, h - 36);
	self.bottomRight:SetPosition(w - 36, h - 36);
	self.left:SetPosition(0, 36 + offset);
	self.right:SetPosition(w - 36, 36 + offset);
	self.center:SetPosition(36, 36 + offset);
	
	self.top:SetWidth(w - 72);
	self.bottom:SetWidth(w - 72);
	self.left:SetHeight(h - 72 - offset);
	self.right:SetHeight(h - 72 - offset);
	self.center:SetSize(w - 72, h - 72 - offset);
  
  self.cancelButton:SetPosition(w/2 + 60, h - 40);
  
  self.label:SetPosition(40, 60);
	self.label:SetSize(w - 80, h - 105);
  
	if (self.dialogType == "option") then
		self.yesButton:SetVisible(true);
		self.noButton:SetVisible(true);
		self.cancelButton:SetVisible(true);
		
		self.yesButton:SetPosition(w/2-166,h-40);
		self.noButton:SetPosition(w/2-53,h-40);
		
	elseif (self.dialogType == "confirm" or self.dialogType == "confirmCancel") then
		self.yesButton:SetVisible(true);
		self.noButton:SetVisible(true);
		self.cancelButton:SetVisible(false);
		
		self.yesButton:SetText(L.Yes);
		self.noButton:SetText(self.dialogType == "confirm" and L.No or L.Cancel);
		
		self.yesButton:SetPosition(w/2-112,h-(self.custom and 40 or 31));
		self.noButton:SetPosition(w/2+7,h-(self.custom and 40 or 31));
		
	else
		self.yesButton:SetVisible(true);
		self.noButton:SetVisible(false);
		self.cancelButton:SetVisible(false);
		
		self.yesButton:SetText(L.OK);
		
		self.yesButton:SetPosition(w/2-53,h-(self.custom and 40 or 31));
		
	end
end

-- Show Dialog functions

local function ShowDialog(text)
	dialog.label:SetText(text);
	dialog:Layout();
	
	DialogManager.ShowDialog(dialog);
end

-- Shows an option dialog with the specified options and a callback function
function Dialog:ShowOptionDialog(text,yesOption,noOption,listenerFunction,listenerParameter)
	self.dialogType = "option";
  self.custom = false;
  self:SetSize(self.defaultWidth,self.defaultHeight);
  
	self.yesButton:SetText(yesOption);
	self.noButton:SetText(noOption);
	
	self.listenerFunction = listenerFunction;
	self.listenerParameter = listenerParameter;
	
	ShowDialog(text);
end

-- Shows a confirm dialog with yes/no options and a callback function
function Dialog:ShowConfirmDialog(text,listenerFunction,listenerParameter)
	self.dialogType = "confirm";
  self.custom = false;
  self:SetSize(self.defaultWidth,self.defaultHeight);
	
	self.listenerFunction = listenerFunction;
	self.listenerParameter = listenerParameter;
	
	ShowDialog(text);
end

-- Shows an info dialog with an ok option and no callback
function Dialog:ShowInfoDialog(text)
	self.dialogType = "info";
  self.custom = false;
  self:SetSize(self.defaultWidth,self.defaultHeight);
  
  self.listenerFunction = nil;
	
	ShowDialog(text);
end

-- Shows a custom dialog with the specified content area
function Dialog:ShowCustomDialog(content,width,height,dialogType,listenerFunction,listenerParameter)
	self.dialogType = (dialogType or "info");
  self.custom = true;
  self:SetSize(width,height);
  
  self.content = content;
	
  self.listenerFunction = listenerFunction;
  self.listenerParameter = listenerParameter;
  
  content:SetParent(self);
  content:SetPosition(36,36);
  content:SetSize(width-72,height-72);
  if (content.Layout) then content:Layout() end
  
	ShowDialog("");
end

_G.dialog = Dialog();
