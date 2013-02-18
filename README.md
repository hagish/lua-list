lua-list
========

LINQ like list processing for ipair lists.
The functions are not optimized for speed (a lot of table creations during processing).
Does not use the iterator pattern like LINQ.

Example usage
-------------

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
		
License
-------

The MIT License (MIT)
Copyright (c) 2013 Sebastian Dorda

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
