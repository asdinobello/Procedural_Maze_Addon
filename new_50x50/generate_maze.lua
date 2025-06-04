
local w, h = 50, 50

for y = 1, h do
    for x = 1, w do
        wesnoth.set_terrain(x, y, "Xuf")
    end
end

local visited = {}
for y = 1, h do
    visited[y] = {}
    for x = 1, w do
        visited[y][x] = false
    end
end

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

local function carve(x, y)
    visited[y][x] = true
    wesnoth.set_terrain(x, y, "Gg")
    local directions = shuffle({{x=2,y=0},{x=-2,y=0},{x=0,y=2},{x=0,y=-2}})
    for _, d in ipairs(directions) do
        local nx, ny = x + d.x, y + d.y
        if nx > 1 and ny > 1 and nx < w and ny < h and not visited[ny][nx] then
            wesnoth.set_terrain(x + d.x//2, y + d.y//2, "Gg")
            carve(nx, ny)
        end
    end
end

math.randomseed(os.time())
carve(3, 3)

wesnoth.put_unit{{x=3, y=3, type="Elvish Marshal", side=1, canrecruit=true}}
wesnoth.put_unit{{x=47, y=47, type="Elvish Marshal", side=2, canrecruit=true}}
