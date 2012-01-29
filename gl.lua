-- LuaJIT FFI extensions for OpenGL & GLUT
-- Created by: Adam Strzelecki http://www.nanoant.com/

local g   = require 'gl.glut'
local ffi = require 'ffi'
local M   = require 'matrix'

-- float vector type
local glFloatv   = ffi.typeof('GLfloat[?]')
local glUshortv  = ffi.typeof('GLushort[?]')
local glUintv    = ffi.typeof('GLuint[?]')
local glIntv     = ffi.typeof('GLint[?]')
local glSizeiv   = ffi.typeof('GLsizei[?]')
local glBooleanv = ffi.typeof('GLboolean[?]')
local glEnumv    = ffi.typeof('GLenum[?]')
local glClampfv  = ffi.typeof('GLclampf[?]')
local glClampdv  = ffi.typeof('GLclampd[?]')
local glCharv    = ffi.typeof('GLchar[?]')
local glCharp    = ffi.typeof('GLchar *')
local glConstCharpp = ffi.typeof('const GLchar *[1]')

-- callbacks
ffi.cdef [[
  typedef void (*glutTimerCallback)(int value);
  typedef void (*glutIdleCallback)(void);
]]
M.utTimerCallback = function(f) return ffi.cast('glutTimerCallback', f) end
M.utIdleCallback  = function(f) return ffi.cast('glutIdleCallback', f)  end

