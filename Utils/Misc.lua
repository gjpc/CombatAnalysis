
--[[

Miscellaneous functions, including:

- A simple math.round type function (avoids string conversion)
- A series of value-to-string type formatting functions
- A series of color manipulation functions
- A simple one-time timer class, with a creation order guarantee

]]--

_G.Misc = {}

-- MATH UTILS

function Misc.Round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- FORMATTING

-- NB: assumes a number equal or greater than 1,000
local function FormatNumber(number)
	number = Misc.Round(number);
	
	-- if the number is below 100,000 display it in full
	if (number < 100000) then
		return string.format("%d,%03d",number/1000,number%1000);
	end
	
	-- otherwise, for very large numbers, round them further (depending on the value)
	number = number/1000;
	local thousands = 1;
	while (number > 1000) do
		number = number/1000;
		thousands = thousands + 1;
		if (thousands > 3) then break end
	end
	
	return string.format("%#."..
		(number < 10 and 3 or (number < 100 and 2 or (number < 1000 and 1 or 0))).."f"..
		(thousands == 1 and L.Thousand or (thousands == 2 and L.Million or (thousands == 3 and L.Billion or L.Trillion))),
			number
	);
end

-- format a standard value
function Misc.FormatValue(value)
	local number = (value+0);
	
	-- if the number is below 10,000 display the full number with (up to) one decimal place
	value = Misc.Round(number,1);
	if (value < 1000) then
		return value;
	elseif (value < 10000) then
		return string.format("%d,%"..(value%1 == 0 and "03d" or "05.1f"),value/1000,value%1000);
	end
	
	-- display the number in the standard long format
	return FormatNumber(number);
end

-- format a "per second" value
function Misc.FormatPs(ps)
	local number = (ps+0);
	
	-- if the number is less than 10,000 display the number (always) rounded to one decimal
	ps = Misc.Round(number,1);
	if (ps < 1000) then
		return string.format("%#.1f",ps);
	elseif (ps < 10000) then
		return string.format("%d,%05.1f",ps/1000,ps%1000);
	end
	
	-- display the number in the standard long format
	return FormatNumber(ps);
end

-- format a "percentage"
function Misc.FormatPerc(perc,round100)
	perc = 100*perc;
	
	--  if the number is below 10,000%, we always round to one decimal place (unless specified not to when the value is exactly 100%)
	if (perc < 1000) then
		return (((perc+0) == 100 and round100) and "100%" or string.format("%.1f%%",perc));
	elseif (perc < 10000) then
		return string.format("%d,%03.1f%%",perc/1000,perc%1000);
	end
	
	-- display the number in standard long format followed by a % sign (TODO: will need to consider this case further at some point)
	return FormatNumber(perc).."%";
end

function Misc.NumberToMonth(number,short)
	if (number == 1)  then return (short and L.Jan[1] or L.Jan[2]) end
	if (number == 2)  then return (short and L.Feb[1] or L.Feb[2]) end
	if (number == 3)  then return (short and L.Mar[1] or L.Mar[2]) end
	if (number == 4)  then return (short and L.Apr[1] or L.Apr[2]) end
	if (number == 5)  then return (short and L.May[1] or L.May[2]) end
	if (number == 6)  then return (short and L.Jun[1] or L.Jun[2]) end
	if (number == 7)  then return (short and L.Jul[1] or L.Jul[2]) end
	if (number == 8)  then return (short and L.Aug[1] or L.Aug[2]) end
	if (number == 9)  then return (short and L.Sep[1] or L.Sep[2]) end
	if (number == 10) then return (short and L.Oct[1] or L.Oct[2]) end
	if (number == 11) then return (short and L.Nov[1] or L.Nov[2]) end
	if (number == 12) then return (short and L.Dec[1] or L.Dec[2]) end
  
  return nil;
end

