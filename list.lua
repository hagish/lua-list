--[[
The MIT License (MIT)
Copyright (c) 2013 Sebastian Dorda

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local list = {}

--[[

-- LINQ like list processing for ipair lists.
-- The functions are not optimized for speed (a lot of table creations during processing).
-- Does not use the iterator pattern like LINQ.

-- Example usage

local list = require 'list'

-- c like api
local l = {1,2,3}
l = list.concat(l, {1,2})
l = list.skip(l, 1)
l = list.take(l, 3)
l = list.concat(l, {1,2})
l = list.distinct(l)
l = list.orderby(l, function(a,b) return a < b end)
list.print(l)

-- fluent api
local l = list.process({1,2,3})
	:concat({1,2})
	:skip(1)
	:take(3)
	:concat({1,2})
	:distinct()
	:orderby(function(a,b) return a < b end)
	:print()
	:done()
	
]]

-- l: ipair list
-- n: int
-- returns the first n elements
function list.take (l, n)
	local r = {}
	if l then for i = 1,n do table.insert(r, l[i]) end end
	return r
end

-- l: ipair list
-- n: int
-- returns all but the first n elements
function list.skip (l, n)
	local r = {}
	if l then for i = n+1,#l do table.insert(r, l[i]) end end
	return r
end

-- function fun(x, i) -> x's
-- l: ipair list
-- returns a list with mapped elements
function list.select (l, fun)
	local r = {}
	for i,v in ipairs(l) do table.insert(r, fun(v,i)) end
	return r
end

-- l: ipair list
-- returns list without duplicates
function list.distinct (l)
	local r = {}
	if l then
		local c = {}
		for i,v in ipairs(l) do 
			if not c[v] then table.insert(r, v) c[v] = true end
		end
	end
	return r
end

-- l: ipair list
-- function fun(a,b) -> bool, true if a < b, not stable
-- returns ordered list
function list.orderby (l, fun)
	local r = {}
	if l then for i,v in ipairs(l) do table.insert(r, v) end end
	table.sort(r, fun)
	return r
end

-- l: ipair list
-- function fun(v,i) -> bool, true if contained in result
-- returns filtered list
function list.where (l, fun)
	local r = {}
	if l then for i,v in ipairs(l) do if fun(v,i) then table.insert(r, v) end end end
	return r
end

-- l: ipair list
-- ll: ipair list
-- returns a list, ll gets appended to l
function list.concat (l, ll)
	local r = {}
	if l then for i,v in ipairs(l) do table.insert(r, v) end end
	if ll then for i,v in ipairs(ll) do table.insert(r, v) end end
	return r
end

-- l: ipair list
-- returns amount of elements
function list.count (l)
	return #l
end

-- l: ipair list
-- just prints the list
function list.print (l)
	print(unpack(l))
end

-- will wrap the list in a "processing" object (fluent)
-- eg. list.process({1,2,3,4,5}):select(function (x) return x*x end):print()
-- list.process(...):done() converts the object back to a list
-- list.process({1,2,3,4,5}):X(6,"lala") will call list.X({1,2,3,4,5}, 6,"lala")
-- if list.X returns a non table table it gets wrapped into a 1-element list
function list.process (l)
	local p = {}
	local mt = {
		__index = function (self, name)
			local f = list[name]
			if f then
				return function (self, ...) 
					local r = f(l, ...)
					if type(r) ~= "table" then r = {r} end
					return list.process(r) 
				end
			end
		end,
	}
	
	p.done = function () return l end
	p.print = function () list.print(l) return p end
		
	setmetatable(p, mt)
	return p
end

-- like list.process but processes the values of a table
function list.process_values (m)
	local r = {}
	for k,v in pairs(m) do table.insert(r, v) end
	return list.process(r)
end

-- like list.process but processes the keys of a table
function list.process_keys (m)
	local r = {}
	for k,v in pairs(m) do table.insert(r, k) end
	return list.process(r)
end

return list
