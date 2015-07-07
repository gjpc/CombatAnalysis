
_G.KeyManager = {}

-- control to get global key events
keyManager = Turbine.UI.Window();
keyManager:SetPosition(-10,-10);
keyManager:SetSize(5,5);
keyManager:SetVisible(true);
keyManager:SetWantsKeyEvents(true);

_G.uiHidden = false;
_G.uiLocked = false;

-- currently just check for F12 (hide all UI elements)
keyManager.KeyDown = function(sender,args)
	if (args.Action == 0x100000B3) then
    uiHidden = not uiHidden;
		WindowManager.ShowHideWindows(nil, false, uiHidden, keyManager);
    Misc.NotifyListeners(nil, "UIHidden", uiHidden);
  elseif (args.Action == 0x1000007B) then
    uiLocked = not uiLocked;
    Misc.NotifyListeners(nil, "UILocked", uiLocked);
    cursorMove:SetVisible(false);
    cursorMove:SetWantsUpdates(false);
	end
end



-- a very hacky way to steal focus from any element, by:
--   > frame 1: activating an off-screen window
--   > giving control to an invisible text box in that window
--   > frame 2: removing the text box from the window in the next frame so it immediately loses focus (but the window keeps focus so it doesn't bounce back to the original control)
--   > frame 3: restoring the text box back to the window in the 3rd frame so that it can be used to steal focus again

keyManager.focusTextBox = Turbine.UI.TextBox();
keyManager.focusTextBox:SetParent(keyManager);
keyManager.focusTextBox:SetVisible(false);

function KeyManager.TakeFocus(control)
  if (keyManager.inProgress) then return end
  
  -- frame 1
  keyManager.inProgress = true;
  if (control ~= nil) then
    keyManager.focusTextBox:SetParent(control);
  else
    keyManager:Activate();
  end
	keyManager.focusTextBox:Focus();
  keyManager.focusGrabbedAt = Turbine.Engine.GetGameTime();
  keyManager:SetWantsUpdates(true);
end

keyManager.Update = function()
  -- frame 3
  if (keyManager.focusTextboxNeedsRestoring) then
    keyManager.focusTextboxNeedsRestoring = nil;
    keyManager.focusTextBox:SetParent(keyManager);
    keyManager:SetWantsUpdates(false);
    keyManager.inProgress = false;
  -- frame 2
  elseif (keyManager.focusGrabbedAt ~= Turbine.Engine.GetGameTime()) then
    keyManager.focusGrabbedAt = nil;
    keyManager.focusTextboxNeedsRestoring = true;
    keyManager.focusTextBox:SetParent(nil);
  end
end

