-- LuaJIT FFI extensions for OpenGL & GLUT
-- Created by: Adam Strzelecki http://www.nanoant.com/

local g = require('gl.glut')
local ffi = require('ffi')
local M = {}

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
  [g.GL_ACCUM_ALPHA_BITS]                     = {  1, glSizeiv   },
  [g.GL_ACCUM_BLUE_BITS]                      = {  1, glSizeiv   },
  [g.GL_ACCUM_CLEAR_VALUE]                    = {  4, glFloatv   },
  [g.GL_ACCUM_GREEN_BITS]                     = {  1, glSizeiv   },
  [g.GL_ACCUM_RED_BITS]                       = {  1, glSizeiv   },
  [g.GL_ACTIVE_TEXTURE]                       = {  1, glEnumv    },
  [g.GL_ALIASED_POINT_SIZE_RANGE]             = {  2, glFloatv   },
  [g.GL_ALIASED_LINE_WIDTH_RANGE]             = {  2, glFloatv   },
  [g.GL_ALPHA_BIAS]                           = {  1, glFloatv   },
  [g.GL_ALPHA_BITS]                           = {  1, glSizeiv   },
  [g.GL_ALPHA_SCALE]                          = {  1, glFloatv   },
  [g.GL_ALPHA_TEST]                           = {  1, glBooleanv },
  [g.GL_ALPHA_TEST_FUNC]                      = {  1, glEnumv    },
  [g.GL_ALPHA_TEST_REF]                       = {  1, glClampfv  },
  [g.GL_ARRAY_BUFFER_BINDING]                 = {  1, glUintv    },
  [g.GL_ATTRIB_STACK_DEPTH]                   = {  1, glSizeiv   },
  [g.GL_AUTO_NORMAL]                          = {  1, glBooleanv },
  [g.GL_AUX_BUFFERS]                          = {  1, glSizeiv   },
  [g.GL_BLEND]                                = {  1, glBooleanv },
  [g.GL_BLEND_COLOR]                          = {  4, glFloatv   },
  [g.GL_BLEND_DST_ALPHA]                      = {  1, glEnumv    },
  [g.GL_BLEND_DST_RGB]                        = {  1, glEnumv    },
  [g.GL_BLEND_EQUATION_RGB]                   = {  1, glEnumv    },
  [g.GL_BLEND_EQUATION_ALPHA]                 = {  1, glEnumv    },
  [g.GL_BLEND_SRC_ALPHA]                      = {  1, glEnumv    },
  [g.GL_BLEND_SRC_RGB]                        = {  1, glEnumv    },
  [g.GL_BLUE_BIAS]                            = {  1, glFloatv   },
  [g.GL_BLUE_BITS]                            = {  1, glSizeiv   },
  [g.GL_BLUE_SCALE]                           = {  1, glFloatv   },
  [g.GL_CLIENT_ACTIVE_TEXTURE]                = {  1, glEnumv    },
  [g.GL_CLIENT_ATTRIB_STACK_DEPTH]            = {  1, glSizeiv   },
  [g.GL_CLIP_PLANE0]                          = {  1, glBooleanv },
  [g.GL_CLIP_PLANE1]                          = {  1, glBooleanv },
  [g.GL_CLIP_PLANE2]                          = {  1, glBooleanv },
  [g.GL_CLIP_PLANE3]                          = {  1, glBooleanv },
  [g.GL_CLIP_PLANE4]                          = {  1, glBooleanv },
  [g.GL_CLIP_PLANE5]                          = {  1, glBooleanv },
  [g.GL_COLOR_ARRAY]                          = {  1, glBooleanv },
  [g.GL_COLOR_ARRAY_BUFFER_BINDING]           = {  1, glUintv    },
  [g.GL_COLOR_ARRAY_SIZE]                     = {  1, glSizeiv   },
  [g.GL_COLOR_ARRAY_STRIDE]                   = {  1, glSizeiv   },
  [g.GL_COLOR_ARRAY_TYPE]                     = {  1, glEnumv    },
  [g.GL_COLOR_CLEAR_VALUE]                    = {  4, glFloatv   },
  [g.GL_COLOR_LOGIC_OP]                       = {  1, glEnumv    },
  [g.GL_COLOR_MATERIAL]                       = {  1, glBooleanv },
  [g.GL_COLOR_MATERIAL_FACE]                  = {  1, glEnumv    },
  [g.GL_COLOR_MATERIAL_PARAMETER]             = {  1, glEnumv    },
  [g.GL_COLOR_MATRIX]                         = { 16, glFloatv   },
  [g.GL_COLOR_MATRIX_STACK_DEPTH]             = {  1, glSizeiv   },
  [g.GL_COLOR_SUM]                            = {  1, glBooleanv },
  [g.GL_COLOR_TABLE]                          = {  1, glBooleanv },
  [g.GL_COLOR_WRITEMASK]                      = {  4, glBooleanv },
  [g.GL_COMPRESSED_TEXTURE_FORMATS]           = { g.GL_NUM_COMPRESSED_TEXTURE_FORMATS, glEnumv },
  [g.GL_CONVOLUTION_1D]                       = {  1, glBooleanv },
  [g.GL_CONVOLUTION_2D]                       = {  1, glBooleanv },
  [g.GL_CULL_FACE]                            = {  1, glBooleanv },
  [g.GL_CULL_FACE_MODE]                       = {  1, glEnumv    },
  [g.GL_CURRENT_COLOR]                        = {  4, glFloatv   },
  [g.GL_CURRENT_FOG_COORD]                    = {  1, glFloatv   },
  [g.GL_CURRENT_INDEX]                        = {  1, glUintv    },
  [g.GL_CURRENT_NORMAL]                       = {  3, glFloatv   },
  [g.GL_CURRENT_PROGRAM]                      = {  1, glUintv    },
  [g.GL_CURRENT_RASTER_COLOR]                 = {  4, glFloatv   },
  [g.GL_CURRENT_RASTER_DISTANCE]              = {  1, glFloatv   },
  [g.GL_CURRENT_RASTER_INDEX]                 = {  1, glUintv    },
  [g.GL_CURRENT_RASTER_POSITION]              = {  3, glFloatv   },
  [g.GL_CURRENT_RASTER_POSITION_VALID]        = {  1, glBooleanv },
  [g.GL_CURRENT_RASTER_SECONDARY_COLOR]       = {  4, glFloatv   },
  [g.GL_CURRENT_RASTER_TEXTURE_COORDS]        = {  4, glFloatv   },
  [g.GL_CURRENT_SECONDARY_COLOR]              = {  4, glFloatv   },
  [g.GL_CURRENT_TEXTURE_COORDS]               = {  4, glFloatv   },
  [g.GL_DEPTH_BIAS]                           = {  1, glFloatv   },
  [g.GL_DEPTH_BITS]                           = {  1, glSizeiv   },
  [g.GL_DEPTH_CLEAR_VALUE]                    = {  1, glClampd   },
  [g.GL_DEPTH_FUNC]                           = {  1, glEnumv    },
  [g.GL_DEPTH_RANGE]                          = {  2, glClampd   },
  [g.GL_DEPTH_SCALE]                          = {  1, glFloatv   },
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
  [g.GL_EDGE_FLAG]                            = {  1, glBooleanv },
  [g.GL_EDGE_FLAG_ARRAY]                      = {  1, glBooleanv },
  [g.GL_EDGE_FLAG_ARRAY_BUFFER_BINDING]       = {  1, glUintv    },
  [g.GL_EDGE_FLAG_ARRAY_STRIDE]               = {  1, glSizeiv    },
  [g.GL_ELEMENT_ARRAY_BUFFER_BINDING]         = {  1, glUintv    },
  [g.GL_FEEDBACK_BUFFER_SIZE]                 = {  1, glSizeiv    },
  [g.GL_FEEDBACK_BUFFER_TYPE]                 = {  1, glEnumv    },
  [g.GL_FOG]                                  = {  1, glBooleanv },
  [g.GL_FOG_COORD_ARRAY]                      = {  1, glBooleanv },
  [g.GL_FOG_COORD_ARRAY_BUFFER_BINDING]       = {  1, glUintv    },
  [g.GL_FOG_COORD_ARRAY_STRIDE]               = {  1, glSizeiv    },
  [g.GL_FOG_COORD_ARRAY_TYPE]                 = {  1, glEnumv    },
  [g.GL_FOG_COORD_SRC]                        = {  1, glEnumv    },
  [g.GL_FOG_COLOR]                            = {  4, glFloatv   },
  [g.GL_FOG_DENSITY]                          = {  1, glFloatv   },
  [g.GL_FOG_END]                              = {  1, glFloatv   },
  [g.GL_FOG_HINT]                             = {  1, glEnumv    },
  [g.GL_FOG_INDEX]                            = {  1, glUintv    },
  [g.GL_FOG_MODE]                             = {  1, glEnumv    },
  [g.GL_FOG_START]                            = {  1, glFloatv   },
  [g.GL_FRAGMENT_SHADER_DERIVATIVE_HINT]      = {  1, glEnumv    },
  [g.GL_FRONT_FACE]                           = {  1, glEnumv    },
  [g.GL_GENERATE_MIPMAP_HINT]                 = {  1, glEnumv    },
  [g.GL_GREEN_BIAS]                           = {  1, glFloatv   },
  [g.GL_GREEN_BITS]                           = {  1, glSizeiv   },
  [g.GL_GREEN_SCALE]                          = {  1, glFloatv   },
  [g.GL_HISTOGRAM]                            = {  1, glBooleanv },
  [g.GL_INDEX_ARRAY]                          = {  1, glBooleanv },
  [g.GL_INDEX_ARRAY_BUFFER_BINDING]           = {  1, glUintv    },
  [g.GL_INDEX_ARRAY_STRIDE]                   = {  1, glSizeiv    },
  [g.GL_INDEX_ARRAY_TYPE]                     = {  1, glEnumv    },
  [g.GL_INDEX_BITS]                           = {  1, glSizeiv   },
  [g.GL_INDEX_CLEAR_VALUE]                    = {  1, glFloatv   },
  [g.GL_INDEX_LOGIC_OP]                       = {  1, glBooleanv },
  [g.GL_INDEX_MODE]                           = {  1, glBooleanv },
  [g.GL_INDEX_OFFSET]                         = {  1, glUintv    },
  [g.GL_INDEX_SHIFT]                          = {  1, glUintv    },
  [g.GL_INDEX_WRITEMASK]                      = {  1, glUintv    },
  [g.GL_LIGHT0]                               = {  1, glBooleanv },
  [g.GL_LIGHT1]                               = {  1, glBooleanv },
  [g.GL_LIGHT2]                               = {  1, glBooleanv },
  [g.GL_LIGHT3]                               = {  1, glBooleanv },
  [g.GL_LIGHT4]                               = {  1, glBooleanv },
  [g.GL_LIGHT5]                               = {  1, glBooleanv },
  [g.GL_LIGHT6]                               = {  1, glBooleanv },
  [g.GL_LIGHT7]                               = {  1, glBooleanv },
  [g.GL_LIGHTING]                             = {  1, glBooleanv },
  [g.GL_LIGHT_MODEL_AMBIENT]                  = {  4, glFloatv   },
  [g.GL_LIGHT_MODEL_COLOR_CONTROL]            = {  1, glEnumv    },
  [g.GL_LIGHT_MODEL_LOCAL_VIEWER]             = {  1, glBooleanv },
  [g.GL_LIGHT_MODEL_TWO_SIDE]                 = {  1, glBooleanv },
  [g.GL_LINE_SMOOTH]                          = {  1, glBooleanv },
  [g.GL_LINE_SMOOTH_HINT]                     = {  1, glEnumv    },
  [g.GL_LINE_STIPPLE]                         = {  1, glBooleanv },
  [g.GL_LINE_STIPPLE_PATTERN]                 = {  1, glUshortv  },
  [g.GL_LINE_STIPPLE_REPEAT]                  = {  1, glUintv    },
  [g.GL_LINE_WIDTH]                           = {  1, glFloatv   },
  [g.GL_LINE_WIDTH_GRANULARITY]               = {  1, glFloatv   },
  [g.GL_LINE_WIDTH_RANGE]                     = {  2, glFloatv   },
  [g.GL_LIST_BASE]                            = {  1, glUintv    },
  [g.GL_LIST_INDEX]                           = {  1, glUintv    },
  [g.GL_LIST_MODE]                            = {  1, glEnumv    },
  [g.GL_LOGIC_OP_MODE]                        = {  1, glEnumv    },
  [g.GL_MAP1_COLOR_4]                         = {  1, glBooleanv },
  [g.GL_MAP1_GRID_DOMAIN]                     = {  2, glFloatv   },
  [g.GL_MAP1_GRID_SEGMENTS]                   = {  1, glSizeiv   },
  [g.GL_MAP1_INDEX]                           = {  1, glBooleanv },
  [g.GL_MAP1_NORMAL]                          = {  1, glBooleanv },
  [g.GL_MAP1_TEXTURE_COORD_1]                 = {  1, glBooleanv },
  [g.GL_MAP1_TEXTURE_COORD_2]                 = {  1, glBooleanv },
  [g.GL_MAP1_TEXTURE_COORD_3]                 = {  1, glBooleanv },
  [g.GL_MAP1_TEXTURE_COORD_4]                 = {  1, glBooleanv },
  [g.GL_MAP1_VERTEX_3]                        = {  1, glBooleanv },
  [g.GL_MAP1_VERTEX_4]                        = {  1, glBooleanv },
  [g.GL_MAP2_COLOR_4]                         = {  1, glBooleanv },
  [g.GL_MAP2_GRID_DOMAIN]                     = {  2, glFloatv   },
  [g.GL_MAP2_GRID_SEGMENTS]                   = {  1, glSizeiv   },
  [g.GL_MAP2_INDEX]                           = {  1, glBooleanv },
  [g.GL_MAP2_NORMAL]                          = {  1, glBooleanv },
  [g.GL_MAP2_TEXTURE_COORD_1]                 = {  1, glBooleanv },
  [g.GL_MAP2_TEXTURE_COORD_2]                 = {  1, glBooleanv },
  [g.GL_MAP2_TEXTURE_COORD_3]                 = {  1, glBooleanv },
  [g.GL_MAP2_TEXTURE_COORD_4]                 = {  1, glBooleanv },
  [g.GL_MAP2_VERTEX_3]                        = {  1, glBooleanv },
  [g.GL_MAP2_VERTEX_4]                        = {  1, glBooleanv },
  [g.GL_MAP_COLOR]                            = {  1, glBooleanv },
  [g.GL_MAP_STENCIL]                          = {  1, glBooleanv },
  [g.GL_MATRIX_MODE]                          = {  1, glEnumv    },
  [g.GL_MAX_3D_TEXTURE_SIZE]                  = {  1, glSizeiv   },
  [g.GL_MAX_CLIENT_ATTRIB_STACK_DEPTH]        = {  1, glSizeiv   },
  [g.GL_MAX_ATTRIB_STACK_DEPTH]               = {  1, glSizeiv   },
  [g.GL_MAX_CLIP_PLANES]                      = {  1, glSizeiv   },
  [g.GL_MAX_COLOR_MATRIX_STACK_DEPTH]         = {  1, glSizeiv   },
  [g.GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS]     = {  1, glSizeiv   },
  [g.GL_MAX_CUBE_MAP_TEXTURE_SIZE]            = {  1, glSizeiv   },
  [g.GL_MAX_DRAW_BUFFERS]                     = {  1, glSizeiv   },
  [g.GL_MAX_ELEMENTS_INDICES]                 = {  1, glSizeiv   },
  [g.GL_MAX_ELEMENTS_VERTICES]                = {  1, glSizeiv   },
  [g.GL_MAX_EVAL_ORDER]                       = {  1, glSizeiv   },
  [g.GL_MAX_FRAGMENT_UNIFORM_COMPONENTS]      = {  1, glSizeiv   },
  [g.GL_MAX_LIGHTS]                           = {  1, glSizeiv   },
  [g.GL_MAX_LIST_NESTING]                     = {  1, glSizeiv   },
  [g.GL_MAX_MODELVIEW_STACK_DEPTH]            = {  1, glSizeiv   },
  [g.GL_MAX_NAME_STACK_DEPTH]                 = {  1, glSizeiv   },
  [g.GL_MAX_PIXEL_MAP_TABLE]                  = {  1, glSizeiv   },
  [g.GL_MAX_PROJECTION_STACK_DEPTH]           = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_COORDS]                   = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_IMAGE_UNITS]              = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_LOD_BIAS]                 = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_SIZE]                     = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_STACK_DEPTH]              = {  1, glSizeiv   },
  [g.GL_MAX_TEXTURE_UNITS]                    = {  1, glSizeiv   },
  [g.GL_MAX_VARYING_FLOATS]                   = {  1, glSizeiv   },
  [g.GL_MAX_VERTEX_ATTRIBS]                   = {  1, glSizeiv   },
  [g.GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS]       = {  1, glSizeiv   },
  [g.GL_MAX_VERTEX_UNIFORM_COMPONENTS]        = {  1, glSizeiv   },
  [g.GL_MAX_VIEWPORT_DIMS]                    = {  2, glSizeiv   },
  [g.GL_MINMAX]                               = {  1, glBooleanv },
  [g.GL_MODELVIEW_MATRIX]                     = { 16, glFloatv   },
  [g.GL_MODELVIEW_STACK_DEPTH]                = {  1, glSizeiv   },
  [g.GL_NAME_STACK_DEPTH]                     = {  1, glSizeiv   },
  [g.GL_NORMAL_ARRAY]                         = {  1, glBooleanv },
  [g.GL_NORMAL_ARRAY_BUFFER_BINDING]          = {  1, glUintv    },
  [g.GL_NORMAL_ARRAY_STRIDE]                  = {  1, glSizeiv   },
  [g.GL_NORMAL_ARRAY_TYPE]                    = {  1, glEnumv    },
  [g.GL_NORMALIZE]                            = {  1, glBooleanv },
  [g.GL_NUM_COMPRESSED_TEXTURE_FORMATS]       = {  1, glUintv    },
  [g.GL_PACK_ALIGNMENT]                       = {  1, glUintv    },
  [g.GL_PACK_IMAGE_HEIGHT]                    = {  1, glUintv    },
  [g.GL_PACK_LSB_FIRST]                       = {  1, glBooleanv },
  [g.GL_PACK_ROW_LENGTH]                      = {  1, glUintv    },
  [g.GL_PACK_SKIP_IMAGES]                     = {  1, glUintv    },
  [g.GL_PACK_SKIP_PIXELS]                     = {  1, glUintv    },
  [g.GL_PACK_SKIP_ROWS]                       = {  1, glUintv    },
  [g.GL_PACK_SWAP_BYTES]                      = {  1, glBooleanv },
  [g.GL_PERSPECTIVE_CORRECTION_HINT]          = {  1, glEnumv    },
  [g.GL_PIXEL_MAP_A_TO_A_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_B_TO_B_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_G_TO_G_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_I_TO_A_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_I_TO_B_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_I_TO_G_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_I_TO_I_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_I_TO_R_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_R_TO_R_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_MAP_S_TO_S_SIZE]                = {  1, glSizeiv   },
  [g.GL_PIXEL_PACK_BUFFER_BINDING]            = {  1, glUintv    },
  [g.GL_PIXEL_UNPACK_BUFFER_BINDING]          = {  1, glUintv    },
  [g.GL_POINT_DISTANCE_ATTENUATION]           = {  3, glFloatv   },
  [g.GL_POINT_FADE_THRESHOLD_SIZE]            = {  1, glFloatv   },
  [g.GL_POINT_SIZE]                           = {  1, glFloatv   },
  [g.GL_POINT_SIZE_GRANULARITY]               = {  1, glFloatv   },
  [g.GL_POINT_SIZE_MAX]                       = {  1, glFloatv   },
  [g.GL_POINT_SIZE_MIN]                       = {  1, glFloatv   },
  [g.GL_POINT_SIZE_RANGE]                     = {  1, glFloatv   },
  [g.GL_POINT_SMOOTH]                         = {  1, glBooleanv },
  [g.GL_POINT_SMOOTH_HINT]                    = {  1, glEnumv    },
  [g.GL_POINT_SPRITE]                         = {  1, glBooleanv },
  [g.GL_POLYGON_MODE]                         = {  1, glEnumv    },
  [g.GL_POLYGON_OFFSET_FACTOR]                = {  1, glFloatv   },
  [g.GL_POLYGON_OFFSET_UNITS]                 = {  1, glFloatv   },
  [g.GL_POLYGON_OFFSET_FILL]                  = {  1, glBooleanv },
  [g.GL_POLYGON_OFFSET_LINE]                  = {  1, glBooleanv },
  [g.GL_POLYGON_OFFSET_POINT]                 = {  1, glBooleanv },
  [g.GL_POLYGON_SMOOTH]                       = {  1, glBooleanv },
  [g.GL_POLYGON_SMOOTH_HINT]                  = {  1, glEnumv    },
  [g.GL_POLYGON_STIPPLE]                      = {  1, glBooleanv },
  [g.GL_POST_COLOR_MATRIX_COLOR_TABLE]        = {  1, glBooleanv },
  [g.GL_POST_COLOR_MATRIX_RED_BIAS]           = {  1, glFloatv   },
  [g.GL_POST_COLOR_MATRIX_GREEN_BIAS]         = {  1, glFloatv   },
  [g.GL_POST_COLOR_MATRIX_BLUE_BIAS]          = {  1, glFloatv   },
  [g.GL_POST_COLOR_MATRIX_ALPHA_BIAS]         = {  1, glFloatv   },
  [g.GL_POST_COLOR_MATRIX_RED_SCALE]          = {  1, glFloatv   },
  [g.GL_POST_COLOR_MATRIX_GREEN_SCALE]        = {  1, glFloatv   },
  [g.GL_POST_COLOR_MATRIX_BLUE_SCALE]         = {  1, glFloatv   },
  [g.GL_POST_COLOR_MATRIX_ALPHA_SCALE]        = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_COLOR_TABLE]         = {  1, glBooleanv },
  [g.GL_POST_CONVOLUTION_RED_BIAS]            = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_GREEN_BIAS]          = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_BLUE_BIAS]           = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_ALPHA_BIAS]          = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_RED_SCALE]           = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_GREEN_SCALE]         = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_BLUE_SCALE]          = {  1, glFloatv   },
  [g.GL_POST_CONVOLUTION_ALPHA_SCALE]         = {  1, glFloatv   },
  [g.GL_PROJECTION_MATRIX]                    = { 16, glFloatv   },
  [g.GL_PROJECTION_STACK_DEPTH]               = {  1, glSizeiv   },
  [g.GL_READ_BUFFER]                          = {  1, glEnumv    },
  [g.GL_RED_BIAS]                             = {  1, glFloatv   },
  [g.GL_RED_BITS]                             = {  1, glSizeiv   },
  [g.GL_RED_SCALE]                            = {  1, glFloatv   },
  [g.GL_RENDER_MODE]                          = {  1, glEnumv    },
  [g.GL_RESCALE_NORMAL]                       = {  1, glBooleanv },
  [g.GL_RGBA_MODE]                            = {  1, glBooleanv },
  [g.GL_SAMPLE_BUFFERS]                       = {  1, glSizeiv   },
  [g.GL_SAMPLE_COVERAGE_VALUE]                = {  1, glFloatv   },
  [g.GL_SAMPLE_COVERAGE_INVERT]               = {  1, glBooleanv },
  [g.GL_SAMPLES]                              = {  1, glSizeiv   },
  [g.GL_SCISSOR_BOX]                          = {  4, glUintv    },
  [g.GL_SCISSOR_TEST]                         = {  1, glBooleanv },
  [g.GL_SECONDARY_COLOR_ARRAY]                = {  1, glBooleanv },
  [g.GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING] = {  1, glUintv    },
  [g.GL_SECONDARY_COLOR_ARRAY_SIZE]           = {  1, glSizeiv   },
  [g.GL_SECONDARY_COLOR_ARRAY_STRIDE]         = {  1, glSizeiv   },
  [g.GL_SECONDARY_COLOR_ARRAY_TYPE]           = {  1, glEnumv    },
  [g.GL_SELECTION_BUFFER_SIZE]                = {  1, glSizeiv   },
  [g.GL_SEPARABLE_2D]                         = {  1, glBooleanv },
  [g.GL_SHADE_MODEL]                          = {  1, glEnumv    },
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
  [g.GL_STENCIL_BITS]                         = {  1, glSizeiv   },
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
  [g.GL_TEXTURE_COORD_ARRAY]                  = {  1, glBooleanv },
  [g.GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING]   = {  1, glUintv    },
  [g.GL_TEXTURE_COORD_ARRAY_SIZE]             = {  1, glSizeiv   },
  [g.GL_TEXTURE_COORD_ARRAY_STRIDE]           = {  1, glSizeiv   },
  [g.GL_TEXTURE_COORD_ARRAY_TYPE]             = {  1, glEnumv    },
  [g.GL_TEXTURE_CUBE_MAP]                     = {  1, glBooleanv },
  [g.GL_TEXTURE_GEN_Q]                        = {  1, glBooleanv },
  [g.GL_TEXTURE_GEN_R]                        = {  1, glBooleanv },
  [g.GL_TEXTURE_GEN_S]                        = {  1, glBooleanv },
  [g.GL_TEXTURE_GEN_T]                        = {  1, glBooleanv },
  [g.GL_TEXTURE_MATRIX]                       = { 16, glFloatv   },
  [g.GL_TEXTURE_STACK_DEPTH]                  = {  1, glSizeiv   },
  [g.GL_TRANSPOSE_COLOR_MATRIX]               = { 16, glFloatv   },
  [g.GL_TRANSPOSE_MODELVIEW_MATRIX]           = { 16, glFloatv   },
  [g.GL_TRANSPOSE_PROJECTION_MATRIX]          = { 16, glFloatv   },
  [g.GL_TRANSPOSE_TEXTURE_MATRIX]             = { 16, glFloatv   },
  [g.GL_UNPACK_ALIGNMENT]                     = {  1, glUintv    },
  [g.GL_UNPACK_IMAGE_HEIGHT]                  = {  1, glUintv    },
  [g.GL_UNPACK_LSB_FIRST]                     = {  1, glUintv    },
  [g.GL_UNPACK_ROW_LENGTH]                    = {  1, glUintv    },
  [g.GL_UNPACK_SKIP_IMAGES]                   = {  1, glUintv    },
  [g.GL_UNPACK_SKIP_PIXELS]                   = {  1, glUintv    },
  [g.GL_UNPACK_SKIP_ROWS]                     = {  1, glUintv    },
  [g.GL_UNPACK_SWAP_BYTES]                    = {  1, glBooleanv },
  [g.GL_VERTEX_ARRAY]                         = {  1, glBooleanv },
  [g.GL_VERTEX_ARRAY_BUFFER_BINDING]          = {  1, glUintv    },
  [g.GL_VERTEX_ARRAY_SIZE]                    = {  1, glSizeiv   },
  [g.GL_VERTEX_ARRAY_STRIDE]                  = {  1, glSizeiv   },
  [g.GL_VERTEX_ARRAY_TYPE]                    = {  1, glEnumv    },
  [g.GL_VERTEX_PROGRAM_POINT_SIZE]            = {  1, glBooleanv },
  [g.GL_VERTEX_PROGRAM_TWO_SIDE]              = {  1, glBooleanv },
  [g.GL_VIEWPORT]                             = {  4, glUintv    },
  [g.GL_ZOOM_X]                               = {  1, glFloatv   },
  [g.GL_ZOOM_Y]                               = {  1, glFloatv   }
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

-- removing type suffixes
M.MultMatrix = g.glMultMatrixf
M.Rotate     = g.glRotatef

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
