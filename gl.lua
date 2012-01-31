-- LuaJIT FFI extensions for OpenGL & GLUT
-- Created by: Adam Strzelecki http://www.nanoant.com/

local lib = require 'gl.glut'
local ffi = require 'ffi'
local gl  = require 'matrix' -- inherit matrix operators

-- load image library, use CoreGraphics on Mac
-- and libpng on other platforms
local imglib = require(ffi.os == 'OSX' and 'mac.CoreGraphics' or 'lib.png')

-- index metamethod removing gl prefix for funtions
-- and GL_ prefix for constants
setmetatable(gl, { __index = function(t, n)
  local s
  -- all functions contain at least one small letter
  if n:find('[a-z]') then
    s = lib['gl'..n]
  elseif n:find('^UT?_') then
    s = lib['GL'..n]
  else
    s = lib['GL_'..n]
  end
  rawset(t, n, s)
  return s
end })

-- float vector type
local glFloatp   = ffi.typeof('GLfloat *')
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
function gl.utTimerCallback(f) return ffi.cast('glutTimerCallback', f) end
function gl.utIdleCallback(f)  return ffi.cast('glutIdleCallback', f)  end

-- automatic vector generating get
-- http://www.opengl.org/sdk/docs/man/xhtml/glGet.xml
local glGetMap = {
  [gl.ACTIVE_TEXTURE]                       = {  1, glEnumv    },
  [gl.ALIASED_LINE_WIDTH_RANGE]             = {  2, glFloatv   },
  [gl.ARRAY_BUFFER_BINDING]                 = {  1, glUintv    },
  [gl.BLEND]                                = {  1, glBooleanv },
  [gl.BLEND_COLOR]                          = {  4, glFloatv   },
  [gl.BLEND_DST_ALPHA]                      = {  1, glEnumv    },
  [gl.BLEND_DST_RGB]                        = {  1, glEnumv    },
  [gl.BLEND_EQUATION_RGB]                   = {  1, glEnumv    },
  [gl.BLEND_EQUATION_ALPHA]                 = {  1, glEnumv    },
  [gl.BLEND_SRC_ALPHA]                      = {  1, glEnumv    },
  [gl.BLEND_SRC_RGB]                        = {  1, glEnumv    },
  [gl.COLOR_CLEAR_VALUE]                    = {  4, glFloatv   },
  [gl.COLOR_LOGIC_OP]                       = {  1, glEnumv    },
  [gl.COLOR_WRITEMASK]                      = {  4, glBooleanv },
  [gl.COMPRESSED_TEXTURE_FORMATS]           = { gl.NUM_COMPRESSED_TEXTURE_FORMATS, glEnumv },
  [gl.CULL_FACE]                            = {  1, glBooleanv },
  [gl.CULL_FACE_MODE]                       = {  1, glEnumv    },
  [gl.CURRENT_PROGRAM]                      = {  1, glUintv    },
  [gl.DEPTH_CLEAR_VALUE]                    = {  1, glClampd   },
  [gl.DEPTH_FUNC]                           = {  1, glEnumv    },
  [gl.DEPTH_RANGE]                          = {  2, glClampd   },
  [gl.DEPTH_TEST]                           = {  1, glBooleanv },
  [gl.DEPTH_WRITEMASK]                      = {  1, glBooleanv },
  [gl.DITHER]                               = {  1, glBooleanv },
  [gl.DOUBLEBUFFER]                         = {  1, glBooleanv },
  [gl.DRAW_BUFFER]                          = {  1, glEnumv    },
  [gl.DRAW_BUFFER0]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER1]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER2]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER3]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER4]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER5]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER6]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER7]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER8]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER9]                         = {  1, glEnumv    },
  [gl.DRAW_BUFFER10]                        = {  1, glEnumv    },
  [gl.DRAW_BUFFER11]                        = {  1, glEnumv    },
  [gl.DRAW_BUFFER12]                        = {  1, glEnumv    },
  [gl.DRAW_BUFFER13]                        = {  1, glEnumv    },
  [gl.DRAW_BUFFER14]                        = {  1, glEnumv    },
  [gl.DRAW_BUFFER15]                        = {  1, glEnumv    },
  [gl.ELEMENT_ARRAY_BUFFER_BINDING]         = {  1, glUintv    },
  [gl.FRAGMENT_SHADER_DERIVATIVE_HINT]      = {  1, glEnumv    },
  [gl.FRONT_FACE]                           = {  1, glEnumv    },
  [gl.LINE_SMOOTH]                          = {  1, glBooleanv },
  [gl.LINE_SMOOTH_HINT]                     = {  1, glEnumv    },
  [gl.LINE_WIDTH]                           = {  1, glFloatv   },
  [gl.LINE_WIDTH_GRANULARITY]               = {  1, glFloatv   },
  [gl.LINE_WIDTH_RANGE]                     = {  2, glFloatv   },
  [gl.LOGIC_OP_MODE]                        = {  1, glEnumv    },
  [gl.MAX_3D_TEXTURE_SIZE]                  = {  1, glSizeiv   },
  [gl.MAX_COMBINED_TEXTURE_IMAGE_UNITS]     = {  1, glSizeiv   },
  [gl.MAX_CUBE_MAP_TEXTURE_SIZE]            = {  1, glSizeiv   },
  [gl.MAX_DRAW_BUFFERS]                     = {  1, glSizeiv   },
  [gl.MAX_ELEMENTS_INDICES]                 = {  1, glSizeiv   },
  [gl.MAX_ELEMENTS_VERTICES]                = {  1, glSizeiv   },
  [gl.MAX_FRAGMENT_UNIFORM_COMPONENTS]      = {  1, glSizeiv   },
  [gl.MAX_TEXTURE_IMAGE_UNITS]              = {  1, glSizeiv   },
  [gl.MAX_TEXTURE_LOD_BIAS]                 = {  1, glSizeiv   },
  [gl.MAX_TEXTURE_SIZE]                     = {  1, glSizeiv   },
  [gl.MAX_VARYING_FLOATS]                   = {  1, glSizeiv   },
  [gl.MAX_VERTEX_ATTRIBS]                   = {  1, glSizeiv   },
  [gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS]       = {  1, glSizeiv   },
  [gl.MAX_VERTEX_UNIFORM_COMPONENTS]        = {  1, glSizeiv   },
  [gl.MAX_VIEWPORT_DIMS]                    = {  2, glSizeiv   },
  [gl.NUM_COMPRESSED_TEXTURE_FORMATS]       = {  1, glUintv    },
  [gl.PACK_ALIGNMENT]                       = {  1, glUintv    },
  [gl.PACK_IMAGE_HEIGHT]                    = {  1, glUintv    },
  [gl.PACK_LSB_FIRST]                       = {  1, glBooleanv },
  [gl.PACK_ROW_LENGTH]                      = {  1, glUintv    },
  [gl.PACK_SKIP_IMAGES]                     = {  1, glUintv    },
  [gl.PACK_SKIP_PIXELS]                     = {  1, glUintv    },
  [gl.PACK_SKIP_ROWS]                       = {  1, glUintv    },
  [gl.PACK_SWAP_BYTES]                      = {  1, glBooleanv },
  [gl.PIXEL_PACK_BUFFER_BINDING]            = {  1, glUintv    },
  [gl.PIXEL_UNPACK_BUFFER_BINDING]          = {  1, glUintv    },
  [gl.POINT_FADE_THRESHOLD_SIZE]            = {  1, glFloatv   },
  [gl.POINT_SIZE]                           = {  1, glFloatv   },
  [gl.POINT_SIZE_GRANULARITY]               = {  1, glFloatv   },
  [gl.POINT_SIZE_RANGE]                     = {  1, glFloatv   },
  [gl.POLYGON_OFFSET_FACTOR]                = {  1, glFloatv   },
  [gl.POLYGON_OFFSET_UNITS]                 = {  1, glFloatv   },
  [gl.POLYGON_OFFSET_FILL]                  = {  1, glBooleanv },
  [gl.POLYGON_OFFSET_LINE]                  = {  1, glBooleanv },
  [gl.POLYGON_OFFSET_POINT]                 = {  1, glBooleanv },
  [gl.POLYGON_SMOOTH]                       = {  1, glBooleanv },
  [gl.POLYGON_SMOOTH_HINT]                  = {  1, glEnumv    },
  [gl.READ_BUFFER]                          = {  1, glEnumv    },
  [gl.SAMPLE_BUFFERS]                       = {  1, glSizeiv   },
  [gl.SAMPLE_COVERAGE_VALUE]                = {  1, glFloatv   },
  [gl.SAMPLE_COVERAGE_INVERT]               = {  1, glBooleanv },
  [gl.SAMPLES]                              = {  1, glSizeiv   },
  [gl.SCISSOR_BOX]                          = {  4, glUintv    },
  [gl.SCISSOR_TEST]                         = {  1, glBooleanv },
  [gl.SMOOTH_LINE_WIDTH_RANGE]              = {  2, glFloatv   },
  [gl.SMOOTH_LINE_WIDTH_GRANULARITY]        = {  1, glFloatv   },
  [gl.SMOOTH_POINT_SIZE_RANGE]              = {  2, glFloatv   },
  [gl.SMOOTH_POINT_SIZE_GRANULARITY]        = {  1, glFloatv   },
  [gl.STENCIL_BACK_FAIL]                    = {  1, glEnumv    },
  [gl.STENCIL_BACK_FUNC]                    = {  1, glEnumv    },
  [gl.STENCIL_BACK_PASS_DEPTH_FAIL]         = {  1, glEnumv    },
  [gl.STENCIL_BACK_PASS_DEPTH_PASS]         = {  1, glEnumv    },
  [gl.STENCIL_BACK_REF]                     = {  1, glIntv     },
  [gl.STENCIL_BACK_VALUE_MASK]              = {  1, glUintv    },
  [gl.STENCIL_BACK_WRITEMASK]               = {  1, glUintv    },
  [gl.STENCIL_CLEAR_VALUE]                  = {  1, glIntv     },
  [gl.STENCIL_FAIL]                         = {  1, glEnumv    },
  [gl.STENCIL_FUNC]                         = {  1, glEnumv    },
  [gl.STENCIL_PASS_DEPTH_FAIL]              = {  1, glEnumv    },
  [gl.STENCIL_PASS_DEPTH_PASS]              = {  1, glEnumv    },
  [gl.STENCIL_REF]                          = {  1, glIntv     },
  [gl.STENCIL_TEST]                         = {  1, glBooleanv },
  [gl.STENCIL_VALUE_MASK]                   = {  1, glUintv    },
  [gl.STENCIL_WRITEMASK]                    = {  1, glUintv    },
  [gl.STEREO]                               = {  1, glBooleanv },
  [gl.SUBPIXEL_BITS]                        = {  1, glSizeiv   },
  [gl.TEXTURE_1D]                           = {  1, glBooleanv },
  [gl.TEXTURE_BINDING_1D]                   = {  1, glUintv    },
  [gl.TEXTURE_2D]                           = {  1, glBooleanv },
  [gl.TEXTURE_BINDING_2D]                   = {  1, glUintv    },
  [gl.TEXTURE_3D]                           = {  1, glBooleanv },
  [gl.TEXTURE_BINDING_3D]                   = {  1, glUintv    },
  [gl.TEXTURE_BINDING_CUBE_MAP]             = {  1, glUintv    },
  [gl.TEXTURE_COMPRESSION_HINT]             = {  1, glEnumv    },
  [gl.TEXTURE_CUBE_MAP]                     = {  1, glBooleanv },
  [gl.UNPACK_ALIGNMENT]                     = {  1, glUintv    },
  [gl.UNPACK_IMAGE_HEIGHT]                  = {  1, glUintv    },
  [gl.UNPACK_LSB_FIRST]                     = {  1, glUintv    },
  [gl.UNPACK_ROW_LENGTH]                    = {  1, glUintv    },
  [gl.UNPACK_SKIP_IMAGES]                   = {  1, glUintv    },
  [gl.UNPACK_SKIP_PIXELS]                   = {  1, glUintv    },
  [gl.UNPACK_SKIP_ROWS]                     = {  1, glUintv    },
  [gl.UNPACK_SWAP_BYTES]                    = {  1, glBooleanv },
  [gl.VIEWPORT]                             = {  4, glUintv    }
}
local glGetTypeMap = {
  [glFloatv]   = gl.GetFloatv,
  [glIntv]     = gl.GetIntegerv,
  [glUintv]    = gl.GetIntegerv,
  [glSizeiv]   = gl.GetIntegerv,
  [glBooleanv] = gl.GetBooleanv,
  [glEnumv]    = gl.GetIntegerv,
  [glClampfv]  = gl.GetFloatv,
  [glClampdv]  = gl.GetDoublev
}
function gl.Get(what)
  local class = glGetMap[what]
  if class == nil then
    return nil
  end
  local m = class[2](class[1])
  glGetTypeMap[class[2]](what, m)
  if class[1] == 1 then
    if ffi.istype(class[2], glBooleanv) then
      return m[0] == gl.TRUE
    end
    return m[0]
  end
  return m