-- automatic vector generating get
-- http://www.opengl.org/sdk/docs/man/xhtml/glGet.xml
local glGetMap = {
  [g.GL_ACTIVE_TEXTURE]                       = {  1, glEnumv    },
  [g.GL_ALIASED_LINE_WIDTH_RANGE]             = {  2, glFloatv   },
  [g.GL_ARRAY_BUFFER_BINDING]                 = {  1, glUintv    },
  [g.GL_BLEND]                                = {  1, glBooleanv },
  [g.GL_BLEND_COLOR]                          = {  4, glFloatv   },
  [g.GL_BLEND_DST_ALPHA]                      = {  1, glEnumv    },
  [g.GL_BLEND_DST_RGB]                        = {  1, glEnumv    },
  [g.GL_BLEND_EQUATION_RGB]                   = {  1, glEnumv    },
  [g.GL_BLEND_EQUATION_ALPHA]                 = {  1, glEnumv    },
  [g.GL_BLEND_SRC_ALPHA]                      = {  1, glEnumv    },
  [g.GL_BLEND_SRC_RGB]                        = {  1, glEnumv    },
  [g.GL_COLOR_CLEAR_VALUE]                    = {  4, glFloatv   },
  [g.GL_COLOR_LOGIC_OP]                       = {  1, glEnumv    },
  [g.GL_COLOR_WRITEMASK]                      = {  4, glBooleanv },
  [g.GL_COMPRESSED_TEXTURE_FORMATS]           = { g.GL_NUM_COMPRESSED_TEXTURE_FORMATS, glEnumv },
  [g.GL_CULL_FACE]                            = {  1, glBooleanv },
  [g.GL_CULL_FACE_MODE]                       = {  1, glEnumv    },
  [g.GL_CURRENT_PROGRAM]                      = {  1, glUintv    },
  [g.GL_DEPTH_CLEAR_VALUE]                    = {  1, glClampd   },
  [g.GL_DEPTH_FUNC]                           = {  1, glEnumv    },
  [g.GL_DEPTH_RANGE]                          = {  2, glClampd   },
  [g.GL_DEPTH_TEST]                           = {  1, glBooleanv },
  [g.GL_DEPTH_WRITEMASK]                      = {  1, glBooleanv },
  [g.GL_DITHER]                               = {  1, glBooleanv },
  [g.GL_DOUBLEBUFFER]                         = {  1, glBooleanv },
  [g.GL_DRAW_BUFFER]                          = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER0]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER1]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER2]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER3]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER4]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER5]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER6]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER7]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER8]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER9]                         = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER10]                        = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER11]                        = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER12]                        = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER13]                        = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER14]                        = {  1, glEnumv    },
  [g.GL_DRAW_BUFFER15]                        = {  1, glEnumv    },
  [g.GL_ELEMENT_ARRAY_BUFFER_BINDING]         = {  1, glUintv    },
  [g.GL_FRAGMENT_SHADER_DERIVATIVE_HINT]      = {  1, glEnumv    },
  [g.GL_FRONT_FACE]                           = {  1, glEnumv    },
  [g.GL_LINE_SMOOTH]                          = {  1, glBooleanv },
  [g.GL_LINE_SMOOTH_HINT]                     = {  1, glEnumv    },
  [g.GL_LINE_WIDTH]                           = {  1, glFloatv   },
  [g.GL_LINE_WIDTH_GRANULARITY]               = {  1, glFloatv   },
  [g.GL_LINE_WIDTH_RANGE]                     = {  2, glFloatv   },
  [g.GL_LOGIC_OP_MODE]                        = {  1, glEnumv    },
  [g.GL_MAX_3D_TEXTURE_SIZE]                  = {  1, glSizeiv   },
  [g.GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS]     = {  1, glSizeiv   },
  [g.GL_MAX_CUBE_MAP_TEXTURE_SIZE]            = {  1, glSizeiv   },
  [g.GL_MAX_DRAW_BUFFERS]                     = {  1, glSizeiv   },
  [g.GL_MAX_ELEMENTS_INDICES]                 = {  1, glSizeiv   },
  [g.GL_MAX_ELEMENTS_VERTICES]                = {  1, glSizeiv   },
  [g.GL_MAX_FRAGMENT_UNIFORM_COMPONENTS]      = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_IMAGE_UNITS]              = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_LOD_BIAS]                 = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_SIZE]                     = {  1, glSizeiv   },
  [g.GL_MAX_VARYING_FLOATS]                   = {  1, glSizeiv   },
  [g.GL_MAX_VERTEX_ATTRIBS]                   = {  1, glSizeiv   },
  [g.GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS]       = {  1, glSizeiv   },
  [g.GL_MAX_VERTEX_UNIFORM_COMPONENTS]        = {  1, glSizeiv   },
  [g.GL_MAX_VIEWPORT_DIMS]                    = {  2, glSizeiv   },
  [g.GL_NUM_COMPRESSED_TEXTURE_FORMATS]       = {  1, glUintv    },
  [g.GL_PACK_ALIGNMENT]                       = {  1, glUintv    },
  [g.GL_PACK_IMAGE_HEIGHT]                    = {  1, glUintv    },
  [g.GL_PACK_LSB_FIRST]                       = {  1, glBooleanv },
  [g.GL_PACK_ROW_LENGTH]                      = {  1, glUintv    },
  [g.GL_PACK_SKIP_IMAGES]                     = {  1, glUintv    },
  [g.GL_PACK_SKIP_PIXELS]                     = {  1, glUintv    },
  [g.GL_PACK_SKIP_ROWS]                       = {  1, glUintv    },
  [g.GL_PACK_SWAP_BYTES]                      = {  1, glBooleanv },
  [g.GL_PIXEL_PACK_BUFFER_BINDING]            = {  1, glUintv    },
  [g.GL_PIXEL_UNPACK_BUFFER_BINDING]          = {  1, glUintv    },
  [g.GL_POINT_FADE_THRESHOLD_SIZE]            = {  1, glFloatv   },
  [g.GL_POINT_SIZE]                           = {  1, glFloatv   },
  [g.GL_POINT_SIZE_GRANULARITY]               = {  1, glFloatv   },
  [g.GL_POINT_SIZE_RANGE]                     = {  1, glFloatv   },
  [g.GL_POLYGON_OFFSET_FACTOR]                = {  1, glFloatv   },
  [g.GL_POLYGON_OFFSET_UNITS]                 = {  1, glFloatv   },
  [g.GL_POLYGON_OFFSET_FILL]                  = {  1, glBooleanv },
  [g.GL_POLYGON_OFFSET_LINE]                  = {  1, glBooleanv },
  [g.GL_POLYGON_OFFSET_POINT]                 = {  1, glBooleanv },
  [g.GL_POLYGON_SMOOTH]                       = {  1, glBooleanv },
  [g.GL_POLYGON_SMOOTH_HINT]                  = {  1, glEnumv    },
  [g.GL_READ_BUFFER]                          = {  1, glEnumv    },
  [g.GL_SAMPLE_BUFFERS]                       = {  1, glSizeiv   },
  [g.GL_SAMPLE_COVERAGE_VALUE]                = {  1, glFloatv   },
  [g.GL_SAMPLE_COVERAGE_INVERT]               = {  1, glBooleanv },
  [g.GL_SAMPLES]                              = {  1, glSizeiv   },
  [g.GL_SCISSOR_BOX]                          = {  4, glUintv    },
  [g.GL_SCISSOR_TEST]                         = {  1, glBooleanv },
  [g.GL_SMOOTH_LINE_WIDTH_RANGE]              = {  2, glFloatv   },
  [g.GL_SMOOTH_LINE_WIDTH_GRANULARITY]        = {  1, glFloatv   },
  [g.GL_SMOOTH_POINT_SIZE_RANGE]              = {  2, glFloatv   },
  [g.GL_SMOOTH_POINT_SIZE_GRANULARITY]        = {  1, glFloatv   },
  [g.GL_STENCIL_BACK_FAIL]                    = {  1, glEnumv    },
  [g.GL_STENCIL_BACK_FUNC]                    = {  1, glEnumv    },
  [g.GL_STENCIL_BACK_PASS_DEPTH_FAIL]         = {  1, glEnumv    },
  [g.GL_STENCIL_BACK_PASS_DEPTH_PASS]         = {  1, glEnumv    },
  [g.GL_STENCIL_BACK_REF]                     = {  1, glIntv     },
  [g.GL_STENCIL_BACK_VALUE_MASK]              = {  1, glUintv    },
  [g.GL_STENCIL_BACK_WRITEMASK]               = {  1, glUintv    },
  [g.GL_STENCIL_CLEAR_VALUE]                  = {  1, glIntv     },
  [g.GL_STENCIL_FAIL]                         = {  1, glEnumv    },
  [g.GL_STENCIL_FUNC]                         = {  1, glEnumv    },
  [g.GL_STENCIL_PASS_DEPTH_FAIL]              = {  1, glEnumv    },
  [g.GL_STENCIL_PASS_DEPTH_PASS]              = {  1, glEnumv    },
  [g.GL_STENCIL_REF]                          = {  1, glIntv     },
  [g.GL_STENCIL_TEST]                         = {  1, glBooleanv },
  [g.GL_STENCIL_VALUE_MASK]                   = {  1, glUintv    },
  [g.GL_STENCIL_WRITEMASK]                    = {  1, glUintv    },
  [g.GL_STEREO]                               = {  1, glBooleanv },
  [g.GL_SUBPIXEL_BITS]                        = {  1, glSizeiv   },
  [g.GL_TEXTURE_1D]                           = {  1, glBooleanv },
  [g.GL_TEXTURE_BINDING_1D]                   = {  1, glUintv    },
  [g.GL_TEXTURE_2D]                           = {  1, glBooleanv },
  [g.GL_TEXTURE_BINDING_2D]                   = {  1, glUintv    },
  [g.GL_TEXTURE_3D]                           = {  1, glBooleanv },
  [g.GL_TEXTURE_BINDING_3D]                   = {  1, glUintv    },
  [g.GL_TEXTURE_BINDING_CUBE_MAP]             = {  1, glUintv    },
  [g.GL_TEXTURE_COMPRESSION_HINT]             = {  1, glEnumv    },
  [g.GL_TEXTURE_CUBE_MAP]                     = {  1, glBooleanv },
  [g.GL_UNPACK_ALIGNMENT]                     = {  1, glUintv    },
  [g.GL_UNPACK_IMAGE_HEIGHT]                  = {  1, glUintv    },
  [g.GL_UNPACK_LSB_FIRST]                     = {  1, glUintv    },
  [g.GL_UNPACK_ROW_LENGTH]                    = {  1, glUintv    },
  [g.GL_UNPACK_SKIP_IMAGES]                   = {  1, glUintv    },
  [g.GL_UNPACK_SKIP_PIXELS]                   = {  1, glUintv    },
  [g.GL_UNPACK_SKIP_ROWS]                     = {  1, glUintv    },
  [g.GL_UNPACK_SWAP_BYTES]                    = {  1, glBooleanv },
  [g.GL_VIEWPORT]                             = {  4, glUintv    }
}
local glGetTypeMap = {
  [glFloatv]   = g.glGetFloatv,
  [glIntv]     = g.glGetIntegerv,
  [glUintv]    = g.glGetIntegerv,
  [glSizeiv]   = g.glGetIntegerv,
  [glBooleanv] = g.glGetBooleanv,
  [glEnumv]    = g.glGetIntegerv,
  [glClampfv]  = g.glGetFloatv,
  [glClampdv]  = g.glGetDoublev
}
M.Get = function(what)
  local class = glGetMap[what]
  if class == nil then
    return nil
  end
  local m = class[2](class[1])
  glGetTypeMap[class[2]](what, m)
  if class[1] == 1 then
    if ffi.istype(class[2], glBooleanv) then
      return m[0] == g.GL_TRUE
    end
    return m[0]
  end
  return m