function Misc.MonthToNumber(month,short)
	if (month == (short and L.Jan[1] or L.Jan[2])) then return 1  end
	if (month == (short and L.Feb[1] or L.Feb[2])) then return 2  end
	if (month == (short and L.Mar[1] or L.Mar[2])) then return 3  end
	if (month == (short and L.Apr[1] or L.Apr[2])) then return 4  end
	if (month == (short and L.May[1] or L.May[2])) then return 5  end
	if (month == (short and L.Jun[1] or L.Jun[2])) then return 6  end
	if (month == (short and L.Jul[1] or L.Jul[2])) then return 7  end
	if (month == (short and L.Aug[1] or L.Aug[2])) then return 8  end
	if (month == (short and L.Sep[1] or L.Sep[2])) then return 9  end
	if (month == (short and L.Oct[1] or L.Oct[2])) then return 10 end
	if (month == (short and L.Nov[1] or L.Nov[2])) then return 11 end
	if (month == (short and L.Dec[1] or L.Dec[2])) then return 12 end
  
  return nil;
end

-- format a date (format = dd mmm yyyy)
function Misc.FormatDate(lotroDate)
	return string.format("%02d",lotroDate.Day).." "..Misc.NumberToMonth(lotroDate.Month,true).." "..string.format("%04d",lotroDate.Year);
end

-- format a time
function Misc.FormatTime(lotroDate)
  -- format = [hh]:[mm]:[ss][am/pm]
  if (locale == "en") then
    return string.format("%02d",(lotroDate.Hour == 12 and 12 or lotroDate.Hour%12))..":"..string.format("%02d",lotroDate.Minute)..":"..string.format("%02d",lotroDate.Second)..(lotroDate.Hour>=12 and "pm" or "am");
  -- format = [hh]:[mm]:[ss] (24h)
  else
    return string.format("%02d",lotroDate.Hour)..":"..string.format("%02d",lotroDate.Minute)..":"..string.format("%02d",lotroDate.Second);
  end
end

-- format a date time (format = yyyymmdd_hhmmss)
function Misc.FormatDateTime(lotroDate)
  return string.format("%04d",lotroDate.Year).." "..string.format("%02d",lotroDate.Month).." "..string.format("%02d",lotroDate.Day).." "..string.format("%02d",lotroDate.Hour).." "..string.format("%02d",lotroDate.Minute).." "..string.format("%02d",lotroDate.Second);
end

-- format a duration (format = [m]m [ss]s) - if slim is true, and the duration is less than 1m, don't show the minutes
function Misc.FormatDuration(duration,slim)
	if (slim and duration/60 < 1) then
		return string.format("%.1f",duration%60)..L.SecondsAbbr;
	else
		return string.format("%d",duration/60)..L.MinutesAbbr.." "..string.format("%.1f",duration%60)..L.SecondsAbbr;
	end
end

-- determine which time is the minimum
function Misc.MinTime(time1,time2)
	if (time1.Year ~= time2.Year) then return (time1.Year < time2.Year and time1 or time2) end
	if (time1.Month ~= time2.Month) then return (time1.Month < time2.Month and time1 or time2) end
	if (time1.Day ~= time2.Day) then return (time1.Day < time2.Day and time1 or time2) end
	if (time1.Hour ~= time2.Hour) then return (time1.Hour < time2.Hour and time1 or time2) end
	if (time1.Minute ~= time2.Minute) then return (time1.Minute < time2.Minute and time1 or time2) end
	return (time1.Second < time2.Second and time1 or time2);
end

-- split a pascal cased string (ie: "PascalCased" ==> "Pascal Cased")
function Misc.SplitPascalCase(str)
  return string.sub(str,1,1)..string.sub(str,2):gsub("([A-Z])"," %1");
end

