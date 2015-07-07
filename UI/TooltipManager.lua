

_G.TooltipManager = {}

TooltipManager.tooltipDelay = 0;

function TooltipManager.SetTooltip(control,text,style,maxWidth,height)
  if (height == nil) then
    Misc.DetermineLength(text,
      (style == TooltipStyle.LOTRO and Turbine.UI.Lotro.Font.TrajanPro16 or (style == TooltipStyle.Menu and Turbine.UI.Lotro.Font.TrajanPro14 or Turbine.UI.Lotro.Font.TrajanPro15)),
      nil,nil,maxWidth);
  end
  
  control.ShowTooltip = function(sender,timestamp,viaMouseUp)
    control.tooltipPending = false;
    -- tooltips should only be shown if the mouse is still in the control, and it isn't being dragged
    if (control.tooltipMouseIn and (viaMouseUp or not control.dragging)) then
      local x,y = control:PointToScreen(control:GetMousePosition());
      control.tooltip = Tooltip(text,style,maxWidth,nil,x+32,y+32,nil,nil,nil,nil,height);
    end
  end
  
  local function StartCooldown(viaMouseUp)
    if (control.tooltipPending) then return end
    
    control.tooltipPending = true;
    if (TooltipManager.tooltipDelay >= 0) then
      Misc.StartTimer(viaMouseUp,Turbine.Engine.GetGameTime(),TooltipManager.tooltipDelay,control.ShowTooltip,control)
    else
      control:ShowTooltip(viaMouseUp);
    end
  end
  
  Misc.AddCallback(control, "MouseEnter", function(sender,args)
    control.tooltipMouseIn = true;
    StartCooldown(false);
  end);
  
  Misc.AddCallback(control, "MouseLeave", function(sender,args)
    control.tooltipMouseIn = false;
    
    if (control.tooltip ~= nil) then
      control.tooltip:Close();
      control.tooltip = nil;
    end
  end);
  
  -- handle tooltip appearing after dragging
  Misc.AddCallback(control, "MouseUp", function(sender,args)
    if (control.tooltipMouseIn and control.tooltip == nil) then
      StartCooldown(true);
    end
  end);
  
end
