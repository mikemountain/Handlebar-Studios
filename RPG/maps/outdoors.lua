local tileString =
    "abbbcxabc\n" ..
    "d   fxd f\n" ..
    "d   fxd f\n" ..
    "d   qbp f\n" ..
    "d       f\n" ..
    "d       f\n" ..
    "d       f\n" ..
    "d       f\n" ..
    "ghhhhhhhi"

local quadInfo = {
    { 'a',   0,   0 },  -- 1 = top left
    { 'b',  64,   0 },  -- 2 = top mid
    { 'c', 128,   0 },  -- 3 = top right
    { 'd',   0,  64 },  -- 4 = mid left
    { ' ',  64,  64 },  -- 5 = mid mid
    { 'f', 128,  64 },  -- 6 = mid right
    { 'g',   0, 128 },  -- 7 = bot left
    { 'h',  64, 128 },  -- 8 = bot mid
    { 'i', 128, 128 },  -- 9 = bot right
    { 'q', 192,  64 },
    { 'p', 256,  64 },
    { 'x', 384,  64 }
}

newMap(64, 64, '/images/sprites.png', tileString, quadInfo)