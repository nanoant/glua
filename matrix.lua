ffi.cdef [[
typedef struct {
  GLfloat v[16];
} GLmatrix;
]]

local matrix = ffi.metatype('GLmatrix', {
  __add = function(a, b) end,
  __len = function(m) return 0 end,
  __index = {
    get  = function(m) gl.glGetFloatv(GL_MODELVIEW_MATRIX, m) end,
    load = function(m) gl.glLoadMatrixf(m) end,
    mult = function(m) gl.glMultMatrixf(m) end
  }
})