end
local glGetShaderMap = {
  [g.GL_SHADER_TYPE]          = {  1, false },
  [g.GL_DELETE_STATUS]        = {  1, true  },
  [g.GL_COMPILE_STATUS]       = {  1, true  },
  [g.GL_INFO_LOG_LENGTH]      = {  1, false },
  [g.GL_SHADER_SOURCE_LENGTH] = {  1, false },
}
function M.GetShader(shader, what)
  local class = glGetShaderMap[what]
  if class == nil then
    return nil
  end
  local m = glIntv(class[1])
  g.glGetShaderiv(shader, what, m)
  if class[1] == 1 then
    if class[2] then
      return m[0] == g.GL_TRUE
    end
    return m[0]
  end
  return m
end
function M.GetShaderInfoLog(shader)
  local logSize  = M.GetShader(shader, g.GL_INFO_LOG_LENGTH)
  local logSizep = glSizeiv(1)
  if logSize == nil or logSize <= 0 then
    return nil
  end
  local log = glCharv(logSize+1)
  g.glGetShaderInfoLog(shader, logSize+1, logSizep, log)
  return ffi.string(log)
end
function M.ShaderSource(shader, source)
  local sourcep = glCharv(#source + 1)
  ffi.copy(sourcep, source)
  local sourcepp = glConstCharpp(sourcep)
  g.glShaderSource(shader, 1, sourcepp, NULL)
end
local glGetProgramMap = {
  [g.GL_DELETE_STATUS]               = {  1, true  },
  [g.GL_LINK_STATUS]                 = {  1, true  },
  [g.GL_VALIDATE_STATUS]             = {  1, true  },
  [g.GL_INFO_LOG_LENGTH]             = {  1, false },
  [g.GL_ATTACHED_SHADERS]            = {  1, false },
  [g.GL_ACTIVE_ATTRIBUTES]           = {  1, false },
  [g.GL_ACTIVE_ATTRIBUTE_MAX_LENGTH] = {  1, false },
  [g.GL_ACTIVE_UNIFORMS]             = {  1, false },
  [g.GL_ACTIVE_UNIFORMS]             = {  1, false },
}
function M.GetProgram(program, what)
  local class = glGetProgramMap[what]
  if class == nil then
    return nil
  end
  local m = glIntv(class[1])
  g.glGetProgramiv(program, what, m)
  if class[1] == 1 then
    if class[2] then
      return m[0] == g.GL_TRUE
    end
    return m[0]
  end
  return m
end
function M.GetProgramInfoLog(program)
  local logSize  = M.GetProgram(program, g.GL_INFO_LOG_LENGTH)
  local logSizep = glSizeiv(1)
  if logSize == nil or logSize <= 0 then
    return nil
  end
  local log = glCharv(logSize+1)
  g.glGetProgramInfoLog(program, logSize+1, logSizep, log)
  return ffi.string(log)
end

-- make glGetString return regular string
M.GetString = function(what)
  return ffi.string(g.glGetString(what))
end

-- make glGetString return regular string
M.GenTextures = function(num, out)
  num = num or 1
  out = out or glUintv(num)
  g.glGenTextures(num, out)
  return out
end
M.GenTexture = function()
  return M.GenTextures(1)[0]
end
M.DeleteTexture = function(texture)
  return M.DeleteTextures(1, glUintv(1, texture))
end

-- light vaarg functions
M.Material = function(face, type, ...)
  return g.glMaterialfv(face, type, glFloatv(select('#', ...), ...))
end
M.Light = function(face, type, ...)
  return g.glLightfv(face, type, glFloatv(select('#', ...), ...))
end

-- renders solid cube with proper texture & normal map coords
function M.SolidCube(s)
  g.glBegin(g.GL_QUADS)
  -- front
  g.glNormal3f(0, 0, 1)
  g.glTexCoord2f(1, 1) g.glVertex3f(-s/2, -s/2,  s/2)
  g.glTexCoord2f(0, 1) g.glVertex3f( s/2, -s/2,  s/2)
  g.glTexCoord2f(0, 0) g.glVertex3f( s/2,  s/2,  s/2)
  g.glTexCoord2f(1, 0) g.glVertex3f(-s/2,  s/2,  s/2)
  -- back
  g.glNormal3f(0, 0, -1)
  g.glTexCoord2f(1, 1) g.glVertex3f( s/2, -s/2, -s/2)
  g.glTexCoord2f(0, 1) g.glVertex3f(-s/2, -s/2, -s/2)
  g.glTexCoord2f(0, 0) g.glVertex3f(-s/2,  s/2, -s/2)
  g.glTexCoord2f(1, 0) g.glVertex3f( s/2,  s/2, -s/2)
  -- top
  g.glNormal3f(0, 1, 0)
  g.glTexCoord2f(1, 1) g.glVertex3f( s/2,  s/2, -s/2)
  g.glTexCoord2f(0, 1) g.glVertex3f(-s/2,  s/2, -s/2)
  g.glTexCoord2f(0, 0) g.glVertex3f(-s/2,  s/2,  s/2)
  g.glTexCoord2f(1, 0) g.glVertex3f( s/2,  s/2,  s/2)
  -- bottom
  g.glNormal3f(0, -1, 0)
  g.glTexCoord2f(1, 1) g.glVertex3f(-s/2, -s/2, -s/2)
  g.glTexCoord2f(0, 1) g.glVertex3f( s/2, -s/2, -s/2)
  g.glTexCoord2f(0, 0) g.glVertex3f( s/2, -s/2,  s/2)
  g.glTexCoord2f(1, 0) g.glVertex3f(-s/2, -s/2,  s/2)
  -- left
  g.glNormal3f(-1, 0, 0)
  g.glTexCoord2f(1, 1) g.glVertex3f(-s/2, -s/2, -s/2)
  g.glTexCoord2f(0, 1) g.glVertex3f(-s/2, -s/2,  s/2)
  g.glTexCoord2f(0, 0) g.glVertex3f(-s/2,  s/2,  s/2)
  g.glTexCoord2f(1, 0) g.glVertex3f(-s/2,  s/2, -s/2)
  -- right
  g.glNormal3f(1, 0, 0)
  g.glTexCoord2f(1, 1) g.glVertex3f( s/2, -s/2,  s/2)
  g.glTexCoord2f(0, 1) g.glVertex3f( s/2, -s/2, -s/2)
  g.glTexCoord2f(0, 0) g.glVertex3f( s/2,  s/2, -s/2)
  g.glTexCoord2f(1, 0) g.glVertex3f( s/2,  s/2,  s/2)
  g.glEnd()
end

-- index metamethod removing gl prefix for funtions
-- and GL_ prefix for constants
setmetatable(M, { __index = function(t, n)
  local s
  -- all functions contain at least one small letter
  if n:find('[a-z]') then
    s = g['gl'..n]
  elseif n:find('^UT?_') then
    s = g['GL'..n]
  else
    s = g['GL_'..n]
  end
  rawset(t, n, s)
  return s
end })

return M
