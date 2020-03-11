--- Priority queue implementation.
-- Runtime is O(log n) for insertion, deletion.

local pq = {}

function pq.create(cmp)
    return {
        items = {},
        count = 0,
        cmp = cmp or function(x, y)
            return x > y
        end,
        insert = function(self, item, pri)
            pq.insert(self, item, pri)
        end,
        pop = function(self)
            return pq.pop(self)
        end,
    }
end

--- Inserts an item with a given priority into the queue.
-- @param self Queue to insert into.
-- @param item Item to insert.
-- @param pri Item priority.
function pq.insert(self, item, pri)
    -- Insert the basic item into the heap at the earliest spot possible.
    local current = #self.items + 1

    self.items[current] = {
        data = item,
        pri = pri,
    }

    -- Shift it upwards to the top to maintain the heap ordering.
    while current > 1 and not pq.test(self, pq.par(current), current) do
        pq.swap(self, current, pq.par(current))
        current = pq.par(current)
    end
end

--- Removes the item with highest priority from the queue.
-- @param self Queue to pop from.
function pq.pop(self)
    if #self.items == 0 then
        return nil
    end

    local ind = 1
    local ret = self.items[1].data
    local mc = pq.maxchild(self, ind)

    while mc do
        pq.swap(self, ind, mc)
        ind = mc
        mc = pq.maxchild(self, ind)
    end

    self.items[ind] = nil
    return ret
end

--- Tests the priority order between two indices.
-- @param self Heap to test on.
-- @param a Index expected to be greater.
-- @param b Index expected to be lesser.
-- @return true if the nodes are in the correct order.
function pq.test(self, a, b)
    return self.cmp(self.items[a].pri, self.items[b].pri)
end

--- Find the index of the maximum child of <ind>.
--
-- @param self Heap to index.
-- @param ind Index to find maximum child of.
--
-- @return Maximum child index, or nil if there is no child.
function pq.maxchild(self, ind)
    local ret = nil
    local left = self.items[pq.lc(ind)]
    local right = self.items[pq.rc(ind)]

    if left then
        ret = pq.lc(ind)
    end

    if right then
        if (not ret) or pq.test(self, pq.rc(ind), pq.lc(ind)) then
            ret = pq.rc(ind)
        end
    end

    return ret
end

--- Swaps two items in place.
-- @param self Heap to perform on.
-- @param first First index for swap.
-- @param second Second index for swap.
function pq.swap(self, first, second)
    local tmp = self.items[first]
    self.items[first] = self.items[second]
    self.items[second] = tmp
end

--- Dumps the priority queue state.
-- @param self Heap to dump.
function pq.dump(self)
    for k, v in pairs(self.items) do
        print('[' .. k .. '] -> priority ' .. v.pri)
    end
end

--- Gets the parent from an index.
-- @param Input index.
-- @return Index of this node's parent.
function pq.par(i)
    return math.floor(i / 2)
end

--- Gets the left child of an index.
-- @param Input index.
-- @return Index of this node's left child.
function pq.lc(i)
    return i * 2
end

--- Gets the right child of an index.
-- @param Input index.
-- @return Index of this node's right child.
function pq.rc(i)
    return i * 2 + 1
end

return pq
