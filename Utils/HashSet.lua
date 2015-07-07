
--[[

A HashSet with a maximum size limit (elements are
automatically removed based on insertion order
if the set fills).

If no max size is specified in the construcutor,
this class just behaves as an ordinary hash set.

]]

_G.HashSet = class();

function HashSet:Constructor(maxSize)
	self.maxSize = maxSize;
	
	self.set = {}
	self.size = 0;
	
	if (self.maxSize) then
		self.list = {}
	end
end

function HashSet:Add(object)
	local index = self:Contains(object);
	
	if (self.maxSize) then
		-- object already exists, re-order list
		if (index) then
			table.remove(self.list,index)
			table.insert(self.list,object);
			self.set[object] = #self.list;
			
		-- add object
		else
			-- remove an object if the set is full
			if (#self.list > self.maxSize) then
				self.set[table.remove(self.list,1)] = nil;
			else
				self.size = self.size+1;
			end
			table.insert(self.list,object);
			self.set[object] = #self.list;
		end
		
	else
		self.set[object] = true;
		self.size = self.size+1;
	end
end

function HashSet:Remove(object)
	local index = self:Contains(object);
	
	if (index) then
		if (self.maxSize) then
			table.remove(self.list,index);
		end
		
		self.set[object] = nil;
		self.size = self.size-1;
	end
end

function HashSet:Contains(object)
	return self.set[object];
end

function HashSet:GetState()
	return EncodeNumbers({self.set,self.size,self.maxSize});
end

function HashSet.RestoreState(state)
	local hashSet = HashSet(state[3]);
	
	hashSet.set = state[1];
	hashSet.size = state[2];
	
	return hashSet;
end
