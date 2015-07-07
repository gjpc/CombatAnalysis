
--[[

An Ordered List of file names.

This implementation assumes the ordering objects are
lower case strings and the data is made up of normal
case strings.

]]

_G.OrderedFileList = class(OrderedList);

function OrderedFileList:Constructor()
	OrderedList.Constructor(self);
end

function OrderedFileList:Suggestions(object,maxSuggestions)
	-- if the list is empty, return an empty table
	if (#self.list == 0) then return {} end
	-- determine the index of the string in the list
	local index,strExists = self:BinarySearch(object);
	
	local suggestions = {}
	local strLen = string.len(object);
	for i=index,math.min(index+maxSuggestions,#self.list) do
		if (string.sub(self.list[i][1],1,strLen) == object) then
			table.insert(suggestions,{i,self.list[i][2]});
		else
			break;
		end
	end
	return suggestions;
end

-- save and restore methods 
function OrderedFileList:GetState()
	local list = {}
	for index,data in ipairs(self.list) do
		list[EncodeNumbers(index)] = data[2];
	end
	return list;
end

function OrderedFileList.RestoreState(state)
	local orderedFileList = OrderedFileList();
	for index,data in ipairs(state) do
		data = string.gsub(data,"_"," ");
		orderedFileList.list[index] = {string.lower(data),data};
	end
	return orderedFileList;
end