function Misc.ClassToIcon(class)
  if (class == "Burglar") then return 0x41007deb end
  if (class == "Captain") then return 0x41007de7 end
  if (class == "Champion") then return 0x41007dec end
  if (class == "Guardian") then return 0x41007de8 end
  if (class == "Hunter") then return 0x41007dea end
  if (class == "LoreMaster") then return 0x41007de9 end
  if (class == "Minstrel") then return 0x41007de6 end
  if (class == "RuneKeeper") then return "CombatAnalysis/Resources/runekeeper_icon_20.tga" end
  if (class == "Warden") then return "CombatAnalysis/Resources/warden_icon_20.tga" end
  if (class == "BlackArrow") then return 0x41007def end
  if (class == "Defiler") then return "CombatAnalysis/Resources/defiler_icon_20.tga" end
  if (class == "Reaver") then return 0x41007ded end
  if (class == "Stalker") then return 0x41007df1 end
  if (class == "WarLeader") then return 0x41007df0 end
  if (class == "Weaver") then return 0x41007dee end
  if (class == "Beorning")then return "CombatAnalysis/Resources/beorning_icon_20.tga" end
end


function Misc.SplitPascalCase(str)
  return string.sub(str,1,1)..string.sub(str,2):gsub("([A-Z])"," %1");
end

-- completely escape a string all pattern escape characters (ie: %, and optionally \ as well)
function Misc.EscapePattern(pattern,escapeSpecialCharacters)
  local escaped = pattern:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]","%%%1");
  
  if (escapeSpecialCharaters) then
    return escaped:gsub("%z","%%z");
  else
    return escaped:gsub("\\","\\\\");
  end
end

-- escape a string (replace \ characters)
function Misc.EscapeString(str)
  return (str:gsub("\\","\\\\"));
end

-- SORTING

function Misc.SortData(unsortedData,sortOnDurations)
	local sortedData = {};
	-- extract data
	for playerName,data in pairs(unsortedData) do
		if not data.empty then
			table.insert(sortedData,{playerName,data});
		end
	end
	-- sort data
	if (sortOnDurations) then
		Misc.SortOnDurations(sortedData);
	else
		Misc.Sort(sortedData);
	end
	-- return sorted data
	return sortedData;
end

function Misc.Sort(unsortedData)
	table.sort(unsortedData,function(a,b)
		if (a[2]:TotalAmount() > b[2]:TotalAmount()) then
			return true;
		elseif (a[2]:TotalAmount() == b[2]:TotalAmount()) then
			if (a[2].attacks > b[2].attacks) then
				return true;
			elseif (a[2].attacks == b[2].attacks) then
				return string.lower(a[1]) < string.lower(b[1]);
			else
				return false;
			end
		else
			return false;
		end
	end);
end

function Misc.SortOnDurations(unsortedData)
	local timestamp = Turbine.Engine.GetGameTime();
	table.sort(unsortedData,function(a,b)
		if (a[2]:CurrentDuration(timestamp) > b[2]:CurrentDuration(timestamp)) then
			return true;
		elseif (a[2]:CurrentDuration(timestamp) == b[2]:CurrentDuration(timestamp)) then
			if (b[2].applications ~= nil and (a[2].applications == nil or a[2].applications > b[2].applications)) then
				return true;
			elseif ((a[2].applications == nil and b[2].applications == nil) or (a[2].applications ~= nil and b[2].applications ~= nil and a[2].applications == b[2].applications)) then
				return string.lower(a[1]) < string.lower(b[1]);
			else
				return false;
			end
		else
			return false;
		end
	end);
end

-- EQUALITY CHECK

function Misc.TablesEqual(table1,table2)
	-- if the supplied arguments are not tables, check for equality
	if (type(table1) ~= "table") then
		return table1 == table2;
		
	-- if the supplied arguments are tables, check each element for equality
	elseif (type(table1) == "table") then
		if (type(table2) ~= "table") then return false end
		
		for k,v in pairs(table1) do
			if (not Misc.TablesEqual(v,table2[k])) then return false end
		end
		for k,v in pairs(table2) do
			if (table1[k] == nil) then return false end
		end
		
		return true;
	end
end

-- DEEP TABLE COPY

