
local FileNotificationIcon = class(Turbine.UI.Window());

FileNotificationIcon.frames = 12;
FileNotificationIcon.animationSpeed = 0.8;

function FileNotificationIcon:Constructor()
	Turbine.UI.Window.Constructor(self);
	
	local x,y = Turbine.UI.Display.GetSize();
	
	self:SetSize(128,128);
	self:SetPosition((x-128)/2,((y-128)/2)-100);
	
	self:SetMouseVisible(false);
	
	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetPosition(0,0);
	self.text:SetSize(128,118);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetForeColor(Turbine.UI.Color(0.55,0.55,0.88));
	self.text:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.text:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.text:SetMouseVisible(false);
	
	self.icon = Turbine.UI.Control();
	self.icon:SetParent(self);
	self.icon:SetPosition(0,113);
	self.icon:SetSize(128,15);
	self.icon:SetMouseVisible(false);
	
	self.icon.Update = function()
		local count = Misc.Round(((Turbine.Engine.GetGameTime()-self.startTime)%FileNotificationIcon.animationSpeed)*((FileNotificationIcon.frames+1)/FileNotificationIcon.animationSpeed));
		
		if (count ~= self.count) then
			self.count = count;
			self.icon:SetBackground("CombatAnalysis/Resources/load_animation_"..(self.count == (FileNotificationIcon.frames+1) and 1 or self.count+1)..".tga");
		end
	end
	
	self.combines = 0;
	self.saves = 0;
	self.loads = 0;
	
	self.prevTimestamp = 0;
end

function FileNotificationIcon:CombineStart()
	self.combines = self.combines+1;
	self:UpdateText();
	if (self.combines == 1 and self.saves == 0 and self.loads == 0) then self:Start() end
end

function FileNotificationIcon:SaveStart()
	self.saves = self.saves+1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 1 and self.loads == 0) then self:Start() end
end

function FileNotificationIcon:LoadStart()
	self.loads = self.loads+1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 1) then self:Start() end
end

function FileNotificationIcon:CombineEnd()
	self.combines = self.combines-1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 0) then self:Stop() end
end

function FileNotificationIcon:SaveEnd()
	self.saves = self.saves-1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 0) then self:Stop() end
end

function FileNotificationIcon:LoadEnd()
	self.loads = self.loads-1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 0) then self:Stop() end
end

function FileNotificationIcon:UpdateText()
	local text = "";
	if (self.combines > 0) then text = text .. self.combines .. "x " .. L.Combine .. (self.combines > 1 and "s" or "") .. "\n" end
	if (self.saves > 0) then text = text .. self.saves .. "x " .. L.Save .. (self.saves > 1 and "s" or "") .. "\n" end
	if (self.loads > 0) then text = text .. self.loads .. "x " .. L.Load .. (self.loads > 1 and "s" or "") .. "\n" end
	
	self:SetVisible(false);
	self.text:SetText(text);
	self:SetVisible(true);
end

function FileNotificationIcon:Start()
	self.startTime = Turbine.Engine.GetGameTime();
	
	self.icon:SetWantsUpdates(true);
	self:SetVisible(true);
end

function FileNotificationIcon:Stop()
	self.icon:SetWantsUpdates(false);
	self:SetVisible(false);
end

_G.fileNotificationIcon = FileNotificationIcon();
