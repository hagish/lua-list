local list = require 'list'

print("c like api")

local l = {1,2,3}
l = list.concat(l, {1,2})
l = list.skip(l, 1)
l = list.take(l, 3)
l = list.concat(l, {1,2})
l = list.distinct(l)
l = list.orderby(l, function(a,b) return a < b end)
list.print(l)

print("fluent api")

local l = list.process({1,2,3})
	:concat({1,2})
	:skip(1)
	:take(3)
	:concat({1,2})
	:distinct()
	:orderby(function(a,b) return a < b end)
	:print()
	:done()

print("finished processing")

-- after :done() you get a simple list
for i,v in ipairs(l) do
	print(i, v)
end