function Misc.TableCopy(originalTable,newTable)
	if (type(originalTable) ~= "table") then return originalTable end
	
	if (newTable == nil) then newTable = {} end
	
	for k,v in pairs(originalTable) do
		newTable[Misc.TableCopy(k)] = Misc.TableCopy(v);
	end
	return newTable;
end

-- REMOVE ALL ELEMENTS IN TABLE (ie: if we want the pointer persisted for listeners etc)

function Misc.TableClear(tableToClear)
  while (next(tableToClear) ~= nil) do
    tableToClear[next(tableToClear)] = nil;
  end
end

-- TABLE DUMP (used for debug only)

function Misc.DumpTable(currentTable,indentation,seen)
	if (currentTable == nil) then
		return (indentation.."(nil)");
	end
  
	seen[currentTable] = true

	local currentKeys = {}
	for key,_ in pairs(currentTable) do
    if (type(key) == "table") then sortable = false end
		table.insert(currentKeys,key);
	end
  if (sortable ~= false) then
    table.sort(currentKeys, function(a,b) return tostring(a) < tostring(b) end);
  end
	
  local str = "";
	for index,key in pairs(currentKeys) do
    local value = currentTable[key];
		str = str .. (str == "" and "" or "\n") .. (indentation..(type(value) == "table" and "<rgb=#FF5555>" or "")..tostring(index)..": "..tostring(key)..", "..tostring(value)..(type(value) == "table" and "</rgb>" or ""));
		if (type(value) == "table" and not seen[value]) then
			str = str .. "\n" .. Misc.DumpTable(value,indentation.."  ",seen);
		end
	end
  
  return str;
end

-- COLOR MANIPULATION

Misc.b2g = 0.10;
Misc.b2r = 0.05;
Misc.r2g = 0.06;

function Misc.SetShade(color,minPercentageShaded,maxPercentageShaded)
  local r = color.R;
  local g = color.G;
  local b = color.B;
  
  local currentTotal = color.R + color.G + color.B;
  local maxTotal = nil;
  
  if (currentTotal == 0) then
    r = minPercentageShaded;
    g = minPercentageShaded;
    b = minPercentageShaded;
    currentTotal = minPercentageShaded*3;
    maxTotal = currentTotal * (1+Misc.b2g*(b-g))*(1+Misc.b2r*(b-r))*(1+Misc.r2g*(r-g));
  else
    maxTotal = math.max(minPercentageShaded,math.min(currentTotal/3,maxPercentageShaded))*3 * (1+Misc.b2g*(b-g))*(1+Misc.b2r*(b-r))*(1+Misc.r2g*(r-g));
  end
  
	return Turbine.UI.Color(color.A,math.min(1,(r/currentTotal)*maxTotal),math.min(1,(g/currentTotal)*maxTotal),math.min(1,(b/currentTotal)*maxTotal));
end

function Misc.SimpleToGray(alpha,color,percentage)
  local maxColor = math.max(color.R,color.G,color.B);
	local newRed,newGreen,newBlue;
  if maxColor == color.R then
		newRed = color.R;
		newGreen = color.R-((color.R-color.G)*(1-percentage));
    newBlue = color.R-((color.R-color.B)*(1-percentage));
  elseif maxColor == color.G then
    newRed = color.G-((color.G-color.R)*(1-percentage));
		newGreen = color.G;
    newBlue = color.G-((color.G-color.B)*(1-percentage));
  else
		newRed = color.B-((color.B-color.R)*(1-percentage));
		newGreen = color.B-((color.B-color.G)*(1-percentage));
    newBlue = color.B;
  end
  return Turbine.UI.Color(alpha,newRed,newGreen,newBlue);
end

