--- eq.lua
-- Event queue implementation

local eq = {}

function eq.create()
    return {
        site = eq.site,
        pop = eq.pop,
        heap = {},
        count = 0,
    }
end

function eq.cmp(a, b)
    if a.y == b.y then
        assert(a.x ~= b.x)
        return a.x > b.x
    else
        return a.y > b.y
    end
end

function eq.test(self, a, b)
    return eq.cmp(self.heap[a].pri, self.heap[b].pri)
end

function eq.site(self, point)
    eq.push(self, {
        evt = 'site',
        p = point,
        pri = point,
    })
end

function eq.push(self, evt)
    self.count = self.count + 1
    self.heap[self.count] = evt

    local cur = self.count

    while cur > 1 and not eq.test(self, eq.par(cur), cur) do
        eq.swap(self, cur, eq.par(cur))
        cur = eq.par(cur)
    end
end

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

function eq.par(i)
    return math.floor(i / 2)
end

function eq.swap(self, a, b) 
    self.heap[a], self.heap[b] = self.heap[b], self.heap[a]
end

return eq.create
