--- eq.lua
-- Event queue implementation

local eq = {}

--- Construct an empty event queue.
-- @return Event queue object.
function eq.create()
    return {
        site = eq.site,
        pop = eq.pop,
        heap = {},
        count = 0,
    }
end

--- Compares two priorities.
-- @param a First priority.
-- @param b Second priority.
-- @return true if the first priority is greater than the second.
function eq.cmp(a, b)
    if a.y == b.y then
        assert(a.x ~= b.x)
        return a.x > b.x
    else
        return a.y > b.y
    end
end

--- Tests the order between two items in the heap.
-- @param a First index.
-- @param b Second index.
-- @return true if the entry at index a is higher priority than the entry at index b.
function eq.test(self, a, b)
    return eq.cmp(self.heap[a].pri, self.heap[b].pri)
end

--- Adds a site event to the queue.
-- @param self Queue to modify.
-- @param point Site location.
function eq.site(self, point)
    eq.push(self, {
        evt = 'site',
        p = point,
        pri = point,
    })
end

--- Pushes a new entry into the heap.
-- @param self Heap to modify.
-- @param evt Entry to push.
function eq.push(self, evt)
    self.count = self.count + 1
    self.heap[self.count] = evt

    local cur = self.count

    while cur > 1 and not eq.test(self, eq.par(cur), cur) do
        eq.swap(self, cur, eq.par(cur))
        cur = eq.par(cur)
    end
end

--- Pop the highest priority entry from the queue.
-- @param self Heap to pop from.
-- @return The highest priority entry, or nil if there are none left.
function eq.pop(self)
    if self.count == 0 then
        return nil
    end

    local ret = self.heap[1]

    self.heap[1] = self.heap[self.count]
    self.heap[self.count] = nil

    self.count = self.count - 1

    local cur = 1
    while cur * 2 <= self.count do
        local mc = eq.maxchild(self, cur)

        if eq.test(self, cur, mc) then
            break
        else
            eq.swap(self, cur, mc)
            cur = mc
        end
    end

    return ret
end

--- Find the maximum priority child of a node.
-- @param self Heap to test.
-- @param i Index of parent node.
-- @return the index of the highest priority child.
function eq.maxchild(self, i)
    if i * 2 + 1 > self.count then
        return i * 2
    else
        if eq.test(self, i * 2, i * 2 + 1) then
            return i * 2
        else
            return i * 2 + 1
        end
    end
end

--- Gets the parent index of a node.
-- @param i Input index.
-- @return the index of this node's parent.
function eq.par(i)
    return math.floor(i / 2)
end

--- Swaps two indices in the heap.
-- @param self Heap to modify.
-- @param a Index of first entry.
-- @param b Index of second entry.
function eq.swap(self, a, b) 
    self.heap[a], self.heap[b] = self.heap[b], self.heap[a]
end

return eq.create
