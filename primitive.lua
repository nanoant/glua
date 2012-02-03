local gl = require 'gl'

local primitive = {}

local plane = {
  -- vertex  -- normal -- tex coord
  -1, -1,  0,   0,  0,  1,   1, 1,
   1, -1,  0,   0,  0,  1,   0, 1,
   1,  1,  0,   0,  0,  1,   0, 0,
   1,  1,  0,   0,  0,  1,   0, 0, -- dup
  -1,  1,  0,   0,  0,  1,   1, 0,
  -1, -1,  0,   0,  0,  1,   1, 1, -- dup
}
local cube = {
  -- position,  normal,      tex coord
  -- front
  -1, -1,  1,   0,  0,  1,   1, 1,
   1, -1,  1,   0,  0,  1,   0, 1,
   1,  1,  1,   0,  0,  1,   0, 0,
   1,  1,  1,   0,  0,  1,   0, 0, -- dup
  -1,  1,  1,   0,  0,  1,   1, 0,
  -1, -1,  1,   0,  0,  1,   1, 1, -- dup
  -- back
   1, -1, -1,   0,  0, -1,   1, 1,
  -1, -1, -1,   0,  0, -1,   0, 1,
  -1,  1, -1,   0,  0, -1,   0, 0,
  -1,  1, -1,   0,  0, -1,   0, 0, -- dup
   1,  1, -1,   0,  0, -1,   1, 0,
   1, -1, -1,   0,  0, -1,   1, 1, -- dup
  -- top
   1,  1, -1,   0,  1,  0,   1, 1,
  -1,  1, -1,   0,  1,  0,   0, 1,
  -1,  1,  1,   0,  1,  0,   0, 0,
  -1,  1,  1,   0,  1,  0,   0, 0, -- dup
   1,  1,  1,   0,  1,  0,   1, 0,
   1,  1, -1,   0,  1,  0,   1, 1, -- dup
  -- bottom
  -1, -1, -1,   0, -1,  0,   1, 1,
   1, -1, -1,   0, -1,  0,   0, 1,
   1, -1,  1,   0, -1,  0,   0, 0,
   1, -1,  1,   0, -1,  0,   0, 0, -- dup
  -1, -1,  1,   0, -1,  0,   1, 0,
  -1, -1, -1,   0, -1,  0,   1, 1, -- dup
  -- left
  -1, -1, -1,  -1,  0,  0,   1, 1,
  -1, -1,  1,  -1,  0,  0,   0, 1,
  -1,  1,  1,  -1,  0,  0,   0, 0,
  -1,  1,  1,  -1,  0,  0,   0, 0, -- dup
  -1,  1, -1,  -1,  0,  0,   1, 0,
  -1, -1, -1,  -1,  0,  0,   1, 1, -- dup
  -- right
   1, -1,  1,   1,  0,  0,   1, 1,
   1, -1, -1,   1,  0,  0,   0, 1,
   1,  1, -1,   1,  0,  0,   0, 0,
   1,  1, -1,   1,  0,  0,   0, 0, -- dup
   1,  1,  1,   1,  0,  0,   1, 0,
   1, -1,  1,   1,  0,  0,   1, 1  -- dup
}

function primitive.draw(what, program, mode)
  mode = mode or gl.TRIANGLES
  if not what or what == 'cube' then
    what = cube
  elseif what == 'plane' then
    what = plane
  end
  return gl.draw(program, mode, what, 'position', 3, 'normal', 3, 'texCoord', 2)
end

function primitive.plane(program) return gl.array(program, plane, 'position', 3, 'normal', 3, 'texCoord', 2) end
function primitive.cube(program)  return gl.array(program, cube,  'position', 3, 'normal', 3, 'texCoord', 2) end

return primitive