end
function gl.GetString(what)
  return ffi.string(lib.glGetString(what)) -- make it return regular string
end

-- SHADERS -------------------------------------------------------------------

local glGetShaderMap = {
  [gl.SHADER_TYPE]          = {  1, false },
  [gl.DELETE_STATUS]        = {  1, true  },
  [gl.COMPILE_STATUS]       = {  1, true  },
  [gl.INFO_LOG_LENGTH]      = {  1, false },
  [gl.SHADER_SOURCE_LENGTH] = {  1, false },
}
function gl.GetShader(shader, what)
  local class = glGetShaderMap[what]
  if class == nil then
    return nil
  end
  local m = glIntv(class[1])
  gl.GetShaderiv(shader, what, m)
  if class[1] == 1 then
    if class[2] then
      return m[0] == gl.TRUE
    end
    return m[0]
  end
  return m
end
function gl.GetShaderInfoLog(shader)
  local logSize  = gl.GetShader(shader, gl.INFO_LOG_LENGTH)
  local logSizep = glSizeiv(1)
  if logSize == nil or logSize <= 0 then return "" end
  local log = glCharv(logSize+1)
  lib.glGetShaderInfoLog(shader, logSize+1, logSizep, log)
  return ffi.string(log)
end
function gl.ShaderSource(shader, source)
  local sourcep = glCharv(#source + 1)
  ffi.copy(sourcep, source)
  local sourcepp = glConstCharpp(sourcep)
  lib.glShaderSource(shader, 1, sourcepp, NULL)
end
local glGetProgramMap = {
  [gl.DELETE_STATUS]               = {  1, true  },
  [gl.LINK_STATUS]                 = {  1, true  },
  [gl.VALIDATE_STATUS]             = {  1, true  },
  [gl.INFO_LOG_LENGTH]             = {  1, false },
  [gl.ATTACHED_SHADERS]            = {  1, false },
  [gl.ACTIVE_ATTRIBUTES]           = {  1, false },
  [gl.ACTIVE_ATTRIBUTE_MAX_LENGTH] = {  1, false },
  [gl.ACTIVE_UNIFORMS]             = {  1, false },
  [gl.ACTIVE_UNIFORMS]             = {  1, false },
}
function gl.GetProgram(program, what)
  local class = glGetProgramMap[what]
  if class == nil then
    return nil
  end
  local m = glIntv(class[1])
  gl.GetProgramiv(program, what, m)
  if class[1] == 1 then
    if class[2] then
      return m[0] == gl.TRUE
    end
    return m[0]
  end
  return m
end
function gl.GetProgramInfoLog(program)
  local logSize  = gl.GetProgram(program, gl.INFO_LOG_LENGTH)
  local logSizep = glSizeiv(1)
  if logSize == nil or logSize <= 0 then
    return nil
  end
  local log = glCharv(logSize+1)
  gl.GetProgramInfoLog(program, logSize+1, logSizep, log)
  return ffi.string(constCharp)
end
function gl.Program(shaderPaths)
  local program = gl.CreateProgram()
  for type, path in pairs(shaderPaths) do
    local f = assert(io.open(path, 'rb'))
    local source = f:read('*all')
    local shader = gl.CreateShader(type)
    f:close()
    gl.ShaderSource(shader, source)
    gl.CompileShader(shader)
    if not gl.GetShader(shader, gl.COMPILE_STATUS) then
      error(path.."\n"..gl.GetShaderInfoLog(shader))
    end
    gl.AttachShader(program, shader)
  end
  gl.LinkProgram(program)
  if not gl.GetProgram(program, gl.LINK_STATUS) then
    error(gl.GetProgramInfoLog(program))
  end
  return program
end

-- TEXTURES ------------------------------------------------------------------

function gl.GenTextures(num, out)
  num = num or 1
  out = out or glUintv(num)
  lib.glGenTextures(num, out)
  return out
end
function gl.GenTexture()
  return gl.GenTextures(1)[0]
end
function gl.DeleteTexture(...)
  return gl.DeleteTextures(select('#', ...), glUintv(select('#', ...), ...))
end
local glTextureStorageMap = {
  [1] = gl.ALPHA,
  [3] = gl.RGB,
  [4] = gl.RGBA
}
function gl.Textures(texturePaths)
  local textures = gl.GenTextures(#texturePaths)
  for target, path in pairs(texturePaths) do
    local texture = textures[target] -- zero indexed
    local data, width, height, channels = imglib.Bitmap(path)
    if data then
      local storage = glTextureStorageMap[channels]
      gl.ActiveTexture(gl.TEXTURE0 + target)
      gl.BindTexture(gl.TEXTURE_2D, texture)
      gl.uBuild2DMipmaps(gl.TEXTURE_2D,    -- texture to specify
                          storage,            -- internal texture storage format
                          width,              -- texture width
                          height,             -- texture height
                          storage,            -- pixel format
                          gl.UNSIGNED_BYTE, -- color component format
                          data)               -- pointer to texture image
      data = nil
      gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
      gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
    end
  end
  return textures
end

-- BUFFERS -------------------------------------------------------------------

function gl.GenBuffers(num, out)
  num = num or 1
  out = out or glUintv(num)
  lib.glGenBuffers(num, out)
  return out
end
function gl.GenBuffer()
  return gl.GenBuffers(1)[0]
end
function gl.DeleteBuffer(...)
  return gl.DeleteBuffers(select('#', ...), glUintv(select('#', ...), ...))
end

-- ARRAYS --------------------------------------------------------------------

function gl.GenVertexArrays(num, out)
  num = num or 1
  out = out or glUintv(num)
  lib.glGenVertexArrays(num, out)
  return out
end
function gl.GenVertexArray()
  return gl.GenVertexArrays(1)[0]
end
function gl.DeleteVertexArray(...)
  return gl.DeleteVertexArrays(select('#', ...), glUintv(select('#', ...), ...))
end
function gl.Array(program, data, ...)
  local array = gl.GenVertexArray()
  gl.BindVertexArray(array)
  local buf = gl.GenBuffer()
  local dataSize = ffi.sizeof(glFloatv, #data)
  local data = glFloatv(#data, data)
  gl.BindBuffer(gl.ARRAY_BUFFER, buf)
  gl.BufferData(gl.ARRAY_BUFFER, dataSize, data, gl.STATIC_DRAW)
  local attr = {}
  local vertexSize = 0
  for i = 1, select('#', ...), 2 do
    local location = select(i, ...)
    local size     = select(i+1, ...) or 3
    if type(location) == 'string' then location = gl.GetAttribLocation(program, location) end
    attr[#attr+1] = { location = location, size = size }
    vertexSize = vertexSize + size
  end
  if #attr == 0 then
    attr[#attr+1] = { location = 0, size = 3 }
    vertexSize = 3
  end
  vertexSize = ffi.sizeof(glFloatv, vertexSize)
  local totalSize = 0
  for i = 1, #attr do
    gl.VertexAttribPointer(attr[i].location, attr[i].size, gl.FLOAT, gl.FALSE, vertexSize, glFloatp(nil)+totalSize)
    gl.EnableVertexAttribArray(attr[i].location)
    totalSize = totalSize + attr[i].size
  end
  return array
end

-- MODELS --------------------------------------------------------------------

function gl.PlaneArray(program) return gl.Array(program, gl.plane, 'position', 3, 'normal', 3, 'texCoord', 2) end
function gl.CubeArray(program)  return gl.Array(program, gl.cube,  'position', 3, 'normal', 3, 'texCoord', 2) end
gl.plane = {
  -- vertex  -- normal -- tex coord
  -1, -1,  0,   0,  0,  1,   1, 1,
   1, -1,  0,   0,  0,  1,   0, 1,
   1,  1,  0,   0,  0,  1,   0, 0,
   1,  1,  0,   0,  0,  1,   0, 0, -- dup
  -1,  1,  0,   0,  0,  1,   1, 0,
  -1, -1,  0,   0,  0,  1,   1, 1, -- dup
}
gl.cube = {
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

return gl
