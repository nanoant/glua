-- LuaJIT FFI extensions for OpenGL & GLUT
-- Created by: Adam Strzelecki http://www.nanoant.com/

local lib = require 'glua.gl.glut'
local ffi = require 'ffi'
local bit = require 'bit'
local gl  = require 'glua.matrix' -- inherit matrix operators

-- OSX compatiblity extensions
local onOSX = false
if ffi.os == 'OSX' then
  require 'glua.mac.glext'
  onOSX = true
end

-- load image library, use CoreGraphics on Mac
-- and libpng on other platforms
local imglib = require(onOSX and 'glua.mac.CoreGraphics' or 'glua.lib.png')

-- index metamethod removing gl prefix for funtions
-- and GL_ prefix for constants
local glDebug       = false
local glCoreProfile = false
local glErrorMap
setmetatable(gl, { __index = function(t, n)
  local s
  -- all functions contain at least one small letter
  if n:find('[a-z]') then
    s = lib['gl'..n]
    if glDebug and not n:find('^ut') then
      return function(...)
        local r = s(...)
        local e = lib.glGetError()
        if e ~= 0 then error(string.format('gl%s: GL_%s', n, glErrorMap[e] or e)) end
        return r
      end
    end
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

-- PATH UTIL -----------------------------------------------------------------

function gl.path(name, type)
  type = type or ''
  if not type:find('^[.]') then type = '.' .. type end
  return package.searchpath(name, string.gsub(package.path, '[.]lua', type))
end

-- ERRORS --------------------------------------------------------------------

glErrorMap = {
  [gl.NO_ERROR]          = 'NO_ERROR: No error has been recorded.',
  [gl.INVALID_ENUM]      = 'INVALID_ENUM: An unacceptable value is specified for an enumerated argument.',
  [gl.INVALID_VALUE]     = 'INVALID_VALUE: A numeric argument is out of range.',
  [gl.INVALID_OPERATION] = 'INVALID_OPERATION: The specified operation is not allowed in the current state.',
  [gl.OUT_OF_MEMORY]     = 'OUT_OF_MEMORY: There is not enough memory left to execute the command.',
}

-- FREEGLUT COMPATIBILITY FOR OSX --------------------------------------------
-- NOTE: requires patched GLUT.framework https://github.com/nanoant/osxglut
if onOSX then
  local contextVersion, contextProfile
  function gl.utInitContextVersion(major, minor) contextVersion = major * 10 + minor end
  function gl.utInitContextProfile(profile)      contextProfile = profile end
  function gl.utInitContextFlags(flags)          glDebug = bit.band(flags, gl.UT_DEBUG) ~= 0 end
  function gl.utInitDisplayString(string)
    -- NOTE: core profile works only for glutInitDisplayString
    glCoreProfile = contextProfile == gl.UT_CORE_PROFILE
    if contextVersion and (contextVersion < 30 or glCoreProfile) then
      string = string.format('%s profile=%d', string, contextVersion)
    end
    lib.glutInitDisplayString(string)
  end
else
  function gl.utInitContextProfile(profile)
    glCoreProfile = profile == gl.UT_CORE_PROFILE
    return lib.glutInitContextProfile(profile)
  end
end

-- GETTERS -------------------------------------------------------------------

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

local program = {}
local programMT = {}
function gl.program(shaderPaths)
  local program = gl.CreateProgram()
  for type, path in pairs(shaderPaths) do
    local f = assert(io.open(path, 'rb'))
    local source = f:read('*all')
    f:close()
    -- append version if we are running higher (core) profiles
    -- do not append new line if it is not necessary
    if glCoreProfile and not source:find('^%s*#version') then
      local version = tonumber(gl.GetString(gl.SHADING_LANGUAGE_VERSION))
      source = string.format('#version %d core%s%s', version * 100, source:find('^%s*/[*/]') and ' ' or "\n", source)
    end
    local shader = gl.CreateShader(type)
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
  return setmetatable({ gl = program, locations = {} }, programMT)
end

function programMT:__index(uniform)
  local location = self.locations[uniform]
  if location == nil then
    location = gl.GetUniformLocation(self.gl, uniform)
    self.locations[uniform] = location
  end
  return location
end

local glMatrix4fv = glFloatv(16)
local glMatrix3fv = glFloatv(9)
local glMatrix2fv = glFloatv(4)

function programMT:__newindex(uniform, value)
  local location = self[uniform]
  if ffi.istype(glFloatv, value) then
    if ffi.sizeof(value) == 64 then
      gl.UniformMatrix4fv(location,  1, gl.TRUE, value)
    elseif ffi.sizeof(value) == 36 then
      gl.UniformMatrix3fv(location,  1, gl.TRUE, value)
    elseif ffi.sizeof(value) == 16 then
      gl.UniformMatrix2fv(location,  1, gl.TRUE, value)
    end
  elseif ffi.istype(gl.mat4, value) then
    glMatrix4fv[0]  = value.m11
    glMatrix4fv[1]  = value.m21
    glMatrix4fv[2]  = value.m31
    glMatrix4fv[3]  = value.m41
    glMatrix4fv[4]  = value.m12
    glMatrix4fv[5]  = value.m22
    glMatrix4fv[6]  = value.m32
    glMatrix4fv[7]  = value.m42
    glMatrix4fv[8]  = value.m13
    glMatrix4fv[9]  = value.m23
    glMatrix4fv[10] = value.m33
    glMatrix4fv[11] = value.m43
    glMatrix4fv[12] = value.m14
    glMatrix4fv[13] = value.m24
    glMatrix4fv[14] = value.m34
    glMatrix4fv[15] = value.m44
    gl.UniformMatrix4fv(location,  1, gl.TRUE, glMatrix4fv)
  elseif ffi.istype(gl.mat3, value) then
    glMatrix3fv[0] = value.m11
    glMatrix3fv[1] = value.m21
    glMatrix3fv[2] = value.m31
    glMatrix3fv[3] = value.m12
    glMatrix3fv[4] = value.m22
    glMatrix3fv[5] = value.m32
    glMatrix3fv[6] = value.m13
    glMatrix3fv[7] = value.m23
    glMatrix3fv[8] = value.m33
    gl.UniformMatrix3fv(location,  1, gl.TRUE, glMatrix3fv)
  elseif ffi.istype(gl.mat2, value) then
    glMatrix2fv[0] = value.m11
    glMatrix2fv[1] = value.m21
    glMatrix2fv[2] = value.m12
    glMatrix2fv[3] = value.m22
    gl.UniformMatrix2fv(location,  1, gl.TRUE, glMatrix2fv)
  elseif type(value) == 'table' then
    gl['Uniform'..#value..'f'](location, unpack(value))
  else
    gl.Uniform1f(location, value)
  end
end

function programMT:__gc()
  gl.DeleteProgram(self.gl)
end

function programMT:__call()
  gl.UseProgram(self.gl)
  return self
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

local texture = {}
local textureMT = { __index = texture }

function gl.texture(path, target)
  local data, width, height, channels = imglib.Bitmap(path)
  if data then
    local storage = glTextureStorageMap[channels]
    local texture = gl.GenTexture()
    if target then gl.ActiveTexture(gl.TEXTURE0 + target) end
    gl.BindTexture(gl.TEXTURE_2D, texture)
    gl.TexImage2D(gl.TEXTURE_2D,
                  0,                  -- level
                  storage,            -- internal texture storage format
                  width,              -- texture width
                  height,             -- texture height
                  0,                  -- border
                  storage,            -- pixel format
                  gl.UNSIGNED_BYTE,   -- color component format
                  data)               -- pointer to texture image
    gl.GenerateMipmap(gl.TEXTURE_2D)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
    return setmetatable({ gl = texture, target = target }, textureMT)
  end
  return nil
end

function textureMT:__gc()
  gl.DeleteTexture(self.gl)
end

function textureMT:__call(target)
  if target then gl.ActiveTexture(gl.TEXTURE0 + target) end
  gl.BindTexture(self.gl)
  return self
end

function gl.textures(paths)
  local textures = {}
  for target, path in pairs(paths) do
    textures[#textures+1] = gl.texture(path, target)
  end
end

-- BUFFERS -------------------------------------------------------------------

function gl.GenBuffers(num, out)
  num = num or 1
  out = out or glUintv(num)
  lib.glGenBuffers(num, out)
  if glDebug then
    local e = lib.glGetError()
    if e ~= 0 then error(glErrorMap[e] or e) end
  end
  return out
end
function gl.GenBuffer()
  return gl.GenBuffers(1)[0]
end
function gl.DeleteBuffer(...)
  return gl.DeleteBuffers(select('#', ...), glUintv(select('#', ...), ...))
end

-- ARRAYS --------------------------------------------------------------------

-- NOTE: in non 3.2 core profile (<Lion) we must use APPLE extensions for
-- vertex arrays, because regular fail with GL_INVALID_OPERATION
if onOSX then
  function gl.BindVertexArray(...)
    local f = not glCoreProfile and lib.glBindVertexArrayAPPLE or lib.glBindVertexArray
    local r = f(...)
    if glDebug then
      local e = lib.glGetError()
      if e ~= 0 then error(glErrorMap[e] or e) end
    else
      rawset(gl, 'BindVertexArray', f)
    end
    return r
  end
  function gl.IsVertexArray(...)
    local f = not glCoreProfile and lib.glIsVertexArrayAPPLE or lib.glIsVertexArray
    local r = f(...)
    if glDebug then
      local e = lib.glGetError()
      if e ~= 0 then error(glErrorMap[e] or e) end
    else
      rawset(gl, 'IsVertexArray', f)
    end
    return r
  end
end
function gl.GenVertexArrays(num, out)
  num = num or 1
  out = out or glUintv(num)
  if onOSX and not glCoreProfile then
    lib.glGenVertexArraysAPPLE(num, out)
  else
    lib.glGenVertexArrays(num, out)
  end
  if glDebug then
    local e = lib.glGetError()
    if e ~= 0 then error(glErrorMap[e] or e) end
  end
  return out
end
function gl.GenVertexArray()
  return gl.GenVertexArrays(1)[0]
end
function gl.DeleteVertexArray(...)
  if onOSX and not glCoreProfile then
    lib.glDeleteVertexArraysAPPLE(select('#', ...), glUintv(select('#', ...), ...))
  else
    lib.glDeleteVertexArrays(select('#', ...), glUintv(select('#', ...), ...))
  end
  if glDebug then
    local e = lib.glGetError()
    if e ~= 0 then error(glErrorMap[e] or e) end
  end
end
local function glLoadArray(program, ptr, ...)
  local attr = {}
  local vertexSize = 0
  local i = 1
  local count = select('#', ...)
  while i <= count do
    local size     = select(i, ...)
    local next     = i < count and select(i+1, ...) or nil
    local location = i-1
    i = i+1
    if type(size) == 'string' then
      if program then
        location = gl.GetAttribLocation(program, size)
      end
      size = next
      if type(size) == 'string' or next == nil then
        size = 3 -- default size if not specified
      else
        i = i+1
      end
    end
    if location >= 0 then
      attr[#attr+1] = { location = location, size = size }
      vertexSize = vertexSize + size
    end
  end
  if #attr == 0 then
    attr[#attr+1] = { location = 0, size = 3 }
    vertexSize = 3
  end
  vertexSize = ffi.sizeof(glFloatv, vertexSize)
  local totalSize = 0
  for i = 1, #attr do
    gl.VertexAttribPointer(attr[i].location, attr[i].size, gl.FLOAT, gl.FALSE, vertexSize, ptr+totalSize)
    gl.EnableVertexAttribArray(attr[i].location)
    totalSize = totalSize + attr[i].size
  end
  return totalSize
end

local array = {}
local arrayMT = {}

function gl.array(program, data, ...)
  local array = gl.GenVertexArray()
  local glProgram = type(program) == 'table' and program.gl or program
  gl.BindVertexArray(array)
  local buf  = gl.GenBuffer()
  local size = ffi.sizeof(glFloatv, #data)
  local ptr  = glFloatv(#data, data)
  gl.BindBuffer(gl.ARRAY_BUFFER, buf)
  gl.BufferData(gl.ARRAY_BUFFER, size, ptr, gl.STATIC_DRAW)
  local self = setmetatable({ program = program, gl = array, size = math.floor(#data / glLoadArray(glProgram, glFloatp(nil), ...)) }, arrayMT)
  gl.BindBuffer(gl.ARRAY_BUFFER, 0)
  return self
end

-- NOTE: this is NOT supported in core profile
function gl.draw(program, mode, data, ...)
  local glProgram = type(program) == 'table' and program.gl or program
  local ptr = glFloatv(#data, data)
  gl.DrawArrays(gl.TRIANGLES, 0, math.floor(#data / glLoadArray(glProgram, ptr, ...)))
end

function arrayMT:__gc(self)
  gl.DeleteVertexArray(self.gl)
end

function arrayMT:__call(mode, from, size)
  mode = mode or gl.TRIANGLES
  from = from or 0
  size = size or self.size
  gl.BindVertexArray(self.gl)
  gl.DrawArrays(mode, from, size)
  return self
end

return gl