function Misc.ToGray(alpha,percent,color,strength)
	local maxColor = math.max(color.R,color.G,color.B);
	local newRed,newGreen,newBlue;
	if maxColor == color.R then
		newRed = color.R;
		newGreen = (color.R-(1-strength)*(color.R-color.G))*(1-percent*(color.R-color.G))
		newBlue = (color.R-(1-strength)*(color.R-color.B))*(1-percent*(color.R-color.B))
	elseif maxColor == color.G then
		newRed = (color.G-(1-strength)*(color.G-color.R))*(1-percent*(color.G-color.R))
		newGreen = color.G;
		newBlue = (color.G-(1-strength)*(color.G-color.B))*(1-percent*(color.G-color.B))
	else
		newRed = (color.B-(1-strength)*(color.B-color.G))*(1-percent*(color.B-color.R))
		newGreen = (color.B-(1-strength)*(color.B-color.G))*(1-percent*(color.B-color.G))
		newBlue = color.B;
	end
	return Turbine.UI.Color(alpha,newRed,newGreen,newBlue);
end

function Misc.Shade(color,amount)
	return Turbine.UI.Color(color.A,color.R-(color.R)*(0.1+0.05*amount),color.G-(color.G)*(0.1+0.05*amount),color.B-(color.B)*(0.1+0.05*amount));
end

function Misc.SetAlpha(color,alpha)
	return Turbine.UI.Color(alpha,color.R,color.G,color.B);
end

local ToHex = function(base16Number)
	if (base16Number < 10) then 		 return string.format("%0d",base16Number);
	elseif (base16Number < 11) then  return "A";
	elseif (base16Number < 12) then  return "B";
	elseif (base16Number < 13) then  return "C";
	elseif (base16Number < 14) then  return "D";
	elseif (base16Number < 15) then  return "E";
	else 									  				 return "F";
	end
end

function Misc.DecimalToHex(decimal)
	return "#"..
		ToHex((decimal.R*255)/16)..ToHex((decimal.R*255)%16)..
		ToHex((decimal.G*255)/16)..ToHex((decimal.G*255)%16)..
		ToHex((decimal.B*255)/16)..ToHex((decimal.B*255)%16);
end

-- LISTENERS (listeners are assigned to any kind of object)

Misc.listeners = {}

function Misc.AddListener(object,variableName,listenerFunction,listenerObject,listenerId)
  if (object == nil) then
    if (Misc.listeners[variableName] == nil) then
      Misc.listeners[variableName] = {{listenerFunction,listenerObject,listenerId}};
    else
      table.insert(Misc.listeners[variableName],{listenerFunction,listenerObject,listenerId});
    end
  else
    if (Misc.listeners[object] == nil) then
      Misc.listeners[object] = {}
    end
    
    if (Misc.listeners[object][variableName] == nil) then
      Misc.listeners[object][variableName] = {{listenerFunction,listenerObject,listenerId}};
    else
      table.insert(Misc.listeners[object][variableName],{listenerFunction,listenerObject,listenerId});
    end
  end
end

function Misc.NotifyListeners(object,variableName,info)
  if (object == nil) then
    if (Misc.listeners[variableName] ~= nil) then
      for _,listener in ipairs(Misc.listeners[variableName]) do
        listener[1](listener[2],info);
      end
    end
  else
    if (Misc.listeners[object] ~= nil and Misc.listeners[object][variableName] ~= nil) then
      for _,listener in ipairs(Misc.listeners[object][variableName]) do
        listener[1](listener[2],info);
      end
    end
  end
end

