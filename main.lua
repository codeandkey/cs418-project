--- COMS 418 Final project source
-- Justin Stanley

-- Imports
local pq = require 'pq'

-- Configuration
DEFAULT_INPUT = 'input.txt'

-- Global state
voronoi_sites = nil

--- Parses site information from file data.
-- @param content Input string.
-- @return List of sites.
function load_sites(content)
    local sites = {}

    for ix, iy in content:gmatch('%(%s*(%-?%d+)%s*,%s*(%-?%d+)%s*%)') do
        table.insert(sites, {
            x = tonumber(ix),
            y = tonumber(iy),
        })
    end

    print('Parsed ' .. #sites .. ' Voronoi sites.')
    return sites
end

--- Reads the content of a file into a string.
-- @param name File name.
-- @return File content.
function read_file(name)
    print('Reading data from ' .. name .. '..')

    io.input(name)
    local input_data = io.read('*all')

    print('Read ' .. #input_data .. ' bytes from stream.')

    return input_data
end

function fortune(sites)
    local event_queue = {}

    for _, s in ipairs(sites) do
    end
end

function love.load(arg)
    if #arg < 1 then
        print('Missing input filename, assuming ' .. DEFAULT_INPUT .. '.')
        arg[1] = DEFAULT_INPUT
    end

    local input_data = read_file(arg[1])
    voronoi_sites = load_sites(input_data)

    local t = pq.create(function(a, b)
        if a.y == b.y then
            assert(a.x ~= b.x)
            return a.x > b.x
        else
            return a.y > b.y
        end
    end)

    for _, p in ipairs(voronoi_sites) do
        t:insert({
            event_type = 'site',
            point = p,
        }, p)
    end

    local p = t:pop()

    while p do
        print('popped type = ' .. p.event_type .. ', point=(' .. p.point.x .. ', ' .. p.point.y .. ')')
        p = t:pop()
    end
end
