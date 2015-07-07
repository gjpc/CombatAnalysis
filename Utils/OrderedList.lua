
--[[

An Ordered List.

This implementation assumes all items in the set are
directly comparable, and includes save/restore state
methods.

]]

_G.OrderedList = class();

function OrderedList:Constructor()
	self.list = {}
end

function OrderedList:Add(object,otherData,replace,allowIdenticalData)
	-- determine the position to insert the new object
	local index,objExists = self:BinarySearch(object,otherData);
	-- if the item already exists, do nothing
	if (objExists and not allowIdenticalData) then return false end
  -- if an item with the same object index (but not the same data) exists, then replace it if specified
  if (objExists == false and replace) then
    table.remove(self.list,index);
  end
	-- insert the object
	table.insert(self.list,index,{object,otherData});
	return true;
end

function OrderedList:Remove(object,otherData)
	-- determine the index of the object in the list
	local index,objExists = self:BinarySearch(object,otherData);
	-- if the item does not exist, do nothing
	if (not objExists) then return end
	-- remove the object
	return table.remove(self.list,index);
end

function OrderedList:BinarySearch(object,otherData)
	-- if the list is empty, return false
	if (#self.list == 0) then return 1,false end
	
	local increment = (#self.list+1)/2;
	local index = Misc.Round(increment);
	
	while true do
		-- stopping case 1: increment is less than or equal to one
		if (increment <= 1) then
			if (index < 1) then
				return 1,false; -- expected index off front of list
			elseif (index > #self.list) then
				return #self.list+1,false; -- expected index off end of list
			elseif (object == self.list[index][1]) then
				if (otherData == nil) then
					return index,true;
				else
					return self:FindData(index,object,otherData); -- search for relevant data
				end
			else
				return (index + ((object < self.list[index][1]) and 0 or 1)),nil; -- determine if the expected index is before or after the element at this index
			end
			
		-- stopping case 2: object found early
		elseif (object == self.list[index][1]) then
			if (otherData == nil) then
				return index,true;
			else
				return self:FindData(index,object,otherData); -- search for relevant data
			end
			
		end
		
		increment = increment/2;
		index = index + ((object < self.list[index][1]) and -1 or 1)*Misc.Round(increment);
	end
end

function OrderedList:FindData(index,object,otherData)
	-- check if the entry at this index matches the data
	if (Misc.TablesEqual(self.list[index][2],otherData)) then
		return index,true;
	end
	
	-- search backwards for data
	for i=index-1,1,-1 do
		if (self.list[i][1] ~= object) then
			break;
		elseif (Misc.TablesEqual(self.list[i][2],otherData)) then
			return i,true;
		end
	end
	
	-- search forwards for data
	for i=index+1,#self.list do
		if (self.list[i][1] ~= object) then
			return index,false; -- no data matched
		elseif (Misc.TablesEqual(self.list[i][2],otherData)) then
			return i,true;
		end
	end
	
	-- the data is not in the list
	return index,false;
end

function OrderedList:Clear()
	self.list = {}
end