function Misc.RemoveListener(object,variableName,listenerId)
  if (object == nil) then
    if (Misc.listeners[variableName] == nil) then return end
    
    for i,l in ipairs(Misc.listeners[variableName]) do
      if (listenerId == l[3]) then
        table.remove(Misc.listeners[variableName],i);
        return;
      end
    end
  else
    if (Misc.listeners[object][variableName] == nil) then return end
    
    for i,l in ipairs(Misc.listeners[object][variableName]) do
      if (listenerId == l[3]) then
        table.remove(Misc.listeners[object][variableName],i);
        
        if (#Misc.listeners[object][variableName] == 0) then
          Misc.listeners[object][variableName] = nil;
          if (next(Misc.listeners[object]) == nil) then
            Misc.listeners[object] = nil;
          end
        end
        
        return;
      end
    end

  end
end

-- shortcut method to update all listeners when a global variable is changed
function Misc.SetValue(object,variableName,value,forceUpdate)
  if ((object or _G)[variableName] ~= value or forceUpdate) then
    (object or _G)[variableName] = value;
    Misc.NotifyListeners(object,variableName);
  end
end

-- SIMPLE TIMER

-- note we do guarantee that timer A, who is started before (but with the
--  same timestamp as) and has the same duration as timer B, will always
--  call its listener (notify) function first
-- 
-- a listener object is not required if the supplied function is static

local timerControl = Turbine.UI.Control();
timerControl.timers = {}

timerControl.Update = function()
	local gameTime = Turbine.Engine.GetGameTime();
	-- notify listeners of any completed timers (in order), and remove them from the list
	local index = 1;
	while true do
		if (index > #timerControl.timers) then break end
		
		local timerData = timerControl.timers[index];
		if (gameTime >= timerData[1]) then
			table.remove(timerControl.timers,index);
			if (timerData[3]) then
				timerData[2](timerData[3],timerData[4],timerData[5]);
			else
				timerData[2](timerData[4],timerData[5]);
			end
		else
			index = index+1;
		end
	end
	-- if no timers remain, stop checking for finished timers
	if (#timerControl.timers == 0) then
		timerControl:SetWantsUpdates(false);
	end
end

function Misc.StartTimer(target,timestamp,duration,listenerFunction,listener)
	-- if this is the first timer added, start checking for it to finish
	if (#timerControl.timers == 0) then
		timerControl:SetWantsUpdates(true);
	end
	-- create the timer
	table.insert(timerControl.timers,{timestamp+duration,listenerFunction,listener,timestamp,target});
end

-- for compatability with other plugins, this method is used to not override the same events

function Misc.AddCallback(object, event, callback)
	if (object[event] == nil) then
		object[event] = callback;
	else
		if (type(object[event]) == "table") then
			table.insert(object[event], callback);
		else
			object[event] = {object[event], callback};
		end
	end
end

--- Determine Text Lengths using hidden window

local precision = 0.5; -- how precise the width determination should be (should not be set lower than 0.1)

Misc.texts = {} -- holds computed text widths

_G.textLengthWindow = Turbine.UI.Window();
textLengthWindow.toBeDeterminedTexts = {} -- holds not yet computed text widths

local widthLabel = Turbine.UI.Label();
widthLabel:SetParent(textLengthWindow);
widthLabel:SetSize(25,25);
widthLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
widthLabel:SetMultiline(false);
widthLabel:SetMarkupEnabled(true);

local widthScroll = Turbine.UI.Lotro.ScrollBar();
widthScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);
widthScroll:SetParent(textLengthWindow);
widthScroll:SetSize(60,10);
widthLabel:SetHorizontalScrollBar(widthScroll);

-- hide off screen
textLengthWindow:SetPosition(-100,-100);
textLengthWindow:SetSize(50,50);

textLengthWindow.Update = function(sender)
  local fixed = false;
  
	for text,info in pairs(textLengthWindow.toBeDeterminedTexts) do
    local font = info[1];
    local fixedWidth = info[3];
    fixed = (fixed or (fixedWidth ~= nil));
		
    local multiline = false;
    local size = (fixedWidth or 512); -- initial width guess
    
    widthLabel:SetFont(font);
    widthLabel:SetText(text);
    
    local increment = size;
    local count = 0;
    
    -- a binary search to find the best width
    while true do
      widthLabel:SetWidth(size);
      if (not widthScroll:IsVisible()) then
        size = size - increment;
        increment = increment/2;
      elseif (increment == fixedWidth) then
        multiline = true;
        break;
      elseif (increment < 512) then
        increment = increment/2;
      end
      size = size + increment;
      
      if (increment < precision) then
        break;
      end
      
      -- unexpected loop escape
      count = count+1;
      if (count > 20) then
        break;
      end
    end
    
    size = Misc.Round(size+precision);
    
    if (fixedWidth ~= nil) then
      local heightControl = Turbine.UI.Control();
      heightControl:SetParent(textLengthWindow);
      heightControl:SetSize(50,50);
      
      local heightLabel = Turbine.UI.Label();
      heightLabel:SetParent(heightControl);
      heightLabel:SetSize(25,25);
      heightLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
      heightLabel:SetMultiline(true);
      heightLabel:SetMarkupEnabled(true);

      local heightScroll = Turbine.UI.Lotro.ScrollBar();
      heightScroll:SetOrientation(Turbine.UI.Orientation.Vertical);
      heightScroll:SetParent(heightControl);
      heightScroll:SetSize(10,60);
      heightScroll:SetZOrder(100);
      heightLabel:SetVerticalScrollBar(heightScroll);
      
      heightLabel:SetFont(font);
      heightLabel:SetText(text);
      heightLabel:SetWidth(fixedWidth);
      
      if (not multiline) then fixedWidth = size end
      
      size = (multiline and 512 or 16); -- initial height guess
      increment = size;
      count = 0;
      
      heightLabel:SetHeight(size);
      
      local start = true;
      heightControl.Update = function(sender, args)
        if (start) then start = false; return end
        
        if (not heightScroll:IsVisible()) then
          size = size - increment;
          increment = increment/2;
        elseif (increment < 512) then
          increment = increment/2;
        end
        size = size + increment;
        
        heightLabel:SetHeight(size);
        
        -- unexpected loop escape
        count = count+1;
        if (increment < precision or count > 20) then
          size = Misc.Round(size+precision);
          local dimensions = {fixedWidth,size};
          if (not info[4]) then Misc.texts[text] = dimensions end
          if (info[2] ~= nil) then
            for _,list in pairs(info[2]) do
              list[2](list[1],dimensions);
            end
          end
          
          heightControl:SetParent(nil);
          heightControl:SetWantsUpdates(false);
          textLengthWindow:SetVisible(false);
        end
      end
      
      heightControl:SetWantsUpdates(true);
    end
    
    if (fixedWidth == nil) then
      size = Misc.Round(size+precision);
      if (not info[4]) then Misc.texts[text] = size; end
      if (info[2] ~= nil) then
        for _,list in pairs(info[2]) do
          list[2](list[1],size);
        end
      end
    end
	end
	
  textLengthWindow.toBeDeterminedTexts = {}
	textLengthWindow:SetWantsUpdates(false);
	if (not fixed) then textLengthWindow:SetVisible(false) end
	textLengthWindow = nil;
end

function Misc.DetermineLength(text,font,callback,object,width,dontStore)
  if (text == nil) then
    Turbine.Shell.WriteLine(Turbine.Engine.GetCallStack());
  end

  if (Misc.texts[text] ~= nil) then
    if (callback ~= nil) then callback(object,Misc.texts[text]) end
    return;
  end
  
  if (textLengthWindow.toBeDeterminedTexts[text] ~= nil) then
    if (callback ~= nil) then table.insert(textLengthWindow.toBeDeterminedTexts[text][2],{object,callback}) end
    return;
  end
  
	textLengthWindow.toBeDeterminedTexts[text] = {font,(callback ~= nil and {{object,callback}} or nil),width,dontStore};
  
  textLengthWindow:SetVisible(true);
  textLengthWindow:SetWantsUpdates(true);
end

function Misc.TextFitsIn(text,font,width)
  local isWorkingOnHeight = textLengthWindow:IsVisible();
  textLengthWindow:SetVisible(true);
  
  widthLabel:SetFont(font);
  widthLabel:SetText(text);
  widthLabel:SetWidth(width);
  
  local fits = not widthScroll:IsVisible();
  if (not isWorkingOnHeight) then textLengthWindow:SetVisible(false) end
  return fits;
end
