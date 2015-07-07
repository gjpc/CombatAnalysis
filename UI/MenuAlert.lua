
_G.MenuAlert = class(Turbine.UI.Window);

function MenuAlert:Constructor(text)
	Turbine.UI.Window.Constructor(self);
	
	
end

function MenuAlert:Layout()
	
end

function MenuAlert:SetSize(width,height)
	Turbine.UI.Window.SetSize(self,width,height);
	self:Layout();
end
