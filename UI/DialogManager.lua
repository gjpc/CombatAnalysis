
--[[

A couple of Static Dialog Helper Functions.

Most notably the screen is darkened when any Dialog windows
are opened. The screen darkening is always applied to one lower
z-order than the highest z-order Dialog that is currently open.

]]--

_G.DialogManager = {}

DialogManager.openDialogs = {};

-- hidden window to blacken out background & block all mouse events outside this window (since we cant hold focus)
DialogManager.dialogShader = Turbine.UI.Window();
DialogManager.dialogShader:SetSize(Turbine.UI.Display.GetWidth(),Turbine.UI.Display.GetHeight());
DialogManager.dialogShader:SetBackColor(Turbine.UI.Color(0.5,0,0,0));
DialogManager.dialogShader:SetMouseVisible(true);

function DialogManager.ShowDialog(dialog)
	if (dialog:IsVisible()) then return end
	
	-- timestamp
	DialogManager.timestamp = Turbine.Engine.GetGameTime();
	
	-- prevent dialogs in the background from responding to further key events
	if (#DialogManager.openDialogs > 0) then
		DialogManager.openDialogs[#DialogManager.openDialogs]:SetWantsKeyEvents(false);
	end
	
	-- set up the new dialog
	table.insert(DialogManager.openDialogs,dialog);
	(dialog.hidden or dialog):SetZOrder(#DialogManager.openDialogs*2);
	dialog:SetWantsKeyEvents(true);
	
	-- set the position of the shading
	DialogManager.dialogShader:SetZOrder(#DialogManager.openDialogs*2-1);
	DialogManager.dialogShader:SetVisible(true);
	
	-- show the dialog
	dialog:SetVisible(true);
end

function DialogManager.HideDialog(dialog)
	-- timestamp
	DialogManager.timestamp = Turbine.Engine.GetGameTime();
	
	-- check to make sure it is the last dialog that has been closed
	--   if not, we have to take special care
	local dialogIndex;
	for index,openDialog in ipairs(DialogManager.openDialogs) do
		if (dialogIndex ~= nil) then
			(openDialog.hidden or openDialog):SetZOrder(2*(index-1));
		elseif (openDialog == dialog) then
			dialogIndex = index;
		end
	end
	
	-- remove the dialog
	table.remove(DialogManager.openDialogs,dialogIndex);
	dialog:SetWantsKeyEvents(false);
	dialog:SetVisible(false);
	
	-- set the position of the shading (behind the next dialog)
	if (#DialogManager.openDialogs == 0) then
		DialogManager.dialogShader:SetVisible(false);
	else
		DialogManager.dialogShader:SetZOrder(2*#DialogManager.openDialogs-1);
		DialogManager.openDialogs[#DialogManager.openDialogs]:SetWantsKeyEvents(true);
	end
end
