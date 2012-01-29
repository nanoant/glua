-- LuaJIT FFI adapted OpenGL 3 Core Profile headers
-- Created by: Adam Strzelecki http://www.nanoant.com/
--
-- Copyright (c) 2007-2012 The Khronos Group Inc.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and/or associated documentation files (the
-- "Materials"), to deal in the Materials without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Materials, and to
-- permit persons to whom the Materials are furnished to do so, subject to
-- the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Materials.
-- 
-- THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.
--
--
-- This is a draft release of gl3.h, a header for use with OpenGL 3.1, and
-- 3.2 and later core profile implementations. The current version is
-- available at http://www.opengl.org/registry/ . Please don't package
-- gl3.h for release with other software until it's out of draft status.
-- The structure of the file may change significantly, and the details
-- will probably change slightly as we make sure exactly the right set
-- of interfaces is included.
--
-- gl3.h last updated on $Date: 2012-01-26 02:57:23 -0800 (Thu, 26 Jan 2012) $
--
-- RELEASE NOTES - 2012/01/26
--
-- gl3.h should be placed under a directory 'GL3' and included as
-- '<GL3/gl3.h>'.
--
-- gl3.h is supposed to only include APIs in a OpenGL 3.1 (without
-- GL_ARB_compatibility) or OpenGL 3.2-4.2 (inclusive) core profile
-- implementation, as well as interfaces for newer ARB extensions which
-- can be supported by the core profile. It does not, and never will
-- include functionality removed from the core profile, such as
-- fixed-function vertex and fragment processing.
--
-- Implementations of OpenGL 3.1 supporting the optional
-- GL_ARB_compatibility extension continue to provide that functionality,
-- as do implementations of the OpenGL 3.2+ compatibility profiles, and
-- source code requiring it should use the traditional <GL/gl.h> and
-- <GL/glext.h> headers instead of <GL3/gl3.h>.
--
-- It is not possible to #include both <GL3/gl3.h> and either of
-- <GL/gl.h> or <GL/glext.h> in the same source file.
--
-- We welcome feedback on gl3.h. Please register for the Khronos Bugzilla
-- (www.khronos.org/bugzilla) and file issues there under product
-- "OpenGL", category "Registry". Feedback on the opengl.org forums
-- may not be responded to in a timely fashion.

local ffi = require 'ffi'
ffi.cdef [[
/* Base GL types */

typedef unsigned int GLenum;
typedef unsigned char GLboolean;
typedef unsigned int GLbitfield;
typedef signed char GLbyte;
typedef short GLshort;
typedef int GLint;
typedef int GLsizei;
typedef unsigned char GLubyte;
typedef unsigned short GLushort;
typedef unsigned int GLuint;
typedef unsigned short GLhalf;
typedef float GLfloat;
typedef float GLclampf;
typedef double GLdouble;
typedef double GLclampd;
typedef void GLvoid;

/*************************************************************/

/* #ifndef GL_VERSION_1_1 */
enum {
/* AttribMask */
  GL_DEPTH_BUFFER_BIT               = 0x00000100,
  GL_STENCIL_BUFFER_BIT             = 0x00000400,
  GL_COLOR_BUFFER_BIT               = 0x00004000,
/* Boolean */
  GL_FALSE                          = 0,
  GL_TRUE                           = 1,
/* BeginMode */
  GL_POINTS                         = 0x0000,
  GL_LINES                          = 0x0001,
  GL_LINE_LOOP                      = 0x0002,
  GL_LINE_STRIP                     = 0x0003,
  GL_TRIANGLES                      = 0x0004,
  GL_TRIANGLE_STRIP                 = 0x0005,
  GL_TRIANGLE_FAN                   = 0x0006,
/* AlphaFunction */
  GL_NEVER                          = 0x0200,
  GL_LESS                           = 0x0201,
  GL_EQUAL                          = 0x0202,
  GL_LEQUAL                         = 0x0203,
  GL_GREATER                        = 0x0204,
  GL_NOTEQUAL                       = 0x0205,
  GL_GEQUAL                         = 0x0206,
  GL_ALWAYS                         = 0x0207,
/* BlendingFactorDest */
  GL_ZERO                           = 0,
  GL_ONE                            = 1,
  GL_SRC_COLOR                      = 0x0300,
  GL_ONE_MINUS_SRC_COLOR            = 0x0301,
  GL_SRC_ALPHA                      = 0x0302,
  GL_ONE_MINUS_SRC_ALPHA            = 0x0303,
  GL_DST_ALPHA                      = 0x0304,
  GL_ONE_MINUS_DST_ALPHA            = 0x0305,
/* BlendingFactorSrc */
  GL_DST_COLOR                      = 0x0306,
  GL_ONE_MINUS_DST_COLOR            = 0x0307,
  GL_SRC_ALPHA_SATURATE             = 0x0308,
/* DrawBufferMode */
  GL_NONE                           = 0,
  GL_FRONT_LEFT                     = 0x0400,
  GL_FRONT_RIGHT                    = 0x0401,
  GL_BACK_LEFT                      = 0x0402,
  GL_BACK_RIGHT                     = 0x0403,
  GL_FRONT                          = 0x0404,
  GL_BACK                           = 0x0405,
  GL_LEFT                           = 0x0406,
  GL_RIGHT                          = 0x0407,
  GL_FRONT_AND_BACK                 = 0x0408,
/* ErrorCode */
  GL_NO_ERROR                       = 0,
  GL_INVALID_ENUM                   = 0x0500,
  GL_INVALID_VALUE                  = 0x0501,
  GL_INVALID_OPERATION              = 0x0502,
  GL_OUT_OF_MEMORY                  = 0x0505,
/* FrontFaceDirection */
  GL_CW                             = 0x0900,
  GL_CCW                            = 0x0901,
/* GetPName */
  GL_POINT_SIZE                     = 0x0B11,
  GL_POINT_SIZE_RANGE               = 0x0B12,
  GL_POINT_SIZE_GRANULARITY         = 0x0B13,
  GL_LINE_SMOOTH                    = 0x0B20,
  GL_LINE_WIDTH                     = 0x0B21,
  GL_LINE_WIDTH_RANGE               = 0x0B22,
  GL_LINE_WIDTH_GRANULARITY         = 0x0B23,
  GL_POLYGON_SMOOTH                 = 0x0B41,
  GL_CULL_FACE                      = 0x0B44,
  GL_CULL_FACE_MODE                 = 0x0B45,
  GL_FRONT_FACE                     = 0x0B46,
  GL_DEPTH_RANGE                    = 0x0B70,
  GL_DEPTH_TEST                     = 0x0B71,
  GL_DEPTH_WRITEMASK                = 0x0B72,
  GL_DEPTH_CLEAR_VALUE              = 0x0B73,
  GL_DEPTH_FUNC                     = 0x0B74,
  GL_STENCIL_TEST                   = 0x0B90,
  GL_STENCIL_CLEAR_VALUE            = 0x0B91,
  GL_STENCIL_FUNC                   = 0x0B92,
  GL_STENCIL_VALUE_MASK             = 0x0B93,
  GL_STENCIL_FAIL                   = 0x0B94,
  GL_STENCIL_PASS_DEPTH_FAIL        = 0x0B95,
  GL_STENCIL_PASS_DEPTH_PASS        = 0x0B96,
  GL_STENCIL_REF                    = 0x0B97,
  GL_STENCIL_WRITEMASK              = 0x0B98,
  GL_VIEWPORT                       = 0x0BA2,
  GL_DITHER                         = 0x0BD0,
  GL_BLEND_DST                      = 0x0BE0,
  GL_BLEND_SRC                      = 0x0BE1,
  GL_BLEND                          = 0x0BE2,
  GL_LOGIC_OP_MODE                  = 0x0BF0,
  GL_COLOR_LOGIC_OP                 = 0x0BF2,
  GL_DRAW_BUFFER                    = 0x0C01,
  GL_READ_BUFFER                    = 0x0C02,
  GL_SCISSOR_BOX                    = 0x0C10,
  GL_SCISSOR_TEST                   = 0x0C11,
  GL_COLOR_CLEAR_VALUE              = 0x0C22,
  GL_COLOR_WRITEMASK                = 0x0C23,
  GL_DOUBLEBUFFER                   = 0x0C32,
  GL_STEREO                         = 0x0C33,
  GL_LINE_SMOOTH_HINT               = 0x0C52,
  GL_POLYGON_SMOOTH_HINT            = 0x0C53,
  GL_UNPACK_SWAP_BYTES              = 0x0CF0,
  GL_UNPACK_LSB_FIRST               = 0x0CF1,
  GL_UNPACK_ROW_LENGTH              = 0x0CF2,
  GL_UNPACK_SKIP_ROWS               = 0x0CF3,
  GL_UNPACK_SKIP_PIXELS             = 0x0CF4,
  GL_UNPACK_ALIGNMENT               = 0x0CF5,
  GL_PACK_SWAP_BYTES                = 0x0D00,
  GL_PACK_LSB_FIRST                 = 0x0D01,
  GL_PACK_ROW_LENGTH                = 0x0D02,
  GL_PACK_SKIP_ROWS                 = 0x0D03,
  GL_PACK_SKIP_PIXELS               = 0x0D04,
  GL_PACK_ALIGNMENT                 = 0x0D05,
  GL_MAX_TEXTURE_SIZE               = 0x0D33,
  GL_MAX_VIEWPORT_DIMS              = 0x0D3A,
  GL_SUBPIXEL_BITS                  = 0x0D50,
  GL_TEXTURE_1D                     = 0x0DE0,
  GL_TEXTURE_2D                     = 0x0DE1,
  GL_POLYGON_OFFSET_UNITS           = 0x2A00,
  GL_POLYGON_OFFSET_POINT           = 0x2A01,
  GL_POLYGON_OFFSET_LINE            = 0x2A02,
  GL_POLYGON_OFFSET_FILL            = 0x8037,
  GL_POLYGON_OFFSET_FACTOR          = 0x8038,
  GL_TEXTURE_BINDING_1D             = 0x8068,
  GL_TEXTURE_BINDING_2D             = 0x8069,
/* GetTextureParameter */
  GL_TEXTURE_WIDTH                  = 0x1000,
  GL_TEXTURE_HEIGHT                 = 0x1001,
  GL_TEXTURE_INTERNAL_FORMAT        = 0x1003,
  GL_TEXTURE_BORDER_COLOR           = 0x1004,
  GL_TEXTURE_RED_SIZE               = 0x805C,
  GL_TEXTURE_GREEN_SIZE             = 0x805D,
  GL_TEXTURE_BLUE_SIZE              = 0x805E,
  GL_TEXTURE_ALPHA_SIZE             = 0x805F,
/* HintMode */
  GL_DONT_CARE                      = 0x1100,
  GL_FASTEST                        = 0x1101,
  GL_NICEST                         = 0x1102,
/* DataType */
  GL_BYTE                           = 0x1400,
  GL_UNSIGNED_BYTE                  = 0x1401,
  GL_SHORT                          = 0x1402,
  GL_UNSIGNED_SHORT                 = 0x1403,
  GL_INT                            = 0x1404,
  GL_UNSIGNED_INT                   = 0x1405,
  GL_FLOAT                          = 0x1406,
  GL_DOUBLE                         = 0x140A,
/* LogicOp */
  GL_CLEAR                          = 0x1500,
  GL_AND                            = 0x1501,
  GL_AND_REVERSE                    = 0x1502,
  GL_COPY                           = 0x1503,
  GL_AND_INVERTED                   = 0x1504,
  GL_NOOP                           = 0x1505,
  GL_XOR                            = 0x1506,
  GL_OR                             = 0x1507,
  GL_NOR                            = 0x1508,
  GL_EQUIV                          = 0x1509,
  GL_INVERT                         = 0x150A,
  GL_OR_REVERSE                     = 0x150B,
  GL_COPY_INVERTED                  = 0x150C,
  GL_OR_INVERTED                    = 0x150D,
  GL_NAND                           = 0x150E,
  GL_SET                            = 0x150F,
/* MatrixMode (for gl3.h, FBO attachment type) */
  GL_TEXTURE                        = 0x1702,
/* PixelCopyType */
  GL_COLOR                          = 0x1800,
  GL_DEPTH                          = 0x1801,
  GL_STENCIL                        = 0x1802,
/* PixelFormat */
  GL_STENCIL_INDEX                  = 0x1901,
  GL_DEPTH_COMPONENT                = 0x1902,
  GL_RED                            = 0x1903,
  GL_GREEN                          = 0x1904,
  GL_BLUE                           = 0x1905,
  GL_ALPHA                          = 0x1906,
  GL_RGB                            = 0x1907,
  GL_RGBA                           = 0x1908,
/* PolygonMode */
  GL_POINT                          = 0x1B00,
  GL_LINE                           = 0x1B01,
  GL_FILL                           = 0x1B02,
/* StencilOp */
  GL_KEEP                           = 0x1E00,
  GL_REPLACE                        = 0x1E01,
  GL_INCR                           = 0x1E02,
  GL_DECR                           = 0x1E03,
/* StringName */
  GL_VENDOR                         = 0x1F00,
  GL_RENDERER                       = 0x1F01,
  GL_VERSION                        = 0x1F02,
  GL_EXTENSIONS                     = 0x1F03,
/* TextureMagFilter */
  GL_NEAREST                        = 0x2600,
  GL_LINEAR                         = 0x2601,
/* TextureMinFilter */
  GL_NEAREST_MIPMAP_NEAREST         = 0x2700,
  GL_LINEAR_MIPMAP_NEAREST          = 0x2701,
  GL_NEAREST_MIPMAP_LINEAR          = 0x2702,
  GL_LINEAR_MIPMAP_LINEAR           = 0x2703,
/* TextureParameterName */
  GL_TEXTURE_MAG_FILTER             = 0x2800,
  GL_TEXTURE_MIN_FILTER             = 0x2801,
  GL_TEXTURE_WRAP_S                 = 0x2802,
  GL_TEXTURE_WRAP_T                 = 0x2803,
/* TextureTarget */
  GL_PROXY_TEXTURE_1D               = 0x8063,
  GL_PROXY_TEXTURE_2D               = 0x8064,
/* TextureWrapMode */
  GL_REPEAT                         = 0x2901,
/* PixelInternalFormat */
  GL_R3_G3_B2                       = 0x2A10,
  GL_RGB4                           = 0x804F,
  GL_RGB5                           = 0x8050,
  GL_RGB8                           = 0x8051,
  GL_RGB10                          = 0x8052,
  GL_RGB12                          = 0x8053,
  GL_RGB16                          = 0x8054,
  GL_RGBA2                          = 0x8055,
  GL_RGBA4                          = 0x8056,
  GL_RGB5_A1                        = 0x8057,
  GL_RGBA8                          = 0x8058,
  GL_RGB10_A2                       = 0x8059,
  GL_RGBA12                         = 0x805A,
  GL_RGBA16                         = 0x805B,
/* #endif */

/* #ifndef GL_VERSION_1_2 */
  GL_UNSIGNED_BYTE_3_3_2            = 0x8032,
  GL_UNSIGNED_SHORT_4_4_4_4         = 0x8033,
  GL_UNSIGNED_SHORT_5_5_5_1         = 0x8034,
  GL_UNSIGNED_INT_8_8_8_8           = 0x8035,
  GL_UNSIGNED_INT_10_10_10_2        = 0x8036,
  GL_TEXTURE_BINDING_3D             = 0x806A,
  GL_PACK_SKIP_IMAGES               = 0x806B,
  GL_PACK_IMAGE_HEIGHT              = 0x806C,
  GL_UNPACK_SKIP_IMAGES             = 0x806D,
  GL_UNPACK_IMAGE_HEIGHT            = 0x806E,
  GL_TEXTURE_3D                     = 0x806F,
  GL_PROXY_TEXTURE_3D               = 0x8070,
  GL_TEXTURE_DEPTH                  = 0x8071,
  GL_TEXTURE_WRAP_R                 = 0x8072,
  GL_MAX_3D_TEXTURE_SIZE            = 0x8073,
  GL_UNSIGNED_BYTE_2_3_3_REV        = 0x8362,
  GL_UNSIGNED_SHORT_5_6_5           = 0x8363,
  GL_UNSIGNED_SHORT_5_6_5_REV       = 0x8364,
  GL_UNSIGNED_SHORT_4_4_4_4_REV     = 0x8365,
  GL_UNSIGNED_SHORT_1_5_5_5_REV     = 0x8366,
  GL_UNSIGNED_INT_8_8_8_8_REV       = 0x8367,
  GL_UNSIGNED_INT_2_10_10_10_REV    = 0x8368,
  GL_BGR                            = 0x80E0,
  GL_BGRA                           = 0x80E1,
  GL_MAX_ELEMENTS_VERTICES          = 0x80E8,
  GL_MAX_ELEMENTS_INDICES           = 0x80E9,
  GL_CLAMP_TO_EDGE                  = 0x812F,
  GL_TEXTURE_MIN_LOD                = 0x813A,
  GL_TEXTURE_MAX_LOD                = 0x813B,
  GL_TEXTURE_BASE_LEVEL             = 0x813C,
  GL_TEXTURE_MAX_LEVEL              = 0x813D,
  GL_SMOOTH_POINT_SIZE_RANGE        = 0x0B12,
  GL_SMOOTH_POINT_SIZE_GRANULARITY  = 0x0B13,
  GL_SMOOTH_LINE_WIDTH_RANGE        = 0x0B22,
  GL_SMOOTH_LINE_WIDTH_GRANULARITY  = 0x0B23,
  GL_ALIASED_LINE_WIDTH_RANGE       = 0x846E,
/* #endif */

/* #ifndef GL_ARB_imaging */
  GL_CONSTANT_COLOR                 = 0x8001,
  GL_ONE_MINUS_CONSTANT_COLOR       = 0x8002,
  GL_CONSTANT_ALPHA                 = 0x8003,
  GL_ONE_MINUS_CONSTANT_ALPHA       = 0x8004,
  GL_BLEND_COLOR                    = 0x8005,
  GL_FUNC_ADD                       = 0x8006,
  GL_MIN                            = 0x8007,
  GL_MAX                            = 0x8008,
  GL_BLEND_EQUATION                 = 0x8009,
  GL_FUNC_SUBTRACT                  = 0x800A,
  GL_FUNC_REVERSE_SUBTRACT          = 0x800B,
/* #endif */

/* #ifndef GL_VERSION_1_3 */
  GL_TEXTURE0                       = 0x84C0,
  GL_TEXTURE1                       = 0x84C1,
  GL_TEXTURE2                       = 0x84C2,
  GL_TEXTURE3                       = 0x84C3,
  GL_TEXTURE4                       = 0x84C4,
  GL_TEXTURE5                       = 0x84C5,
  GL_TEXTURE6                       = 0x84C6,
  GL_TEXTURE7                       = 0x84C7,
  GL_TEXTURE8                       = 0x84C8,
  GL_TEXTURE9                       = 0x84C9,
  GL_TEXTURE10                      = 0x84CA,
  GL_TEXTURE11                      = 0x84CB,
  GL_TEXTURE12                      = 0x84CC,
  GL_TEXTURE13                      = 0x84CD,
  GL_TEXTURE14                      = 0x84CE,
  GL_TEXTURE15                      = 0x84CF,
  GL_TEXTURE16                      = 0x84D0,
  GL_TEXTURE17                      = 0x84D1,
  GL_TEXTURE18                      = 0x84D2,
  GL_TEXTURE19                      = 0x84D3,
  GL_TEXTURE20                      = 0x84D4,
  GL_TEXTURE21                      = 0x84D5,
  GL_TEXTURE22                      = 0x84D6,
  GL_TEXTURE23                      = 0x84D7,
  GL_TEXTURE24                      = 0x84D8,
  GL_TEXTURE25                      = 0x84D9,
  GL_TEXTURE26                      = 0x84DA,
  GL_TEXTURE27                      = 0x84DB,
  GL_TEXTURE28                      = 0x84DC,
  GL_TEXTURE29                      = 0x84DD,
  GL_TEXTURE30                      = 0x84DE,
  GL_TEXTURE31                      = 0x84DF,
  GL_ACTIVE_TEXTURE                 = 0x84E0,
  GL_MULTISAMPLE                    = 0x809D,
  GL_SAMPLE_ALPHA_TO_COVERAGE       = 0x809E,
  GL_SAMPLE_ALPHA_TO_ONE            = 0x809F,
  GL_SAMPLE_COVERAGE                = 0x80A0,
  GL_SAMPLE_BUFFERS                 = 0x80A8,
  GL_SAMPLES                        = 0x80A9,
  GL_SAMPLE_COVERAGE_VALUE          = 0x80AA,
  GL_SAMPLE_COVERAGE_INVERT         = 0x80AB,
  GL_TEXTURE_CUBE_MAP               = 0x8513,
  GL_TEXTURE_BINDING_CUBE_MAP       = 0x8514,
  GL_TEXTURE_CUBE_MAP_POSITIVE_X    = 0x8515,
  GL_TEXTURE_CUBE_MAP_NEGATIVE_X    = 0x8516,
  GL_TEXTURE_CUBE_MAP_POSITIVE_Y    = 0x8517,
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y    = 0x8518,
  GL_TEXTURE_CUBE_MAP_POSITIVE_Z    = 0x8519,
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z    = 0x851A,
  GL_PROXY_TEXTURE_CUBE_MAP         = 0x851B,
  GL_MAX_CUBE_MAP_TEXTURE_SIZE      = 0x851C,
  GL_COMPRESSED_RGB                 = 0x84ED,
  GL_COMPRESSED_RGBA                = 0x84EE,
  GL_TEXTURE_COMPRESSION_HINT       = 0x84EF,
  GL_TEXTURE_COMPRESSED_IMAGE_SIZE  = 0x86A0,
  GL_TEXTURE_COMPRESSED             = 0x86A1,
  GL_NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2,
  GL_COMPRESSED_TEXTURE_FORMATS     = 0x86A3,
  GL_CLAMP_TO_BORDER                = 0x812D,
/* #endif */

/* #ifndef GL_VERSION_1_4 */
  GL_BLEND_DST_RGB                  = 0x80C8,
  GL_BLEND_SRC_RGB                  = 0x80C9,
  GL_BLEND_DST_ALPHA                = 0x80CA,
  GL_BLEND_SRC_ALPHA                = 0x80CB,
  GL_POINT_FADE_THRESHOLD_SIZE      = 0x8128,
  GL_DEPTH_COMPONENT16              = 0x81A5,
  GL_DEPTH_COMPONENT24              = 0x81A6,
  GL_DEPTH_COMPONENT32              = 0x81A7,
  GL_MIRRORED_REPEAT                = 0x8370,
  GL_MAX_TEXTURE_LOD_BIAS           = 0x84FD,
  GL_TEXTURE_LOD_BIAS               = 0x8501,
  GL_INCR_WRAP                      = 0x8507,
  GL_DECR_WRAP                      = 0x8508,
  GL_TEXTURE_DEPTH_SIZE             = 0x884A,
  GL_TEXTURE_COMPARE_MODE           = 0x884C,
  GL_TEXTURE_COMPARE_FUNC           = 0x884D,
/* #endif */

/* #ifndef GL_VERSION_1_5 */
  GL_BUFFER_SIZE                    = 0x8764,
  GL_BUFFER_USAGE                   = 0x8765,
  GL_QUERY_COUNTER_BITS             = 0x8864,
  GL_CURRENT_QUERY                  = 0x8865,
  GL_QUERY_RESULT                   = 0x8866,
  GL_QUERY_RESULT_AVAILABLE         = 0x8867,
  GL_ARRAY_BUFFER                   = 0x8892,
  GL_ELEMENT_ARRAY_BUFFER           = 0x8893,
  GL_ARRAY_BUFFER_BINDING           = 0x8894,
  GL_ELEMENT_ARRAY_BUFFER_BINDING   = 0x8895,
  GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F,
  GL_READ_ONLY                      = 0x88B8,
  GL_WRITE_ONLY                     = 0x88B9,
  GL_READ_WRITE                     = 0x88BA,
  GL_BUFFER_ACCESS                  = 0x88BB,
  GL_BUFFER_MAPPED                  = 0x88BC,
  GL_BUFFER_MAP_POINTER             = 0x88BD,
  GL_STREAM_DRAW                    = 0x88E0,
  GL_STREAM_READ                    = 0x88E1,
  GL_STREAM_COPY                    = 0x88E2,
  GL_STATIC_DRAW                    = 0x88E4,
  GL_STATIC_READ                    = 0x88E5,
  GL_STATIC_COPY                    = 0x88E6,
  GL_DYNAMIC_DRAW                   = 0x88E8,
  GL_DYNAMIC_READ                   = 0x88E9,
  GL_DYNAMIC_COPY                   = 0x88EA,
  GL_SAMPLES_PASSED                 = 0x8914,
/* #endif */

/* #ifndef GL_VERSION_2_0 */
  GL_BLEND_EQUATION_RGB             = 0x8009,
  GL_VERTEX_ATTRIB_ARRAY_ENABLED    = 0x8622,
  GL_VERTEX_ATTRIB_ARRAY_SIZE       = 0x8623,
  GL_VERTEX_ATTRIB_ARRAY_STRIDE     = 0x8624,
  GL_VERTEX_ATTRIB_ARRAY_TYPE       = 0x8625,
  GL_CURRENT_VERTEX_ATTRIB          = 0x8626,
  GL_VERTEX_PROGRAM_POINT_SIZE      = 0x8642,
  GL_VERTEX_ATTRIB_ARRAY_POINTER    = 0x8645,
  GL_STENCIL_BACK_FUNC              = 0x8800,
  GL_STENCIL_BACK_FAIL              = 0x8801,
  GL_STENCIL_BACK_PASS_DEPTH_FAIL   = 0x8802,
  GL_STENCIL_BACK_PASS_DEPTH_PASS   = 0x8803,
  GL_MAX_DRAW_BUFFERS               = 0x8824,
  GL_DRAW_BUFFER0                   = 0x8825,
  GL_DRAW_BUFFER1                   = 0x8826,
  GL_DRAW_BUFFER2                   = 0x8827,
  GL_DRAW_BUFFER3                   = 0x8828,
  GL_DRAW_BUFFER4                   = 0x8829,
  GL_DRAW_BUFFER5                   = 0x882A,
  GL_DRAW_BUFFER6                   = 0x882B,
  GL_DRAW_BUFFER7                   = 0x882C,
  GL_DRAW_BUFFER8                   = 0x882D,
  GL_DRAW_BUFFER9                   = 0x882E,
  GL_DRAW_BUFFER10                  = 0x882F,
  GL_DRAW_BUFFER11                  = 0x8830,
  GL_DRAW_BUFFER12                  = 0x8831,
  GL_DRAW_BUFFER13                  = 0x8832,
  GL_DRAW_BUFFER14                  = 0x8833,
  GL_DRAW_BUFFER15                  = 0x8834,
  GL_BLEND_EQUATION_ALPHA           = 0x883D,
  GL_MAX_VERTEX_ATTRIBS             = 0x8869,
  GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A,
  GL_MAX_TEXTURE_IMAGE_UNITS        = 0x8872,
  GL_FRAGMENT_SHADER                = 0x8B30,
  GL_VERTEX_SHADER                  = 0x8B31,
  GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49,
  GL_MAX_VERTEX_UNIFORM_COMPONENTS  = 0x8B4A,
  GL_MAX_VARYING_FLOATS             = 0x8B4B,
  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C,
  GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D,
  GL_SHADER_TYPE                    = 0x8B4F,
  GL_FLOAT_VEC2                     = 0x8B50,
  GL_FLOAT_VEC3                     = 0x8B51,
  GL_FLOAT_VEC4                     = 0x8B52,
  GL_INT_VEC2                       = 0x8B53,
  GL_INT_VEC3                       = 0x8B54,
  GL_INT_VEC4                       = 0x8B55,
  GL_BOOL                           = 0x8B56,
  GL_BOOL_VEC2                      = 0x8B57,
  GL_BOOL_VEC3                      = 0x8B58,
  GL_BOOL_VEC4                      = 0x8B59,
  GL_FLOAT_MAT2                     = 0x8B5A,
  GL_FLOAT_MAT3                     = 0x8B5B,
  GL_FLOAT_MAT4                     = 0x8B5C,
  GL_SAMPLER_1D                     = 0x8B5D,
  GL_SAMPLER_2D                     = 0x8B5E,
  GL_SAMPLER_3D                     = 0x8B5F,
  GL_SAMPLER_CUBE                   = 0x8B60,
  GL_SAMPLER_1D_SHADOW              = 0x8B61,
  GL_SAMPLER_2D_SHADOW              = 0x8B62,
  GL_DELETE_STATUS                  = 0x8B80,
  GL_COMPILE_STATUS                 = 0x8B81,
  GL_LINK_STATUS                    = 0x8B82,
  GL_VALIDATE_STATUS                = 0x8B83,
  GL_INFO_LOG_LENGTH                = 0x8B84,
  GL_ATTACHED_SHADERS               = 0x8B85,
  GL_ACTIVE_UNIFORMS                = 0x8B86,
  GL_ACTIVE_UNIFORM_MAX_LENGTH      = 0x8B87,
  GL_SHADER_SOURCE_LENGTH           = 0x8B88,
  GL_ACTIVE_ATTRIBUTES              = 0x8B89,
  GL_ACTIVE_ATTRIBUTE_MAX_LENGTH    = 0x8B8A,
  GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B,
  GL_SHADING_LANGUAGE_VERSION       = 0x8B8C,
  GL_CURRENT_PROGRAM                = 0x8B8D,
  GL_POINT_SPRITE_COORD_ORIGIN      = 0x8CA0,
  GL_LOWER_LEFT                     = 0x8CA1,
  GL_UPPER_LEFT                     = 0x8CA2,
  GL_STENCIL_BACK_REF               = 0x8CA3,
  GL_STENCIL_BACK_VALUE_MASK        = 0x8CA4,
  GL_STENCIL_BACK_WRITEMASK         = 0x8CA5,
/* #endif */

/* #ifndef GL_VERSION_2_1 */
  GL_PIXEL_PACK_BUFFER              = 0x88EB,
  GL_PIXEL_UNPACK_BUFFER            = 0x88EC,
  GL_PIXEL_PACK_BUFFER_BINDING      = 0x88ED,
  GL_PIXEL_UNPACK_BUFFER_BINDING    = 0x88EF,
  GL_FLOAT_MAT2x3                   = 0x8B65,
  GL_FLOAT_MAT2x4                   = 0x8B66,
  GL_FLOAT_MAT3x2                   = 0x8B67,
  GL_FLOAT_MAT3x4                   = 0x8B68,
  GL_FLOAT_MAT4x2                   = 0x8B69,
  GL_FLOAT_MAT4x3                   = 0x8B6A,
  GL_SRGB                           = 0x8C40,
  GL_SRGB8                          = 0x8C41,
  GL_SRGB_ALPHA                     = 0x8C42,
  GL_SRGB8_ALPHA8                   = 0x8C43,
  GL_COMPRESSED_SRGB                = 0x8C48,
  GL_COMPRESSED_SRGB_ALPHA          = 0x8C49,
/* #endif */

/* #ifndef GL_VERSION_3_0 */
  GL_COMPARE_REF_TO_TEXTURE         = 0x884E,
  GL_CLIP_DISTANCE0                 = 0x3000,
  GL_CLIP_DISTANCE1                 = 0x3001,
  GL_CLIP_DISTANCE2                 = 0x3002,
  GL_CLIP_DISTANCE3                 = 0x3003,
  GL_CLIP_DISTANCE4                 = 0x3004,
  GL_CLIP_DISTANCE5                 = 0x3005,
  GL_CLIP_DISTANCE6                 = 0x3006,
  GL_CLIP_DISTANCE7                 = 0x3007,
  GL_MAX_CLIP_DISTANCES             = 0x0D32,
  GL_MAJOR_VERSION                  = 0x821B,
  GL_MINOR_VERSION                  = 0x821C,
  GL_NUM_EXTENSIONS                 = 0x821D,
  GL_CONTEXT_FLAGS                  = 0x821E,
  GL_COMPRESSED_RED                 = 0x8225,
  GL_COMPRESSED_RG                  = 0x8226,
  GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = 0x0001,
  GL_RGBA32F                        = 0x8814,
  GL_RGB32F                         = 0x8815,
  GL_RGBA16F                        = 0x881A,
  GL_RGB16F                         = 0x881B,
  GL_VERTEX_ATTRIB_ARRAY_INTEGER    = 0x88FD,
  GL_MAX_ARRAY_TEXTURE_LAYERS       = 0x88FF,
  GL_MIN_PROGRAM_TEXEL_OFFSET       = 0x8904,
  GL_MAX_PROGRAM_TEXEL_OFFSET       = 0x8905,
  GL_CLAMP_READ_COLOR               = 0x891C,
  GL_FIXED_ONLY                     = 0x891D,
  GL_MAX_VARYING_COMPONENTS         = 0x8B4B,
  GL_TEXTURE_1D_ARRAY               = 0x8C18,
  GL_PROXY_TEXTURE_1D_ARRAY         = 0x8C19,
  GL_TEXTURE_2D_ARRAY               = 0x8C1A,
  GL_PROXY_TEXTURE_2D_ARRAY         = 0x8C1B,
  GL_TEXTURE_BINDING_1D_ARRAY       = 0x8C1C,
  GL_TEXTURE_BINDING_2D_ARRAY       = 0x8C1D,
  GL_R11F_G11F_B10F                 = 0x8C3A,
  GL_UNSIGNED_INT_10F_11F_11F_REV   = 0x8C3B,
  GL_RGB9_E5                        = 0x8C3D,
  GL_UNSIGNED_INT_5_9_9_9_REV       = 0x8C3E,
  GL_TEXTURE_SHARED_SIZE            = 0x8C3F,
  GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 0x8C76,
  GL_TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F,
  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80,
  GL_TRANSFORM_FEEDBACK_VARYINGS    = 0x8C83,
  GL_TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84,
  GL_TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85,
  GL_PRIMITIVES_GENERATED           = 0x8C87,
  GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88,
  GL_RASTERIZER_DISCARD             = 0x8C89,
  GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A,
  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B,
  GL_INTERLEAVED_ATTRIBS            = 0x8C8C,
  GL_SEPARATE_ATTRIBS               = 0x8C8D,
  GL_TRANSFORM_FEEDBACK_BUFFER      = 0x8C8E,
  GL_TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F,
  GL_RGBA32UI                       = 0x8D70,
  GL_RGB32UI                        = 0x8D71,
  GL_RGBA16UI                       = 0x8D76,
  GL_RGB16UI                        = 0x8D77,
  GL_RGBA8UI                        = 0x8D7C,
  GL_RGB8UI                         = 0x8D7D,
  GL_RGBA32I                        = 0x8D82,
  GL_RGB32I                         = 0x8D83,
  GL_RGBA16I                        = 0x8D88,
  GL_RGB16I                         = 0x8D89,
  GL_RGBA8I                         = 0x8D8E,
  GL_RGB8I                          = 0x8D8F,
  GL_RED_INTEGER                    = 0x8D94,
  GL_GREEN_INTEGER                  = 0x8D95,
  GL_BLUE_INTEGER                   = 0x8D96,
  GL_RGB_INTEGER                    = 0x8D98,
  GL_RGBA_INTEGER                   = 0x8D99,
  GL_BGR_INTEGER                    = 0x8D9A,
  GL_BGRA_INTEGER                   = 0x8D9B,
  GL_SAMPLER_1D_ARRAY               = 0x8DC0,
  GL_SAMPLER_2D_ARRAY               = 0x8DC1,
  GL_SAMPLER_1D_ARRAY_SHADOW        = 0x8DC3,
  GL_SAMPLER_2D_ARRAY_SHADOW        = 0x8DC4,
  GL_SAMPLER_CUBE_SHADOW            = 0x8DC5,
  GL_UNSIGNED_INT_VEC2              = 0x8DC6,
  GL_UNSIGNED_INT_VEC3              = 0x8DC7,
  GL_UNSIGNED_INT_VEC4              = 0x8DC8,
  GL_INT_SAMPLER_1D                 = 0x8DC9,
  GL_INT_SAMPLER_2D                 = 0x8DCA,
  GL_INT_SAMPLER_3D                 = 0x8DCB,
  GL_INT_SAMPLER_CUBE               = 0x8DCC,
  GL_INT_SAMPLER_1D_ARRAY           = 0x8DCE,
  GL_INT_SAMPLER_2D_ARRAY           = 0x8DCF,
  GL_UNSIGNED_INT_SAMPLER_1D        = 0x8DD1,
  GL_UNSIGNED_INT_SAMPLER_2D        = 0x8DD2,
  GL_UNSIGNED_INT_SAMPLER_3D        = 0x8DD3,
  GL_UNSIGNED_INT_SAMPLER_CUBE      = 0x8DD4,
  GL_UNSIGNED_INT_SAMPLER_1D_ARRAY  = 0x8DD6,
  GL_UNSIGNED_INT_SAMPLER_2D_ARRAY  = 0x8DD7,
  GL_QUERY_WAIT                     = 0x8E13,
  GL_QUERY_NO_WAIT                  = 0x8E14,
  GL_QUERY_BY_REGION_WAIT           = 0x8E15,
  GL_QUERY_BY_REGION_NO_WAIT        = 0x8E16,
  GL_BUFFER_ACCESS_FLAGS            = 0x911F,
  GL_BUFFER_MAP_LENGTH              = 0x9120,
  GL_BUFFER_MAP_OFFSET              = 0x9121,
/* Reuse tokens from ARB_depth_buffer_float */
/* reuse GL_DEPTH_COMPONENT32F */
/* reuse GL_DEPTH32F_STENCIL8 */
/* reuse GL_FLOAT_32_UNSIGNED_INT_24_8_REV */
/* Reuse tokens from ARB_framebuffer_object */
/* reuse GL_INVALID_FRAMEBUFFER_OPERATION */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE */
/* reuse GL_FRAMEBUFFER_DEFAULT */
/* reuse GL_FRAMEBUFFER_UNDEFINED */
/* reuse GL_DEPTH_STENCIL_ATTACHMENT */
/* reuse GL_INDEX */
/* reuse GL_MAX_RENDERBUFFER_SIZE */
/* reuse GL_DEPTH_STENCIL */
/* reuse GL_UNSIGNED_INT_24_8 */
/* reuse GL_DEPTH24_STENCIL8 */
/* reuse GL_TEXTURE_STENCIL_SIZE */
/* reuse GL_TEXTURE_RED_TYPE */
/* reuse GL_TEXTURE_GREEN_TYPE */
/* reuse GL_TEXTURE_BLUE_TYPE */
/* reuse GL_TEXTURE_ALPHA_TYPE */
/* reuse GL_TEXTURE_DEPTH_TYPE */
/* reuse GL_UNSIGNED_NORMALIZED */
/* reuse GL_FRAMEBUFFER_BINDING */
/* reuse GL_DRAW_FRAMEBUFFER_BINDING */
/* reuse GL_RENDERBUFFER_BINDING */
/* reuse GL_READ_FRAMEBUFFER */
/* reuse GL_DRAW_FRAMEBUFFER */
/* reuse GL_READ_FRAMEBUFFER_BINDING */
/* reuse GL_RENDERBUFFER_SAMPLES */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */
/* reuse GL_FRAMEBUFFER_COMPLETE */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER */
/* reuse GL_FRAMEBUFFER_UNSUPPORTED */
/* reuse GL_MAX_COLOR_ATTACHMENTS */
/* reuse GL_COLOR_ATTACHMENT0 */
/* reuse GL_COLOR_ATTACHMENT1 */
/* reuse GL_COLOR_ATTACHMENT2 */
/* reuse GL_COLOR_ATTACHMENT3 */
/* reuse GL_COLOR_ATTACHMENT4 */
/* reuse GL_COLOR_ATTACHMENT5 */
/* reuse GL_COLOR_ATTACHMENT6 */
/* reuse GL_COLOR_ATTACHMENT7 */
/* reuse GL_COLOR_ATTACHMENT8 */
/* reuse GL_COLOR_ATTACHMENT9 */
/* reuse GL_COLOR_ATTACHMENT10 */
/* reuse GL_COLOR_ATTACHMENT11 */
/* reuse GL_COLOR_ATTACHMENT12 */
/* reuse GL_COLOR_ATTACHMENT13 */
/* reuse GL_COLOR_ATTACHMENT14 */
/* reuse GL_COLOR_ATTACHMENT15 */
/* reuse GL_DEPTH_ATTACHMENT */
/* reuse GL_STENCIL_ATTACHMENT */
/* reuse GL_FRAMEBUFFER */
/* reuse GL_RENDERBUFFER */
/* reuse GL_RENDERBUFFER_WIDTH */
/* reuse GL_RENDERBUFFER_HEIGHT */
/* reuse GL_RENDERBUFFER_INTERNAL_FORMAT */
/* reuse GL_STENCIL_INDEX1 */
/* reuse GL_STENCIL_INDEX4 */
/* reuse GL_STENCIL_INDEX8 */
/* reuse GL_STENCIL_INDEX16 */
/* reuse GL_RENDERBUFFER_RED_SIZE */
/* reuse GL_RENDERBUFFER_GREEN_SIZE */
/* reuse GL_RENDERBUFFER_BLUE_SIZE */
/* reuse GL_RENDERBUFFER_ALPHA_SIZE */
/* reuse GL_RENDERBUFFER_DEPTH_SIZE */
/* reuse GL_RENDERBUFFER_STENCIL_SIZE */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE */
/* reuse GL_MAX_SAMPLES */
/* Reuse tokens from ARB_framebuffer_sRGB */
/* reuse GL_FRAMEBUFFER_SRGB */
/* Reuse tokens from ARB_half_float_vertex */
/* reuse GL_HALF_FLOAT */
/* Reuse tokens from ARB_map_buffer_range */
/* reuse GL_MAP_READ_BIT */
/* reuse GL_MAP_WRITE_BIT */
/* reuse GL_MAP_INVALIDATE_RANGE_BIT */
/* reuse GL_MAP_INVALIDATE_BUFFER_BIT */
/* reuse GL_MAP_FLUSH_EXPLICIT_BIT */
/* reuse GL_MAP_UNSYNCHRONIZED_BIT */
/* Reuse tokens from ARB_texture_compression_rgtc */
/* reuse GL_COMPRESSED_RED_RGTC1 */
/* reuse GL_COMPRESSED_SIGNED_RED_RGTC1 */
/* reuse GL_COMPRESSED_RG_RGTC2 */
/* reuse GL_COMPRESSED_SIGNED_RG_RGTC2 */
/* Reuse tokens from ARB_texture_rg */
/* reuse GL_RG */
/* reuse GL_RG_INTEGER */
/* reuse GL_R8 */
/* reuse GL_R16 */
/* reuse GL_RG8 */
/* reuse GL_RG16 */
/* reuse GL_R16F */
/* reuse GL_R32F */
/* reuse GL_RG16F */
/* reuse GL_RG32F */
/* reuse GL_R8I */
/* reuse GL_R8UI */
/* reuse GL_R16I */
/* reuse GL_R16UI */
/* reuse GL_R32I */
/* reuse GL_R32UI */
/* reuse GL_RG8I */
/* reuse GL_RG8UI */
/* reuse GL_RG16I */
/* reuse GL_RG16UI */
/* reuse GL_RG32I */
/* reuse GL_RG32UI */
/* Reuse tokens from ARB_vertex_array_object */
/* reuse GL_VERTEX_ARRAY_BINDING */
/* #endif */

/* #ifndef GL_VERSION_3_1 */
  GL_SAMPLER_2D_RECT                = 0x8B63,
  GL_SAMPLER_2D_RECT_SHADOW         = 0x8B64,
  GL_SAMPLER_BUFFER                 = 0x8DC2,
  GL_INT_SAMPLER_2D_RECT            = 0x8DCD,
  GL_INT_SAMPLER_BUFFER             = 0x8DD0,
  GL_UNSIGNED_INT_SAMPLER_2D_RECT   = 0x8DD5,
  GL_UNSIGNED_INT_SAMPLER_BUFFER    = 0x8DD8,
  GL_TEXTURE_BUFFER                 = 0x8C2A,
  GL_MAX_TEXTURE_BUFFER_SIZE        = 0x8C2B,
  GL_TEXTURE_BINDING_BUFFER         = 0x8C2C,
  GL_TEXTURE_BUFFER_DATA_STORE_BINDING = 0x8C2D,
  GL_TEXTURE_BUFFER_FORMAT          = 0x8C2E,
  GL_TEXTURE_RECTANGLE              = 0x84F5,
  GL_TEXTURE_BINDING_RECTANGLE      = 0x84F6,
  GL_PROXY_TEXTURE_RECTANGLE        = 0x84F7,
  GL_MAX_RECTANGLE_TEXTURE_SIZE     = 0x84F8,
  GL_RED_SNORM                      = 0x8F90,
  GL_RG_SNORM                       = 0x8F91,
  GL_RGB_SNORM                      = 0x8F92,
  GL_RGBA_SNORM                     = 0x8F93,
  GL_R8_SNORM                       = 0x8F94,
  GL_RG8_SNORM                      = 0x8F95,
  GL_RGB8_SNORM                     = 0x8F96,
  GL_RGBA8_SNORM                    = 0x8F97,
  GL_R16_SNORM                      = 0x8F98,
  GL_RG16_SNORM                     = 0x8F99,
  GL_RGB16_SNORM                    = 0x8F9A,
  GL_RGBA16_SNORM                   = 0x8F9B,
  GL_SIGNED_NORMALIZED              = 0x8F9C,
  GL_PRIMITIVE_RESTART              = 0x8F9D,
  GL_PRIMITIVE_RESTART_INDEX        = 0x8F9E,
/* Reuse tokens from ARB_copy_buffer */
/* reuse GL_COPY_READ_BUFFER */
/* reuse GL_COPY_WRITE_BUFFER */
/* Reuse tokens from ARB_draw_instanced (none) */
/* Reuse tokens from ARB_uniform_buffer_object */
/* reuse GL_UNIFORM_BUFFER */
/* reuse GL_UNIFORM_BUFFER_BINDING */
/* reuse GL_UNIFORM_BUFFER_START */
/* reuse GL_UNIFORM_BUFFER_SIZE */
/* reuse GL_MAX_VERTEX_UNIFORM_BLOCKS */
/* reuse GL_MAX_FRAGMENT_UNIFORM_BLOCKS */
/* reuse GL_MAX_COMBINED_UNIFORM_BLOCKS */
/* reuse GL_MAX_UNIFORM_BUFFER_BINDINGS */
/* reuse GL_MAX_UNIFORM_BLOCK_SIZE */
/* reuse GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS */
/* reuse GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS */
/* reuse GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT */
/* reuse GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH */
/* reuse GL_ACTIVE_UNIFORM_BLOCKS */
/* reuse GL_UNIFORM_TYPE */
/* reuse GL_UNIFORM_SIZE */
/* reuse GL_UNIFORM_NAME_LENGTH */
/* reuse GL_UNIFORM_BLOCK_INDEX */
/* reuse GL_UNIFORM_OFFSET */
/* reuse GL_UNIFORM_ARRAY_STRIDE */
/* reuse GL_UNIFORM_MATRIX_STRIDE */
/* reuse GL_UNIFORM_IS_ROW_MAJOR */
/* reuse GL_UNIFORM_BLOCK_BINDING */
/* reuse GL_UNIFORM_BLOCK_DATA_SIZE */
/* reuse GL_UNIFORM_BLOCK_NAME_LENGTH */
/* reuse GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS */
/* reuse GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER */
/* reuse GL_INVALID_INDEX */
/* #endif */

/* #ifndef GL_VERSION_3_2 */
  GL_CONTEXT_CORE_PROFILE_BIT       = 0x00000001,
  GL_CONTEXT_COMPATIBILITY_PROFILE_BIT = 0x00000002,
  GL_LINES_ADJACENCY                = 0x000A,
  GL_LINE_STRIP_ADJACENCY           = 0x000B,
  GL_TRIANGLES_ADJACENCY            = 0x000C,
  GL_TRIANGLE_STRIP_ADJACENCY       = 0x000D,
  GL_PROGRAM_POINT_SIZE             = 0x8642,
  GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = 0x8C29,
  GL_FRAMEBUFFER_ATTACHMENT_LAYERED = 0x8DA7,
  GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = 0x8DA8,
  GL_GEOMETRY_SHADER                = 0x8DD9,
  GL_GEOMETRY_VERTICES_OUT          = 0x8916,
  GL_GEOMETRY_INPUT_TYPE            = 0x8917,
  GL_GEOMETRY_OUTPUT_TYPE           = 0x8918,
  GL_MAX_GEOMETRY_UNIFORM_COMPONENTS = 0x8DDF,
  GL_MAX_GEOMETRY_OUTPUT_VERTICES   = 0x8DE0,
  GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = 0x8DE1,
  GL_MAX_VERTEX_OUTPUT_COMPONENTS   = 0x9122,
  GL_MAX_GEOMETRY_INPUT_COMPONENTS  = 0x9123,
  GL_MAX_GEOMETRY_OUTPUT_COMPONENTS = 0x9124,
  GL_MAX_FRAGMENT_INPUT_COMPONENTS  = 0x9125,
  GL_CONTEXT_PROFILE_MASK           = 0x9126,
/* reuse GL_MAX_VARYING_COMPONENTS */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */
/* Reuse tokens from ARB_depth_clamp */
/* reuse GL_DEPTH_CLAMP */
/* Reuse tokens from ARB_draw_elements_base_vertex (none) */
/* Reuse tokens from ARB_fragment_coord_conventions (none) */
/* Reuse tokens from ARB_provoking_vertex */
/* reuse GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION */
/* reuse GL_FIRST_VERTEX_CONVENTION */
/* reuse GL_LAST_VERTEX_CONVENTION */
/* reuse GL_PROVOKING_VERTEX */
/* Reuse tokens from ARB_seamless_cube_map */
/* reuse GL_TEXTURE_CUBE_MAP_SEAMLESS */
/* Reuse tokens from ARB_sync */
/* reuse GL_MAX_SERVER_WAIT_TIMEOUT */
/* reuse GL_OBJECT_TYPE */
/* reuse GL_SYNC_CONDITION */
/* reuse GL_SYNC_STATUS */
/* reuse GL_SYNC_FLAGS */
/* reuse GL_SYNC_FENCE */
/* reuse GL_SYNC_GPU_COMMANDS_COMPLETE */
/* reuse GL_UNSIGNALED */
/* reuse GL_SIGNALED */
/* reuse GL_ALREADY_SIGNALED */
/* reuse GL_TIMEOUT_EXPIRED */
/* reuse GL_CONDITION_SATISFIED */
/* reuse GL_WAIT_FAILED */
/* reuse GL_TIMEOUT_IGNORED */
/* reuse GL_SYNC_FLUSH_COMMANDS_BIT */
/* reuse GL_TIMEOUT_IGNORED */
/* Reuse tokens from ARB_texture_multisample */
/* reuse GL_SAMPLE_POSITION */
/* reuse GL_SAMPLE_MASK */
/* reuse GL_SAMPLE_MASK_VALUE */
/* reuse GL_MAX_SAMPLE_MASK_WORDS */
/* reuse GL_TEXTURE_2D_MULTISAMPLE */
/* reuse GL_PROXY_TEXTURE_2D_MULTISAMPLE */
/* reuse GL_TEXTURE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_TEXTURE_BINDING_2D_MULTISAMPLE */
/* reuse GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY */
/* reuse GL_TEXTURE_SAMPLES */
/* reuse GL_TEXTURE_FIXED_SAMPLE_LOCATIONS */
/* reuse GL_SAMPLER_2D_MULTISAMPLE */
/* reuse GL_INT_SAMPLER_2D_MULTISAMPLE */
/* reuse GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE */
/* reuse GL_SAMPLER_2D_MULTISAMPLE_ARRAY */
/* reuse GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY */
/* reuse GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY */
/* reuse GL_MAX_COLOR_TEXTURE_SAMPLES */
/* reuse GL_MAX_DEPTH_TEXTURE_SAMPLES */
/* reuse GL_MAX_INTEGER_SAMPLES */
/* Don't need to reuse tokens from ARB_vertex_array_bgra since they're already in 1.2 core */
/* #endif */

/* #ifndef GL_VERSION_3_3 */
  GL_VERTEX_ATTRIB_ARRAY_DIVISOR    = 0x88FE,
/* Reuse tokens from ARB_blend_func_extended */
/* reuse GL_SRC1_COLOR */
/* reuse GL_ONE_MINUS_SRC1_COLOR */
/* reuse GL_ONE_MINUS_SRC1_ALPHA */
/* reuse GL_MAX_DUAL_SOURCE_DRAW_BUFFERS */
/* Reuse tokens from ARB_explicit_attrib_location (none) */
/* Reuse tokens from ARB_occlusion_query2 */
/* reuse GL_ANY_SAMPLES_PASSED */
/* Reuse tokens from ARB_sampler_objects */
/* reuse GL_SAMPLER_BINDING */
/* Reuse tokens from ARB_shader_bit_encoding (none) */
/* Reuse tokens from ARB_texture_rgb10_a2ui */
/* reuse GL_RGB10_A2UI */
/* Reuse tokens from ARB_texture_swizzle */
/* reuse GL_TEXTURE_SWIZZLE_R */
/* reuse GL_TEXTURE_SWIZZLE_G */
/* reuse GL_TEXTURE_SWIZZLE_B */
/* reuse GL_TEXTURE_SWIZZLE_A */
/* reuse GL_TEXTURE_SWIZZLE_RGBA */
/* Reuse tokens from ARB_timer_query */
/* reuse GL_TIME_ELAPSED */
/* reuse GL_TIMESTAMP */
/* Reuse tokens from ARB_vertex_type_2_10_10_10_rev */
/* reuse GL_INT_2_10_10_10_REV */
/* #endif */

/* #ifndef GL_VERSION_4_0 */
  GL_SAMPLE_SHADING                 = 0x8C36,
  GL_MIN_SAMPLE_SHADING_VALUE       = 0x8C37,
  GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET = 0x8E5E,
  GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET = 0x8E5F,
  GL_TEXTURE_CUBE_MAP_ARRAY         = 0x9009,
  GL_TEXTURE_BINDING_CUBE_MAP_ARRAY = 0x900A,
  GL_PROXY_TEXTURE_CUBE_MAP_ARRAY   = 0x900B,
  GL_SAMPLER_CUBE_MAP_ARRAY         = 0x900C,
  GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW  = 0x900D,
  GL_INT_SAMPLER_CUBE_MAP_ARRAY     = 0x900E,
  GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY = 0x900F,
/* Reuse tokens from ARB_texture_query_lod (none) */
/* Reuse tokens from ARB_draw_buffers_blend (none) */
/* Reuse tokens from ARB_draw_indirect */
/* reuse GL_DRAW_INDIRECT_BUFFER */
/* reuse GL_DRAW_INDIRECT_BUFFER_BINDING */
/* Reuse tokens from ARB_gpu_shader5 */
/* reuse GL_GEOMETRY_SHADER_INVOCATIONS */
/* reuse GL_MAX_GEOMETRY_SHADER_INVOCATIONS */
/* reuse GL_MIN_FRAGMENT_INTERPOLATION_OFFSET */
/* reuse GL_MAX_FRAGMENT_INTERPOLATION_OFFSET */
/* reuse GL_FRAGMENT_INTERPOLATION_OFFSET_BITS */
/* reuse GL_MAX_VERTEX_STREAMS */
/* Reuse tokens from ARB_gpu_shader_fp64 */
/* reuse GL_DOUBLE_VEC2 */
/* reuse GL_DOUBLE_VEC3 */
/* reuse GL_DOUBLE_VEC4 */
/* reuse GL_DOUBLE_MAT2 */
/* reuse GL_DOUBLE_MAT3 */
/* reuse GL_DOUBLE_MAT4 */
/* reuse GL_DOUBLE_MAT2x3 */
/* reuse GL_DOUBLE_MAT2x4 */
/* reuse GL_DOUBLE_MAT3x2 */
/* reuse GL_DOUBLE_MAT3x4 */
/* reuse GL_DOUBLE_MAT4x2 */
/* reuse GL_DOUBLE_MAT4x3 */
/* Reuse tokens from ARB_shader_subroutine */
/* reuse GL_ACTIVE_SUBROUTINES */
/* reuse GL_ACTIVE_SUBROUTINE_UNIFORMS */
/* reuse GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS */
/* reuse GL_ACTIVE_SUBROUTINE_MAX_LENGTH */
/* reuse GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH */
/* reuse GL_MAX_SUBROUTINES */
/* reuse GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS */
/* reuse GL_NUM_COMPATIBLE_SUBROUTINES */
/* reuse GL_COMPATIBLE_SUBROUTINES */
/* Reuse tokens from ARB_tessellation_shader */
/* reuse GL_PATCHES */
/* reuse GL_PATCH_VERTICES */
/* reuse GL_PATCH_DEFAULT_INNER_LEVEL */
/* reuse GL_PATCH_DEFAULT_OUTER_LEVEL */
/* reuse GL_TESS_CONTROL_OUTPUT_VERTICES */
/* reuse GL_TESS_GEN_MODE */
/* reuse GL_TESS_GEN_SPACING */
/* reuse GL_TESS_GEN_VERTEX_ORDER */
/* reuse GL_TESS_GEN_POINT_MODE */
/* reuse GL_ISOLINES */
/* reuse GL_FRACTIONAL_ODD */
/* reuse GL_FRACTIONAL_EVEN */
/* reuse GL_MAX_PATCH_VERTICES */
/* reuse GL_MAX_TESS_GEN_LEVEL */
/* reuse GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS */
/* reuse GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS */
/* reuse GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS */
/* reuse GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS */
/* reuse GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS */
/* reuse GL_MAX_TESS_PATCH_COMPONENTS */
/* reuse GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS */
/* reuse GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS */
/* reuse GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS */
/* reuse GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS */
/* reuse GL_MAX_TESS_CONTROL_INPUT_COMPONENTS */
/* reuse GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS */
/* reuse GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS */
/* reuse GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER */
/* reuse GL_TESS_EVALUATION_SHADER */
/* reuse GL_TESS_CONTROL_SHADER */
/* Reuse tokens from ARB_texture_buffer_object_rgb32 (none) */
/* Reuse tokens from ARB_transform_feedback2 */
/* reuse GL_TRANSFORM_FEEDBACK */
/* reuse GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED */
/* reuse GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE */
/* reuse GL_TRANSFORM_FEEDBACK_BINDING */
/* Reuse tokens from ARB_transform_feedback3 */
/* reuse GL_MAX_TRANSFORM_FEEDBACK_BUFFERS */
/* reuse GL_MAX_VERTEX_STREAMS */
/* #endif */

/* #ifndef GL_VERSION_4_1 */
/* Reuse tokens from ARB_ES2_compatibility */
/* reuse GL_FIXED */
/* reuse GL_IMPLEMENTATION_COLOR_READ_TYPE */
/* reuse GL_IMPLEMENTATION_COLOR_READ_FORMAT */
/* reuse GL_LOW_FLOAT */
/* reuse GL_MEDIUM_FLOAT */
/* reuse GL_HIGH_FLOAT */
/* reuse GL_LOW_INT */
/* reuse GL_MEDIUM_INT */
/* reuse GL_HIGH_INT */
/* reuse GL_SHADER_COMPILER */
/* reuse GL_NUM_SHADER_BINARY_FORMATS */
/* reuse GL_MAX_VERTEX_UNIFORM_VECTORS */
/* reuse GL_MAX_VARYING_VECTORS */
/* reuse GL_MAX_FRAGMENT_UNIFORM_VECTORS */
/* Reuse tokens from ARB_get_program_binary */
/* reuse GL_PROGRAM_BINARY_RETRIEVABLE_HINT */
/* reuse GL_PROGRAM_BINARY_LENGTH */
/* reuse GL_NUM_PROGRAM_BINARY_FORMATS */
/* reuse GL_PROGRAM_BINARY_FORMATS */
/* Reuse tokens from ARB_separate_shader_objects */
/* reuse GL_VERTEX_SHADER_BIT */
/* reuse GL_FRAGMENT_SHADER_BIT */
/* reuse GL_GEOMETRY_SHADER_BIT */
/* reuse GL_TESS_CONTROL_SHADER_BIT */
/* reuse GL_TESS_EVALUATION_SHADER_BIT */
/* reuse GL_ALL_SHADER_BITS */
/* reuse GL_PROGRAM_SEPARABLE */
/* reuse GL_ACTIVE_PROGRAM */
/* reuse GL_PROGRAM_PIPELINE_BINDING */
/* Reuse tokens from ARB_shader_precision (none) */
/* Reuse tokens from ARB_vertex_attrib_64bit - all are in GL 3.0 and 4.0 already */
/* Reuse tokens from ARB_viewport_array - some are in GL 1.1 and ARB_provoking_vertex already */
/* reuse GL_MAX_VIEWPORTS */
/* reuse GL_VIEWPORT_SUBPIXEL_BITS */
/* reuse GL_VIEWPORT_BOUNDS_RANGE */
/* reuse GL_LAYER_PROVOKING_VERTEX */
/* reuse GL_VIEWPORT_INDEX_PROVOKING_VERTEX */
/* reuse GL_UNDEFINED_VERTEX */
/* #endif */

/* #ifndef GL_VERSION_4_2 */
/* Reuse tokens from ARB_base_instance (none) */
/* Reuse tokens from ARB_shading_language_420pack (none) */
/* Reuse tokens from ARB_transform_feedback_instanced (none) */
/* Reuse tokens from ARB_compressed_texture_pixel_storage */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_WIDTH */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_HEIGHT */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_DEPTH */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_SIZE */
/* reuse GL_PACK_COMPRESSED_BLOCK_WIDTH */
/* reuse GL_PACK_COMPRESSED_BLOCK_HEIGHT */
/* reuse GL_PACK_COMPRESSED_BLOCK_DEPTH */
/* reuse GL_PACK_COMPRESSED_BLOCK_SIZE */
/* Reuse tokens from ARB_conservative_depth (none) */
/* Reuse tokens from ARB_internalformat_query */
/* reuse GL_NUM_SAMPLE_COUNTS */
/* Reuse tokens from ARB_map_buffer_alignment */
/* reuse GL_MIN_MAP_BUFFER_ALIGNMENT */
/* Reuse tokens from ARB_shader_atomic_counters */
/* reuse GL_ATOMIC_COUNTER_BUFFER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_BINDING */
/* reuse GL_ATOMIC_COUNTER_BUFFER_START */
/* reuse GL_ATOMIC_COUNTER_BUFFER_SIZE */
/* reuse GL_ATOMIC_COUNTER_BUFFER_DATA_SIZE */
/* reuse GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS */
/* reuse GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER */
/* reuse GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_VERTEX_ATOMIC_COUNTERS */
/* reuse GL_MAX_TESS_CONTROL_ATOMIC_COUNTERS */
/* reuse GL_MAX_TESS_EVALUATION_ATOMIC_COUNTERS */
/* reuse GL_MAX_GEOMETRY_ATOMIC_COUNTERS */
/* reuse GL_MAX_FRAGMENT_ATOMIC_COUNTERS */
/* reuse GL_MAX_COMBINED_ATOMIC_COUNTERS */
/* reuse GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE */
/* reuse GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS */
/* reuse GL_ACTIVE_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX */
/* reuse GL_UNSIGNED_INT_ATOMIC_COUNTER */
/* Reuse tokens from ARB_shader_image_load_store */
/* reuse GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT */
/* reuse GL_ELEMENT_ARRAY_BARRIER_BIT */
/* reuse GL_UNIFORM_BARRIER_BIT */
/* reuse GL_TEXTURE_FETCH_BARRIER_BIT */
/* reuse GL_SHADER_IMAGE_ACCESS_BARRIER_BIT */
/* reuse GL_COMMAND_BARRIER_BIT */
/* reuse GL_PIXEL_BUFFER_BARRIER_BIT */
/* reuse GL_TEXTURE_UPDATE_BARRIER_BIT */
/* reuse GL_BUFFER_UPDATE_BARRIER_BIT */
/* reuse GL_FRAMEBUFFER_BARRIER_BIT */
/* reuse GL_TRANSFORM_FEEDBACK_BARRIER_BIT */
/* reuse GL_ATOMIC_COUNTER_BARRIER_BIT */
/* reuse GL_ALL_BARRIER_BITS */
/* reuse GL_MAX_IMAGE_UNITS */
/* reuse GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS */
/* reuse GL_IMAGE_BINDING_NAME */
/* reuse GL_IMAGE_BINDING_LEVEL */
/* reuse GL_IMAGE_BINDING_LAYERED */
/* reuse GL_IMAGE_BINDING_LAYER */
/* reuse GL_IMAGE_BINDING_ACCESS */
/* reuse GL_IMAGE_1D */
/* reuse GL_IMAGE_2D */
/* reuse GL_IMAGE_3D */
/* reuse GL_IMAGE_2D_RECT */
/* reuse GL_IMAGE_CUBE */
/* reuse GL_IMAGE_BUFFER */
/* reuse GL_IMAGE_1D_ARRAY */
/* reuse GL_IMAGE_2D_ARRAY */
/* reuse GL_IMAGE_CUBE_MAP_ARRAY */
/* reuse GL_IMAGE_2D_MULTISAMPLE */
/* reuse GL_IMAGE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_INT_IMAGE_1D */
/* reuse GL_INT_IMAGE_2D */
/* reuse GL_INT_IMAGE_3D */
/* reuse GL_INT_IMAGE_2D_RECT */
/* reuse GL_INT_IMAGE_CUBE */
/* reuse GL_INT_IMAGE_BUFFER */
/* reuse GL_INT_IMAGE_1D_ARRAY */
/* reuse GL_INT_IMAGE_2D_ARRAY */
/* reuse GL_INT_IMAGE_CUBE_MAP_ARRAY */
/* reuse GL_INT_IMAGE_2D_MULTISAMPLE */
/* reuse GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_1D */
/* reuse GL_UNSIGNED_INT_IMAGE_2D */
/* reuse GL_UNSIGNED_INT_IMAGE_3D */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_RECT */
/* reuse GL_UNSIGNED_INT_IMAGE_CUBE */
/* reuse GL_UNSIGNED_INT_IMAGE_BUFFER */
/* reuse GL_UNSIGNED_INT_IMAGE_1D_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_MAX_IMAGE_SAMPLES */
/* reuse GL_IMAGE_BINDING_FORMAT */
/* reuse GL_IMAGE_FORMAT_COMPATIBILITY_TYPE */
/* reuse GL_IMAGE_FORMAT_COMPATIBILITY_BY_SIZE */
/* reuse GL_IMAGE_FORMAT_COMPATIBILITY_BY_CLASS */
/* reuse GL_MAX_VERTEX_IMAGE_UNIFORMS */
/* reuse GL_MAX_TESS_CONTROL_IMAGE_UNIFORMS */
/* reuse GL_MAX_TESS_EVALUATION_IMAGE_UNIFORMS */
/* reuse GL_MAX_GEOMETRY_IMAGE_UNIFORMS */
/* reuse GL_MAX_FRAGMENT_IMAGE_UNIFORMS */
/* reuse GL_MAX_COMBINED_IMAGE_UNIFORMS */
/* Reuse tokens from ARB_shading_language_packing (none) */
/* Reuse tokens from ARB_texture_storage */
/* reuse GL_TEXTURE_IMMUTABLE_FORMAT */
/* #endif */

/* #ifndef GL_ARB_depth_buffer_float */
  GL_DEPTH_COMPONENT32F             = 0x8CAC,
  GL_DEPTH32F_STENCIL8              = 0x8CAD,
  GL_FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAD,
/* #endif */

/* #ifndef GL_ARB_framebuffer_object */
  GL_INVALID_FRAMEBUFFER_OPERATION  = 0x0506,
  GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210,
  GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211,
  GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212,
  GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213,
  GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214,
  GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215,
  GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216,
  GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217,
  GL_FRAMEBUFFER_DEFAULT            = 0x8218,
  GL_FRAMEBUFFER_UNDEFINED          = 0x8219,
  GL_DEPTH_STENCIL_ATTACHMENT       = 0x821A,
  GL_MAX_RENDERBUFFER_SIZE          = 0x84E8,
  GL_DEPTH_STENCIL                  = 0x84F9,
  GL_UNSIGNED_INT_24_8              = 0x84FA,
  GL_DEPTH24_STENCIL8               = 0x88F0,
  GL_TEXTURE_STENCIL_SIZE           = 0x88F1,
  GL_TEXTURE_RED_TYPE               = 0x8C10,
  GL_TEXTURE_GREEN_TYPE             = 0x8C11,
  GL_TEXTURE_BLUE_TYPE              = 0x8C12,
  GL_TEXTURE_ALPHA_TYPE             = 0x8C13,
  GL_TEXTURE_DEPTH_TYPE             = 0x8C16,
  GL_UNSIGNED_NORMALIZED            = 0x8C17,
  GL_FRAMEBUFFER_BINDING            = 0x8CA6,
  GL_DRAW_FRAMEBUFFER_BINDING       = GL_FRAMEBUFFER_BINDING,
  GL_RENDERBUFFER_BINDING           = 0x8CA7,
  GL_READ_FRAMEBUFFER               = 0x8CA8,
  GL_DRAW_FRAMEBUFFER               = 0x8CA9,
  GL_READ_FRAMEBUFFER_BINDING       = 0x8CAA,
  GL_RENDERBUFFER_SAMPLES           = 0x8CAB,
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0,
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1,
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2,
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3,
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4,
  GL_FRAMEBUFFER_COMPLETE           = 0x8CD5,
  GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6,
  GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7,
  GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = 0x8CDB,
  GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER = 0x8CDC,
  GL_FRAMEBUFFER_UNSUPPORTED        = 0x8CDD,
  GL_MAX_COLOR_ATTACHMENTS          = 0x8CDF,
  GL_COLOR_ATTACHMENT0              = 0x8CE0,
  GL_COLOR_ATTACHMENT1              = 0x8CE1,
  GL_COLOR_ATTACHMENT2              = 0x8CE2,
  GL_COLOR_ATTACHMENT3              = 0x8CE3,
  GL_COLOR_ATTACHMENT4              = 0x8CE4,
  GL_COLOR_ATTACHMENT5              = 0x8CE5,
  GL_COLOR_ATTACHMENT6              = 0x8CE6,
  GL_COLOR_ATTACHMENT7              = 0x8CE7,
  GL_COLOR_ATTACHMENT8              = 0x8CE8,
  GL_COLOR_ATTACHMENT9              = 0x8CE9,
  GL_COLOR_ATTACHMENT10             = 0x8CEA,
  GL_COLOR_ATTACHMENT11             = 0x8CEB,
  GL_COLOR_ATTACHMENT12             = 0x8CEC,
  GL_COLOR_ATTACHMENT13             = 0x8CED,
  GL_COLOR_ATTACHMENT14             = 0x8CEE,
  GL_COLOR_ATTACHMENT15             = 0x8CEF,
  GL_DEPTH_ATTACHMENT               = 0x8D00,
  GL_STENCIL_ATTACHMENT             = 0x8D20,
  GL_FRAMEBUFFER                    = 0x8D40,
  GL_RENDERBUFFER                   = 0x8D41,
  GL_RENDERBUFFER_WIDTH             = 0x8D42,
  GL_RENDERBUFFER_HEIGHT            = 0x8D43,
  GL_RENDERBUFFER_INTERNAL_FORMAT   = 0x8D44,
  GL_STENCIL_INDEX1                 = 0x8D46,
  GL_STENCIL_INDEX4                 = 0x8D47,
  GL_STENCIL_INDEX8                 = 0x8D48,
  GL_STENCIL_INDEX16                = 0x8D49,
  GL_RENDERBUFFER_RED_SIZE          = 0x8D50,
  GL_RENDERBUFFER_GREEN_SIZE        = 0x8D51,
  GL_RENDERBUFFER_BLUE_SIZE         = 0x8D52,
  GL_RENDERBUFFER_ALPHA_SIZE        = 0x8D53,
  GL_RENDERBUFFER_DEPTH_SIZE        = 0x8D54,
  GL_RENDERBUFFER_STENCIL_SIZE      = 0x8D55,
  GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56,
  GL_MAX_SAMPLES                    = 0x8D57,
/* #endif */

/* #ifndef GL_ARB_framebuffer_sRGB */
  GL_FRAMEBUFFER_SRGB               = 0x8DB9,
/* #endif */

/* #ifndef GL_ARB_half_float_vertex */
  GL_HALF_FLOAT                     = 0x140B,
/* #endif */

/* #ifndef GL_ARB_map_buffer_range */
  GL_MAP_READ_BIT                   = 0x0001,
  GL_MAP_WRITE_BIT                  = 0x0002,
  GL_MAP_INVALIDATE_RANGE_BIT       = 0x0004,
  GL_MAP_INVALIDATE_BUFFER_BIT      = 0x0008,
  GL_MAP_FLUSH_EXPLICIT_BIT         = 0x0010,
  GL_MAP_UNSYNCHRONIZED_BIT         = 0x0020,
/* #endif */

/* #ifndef GL_ARB_texture_compression_rgtc */
  GL_COMPRESSED_RED_RGTC1           = 0x8DBB,
  GL_COMPRESSED_SIGNED_RED_RGTC1    = 0x8DBC,
  GL_COMPRESSED_RG_RGTC2            = 0x8DBD,
  GL_COMPRESSED_SIGNED_RG_RGTC2     = 0x8DBE,
/* #endif */

/* #ifndef GL_ARB_texture_rg */
  GL_RG                             = 0x8227,
  GL_RG_INTEGER                     = 0x8228,
  GL_R8                             = 0x8229,
  GL_R16                            = 0x822A,
  GL_RG8                            = 0x822B,
  GL_RG16                           = 0x822C,
  GL_R16F                           = 0x822D,
  GL_R32F                           = 0x822E,
  GL_RG16F                          = 0x822F,
  GL_RG32F                          = 0x8230,
  GL_R8I                            = 0x8231,
  GL_R8UI                           = 0x8232,
  GL_R16I                           = 0x8233,
  GL_R16UI                          = 0x8234,
  GL_R32I                           = 0x8235,
  GL_R32UI                          = 0x8236,
  GL_RG8I                           = 0x8237,
  GL_RG8UI                          = 0x8238,
  GL_RG16I                          = 0x8239,
  GL_RG16UI                         = 0x823A,
  GL_RG32I                          = 0x823B,
  GL_RG32UI                         = 0x823C,
/* #endif */

/* #ifndef GL_ARB_vertex_array_object */
  GL_VERTEX_ARRAY_BINDING           = 0x85B5,
/* #endif */

/* #ifndef GL_ARB_uniform_buffer_object */
  GL_UNIFORM_BUFFER                 = 0x8A11,
  GL_UNIFORM_BUFFER_BINDING         = 0x8A28,
  GL_UNIFORM_BUFFER_START           = 0x8A29,
  GL_UNIFORM_BUFFER_SIZE            = 0x8A2A,
  GL_MAX_VERTEX_UNIFORM_BLOCKS      = 0x8A2B,
  GL_MAX_GEOMETRY_UNIFORM_BLOCKS    = 0x8A2C,
  GL_MAX_FRAGMENT_UNIFORM_BLOCKS    = 0x8A2D,
  GL_MAX_COMBINED_UNIFORM_BLOCKS    = 0x8A2E,
  GL_MAX_UNIFORM_BUFFER_BINDINGS    = 0x8A2F,
  GL_MAX_UNIFORM_BLOCK_SIZE         = 0x8A30,
  GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31,
  GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = 0x8A32,
  GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33,
  GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34,
  GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 0x8A35,
  GL_ACTIVE_UNIFORM_BLOCKS          = 0x8A36,
  GL_UNIFORM_TYPE                   = 0x8A37,
  GL_UNIFORM_SIZE                   = 0x8A38,
  GL_UNIFORM_NAME_LENGTH            = 0x8A39,
  GL_UNIFORM_BLOCK_INDEX            = 0x8A3A,
  GL_UNIFORM_OFFSET                 = 0x8A3B,
  GL_UNIFORM_ARRAY_STRIDE           = 0x8A3C,
  GL_UNIFORM_MATRIX_STRIDE          = 0x8A3D,
  GL_UNIFORM_IS_ROW_MAJOR           = 0x8A3E,
  GL_UNIFORM_BLOCK_BINDING          = 0x8A3F,
  GL_UNIFORM_BLOCK_DATA_SIZE        = 0x8A40,
  GL_UNIFORM_BLOCK_NAME_LENGTH      = 0x8A41,
  GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS  = 0x8A42,
  GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43,
  GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44,
  GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = 0x8A45,
  GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46,
  GL_INVALID_INDEX                  = 0xFFFFFFFFu,
/* #endif */

/* #ifndef GL_ARB_copy_buffer */
  GL_COPY_READ_BUFFER               = 0x8F36,
  GL_COPY_WRITE_BUFFER              = 0x8F37,
/* #endif */

/* #ifndef GL_ARB_depth_clamp */
  GL_DEPTH_CLAMP                    = 0x864F,
/* #endif */

/* #ifndef GL_ARB_draw_elements_base_vertex */
/* #endif */

/* #ifndef GL_ARB_fragment_coord_conventions */
/* #endif */

/* #ifndef GL_ARB_provoking_vertex */
  GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = 0x8E4C,
  GL_FIRST_VERTEX_CONVENTION        = 0x8E4D,
  GL_LAST_VERTEX_CONVENTION         = 0x8E4E,
  GL_PROVOKING_VERTEX               = 0x8E4F,
/* #endif */

/* #ifndef GL_ARB_seamless_cube_map */
  GL_TEXTURE_CUBE_MAP_SEAMLESS      = 0x884F,
/* #endif */

/* #ifndef GL_ARB_sync */
  GL_MAX_SERVER_WAIT_TIMEOUT        = 0x9111,
  GL_OBJECT_TYPE                    = 0x9112,
  GL_SYNC_CONDITION                 = 0x9113,
  GL_SYNC_STATUS                    = 0x9114,
  GL_SYNC_FLAGS                     = 0x9115,
  GL_SYNC_FENCE                     = 0x9116,
  GL_SYNC_GPU_COMMANDS_COMPLETE     = 0x9117,
  GL_UNSIGNALED                     = 0x9118,
  GL_SIGNALED                       = 0x9119,
  GL_ALREADY_SIGNALED               = 0x911A,
  GL_TIMEOUT_EXPIRED                = 0x911B,
  GL_CONDITION_SATISFIED            = 0x911C,
  GL_WAIT_FAILED                    = 0x911D,
  GL_SYNC_FLUSH_COMMANDS_BIT        = 0x00000001,
  GL_TIMEOUT_IGNORED                = 0xFFFFFFFFFFFFFFFFull,
/* #endif */

/* #ifndef GL_ARB_texture_multisample */
  GL_SAMPLE_POSITION                = 0x8E50,
  GL_SAMPLE_MASK                    = 0x8E51,
  GL_SAMPLE_MASK_VALUE              = 0x8E52,
  GL_MAX_SAMPLE_MASK_WORDS          = 0x8E59,
  GL_TEXTURE_2D_MULTISAMPLE         = 0x9100,
  GL_PROXY_TEXTURE_2D_MULTISAMPLE   = 0x9101,
  GL_TEXTURE_2D_MULTISAMPLE_ARRAY   = 0x9102,
  GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9103,
  GL_TEXTURE_BINDING_2D_MULTISAMPLE = 0x9104,
  GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = 0x9105,
  GL_TEXTURE_SAMPLES                = 0x9106,
  GL_TEXTURE_FIXED_SAMPLE_LOCATIONS = 0x9107,
  GL_SAMPLER_2D_MULTISAMPLE         = 0x9108,
  GL_INT_SAMPLER_2D_MULTISAMPLE     = 0x9109,
  GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = 0x910A,
  GL_SAMPLER_2D_MULTISAMPLE_ARRAY   = 0x910B,
  GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910C,
  GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910D,
  GL_MAX_COLOR_TEXTURE_SAMPLES      = 0x910E,
  GL_MAX_DEPTH_TEXTURE_SAMPLES      = 0x910F,
  GL_MAX_INTEGER_SAMPLES            = 0x9110,
/* #endif */

/* #ifndef GL_ARB_vertex_array_bgra */
/* reuse GL_BGRA */
/* #endif */

/* #ifndef GL_ARB_draw_buffers_blend */
/* #endif */

/* #ifndef GL_ARB_sample_shading */
  GL_SAMPLE_SHADING_ARB             = 0x8C36,
  GL_MIN_SAMPLE_SHADING_VALUE_ARB   = 0x8C37,
/* #endif */

/* #ifndef GL_ARB_texture_cube_map_array */
  GL_TEXTURE_CUBE_MAP_ARRAY_ARB     = 0x9009,
  GL_TEXTURE_BINDING_CUBE_MAP_ARRAY_ARB = 0x900A,
  GL_PROXY_TEXTURE_CUBE_MAP_ARRAY_ARB = 0x900B,
  GL_SAMPLER_CUBE_MAP_ARRAY_ARB     = 0x900C,
  GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW_ARB = 0x900D,
  GL_INT_SAMPLER_CUBE_MAP_ARRAY_ARB = 0x900E,
  GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY_ARB = 0x900F,
/* #endif */

/* #ifndef GL_ARB_texture_gather */
  GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET_ARB = 0x8E5E,
  GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET_ARB = 0x8E5F,
/* #endif */

/* #ifndef GL_ARB_texture_query_lod */
/* #endif */

/* #ifndef GL_ARB_shading_language_include */
  GL_SHADER_INCLUDE_ARB             = 0x8DAE,
  GL_NAMED_STRING_LENGTH_ARB        = 0x8DE9,
  GL_NAMED_STRING_TYPE_ARB          = 0x8DEA,
/* #endif */

/* #ifndef GL_ARB_texture_compression_bptc */
  GL_COMPRESSED_RGBA_BPTC_UNORM_ARB = 0x8E8C,
  GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM_ARB = 0x8E8D,
  GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT_ARB = 0x8E8E,
  GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_ARB = 0x8E8F,
/* #endif */

/* #ifndef GL_ARB_blend_func_extended */
  GL_SRC1_COLOR                     = 0x88F9,
/* reuse GL_SRC1_ALPHA */
  GL_ONE_MINUS_SRC1_COLOR           = 0x88FA,
  GL_ONE_MINUS_SRC1_ALPHA           = 0x88FB,
  GL_MAX_DUAL_SOURCE_DRAW_BUFFERS   = 0x88FC,
/* #endif */

/* #ifndef GL_ARB_explicit_attrib_location */
/* #endif */

/* #ifndef GL_ARB_occlusion_query2 */
  GL_ANY_SAMPLES_PASSED             = 0x8C2F,
/* #endif */

/* #ifndef GL_ARB_sampler_objects */
  GL_SAMPLER_BINDING                = 0x8919,
/* #endif */

/* #ifndef GL_ARB_shader_bit_encoding */
/* #endif */

/* #ifndef GL_ARB_texture_rgb10_a2ui */
  GL_RGB10_A2UI                     = 0x906F,
/* #endif */

/* #ifndef GL_ARB_texture_swizzle */
  GL_TEXTURE_SWIZZLE_R              = 0x8E42,
  GL_TEXTURE_SWIZZLE_G              = 0x8E43,
  GL_TEXTURE_SWIZZLE_B              = 0x8E44,
  GL_TEXTURE_SWIZZLE_A              = 0x8E45,
  GL_TEXTURE_SWIZZLE_RGBA           = 0x8E46,
/* #endif */

/* #ifndef GL_ARB_timer_query */
  GL_TIME_ELAPSED                   = 0x88BF,
  GL_TIMESTAMP                      = 0x8E28,
/* #endif */

/* #ifndef GL_ARB_vertex_type_2_10_10_10_rev */
/* reuse GL_UNSIGNED_INT_2_10_10_10_REV */
  GL_INT_2_10_10_10_REV             = 0x8D9F,
/* #endif */

/* #ifndef GL_ARB_draw_indirect */
  GL_DRAW_INDIRECT_BUFFER           = 0x8F3F,
  GL_DRAW_INDIRECT_BUFFER_BINDING   = 0x8F43,
/* #endif */

/* #ifndef GL_ARB_gpu_shader5 */
  GL_GEOMETRY_SHADER_INVOCATIONS    = 0x887F,
  GL_MAX_GEOMETRY_SHADER_INVOCATIONS = 0x8E5A,
  GL_MIN_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5B,
  GL_MAX_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5C,
  GL_FRAGMENT_INTERPOLATION_OFFSET_BITS = 0x8E5D,
/* reuse GL_MAX_VERTEX_STREAMS */
/* #endif */

/* #ifndef GL_ARB_gpu_shader_fp64 */
/* reuse GL_DOUBLE */
  GL_DOUBLE_VEC2                    = 0x8FFC,
  GL_DOUBLE_VEC3                    = 0x8FFD,
  GL_DOUBLE_VEC4                    = 0x8FFE,
  GL_DOUBLE_MAT2                    = 0x8F46,
  GL_DOUBLE_MAT3                    = 0x8F47,
  GL_DOUBLE_MAT4                    = 0x8F48,
  GL_DOUBLE_MAT2x3                  = 0x8F49,
  GL_DOUBLE_MAT2x4                  = 0x8F4A,
  GL_DOUBLE_MAT3x2                  = 0x8F4B,
  GL_DOUBLE_MAT3x4                  = 0x8F4C,
  GL_DOUBLE_MAT4x2                  = 0x8F4D,
  GL_DOUBLE_MAT4x3                  = 0x8F4E,
/* #endif */

/* #ifndef GL_ARB_shader_subroutine */
  GL_ACTIVE_SUBROUTINES             = 0x8DE5,
  GL_ACTIVE_SUBROUTINE_UNIFORMS     = 0x8DE6,
  GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS = 0x8E47,
  GL_ACTIVE_SUBROUTINE_MAX_LENGTH   = 0x8E48,
  GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH = 0x8E49,
  GL_MAX_SUBROUTINES                = 0x8DE7,
  GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS = 0x8DE8,
  GL_NUM_COMPATIBLE_SUBROUTINES     = 0x8E4A,
  GL_COMPATIBLE_SUBROUTINES         = 0x8E4B,
/* reuse GL_UNIFORM_SIZE */
/* reuse GL_UNIFORM_NAME_LENGTH */
/* #endif */

/* #ifndef GL_ARB_tessellation_shader */
  GL_PATCHES                        = 0x000E,
  GL_PATCH_VERTICES                 = 0x8E72,
  GL_PATCH_DEFAULT_INNER_LEVEL      = 0x8E73,
  GL_PATCH_DEFAULT_OUTER_LEVEL      = 0x8E74,
  GL_TESS_CONTROL_OUTPUT_VERTICES   = 0x8E75,
  GL_TESS_GEN_MODE                  = 0x8E76,
  GL_TESS_GEN_SPACING               = 0x8E77,
  GL_TESS_GEN_VERTEX_ORDER          = 0x8E78,
  GL_TESS_GEN_POINT_MODE            = 0x8E79,
/* reuse GL_TRIANGLES */
/* reuse GL_QUADS */
  GL_ISOLINES                       = 0x8E7A,
/* reuse GL_EQUAL */
  GL_FRACTIONAL_ODD                 = 0x8E7B,
  GL_FRACTIONAL_EVEN                = 0x8E7C,
/* reuse GL_CCW */
/* reuse GL_CW */
  GL_MAX_PATCH_VERTICES             = 0x8E7D,
  GL_MAX_TESS_GEN_LEVEL             = 0x8E7E,
  GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E7F,
  GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E80,
  GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS = 0x8E81,
  GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS = 0x8E82,
  GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS = 0x8E83,
  GL_MAX_TESS_PATCH_COMPONENTS      = 0x8E84,
  GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS = 0x8E85,
  GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS = 0x8E86,
  GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS = 0x8E89,
  GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS = 0x8E8A,
  GL_MAX_TESS_CONTROL_INPUT_COMPONENTS = 0x886C,
  GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS = 0x886D,
  GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E1E,
  GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E1F,
  GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER = 0x84F0,
  GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x84F1,
  GL_TESS_EVALUATION_SHADER         = 0x8E87,
  GL_TESS_CONTROL_SHADER            = 0x8E88,
/* #endif */

/* #ifndef GL_ARB_texture_buffer_object_rgb32 */
/* reuse GL_RGB32F */
/* reuse GL_RGB32UI */
/* reuse GL_RGB32I */
/* #endif */

/* #ifndef GL_ARB_transform_feedback2 */
  GL_TRANSFORM_FEEDBACK             = 0x8E22,
  GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED = 0x8E23,
  GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE = 0x8E24,
  GL_TRANSFORM_FEEDBACK_BINDING     = 0x8E25,
/* #endif */

/* #ifndef GL_ARB_transform_feedback3 */
  GL_MAX_TRANSFORM_FEEDBACK_BUFFERS = 0x8E70,
  GL_MAX_VERTEX_STREAMS             = 0x8E71,
/* #endif */

/* #ifndef GL_ARB_ES2_compatibility */
  GL_FIXED                          = 0x140C,
  GL_IMPLEMENTATION_COLOR_READ_TYPE = 0x8B9A,
  GL_IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B,
  GL_LOW_FLOAT                      = 0x8DF0,
  GL_MEDIUM_FLOAT                   = 0x8DF1,
  GL_HIGH_FLOAT                     = 0x8DF2,
  GL_LOW_INT                        = 0x8DF3,
  GL_MEDIUM_INT                     = 0x8DF4,
  GL_HIGH_INT                       = 0x8DF5,
  GL_SHADER_COMPILER                = 0x8DFA,
  GL_NUM_SHADER_BINARY_FORMATS      = 0x8DF9,
  GL_MAX_VERTEX_UNIFORM_VECTORS     = 0x8DFB,
  GL_MAX_VARYING_VECTORS            = 0x8DFC,
  GL_MAX_FRAGMENT_UNIFORM_VECTORS   = 0x8DFD,
/* #endif */

/* #ifndef GL_ARB_get_program_binary */
  GL_PROGRAM_BINARY_RETRIEVABLE_HINT = 0x8257,
  GL_PROGRAM_BINARY_LENGTH          = 0x8741,
  GL_NUM_PROGRAM_BINARY_FORMATS     = 0x87FE,
  GL_PROGRAM_BINARY_FORMATS         = 0x87FF,
/* #endif */

/* #ifndef GL_ARB_separate_shader_objects */
  GL_VERTEX_SHADER_BIT              = 0x00000001,
  GL_FRAGMENT_SHADER_BIT            = 0x00000002,
  GL_GEOMETRY_SHADER_BIT            = 0x00000004,
  GL_TESS_CONTROL_SHADER_BIT        = 0x00000008,
  GL_TESS_EVALUATION_SHADER_BIT     = 0x00000010,
  GL_ALL_SHADER_BITS                = 0xFFFFFFFF,
  GL_PROGRAM_SEPARABLE              = 0x8258,
  GL_ACTIVE_PROGRAM                 = 0x8259,
  GL_PROGRAM_PIPELINE_BINDING       = 0x825A,
/* #endif */

/* #ifndef GL_ARB_shader_precision */
/* #endif */

/* #ifndef GL_ARB_vertex_attrib_64bit */
/* reuse GL_RGB32I */
/* reuse GL_DOUBLE_VEC2 */
/* reuse GL_DOUBLE_VEC3 */
/* reuse GL_DOUBLE_VEC4 */
/* reuse GL_DOUBLE_MAT2 */
/* reuse GL_DOUBLE_MAT3 */
/* reuse GL_DOUBLE_MAT4 */
/* reuse GL_DOUBLE_MAT2x3 */
/* reuse GL_DOUBLE_MAT2x4 */
/* reuse GL_DOUBLE_MAT3x2 */
/* reuse GL_DOUBLE_MAT3x4 */
/* reuse GL_DOUBLE_MAT4x2 */
/* reuse GL_DOUBLE_MAT4x3 */
/* #endif */

/* #ifndef GL_ARB_viewport_array */
/* reuse GL_SCISSOR_BOX */
/* reuse GL_VIEWPORT */
/* reuse GL_DEPTH_RANGE */
/* reuse GL_SCISSOR_TEST */
  GL_MAX_VIEWPORTS                  = 0x825B,
  GL_VIEWPORT_SUBPIXEL_BITS         = 0x825C,
  GL_VIEWPORT_BOUNDS_RANGE          = 0x825D,
  GL_LAYER_PROVOKING_VERTEX         = 0x825E,
  GL_VIEWPORT_INDEX_PROVOKING_VERTEX = 0x825F,
  GL_UNDEFINED_VERTEX               = 0x8260,
/* reuse GL_FIRST_VERTEX_CONVENTION */
/* reuse GL_LAST_VERTEX_CONVENTION */
/* reuse GL_PROVOKING_VERTEX */
/* #endif */

/* #ifndef GL_ARB_cl_event */
  GL_SYNC_CL_EVENT_ARB              = 0x8240,
  GL_SYNC_CL_EVENT_COMPLETE_ARB     = 0x8241,
/* #endif */

/* #ifndef GL_ARB_debug_output */
  GL_DEBUG_OUTPUT_SYNCHRONOUS_ARB   = 0x8242,
  GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH_ARB = 0x8243,
  GL_DEBUG_CALLBACK_FUNCTION_ARB    = 0x8244,
  GL_DEBUG_CALLBACK_USER_PARAM_ARB  = 0x8245,
  GL_DEBUG_SOURCE_API_ARB           = 0x8246,
  GL_DEBUG_SOURCE_WINDOW_SYSTEM_ARB = 0x8247,
  GL_DEBUG_SOURCE_SHADER_COMPILER_ARB = 0x8248,
  GL_DEBUG_SOURCE_THIRD_PARTY_ARB   = 0x8249,
  GL_DEBUG_SOURCE_APPLICATION_ARB   = 0x824A,
  GL_DEBUG_SOURCE_OTHER_ARB         = 0x824B,
  GL_DEBUG_TYPE_ERROR_ARB           = 0x824C,
  GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR_ARB = 0x824D,
  GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR_ARB = 0x824E,
  GL_DEBUG_TYPE_PORTABILITY_ARB     = 0x824F,
  GL_DEBUG_TYPE_PERFORMANCE_ARB     = 0x8250,
  GL_DEBUG_TYPE_OTHER_ARB           = 0x8251,
  GL_MAX_DEBUG_MESSAGE_LENGTH_ARB   = 0x9143,
  GL_MAX_DEBUG_LOGGED_MESSAGES_ARB  = 0x9144,
  GL_DEBUG_LOGGED_MESSAGES_ARB      = 0x9145,
  GL_DEBUG_SEVERITY_HIGH_ARB        = 0x9146,
  GL_DEBUG_SEVERITY_MEDIUM_ARB      = 0x9147,
  GL_DEBUG_SEVERITY_LOW_ARB         = 0x9148,
/* #endif */

/* #ifndef GL_ARB_robustness */
/* reuse GL_NO_ERROR */
  GL_CONTEXT_FLAG_ROBUST_ACCESS_BIT_ARB = 0x00000004,
  GL_LOSE_CONTEXT_ON_RESET_ARB      = 0x8252,
  GL_GUILTY_CONTEXT_RESET_ARB       = 0x8253,
  GL_INNOCENT_CONTEXT_RESET_ARB     = 0x8254,
  GL_UNKNOWN_CONTEXT_RESET_ARB      = 0x8255,
  GL_RESET_NOTIFICATION_STRATEGY_ARB = 0x8256,
  GL_NO_RESET_NOTIFICATION_ARB      = 0x8261,
/* #endif */

/* #ifndef GL_ARB_shader_stencil_export */
/* #endif */

/* #ifndef GL_ARB_base_instance */
/* #endif */

/* #ifndef GL_ARB_shading_language_420pack */
/* #endif */

/* #ifndef GL_ARB_transform_feedback_instanced */
/* #endif */

/* #ifndef GL_ARB_compressed_texture_pixel_storage */
  GL_UNPACK_COMPRESSED_BLOCK_WIDTH  = 0x9127,
  GL_UNPACK_COMPRESSED_BLOCK_HEIGHT = 0x9128,
  GL_UNPACK_COMPRESSED_BLOCK_DEPTH  = 0x9129,
  GL_UNPACK_COMPRESSED_BLOCK_SIZE   = 0x912A,
  GL_PACK_COMPRESSED_BLOCK_WIDTH    = 0x912B,
  GL_PACK_COMPRESSED_BLOCK_HEIGHT   = 0x912C,
  GL_PACK_COMPRESSED_BLOCK_DEPTH    = 0x912D,
  GL_PACK_COMPRESSED_BLOCK_SIZE     = 0x912E,
/* #endif */

/* #ifndef GL_ARB_conservative_depth */
/* #endif */

/* #ifndef GL_ARB_internalformat_query */
  GL_NUM_SAMPLE_COUNTS              = 0x9380,
/* #endif */

/* #ifndef GL_ARB_map_buffer_alignment */
  GL_MIN_MAP_BUFFER_ALIGNMENT       = 0x90BC,
/* #endif */

/* #ifndef GL_ARB_shader_atomic_counters */
  GL_ATOMIC_COUNTER_BUFFER          = 0x92C0,
  GL_ATOMIC_COUNTER_BUFFER_BINDING  = 0x92C1,
  GL_ATOMIC_COUNTER_BUFFER_START    = 0x92C2,
  GL_ATOMIC_COUNTER_BUFFER_SIZE     = 0x92C3,
  GL_ATOMIC_COUNTER_BUFFER_DATA_SIZE = 0x92C4,
  GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS = 0x92C5,
  GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES = 0x92C6,
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER = 0x92C7,
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER = 0x92C8,
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x92C9,
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER = 0x92CA,
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER = 0x92CB,
  GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS = 0x92CC,
  GL_MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS = 0x92CD,
  GL_MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS = 0x92CE,
  GL_MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS = 0x92CF,
  GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS = 0x92D0,
  GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS = 0x92D1,
  GL_MAX_VERTEX_ATOMIC_COUNTERS     = 0x92D2,
  GL_MAX_TESS_CONTROL_ATOMIC_COUNTERS = 0x92D3,
  GL_MAX_TESS_EVALUATION_ATOMIC_COUNTERS = 0x92D4,
  GL_MAX_GEOMETRY_ATOMIC_COUNTERS   = 0x92D5,
  GL_MAX_FRAGMENT_ATOMIC_COUNTERS   = 0x92D6,
  GL_MAX_COMBINED_ATOMIC_COUNTERS   = 0x92D7,
  GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE = 0x92D8,
  GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS = 0x92DC,
  GL_ACTIVE_ATOMIC_COUNTER_BUFFERS  = 0x92D9,
  GL_UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX = 0x92DA,
  GL_UNSIGNED_INT_ATOMIC_COUNTER    = 0x92DB,
/* #endif */

/* #ifndef GL_ARB_shader_image_load_store */
  GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT = 0x00000001,
  GL_ELEMENT_ARRAY_BARRIER_BIT      = 0x00000002,
  GL_UNIFORM_BARRIER_BIT            = 0x00000004,
  GL_TEXTURE_FETCH_BARRIER_BIT      = 0x00000008,
  GL_SHADER_IMAGE_ACCESS_BARRIER_BIT = 0x00000020,
  GL_COMMAND_BARRIER_BIT            = 0x00000040,
  GL_PIXEL_BUFFER_BARRIER_BIT       = 0x00000080,
  GL_TEXTURE_UPDATE_BARRIER_BIT     = 0x00000100,
  GL_BUFFER_UPDATE_BARRIER_BIT      = 0x00000200,
  GL_FRAMEBUFFER_BARRIER_BIT        = 0x00000400,
  GL_TRANSFORM_FEEDBACK_BARRIER_BIT = 0x00000800,
  GL_ATOMIC_COUNTER_BARRIER_BIT     = 0x00001000,
  GL_ALL_BARRIER_BITS               = 0xFFFFFFFF,
  GL_MAX_IMAGE_UNITS                = 0x8F38,
  GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS = 0x8F39,
  GL_IMAGE_BINDING_NAME             = 0x8F3A,
  GL_IMAGE_BINDING_LEVEL            = 0x8F3B,
  GL_IMAGE_BINDING_LAYERED          = 0x8F3C,
  GL_IMAGE_BINDING_LAYER            = 0x8F3D,
  GL_IMAGE_BINDING_ACCESS           = 0x8F3E,
  GL_IMAGE_1D                       = 0x904C,
  GL_IMAGE_2D                       = 0x904D,
  GL_IMAGE_3D                       = 0x904E,
  GL_IMAGE_2D_RECT                  = 0x904F,
  GL_IMAGE_CUBE                     = 0x9050,
  GL_IMAGE_BUFFER                   = 0x9051,
  GL_IMAGE_1D_ARRAY                 = 0x9052,
  GL_IMAGE_2D_ARRAY                 = 0x9053,
  GL_IMAGE_CUBE_MAP_ARRAY           = 0x9054,
  GL_IMAGE_2D_MULTISAMPLE           = 0x9055,
  GL_IMAGE_2D_MULTISAMPLE_ARRAY     = 0x9056,
  GL_INT_IMAGE_1D                   = 0x9057,
  GL_INT_IMAGE_2D                   = 0x9058,
  GL_INT_IMAGE_3D                   = 0x9059,
  GL_INT_IMAGE_2D_RECT              = 0x905A,
  GL_INT_IMAGE_CUBE                 = 0x905B,
  GL_INT_IMAGE_BUFFER               = 0x905C,
  GL_INT_IMAGE_1D_ARRAY             = 0x905D,
  GL_INT_IMAGE_2D_ARRAY             = 0x905E,
  GL_INT_IMAGE_CUBE_MAP_ARRAY       = 0x905F,
  GL_INT_IMAGE_2D_MULTISAMPLE       = 0x9060,
  GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY = 0x9061,
  GL_UNSIGNED_INT_IMAGE_1D          = 0x9062,
  GL_UNSIGNED_INT_IMAGE_2D          = 0x9063,
  GL_UNSIGNED_INT_IMAGE_3D          = 0x9064,
  GL_UNSIGNED_INT_IMAGE_2D_RECT     = 0x9065,
  GL_UNSIGNED_INT_IMAGE_CUBE        = 0x9066,
  GL_UNSIGNED_INT_IMAGE_BUFFER      = 0x9067,
  GL_UNSIGNED_INT_IMAGE_1D_ARRAY    = 0x9068,
  GL_UNSIGNED_INT_IMAGE_2D_ARRAY    = 0x9069,
  GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY = 0x906A,
  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE = 0x906B,
  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY = 0x906C,
  GL_MAX_IMAGE_SAMPLES              = 0x906D,
  GL_IMAGE_BINDING_FORMAT           = 0x906E,
  GL_IMAGE_FORMAT_COMPATIBILITY_TYPE = 0x90C7,
  GL_IMAGE_FORMAT_COMPATIBILITY_BY_SIZE = 0x90C8,
  GL_IMAGE_FORMAT_COMPATIBILITY_BY_CLASS = 0x90C9,
  GL_MAX_VERTEX_IMAGE_UNIFORMS      = 0x90CA,
  GL_MAX_TESS_CONTROL_IMAGE_UNIFORMS = 0x90CB,
  GL_MAX_TESS_EVALUATION_IMAGE_UNIFORMS = 0x90CC,
  GL_MAX_GEOMETRY_IMAGE_UNIFORMS    = 0x90CD,
  GL_MAX_FRAGMENT_IMAGE_UNIFORMS    = 0x90CE,
  GL_MAX_COMBINED_IMAGE_UNIFORMS    = 0x90CF,
/* #endif */

/* #ifndef GL_ARB_shading_language_packing */
/* #endif */

/* #ifndef GL_ARB_texture_storage */
  GL_TEXTURE_IMMUTABLE_FORMAT       = 0x912F,
/* #endif */

} /* enum */
/*************************************************************/

/*
#include <stddef.h>
/* #ifndef GL_VERSION_2_0 */
/* GL type for program/shader text */
typedef char GLchar;
/* #endif */

/* #ifndef GL_VERSION_1_5 */
/* GL types for handling large vertex buffer objects */
typedef ptrdiff_t GLintptr;
typedef ptrdiff_t GLsizeiptr;
/* #endif */

/* #ifndef GL_ARB_vertex_buffer_object */
/* GL types for handling large vertex buffer objects */
typedef ptrdiff_t GLintptrARB;
typedef ptrdiff_t GLsizeiptrARB;
/* #endif */

/* #ifndef GL_ARB_shader_objects */
/* GL types for program/shader text and shader object handles */
typedef char GLcharARB;
typedef unsigned int GLhandleARB;
/* #endif */

/* GL type for "half" precision (s10e5) float data in host memory */
/* #ifndef GL_ARB_half_float_pixel */
typedef unsigned short GLhalfARB;
/* #endif */

/* #ifndef GL_NV_half_float */
typedef unsigned short GLhalfNV;
/* #endif */

/* #ifndef GL_EXT_timer_query */
typedef int64_t GLint64EXT;
typedef uint64_t GLuint64EXT;
/* #endif */

/* #ifndef GL_ARB_sync */
typedef int64_t GLint64;
typedef uint64_t GLuint64;
typedef struct __GLsync *GLsync;
/* #endif */

/* #ifndef GL_ARB_cl_event */
/* These incomplete types let us declare types compatible with OpenCL's cl_context and cl_event */
struct _cl_context;
struct _cl_event;
/* #endif */

/* #ifndef GL_ARB_debug_output */
typedef void (*GLDEBUGPROCARB)(GLenum source,GLenum type,GLuint id,GLenum severity,GLsizei length,const GLchar *message,GLvoid *userParam);
/* #endif */

/* #ifndef GL_AMD_debug_output */
typedef void (*GLDEBUGPROCAMD)(GLuint id,GLenum category,GLenum severity,GLsizei length,const GLchar *message,GLvoid *userParam);
/* #endif */

/* #ifndef GL_NV_vdpau_interop */
typedef GLintptr GLvdpauSurfaceNV;
/* #endif */

/* #ifndef GL_VERSION_1_0 */
enum { GL_VERSION_1_0 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glCullFace (GLenum mode);
void glFrontFace (GLenum mode);
void glHint (GLenum target, GLenum mode);
void glLineWidth (GLfloat width);
void glPointSize (GLfloat size);
void glPolygonMode (GLenum face, GLenum mode);
void glScissor (GLint x, GLint y, GLsizei width, GLsizei height);
void glTexParameterf (GLenum target, GLenum pname, GLfloat param);
void glTexParameterfv (GLenum target, GLenum pname, const GLfloat *params);
void glTexParameteri (GLenum target, GLenum pname, GLint param);
void glTexParameteriv (GLenum target, GLenum pname, const GLint *params);
void glTexImage1D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glDrawBuffer (GLenum mode);
void glClear (GLbitfield mask);
void glClearColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
void glClearStencil (GLint s);
void glClearDepth (GLclampd depth);
void glStencilMask (GLuint mask);
void glColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
void glDepthMask (GLboolean flag);
void glDisable (GLenum cap);
void glEnable (GLenum cap);
void glFinish (void);
void glFlush (void);
void glBlendFunc (GLenum sfactor, GLenum dfactor);
void glLogicOp (GLenum opcode);
void glStencilFunc (GLenum func, GLint ref, GLuint mask);
void glStencilOp (GLenum fail, GLenum zfail, GLenum zpass);
void glDepthFunc (GLenum func);
void glPixelStoref (GLenum pname, GLfloat param);
void glPixelStorei (GLenum pname, GLint param);
void glReadBuffer (GLenum mode);
void glReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
void glGetBooleanv (GLenum pname, GLboolean *params);
void glGetDoublev (GLenum pname, GLdouble *params);
GLenum glGetError (void);
void glGetFloatv (GLenum pname, GLfloat *params);
void glGetIntegerv (GLenum pname, GLint *params);
const GLubyte * glGetString (GLenum name);
void glGetTexImage (GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
void glGetTexParameterfv (GLenum target, GLenum pname, GLfloat *params);
void glGetTexParameteriv (GLenum target, GLenum pname, GLint *params);
void glGetTexLevelParameterfv (GLenum target, GLint level, GLenum pname, GLfloat *params);
void glGetTexLevelParameteriv (GLenum target, GLint level, GLenum pname, GLint *params);
GLboolean glIsEnabled (GLenum cap);
void glDepthRange (GLclampd near, GLclampd far);
void glViewport (GLint x, GLint y, GLsizei width, GLsizei height);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLCULLFACEPROC) (GLenum mode);
typedef void (PFNGLFRONTFACEPROC) (GLenum mode);
typedef void (PFNGLHINTPROC) (GLenum target, GLenum mode);
typedef void (PFNGLLINEWIDTHPROC) (GLfloat width);
typedef void (PFNGLPOINTSIZEPROC) (GLfloat size);
typedef void (PFNGLPOLYGONMODEPROC) (GLenum face, GLenum mode);
typedef void (PFNGLSCISSORPROC) (GLint x, GLint y, GLsizei width, GLsizei height);
typedef void (PFNGLTEXPARAMETERFPROC) (GLenum target, GLenum pname, GLfloat param);
typedef void (PFNGLTEXPARAMETERFVPROC) (GLenum target, GLenum pname, const GLfloat *params);
typedef void (PFNGLTEXPARAMETERIPROC) (GLenum target, GLenum pname, GLint param);
typedef void (PFNGLTEXPARAMETERIVPROC) (GLenum target, GLenum pname, const GLint *params);
typedef void (PFNGLTEXIMAGE1DPROC) (GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (PFNGLTEXIMAGE2DPROC) (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (PFNGLDRAWBUFFERPROC) (GLenum mode);
typedef void (PFNGLCLEARPROC) (GLbitfield mask);
typedef void (PFNGLCLEARCOLORPROC) (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
typedef void (PFNGLCLEARSTENCILPROC) (GLint s);
typedef void (PFNGLCLEARDEPTHPROC) (GLclampd depth);
typedef void (PFNGLSTENCILMASKPROC) (GLuint mask);
typedef void (PFNGLCOLORMASKPROC) (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
typedef void (PFNGLDEPTHMASKPROC) (GLboolean flag);
typedef void (PFNGLDISABLEPROC) (GLenum cap);
typedef void (PFNGLENABLEPROC) (GLenum cap);
typedef void (PFNGLFINISHPROC) (void);
typedef void (PFNGLFLUSHPROC) (void);
typedef void (PFNGLBLENDFUNCPROC) (GLenum sfactor, GLenum dfactor);
typedef void (PFNGLLOGICOPPROC) (GLenum opcode);
typedef void (PFNGLSTENCILFUNCPROC) (GLenum func, GLint ref, GLuint mask);
typedef void (PFNGLSTENCILOPPROC) (GLenum fail, GLenum zfail, GLenum zpass);
typedef void (PFNGLDEPTHFUNCPROC) (GLenum func);
typedef void (PFNGLPIXELSTOREFPROC) (GLenum pname, GLfloat param);
typedef void (PFNGLPIXELSTOREIPROC) (GLenum pname, GLint param);
typedef void (PFNGLREADBUFFERPROC) (GLenum mode);
typedef void (PFNGLREADPIXELSPROC) (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
typedef void (PFNGLGETBOOLEANVPROC) (GLenum pname, GLboolean *params);
typedef void (PFNGLGETDOUBLEVPROC) (GLenum pname, GLdouble *params);
typedef GLenum (PFNGLGETERRORPROC) (void);
typedef void (PFNGLGETFLOATVPROC) (GLenum pname, GLfloat *params);
typedef void (PFNGLGETINTEGERVPROC) (GLenum pname, GLint *params);
typedef const GLubyte * (PFNGLGETSTRINGPROC) (GLenum name);
typedef void (PFNGLGETTEXIMAGEPROC) (GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
typedef void (PFNGLGETTEXPARAMETERFVPROC) (GLenum target, GLenum pname, GLfloat *params);
typedef void (PFNGLGETTEXPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (PFNGLGETTEXLEVELPARAMETERFVPROC) (GLenum target, GLint level, GLenum pname, GLfloat *params);
typedef void (PFNGLGETTEXLEVELPARAMETERIVPROC) (GLenum target, GLint level, GLenum pname, GLint *params);
typedef GLboolean (PFNGLISENABLEDPROC) (GLenum cap);
typedef void (PFNGLDEPTHRANGEPROC) (GLclampd near, GLclampd far);
typedef void (PFNGLVIEWPORTPROC) (GLint x, GLint y, GLsizei width, GLsizei height);
/* #endif */

/* #ifndef GL_VERSION_1_1 */
enum { GL_VERSION_1_1 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glDrawArrays (GLenum mode, GLint first, GLsizei count);
void glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);
void glGetPointerv (GLenum pname, GLvoid* *params);
void glPolygonOffset (GLfloat factor, GLfloat units);
void glCopyTexImage1D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border);
void glCopyTexImage2D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
void glCopyTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
void glCopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
void glTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const GLvoid *pixels);
void glTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
void glBindTexture (GLenum target, GLuint texture);
void glDeleteTextures (GLsizei n, const GLuint *textures);
void glGenTextures (GLsizei n, GLuint *textures);
GLboolean glIsTexture (GLuint texture);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDRAWARRAYSPROC) (GLenum mode, GLint first, GLsizei count);
typedef void (PFNGLDRAWELEMENTSPROC) (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);
typedef void (PFNGLGETPOINTERVPROC) (GLenum pname, GLvoid* *params);
typedef void (PFNGLPOLYGONOFFSETPROC) (GLfloat factor, GLfloat units);
typedef void (PFNGLCOPYTEXIMAGE1DPROC) (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border);
typedef void (PFNGLCOPYTEXIMAGE2DPROC) (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
typedef void (PFNGLCOPYTEXSUBIMAGE1DPROC) (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
typedef void (PFNGLCOPYTEXSUBIMAGE2DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
typedef void (PFNGLTEXSUBIMAGE1DPROC) (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (PFNGLTEXSUBIMAGE2DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (PFNGLBINDTEXTUREPROC) (GLenum target, GLuint texture);
typedef void (PFNGLDELETETEXTURESPROC) (GLsizei n, const GLuint *textures);
typedef void (PFNGLGENTEXTURESPROC) (GLsizei n, GLuint *textures);
typedef GLboolean (PFNGLISTEXTUREPROC) (GLuint texture);
/* #endif */

/* #ifndef GL_VERSION_1_2 */
enum { GL_VERSION_1_2 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBlendColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
void glBlendEquation (GLenum mode);
void glDrawRangeElements (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices);
void glTexImage3D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const GLvoid *pixels);
void glCopyTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBLENDCOLORPROC) (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
typedef void (PFNGLBLENDEQUATIONPROC) (GLenum mode);
typedef void (PFNGLDRAWRANGEELEMENTSPROC) (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices);
typedef void (PFNGLTEXIMAGE3DPROC) (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (PFNGLTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (PFNGLCOPYTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
/* #endif */

/* #ifndef GL_VERSION_1_3 */
enum { GL_VERSION_1_3 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glActiveTexture (GLenum texture);
void glSampleCoverage (GLclampf value, GLboolean invert);
void glCompressedTexImage3D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const GLvoid *data);
void glCompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid *data);
void glCompressedTexImage1D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const GLvoid *data);
void glCompressedTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const GLvoid *data);
void glCompressedTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid *data);
void glCompressedTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const GLvoid *data);
void glGetCompressedTexImage (GLenum target, GLint level, GLvoid *img);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLACTIVETEXTUREPROC) (GLenum texture);
typedef void (PFNGLSAMPLECOVERAGEPROC) (GLclampf value, GLboolean invert);
typedef void (PFNGLCOMPRESSEDTEXIMAGE3DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const GLvoid *data);
typedef void (PFNGLCOMPRESSEDTEXIMAGE2DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid *data);
typedef void (PFNGLCOMPRESSEDTEXIMAGE1DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const GLvoid *data);
typedef void (PFNGLCOMPRESSEDTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const GLvoid *data);
typedef void (PFNGLCOMPRESSEDTEXSUBIMAGE2DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid *data);
typedef void (PFNGLCOMPRESSEDTEXSUBIMAGE1DPROC) (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const GLvoid *data);
typedef void (PFNGLGETCOMPRESSEDTEXIMAGEPROC) (GLenum target, GLint level, GLvoid *img);
/* #endif */

/* #ifndef GL_VERSION_1_4 */
enum { GL_VERSION_1_4 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBlendFuncSeparate (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);
void glMultiDrawArrays (GLenum mode, const GLint *first, const GLsizei *count, GLsizei primcount);
void glMultiDrawElements (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* *indices, GLsizei primcount);
void glPointParameterf (GLenum pname, GLfloat param);
void glPointParameterfv (GLenum pname, const GLfloat *params);
void glPointParameteri (GLenum pname, GLint param);
void glPointParameteriv (GLenum pname, const GLint *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBLENDFUNCSEPARATEPROC) (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);
typedef void (PFNGLMULTIDRAWARRAYSPROC) (GLenum mode, const GLint *first, const GLsizei *count, GLsizei primcount);
typedef void (PFNGLMULTIDRAWELEMENTSPROC) (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* *indices, GLsizei primcount);
typedef void (PFNGLPOINTPARAMETERFPROC) (GLenum pname, GLfloat param);
typedef void (PFNGLPOINTPARAMETERFVPROC) (GLenum pname, const GLfloat *params);
typedef void (PFNGLPOINTPARAMETERIPROC) (GLenum pname, GLint param);
typedef void (PFNGLPOINTPARAMETERIVPROC) (GLenum pname, const GLint *params);
/* #endif */

/* #ifndef GL_VERSION_1_5 */
enum { GL_VERSION_1_5 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glGenQueries (GLsizei n, GLuint *ids);
void glDeleteQueries (GLsizei n, const GLuint *ids);
GLboolean glIsQuery (GLuint id);
void glBeginQuery (GLenum target, GLuint id);
void glEndQuery (GLenum target);
void glGetQueryiv (GLenum target, GLenum pname, GLint *params);
void glGetQueryObjectiv (GLuint id, GLenum pname, GLint *params);
void glGetQueryObjectuiv (GLuint id, GLenum pname, GLuint *params);
void glBindBuffer (GLenum target, GLuint buffer);
void glDeleteBuffers (GLsizei n, const GLuint *buffers);
void glGenBuffers (GLsizei n, GLuint *buffers);
GLboolean glIsBuffer (GLuint buffer);
void glBufferData (GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
void glBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);
void glGetBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data);
GLvoid* glMapBuffer (GLenum target, GLenum access);
GLboolean glUnmapBuffer (GLenum target);
void glGetBufferParameteriv (GLenum target, GLenum pname, GLint *params);
void glGetBufferPointerv (GLenum target, GLenum pname, GLvoid* *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLGENQUERIESPROC) (GLsizei n, GLuint *ids);
typedef void (PFNGLDELETEQUERIESPROC) (GLsizei n, const GLuint *ids);
typedef GLboolean (PFNGLISQUERYPROC) (GLuint id);
typedef void (PFNGLBEGINQUERYPROC) (GLenum target, GLuint id);
typedef void (PFNGLENDQUERYPROC) (GLenum target);
typedef void (PFNGLGETQUERYIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (PFNGLGETQUERYOBJECTIVPROC) (GLuint id, GLenum pname, GLint *params);
typedef void (PFNGLGETQUERYOBJECTUIVPROC) (GLuint id, GLenum pname, GLuint *params);
typedef void (PFNGLBINDBUFFERPROC) (GLenum target, GLuint buffer);
typedef void (PFNGLDELETEBUFFERSPROC) (GLsizei n, const GLuint *buffers);
typedef void (PFNGLGENBUFFERSPROC) (GLsizei n, GLuint *buffers);
typedef GLboolean (PFNGLISBUFFERPROC) (GLuint buffer);
typedef void (PFNGLBUFFERDATAPROC) (GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
typedef void (PFNGLBUFFERSUBDATAPROC) (GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);
typedef void (PFNGLGETBUFFERSUBDATAPROC) (GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data);
typedef GLvoid* (PFNGLMAPBUFFERPROC) (GLenum target, GLenum access);
typedef GLboolean (PFNGLUNMAPBUFFERPROC) (GLenum target);
typedef void (PFNGLGETBUFFERPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (PFNGLGETBUFFERPOINTERVPROC) (GLenum target, GLenum pname, GLvoid* *params);
/* #endif */

/* #ifndef GL_VERSION_2_0 */
enum { GL_VERSION_2_0 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBlendEquationSeparate (GLenum modeRGB, GLenum modeAlpha);
void glDrawBuffers (GLsizei n, const GLenum *bufs);
void glStencilOpSeparate (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
void glStencilFuncSeparate (GLenum face, GLenum func, GLint ref, GLuint mask);
void glStencilMaskSeparate (GLenum face, GLuint mask);
void glAttachShader (GLuint program, GLuint shader);
void glBindAttribLocation (GLuint program, GLuint index, const GLchar *name);
void glCompileShader (GLuint shader);
GLuint glCreateProgram (void);
GLuint glCreateShader (GLenum type);
void glDeleteProgram (GLuint program);
void glDeleteShader (GLuint shader);
void glDetachShader (GLuint program, GLuint shader);
void glDisableVertexAttribArray (GLuint index);
void glEnableVertexAttribArray (GLuint index);
void glGetActiveAttrib (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
void glGetActiveUniform (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
void glGetAttachedShaders (GLuint program, GLsizei maxCount, GLsizei *count, GLuint *obj);
GLint glGetAttribLocation (GLuint program, const GLchar *name);
void glGetProgramiv (GLuint program, GLenum pname, GLint *params);
void glGetProgramInfoLog (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
void glGetShaderiv (GLuint shader, GLenum pname, GLint *params);
void glGetShaderInfoLog (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
void glGetShaderSource (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source);
GLint glGetUniformLocation (GLuint program, const GLchar *name);
void glGetUniformfv (GLuint program, GLint location, GLfloat *params);
void glGetUniformiv (GLuint program, GLint location, GLint *params);
void glGetVertexAttribdv (GLuint index, GLenum pname, GLdouble *params);
void glGetVertexAttribfv (GLuint index, GLenum pname, GLfloat *params);
void glGetVertexAttribiv (GLuint index, GLenum pname, GLint *params);
void glGetVertexAttribPointerv (GLuint index, GLenum pname, GLvoid* *pointer);
GLboolean glIsProgram (GLuint program);
GLboolean glIsShader (GLuint shader);
void glLinkProgram (GLuint program);
void glShaderSource (GLuint shader, GLsizei count, const GLchar* *string, const GLint *length);
void glUseProgram (GLuint program);
void glUniform1f (GLint location, GLfloat v0);
void glUniform2f (GLint location, GLfloat v0, GLfloat v1);
void glUniform3f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
void glUniform4f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
void glUniform1i (GLint location, GLint v0);
void glUniform2i (GLint location, GLint v0, GLint v1);
void glUniform3i (GLint location, GLint v0, GLint v1, GLint v2);
void glUniform4i (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
void glUniform1fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform2fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform3fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform4fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform1iv (GLint location, GLsizei count, const GLint *value);
void glUniform2iv (GLint location, GLsizei count, const GLint *value);
void glUniform3iv (GLint location, GLsizei count, const GLint *value);
void glUniform4iv (GLint location, GLsizei count, const GLint *value);
void glUniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glValidateProgram (GLuint program);
void glVertexAttrib1d (GLuint index, GLdouble x);
void glVertexAttrib1dv (GLuint index, const GLdouble *v);
void glVertexAttrib1f (GLuint index, GLfloat x);
void glVertexAttrib1fv (GLuint index, const GLfloat *v);
void glVertexAttrib1s (GLuint index, GLshort x);
void glVertexAttrib1sv (GLuint index, const GLshort *v);
void glVertexAttrib2d (GLuint index, GLdouble x, GLdouble y);
void glVertexAttrib2dv (GLuint index, const GLdouble *v);
void glVertexAttrib2f (GLuint index, GLfloat x, GLfloat y);
void glVertexAttrib2fv (GLuint index, const GLfloat *v);
void glVertexAttrib2s (GLuint index, GLshort x, GLshort y);
void glVertexAttrib2sv (GLuint index, const GLshort *v);
void glVertexAttrib3d (GLuint index, GLdouble x, GLdouble y, GLdouble z);
void glVertexAttrib3dv (GLuint index, const GLdouble *v);
void glVertexAttrib3f (GLuint index, GLfloat x, GLfloat y, GLfloat z);
void glVertexAttrib3fv (GLuint index, const GLfloat *v);
void glVertexAttrib3s (GLuint index, GLshort x, GLshort y, GLshort z);
void glVertexAttrib3sv (GLuint index, const GLshort *v);
void glVertexAttrib4Nbv (GLuint index, const GLbyte *v);
void glVertexAttrib4Niv (GLuint index, const GLint *v);
void glVertexAttrib4Nsv (GLuint index, const GLshort *v);
void glVertexAttrib4Nub (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
void glVertexAttrib4Nubv (GLuint index, const GLubyte *v);
void glVertexAttrib4Nuiv (GLuint index, const GLuint *v);
void glVertexAttrib4Nusv (GLuint index, const GLushort *v);
void glVertexAttrib4bv (GLuint index, const GLbyte *v);
void glVertexAttrib4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glVertexAttrib4dv (GLuint index, const GLdouble *v);
void glVertexAttrib4f (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void glVertexAttrib4fv (GLuint index, const GLfloat *v);
void glVertexAttrib4iv (GLuint index, const GLint *v);
void glVertexAttrib4s (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
void glVertexAttrib4sv (GLuint index, const GLshort *v);
void glVertexAttrib4ubv (GLuint index, const GLubyte *v);
void glVertexAttrib4uiv (GLuint index, const GLuint *v);
void glVertexAttrib4usv (GLuint index, const GLushort *v);
void glVertexAttribPointer (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBLENDEQUATIONSEPARATEPROC) (GLenum modeRGB, GLenum modeAlpha);
typedef void (PFNGLDRAWBUFFERSPROC) (GLsizei n, const GLenum *bufs);
typedef void (PFNGLSTENCILOPSEPARATEPROC) (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
typedef void (PFNGLSTENCILFUNCSEPARATEPROC) (GLenum face, GLenum func, GLint ref, GLuint mask);
typedef void (PFNGLSTENCILMASKSEPARATEPROC) (GLenum face, GLuint mask);
typedef void (PFNGLATTACHSHADERPROC) (GLuint program, GLuint shader);
typedef void (PFNGLBINDATTRIBLOCATIONPROC) (GLuint program, GLuint index, const GLchar *name);
typedef void (PFNGLCOMPILESHADERPROC) (GLuint shader);
typedef GLuint (PFNGLCREATEPROGRAMPROC) (void);
typedef GLuint (PFNGLCREATESHADERPROC) (GLenum type);
typedef void (PFNGLDELETEPROGRAMPROC) (GLuint program);
typedef void (PFNGLDELETESHADERPROC) (GLuint shader);
typedef void (PFNGLDETACHSHADERPROC) (GLuint program, GLuint shader);
typedef void (PFNGLDISABLEVERTEXATTRIBARRAYPROC) (GLuint index);
typedef void (PFNGLENABLEVERTEXATTRIBARRAYPROC) (GLuint index);
typedef void (PFNGLGETACTIVEATTRIBPROC) (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
typedef void (PFNGLGETACTIVEUNIFORMPROC) (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
typedef void (PFNGLGETATTACHEDSHADERSPROC) (GLuint program, GLsizei maxCount, GLsizei *count, GLuint *obj);
typedef GLint (PFNGLGETATTRIBLOCATIONPROC) (GLuint program, const GLchar *name);
typedef void (PFNGLGETPROGRAMIVPROC) (GLuint program, GLenum pname, GLint *params);
typedef void (PFNGLGETPROGRAMINFOLOGPROC) (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
typedef void (PFNGLGETSHADERIVPROC) (GLuint shader, GLenum pname, GLint *params);
typedef void (PFNGLGETSHADERINFOLOGPROC) (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
typedef void (PFNGLGETSHADERSOURCEPROC) (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source);
typedef GLint (PFNGLGETUNIFORMLOCATIONPROC) (GLuint program, const GLchar *name);
typedef void (PFNGLGETUNIFORMFVPROC) (GLuint program, GLint location, GLfloat *params);
typedef void (PFNGLGETUNIFORMIVPROC) (GLuint program, GLint location, GLint *params);
typedef void (PFNGLGETVERTEXATTRIBDVPROC) (GLuint index, GLenum pname, GLdouble *params);
typedef void (PFNGLGETVERTEXATTRIBFVPROC) (GLuint index, GLenum pname, GLfloat *params);
typedef void (PFNGLGETVERTEXATTRIBIVPROC) (GLuint index, GLenum pname, GLint *params);
typedef void (PFNGLGETVERTEXATTRIBPOINTERVPROC) (GLuint index, GLenum pname, GLvoid* *pointer);
typedef GLboolean (PFNGLISPROGRAMPROC) (GLuint program);
typedef GLboolean (PFNGLISSHADERPROC) (GLuint shader);
typedef void (PFNGLLINKPROGRAMPROC) (GLuint program);
typedef void (PFNGLSHADERSOURCEPROC) (GLuint shader, GLsizei count, const GLchar* *string, const GLint *length);
typedef void (PFNGLUSEPROGRAMPROC) (GLuint program);
typedef void (PFNGLUNIFORM1FPROC) (GLint location, GLfloat v0);
typedef void (PFNGLUNIFORM2FPROC) (GLint location, GLfloat v0, GLfloat v1);
typedef void (PFNGLUNIFORM3FPROC) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
typedef void (PFNGLUNIFORM4FPROC) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
typedef void (PFNGLUNIFORM1IPROC) (GLint location, GLint v0);
typedef void (PFNGLUNIFORM2IPROC) (GLint location, GLint v0, GLint v1);
typedef void (PFNGLUNIFORM3IPROC) (GLint location, GLint v0, GLint v1, GLint v2);
typedef void (PFNGLUNIFORM4IPROC) (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
typedef void (PFNGLUNIFORM1FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLUNIFORM2FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLUNIFORM3FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLUNIFORM4FVPROC) (GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLUNIFORM1IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLUNIFORM2IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLUNIFORM3IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLUNIFORM4IVPROC) (GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLUNIFORMMATRIX2FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLUNIFORMMATRIX3FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLUNIFORMMATRIX4FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLVALIDATEPROGRAMPROC) (GLuint program);
typedef void (PFNGLVERTEXATTRIB1DPROC) (GLuint index, GLdouble x);
typedef void (PFNGLVERTEXATTRIB1DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIB1FPROC) (GLuint index, GLfloat x);
typedef void (PFNGLVERTEXATTRIB1FVPROC) (GLuint index, const GLfloat *v);
typedef void (PFNGLVERTEXATTRIB1SPROC) (GLuint index, GLshort x);
typedef void (PFNGLVERTEXATTRIB1SVPROC) (GLuint index, const GLshort *v);
typedef void (PFNGLVERTEXATTRIB2DPROC) (GLuint index, GLdouble x, GLdouble y);
typedef void (PFNGLVERTEXATTRIB2DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIB2FPROC) (GLuint index, GLfloat x, GLfloat y);
typedef void (PFNGLVERTEXATTRIB2FVPROC) (GLuint index, const GLfloat *v);
typedef void (PFNGLVERTEXATTRIB2SPROC) (GLuint index, GLshort x, GLshort y);
typedef void (PFNGLVERTEXATTRIB2SVPROC) (GLuint index, const GLshort *v);
typedef void (PFNGLVERTEXATTRIB3DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z);
typedef void (PFNGLVERTEXATTRIB3DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIB3FPROC) (GLuint index, GLfloat x, GLfloat y, GLfloat z);
typedef void (PFNGLVERTEXATTRIB3FVPROC) (GLuint index, const GLfloat *v);
typedef void (PFNGLVERTEXATTRIB3SPROC) (GLuint index, GLshort x, GLshort y, GLshort z);
typedef void (PFNGLVERTEXATTRIB3SVPROC) (GLuint index, const GLshort *v);
typedef void (PFNGLVERTEXATTRIB4NBVPROC) (GLuint index, const GLbyte *v);
typedef void (PFNGLVERTEXATTRIB4NIVPROC) (GLuint index, const GLint *v);
typedef void (PFNGLVERTEXATTRIB4NSVPROC) (GLuint index, const GLshort *v);
typedef void (PFNGLVERTEXATTRIB4NUBPROC) (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
typedef void (PFNGLVERTEXATTRIB4NUBVPROC) (GLuint index, const GLubyte *v);
typedef void (PFNGLVERTEXATTRIB4NUIVPROC) (GLuint index, const GLuint *v);
typedef void (PFNGLVERTEXATTRIB4NUSVPROC) (GLuint index, const GLushort *v);
typedef void (PFNGLVERTEXATTRIB4BVPROC) (GLuint index, const GLbyte *v);
typedef void (PFNGLVERTEXATTRIB4DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
typedef void (PFNGLVERTEXATTRIB4DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIB4FPROC) (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
typedef void (PFNGLVERTEXATTRIB4FVPROC) (GLuint index, const GLfloat *v);
typedef void (PFNGLVERTEXATTRIB4IVPROC) (GLuint index, const GLint *v);
typedef void (PFNGLVERTEXATTRIB4SPROC) (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
typedef void (PFNGLVERTEXATTRIB4SVPROC) (GLuint index, const GLshort *v);
typedef void (PFNGLVERTEXATTRIB4UBVPROC) (GLuint index, const GLubyte *v);
typedef void (PFNGLVERTEXATTRIB4UIVPROC) (GLuint index, const GLuint *v);
typedef void (PFNGLVERTEXATTRIB4USVPROC) (GLuint index, const GLushort *v);
typedef void (PFNGLVERTEXATTRIBPOINTERPROC) (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer);
/* #endif */

/* #ifndef GL_VERSION_2_1 */
enum { GL_VERSION_2_1 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glUniformMatrix2x3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix3x2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix2x4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix4x2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix3x4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix4x3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLUNIFORMMATRIX2X3FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLUNIFORMMATRIX3X2FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLUNIFORMMATRIX2X4FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLUNIFORMMATRIX4X2FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLUNIFORMMATRIX3X4FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLUNIFORMMATRIX4X3FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
/* #endif */

/* #ifndef GL_VERSION_3_0 */
enum { GL_VERSION_3_0 = 1 };
/* OpenGL 3.0 also reuses entry points from these extensions: */
/* ARB_framebuffer_object */
/* ARB_map_buffer_range */
/* ARB_vertex_array_object */
/* #ifdef GL3_PROTOTYPES */
void glColorMaski (GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a);
void glGetBooleani_v (GLenum target, GLuint index, GLboolean *data);
void glGetIntegeri_v (GLenum target, GLuint index, GLint *data);
void glEnablei (GLenum target, GLuint index);
void glDisablei (GLenum target, GLuint index);
GLboolean glIsEnabledi (GLenum target, GLuint index);
void glBeginTransformFeedback (GLenum primitiveMode);
void glEndTransformFeedback (void);
void glBindBufferRange (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size);
void glBindBufferBase (GLenum target, GLuint index, GLuint buffer);
void glTransformFeedbackVaryings (GLuint program, GLsizei count, const GLchar* *varyings, GLenum bufferMode);
void glGetTransformFeedbackVarying (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name);
void glClampColor (GLenum target, GLenum clamp);
void glBeginConditionalRender (GLuint id, GLenum mode);
void glEndConditionalRender (void);
void glVertexAttribIPointer (GLuint index, GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glGetVertexAttribIiv (GLuint index, GLenum pname, GLint *params);
void glGetVertexAttribIuiv (GLuint index, GLenum pname, GLuint *params);
void glVertexAttribI1i (GLuint index, GLint x);
void glVertexAttribI2i (GLuint index, GLint x, GLint y);
void glVertexAttribI3i (GLuint index, GLint x, GLint y, GLint z);
void glVertexAttribI4i (GLuint index, GLint x, GLint y, GLint z, GLint w);
void glVertexAttribI1ui (GLuint index, GLuint x);
void glVertexAttribI2ui (GLuint index, GLuint x, GLuint y);
void glVertexAttribI3ui (GLuint index, GLuint x, GLuint y, GLuint z);
void glVertexAttribI4ui (GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
void glVertexAttribI1iv (GLuint index, const GLint *v);
void glVertexAttribI2iv (GLuint index, const GLint *v);
void glVertexAttribI3iv (GLuint index, const GLint *v);
void glVertexAttribI4iv (GLuint index, const GLint *v);
void glVertexAttribI1uiv (GLuint index, const GLuint *v);
void glVertexAttribI2uiv (GLuint index, const GLuint *v);
void glVertexAttribI3uiv (GLuint index, const GLuint *v);
void glVertexAttribI4uiv (GLuint index, const GLuint *v);
void glVertexAttribI4bv (GLuint index, const GLbyte *v);
void glVertexAttribI4sv (GLuint index, const GLshort *v);
void glVertexAttribI4ubv (GLuint index, const GLubyte *v);
void glVertexAttribI4usv (GLuint index, const GLushort *v);
void glGetUniformuiv (GLuint program, GLint location, GLuint *params);
void glBindFragDataLocation (GLuint program, GLuint color, const GLchar *name);
GLint glGetFragDataLocation (GLuint program, const GLchar *name);
void glUniform1ui (GLint location, GLuint v0);
void glUniform2ui (GLint location, GLuint v0, GLuint v1);
void glUniform3ui (GLint location, GLuint v0, GLuint v1, GLuint v2);
void glUniform4ui (GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
void glUniform1uiv (GLint location, GLsizei count, const GLuint *value);
void glUniform2uiv (GLint location, GLsizei count, const GLuint *value);
void glUniform3uiv (GLint location, GLsizei count, const GLuint *value);
void glUniform4uiv (GLint location, GLsizei count, const GLuint *value);
void glTexParameterIiv (GLenum target, GLenum pname, const GLint *params);
void glTexParameterIuiv (GLenum target, GLenum pname, const GLuint *params);
void glGetTexParameterIiv (GLenum target, GLenum pname, GLint *params);
void glGetTexParameterIuiv (GLenum target, GLenum pname, GLuint *params);
void glClearBufferiv (GLenum buffer, GLint drawbuffer, const GLint *value);
void glClearBufferuiv (GLenum buffer, GLint drawbuffer, const GLuint *value);
void glClearBufferfv (GLenum buffer, GLint drawbuffer, const GLfloat *value);
void glClearBufferfi (GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil);
const GLubyte * glGetStringi (GLenum name, GLuint index);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLCOLORMASKIPROC) (GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a);
typedef void (PFNGLGETBOOLEANI_VPROC) (GLenum target, GLuint index, GLboolean *data);
typedef void (PFNGLGETINTEGERI_VPROC) (GLenum target, GLuint index, GLint *data);
typedef void (PFNGLENABLEIPROC) (GLenum target, GLuint index);
typedef void (PFNGLDISABLEIPROC) (GLenum target, GLuint index);
typedef GLboolean (PFNGLISENABLEDIPROC) (GLenum target, GLuint index);
typedef void (PFNGLBEGINTRANSFORMFEEDBACKPROC) (GLenum primitiveMode);
typedef void (PFNGLENDTRANSFORMFEEDBACKPROC) (void);
typedef void (PFNGLBINDBUFFERRANGEPROC) (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size);
typedef void (PFNGLBINDBUFFERBASEPROC) (GLenum target, GLuint index, GLuint buffer);
typedef void (PFNGLTRANSFORMFEEDBACKVARYINGSPROC) (GLuint program, GLsizei count, const GLchar* *varyings, GLenum bufferMode);
typedef void (PFNGLGETTRANSFORMFEEDBACKVARYINGPROC) (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name);
typedef void (PFNGLCLAMPCOLORPROC) (GLenum target, GLenum clamp);
typedef void (PFNGLBEGINCONDITIONALRENDERPROC) (GLuint id, GLenum mode);
typedef void (PFNGLENDCONDITIONALRENDERPROC) (void);
typedef void (PFNGLVERTEXATTRIBIPOINTERPROC) (GLuint index, GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
typedef void (PFNGLGETVERTEXATTRIBIIVPROC) (GLuint index, GLenum pname, GLint *params);
typedef void (PFNGLGETVERTEXATTRIBIUIVPROC) (GLuint index, GLenum pname, GLuint *params);
typedef void (PFNGLVERTEXATTRIBI1IPROC) (GLuint index, GLint x);
typedef void (PFNGLVERTEXATTRIBI2IPROC) (GLuint index, GLint x, GLint y);
typedef void (PFNGLVERTEXATTRIBI3IPROC) (GLuint index, GLint x, GLint y, GLint z);
typedef void (PFNGLVERTEXATTRIBI4IPROC) (GLuint index, GLint x, GLint y, GLint z, GLint w);
typedef void (PFNGLVERTEXATTRIBI1UIPROC) (GLuint index, GLuint x);
typedef void (PFNGLVERTEXATTRIBI2UIPROC) (GLuint index, GLuint x, GLuint y);
typedef void (PFNGLVERTEXATTRIBI3UIPROC) (GLuint index, GLuint x, GLuint y, GLuint z);
typedef void (PFNGLVERTEXATTRIBI4UIPROC) (GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
typedef void (PFNGLVERTEXATTRIBI1IVPROC) (GLuint index, const GLint *v);
typedef void (PFNGLVERTEXATTRIBI2IVPROC) (GLuint index, const GLint *v);
typedef void (PFNGLVERTEXATTRIBI3IVPROC) (GLuint index, const GLint *v);
typedef void (PFNGLVERTEXATTRIBI4IVPROC) (GLuint index, const GLint *v);
typedef void (PFNGLVERTEXATTRIBI1UIVPROC) (GLuint index, const GLuint *v);
typedef void (PFNGLVERTEXATTRIBI2UIVPROC) (GLuint index, const GLuint *v);
typedef void (PFNGLVERTEXATTRIBI3UIVPROC) (GLuint index, const GLuint *v);
typedef void (PFNGLVERTEXATTRIBI4UIVPROC) (GLuint index, const GLuint *v);
typedef void (PFNGLVERTEXATTRIBI4BVPROC) (GLuint index, const GLbyte *v);
typedef void (PFNGLVERTEXATTRIBI4SVPROC) (GLuint index, const GLshort *v);
typedef void (PFNGLVERTEXATTRIBI4UBVPROC) (GLuint index, const GLubyte *v);
typedef void (PFNGLVERTEXATTRIBI4USVPROC) (GLuint index, const GLushort *v);
typedef void (PFNGLGETUNIFORMUIVPROC) (GLuint program, GLint location, GLuint *params);
typedef void (PFNGLBINDFRAGDATALOCATIONPROC) (GLuint program, GLuint color, const GLchar *name);
typedef GLint (PFNGLGETFRAGDATALOCATIONPROC) (GLuint program, const GLchar *name);
typedef void (PFNGLUNIFORM1UIPROC) (GLint location, GLuint v0);
typedef void (PFNGLUNIFORM2UIPROC) (GLint location, GLuint v0, GLuint v1);
typedef void (PFNGLUNIFORM3UIPROC) (GLint location, GLuint v0, GLuint v1, GLuint v2);
typedef void (PFNGLUNIFORM4UIPROC) (GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
typedef void (PFNGLUNIFORM1UIVPROC) (GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLUNIFORM2UIVPROC) (GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLUNIFORM3UIVPROC) (GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLUNIFORM4UIVPROC) (GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLTEXPARAMETERIIVPROC) (GLenum target, GLenum pname, const GLint *params);
typedef void (PFNGLTEXPARAMETERIUIVPROC) (GLenum target, GLenum pname, const GLuint *params);
typedef void (PFNGLGETTEXPARAMETERIIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (PFNGLGETTEXPARAMETERIUIVPROC) (GLenum target, GLenum pname, GLuint *params);
typedef void (PFNGLCLEARBUFFERIVPROC) (GLenum buffer, GLint drawbuffer, const GLint *value);
typedef void (PFNGLCLEARBUFFERUIVPROC) (GLenum buffer, GLint drawbuffer, const GLuint *value);
typedef void (PFNGLCLEARBUFFERFVPROC) (GLenum buffer, GLint drawbuffer, const GLfloat *value);
typedef void (PFNGLCLEARBUFFERFIPROC) (GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil);
typedef const GLubyte * (PFNGLGETSTRINGIPROC) (GLenum name, GLuint index);
/* #endif */

/* #ifndef GL_VERSION_3_1 */
enum { GL_VERSION_3_1 = 1 };
/* OpenGL 3.1 also reuses entry points from these extensions: */
/* ARB_copy_buffer */
/* ARB_uniform_buffer_object */
/* #ifdef GL3_PROTOTYPES */
void glDrawArraysInstanced (GLenum mode, GLint first, GLsizei count, GLsizei primcount);
void glDrawElementsInstanced (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLsizei primcount);
void glTexBuffer (GLenum target, GLenum internalformat, GLuint buffer);
void glPrimitiveRestartIndex (GLuint index);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDRAWARRAYSINSTANCEDPROC) (GLenum mode, GLint first, GLsizei count, GLsizei primcount);
typedef void (PFNGLDRAWELEMENTSINSTANCEDPROC) (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLsizei primcount);
typedef void (PFNGLTEXBUFFERPROC) (GLenum target, GLenum internalformat, GLuint buffer);
typedef void (PFNGLPRIMITIVERESTARTINDEXPROC) (GLuint index);
/* #endif */

/* #ifndef GL_VERSION_3_2 */
enum { GL_VERSION_3_2 = 1 };
/* OpenGL 3.2 also reuses entry points from these extensions: */
/* ARB_draw_elements_base_vertex */
/* ARB_provoking_vertex */
/* ARB_sync */
/* ARB_texture_multisample */
/* #ifdef GL3_PROTOTYPES */
void glGetInteger64i_v (GLenum target, GLuint index, GLint64 *data);
void glGetBufferParameteri64v (GLenum target, GLenum pname, GLint64 *params);
void glFramebufferTexture (GLenum target, GLenum attachment, GLuint texture, GLint level);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLGETINTEGER64I_VPROC) (GLenum target, GLuint index, GLint64 *data);
typedef void (PFNGLGETBUFFERPARAMETERI64VPROC) (GLenum target, GLenum pname, GLint64 *params);
typedef void (PFNGLFRAMEBUFFERTEXTUREPROC) (GLenum target, GLenum attachment, GLuint texture, GLint level);
/* #endif */

/* #ifndef GL_VERSION_3_3 */
enum { GL_VERSION_3_3 = 1 };
/* OpenGL 3.3 also reuses entry points from these extensions: */
/* ARB_blend_func_extended */
/* ARB_sampler_objects */
/* ARB_explicit_attrib_location, but it has none */
/* ARB_occlusion_query2 (no entry points) */
/* ARB_shader_bit_encoding (no entry points) */
/* ARB_texture_rgb10_a2ui (no entry points) */
/* ARB_texture_swizzle (no entry points) */
/* ARB_timer_query */
/* ARB_vertex_type_2_10_10_10_rev */
/* #ifdef GL3_PROTOTYPES */
void glVertexAttribDivisor (GLuint index, GLuint divisor);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLVERTEXATTRIBDIVISORPROC) (GLuint index, GLuint divisor);
/* #endif */

/* #ifndef GL_VERSION_4_0 */
enum { GL_VERSION_4_0 = 1 };
/* OpenGL 4.0 also reuses entry points from these extensions: */
/* ARB_texture_query_lod (no entry points) */
/* ARB_draw_indirect */
/* ARB_gpu_shader5 (no entry points) */
/* ARB_gpu_shader_fp64 */
/* ARB_shader_subroutine */
/* ARB_tessellation_shader */
/* ARB_texture_buffer_object_rgb32 (no entry points) */
/* ARB_texture_cube_map_array (no entry points) */
/* ARB_texture_gather (no entry points) */
/* ARB_transform_feedback2 */
/* ARB_transform_feedback3 */
/* #ifdef GL3_PROTOTYPES */
void glMinSampleShading (GLclampf value);
void glBlendEquationi (GLuint buf, GLenum mode);
void glBlendEquationSeparatei (GLuint buf, GLenum modeRGB, GLenum modeAlpha);
void glBlendFunci (GLuint buf, GLenum src, GLenum dst);
void glBlendFuncSeparatei (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLMINSAMPLESHADINGPROC) (GLclampf value);
typedef void (PFNGLBLENDEQUATIONIPROC) (GLuint buf, GLenum mode);
typedef void (PFNGLBLENDEQUATIONSEPARATEIPROC) (GLuint buf, GLenum modeRGB, GLenum modeAlpha);
typedef void (PFNGLBLENDFUNCIPROC) (GLuint buf, GLenum src, GLenum dst);
typedef void (PFNGLBLENDFUNCSEPARATEIPROC) (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
/* #endif */

/* #ifndef GL_VERSION_4_1 */
enum { GL_VERSION_4_1 = 1 };
/* OpenGL 4.1 reuses entry points from these extensions: */
/* ARB_ES2_compatibility */
/* ARB_get_program_binary */
/* ARB_separate_shader_objects */
/* ARB_shader_precision (no entry points) */
/* ARB_vertex_attrib_64bit */
/* ARB_viewport_array */
/* #endif */

/* #ifndef GL_VERSION_4_2 */
enum { GL_VERSION_4_2 = 1 };
/* OpenGL 4.2 reuses entry points from these extensions: */
/* ARB_base_instance */
/* ARB_shading_language_420pack (no entry points) */
/* ARB_transform_feedback_instanced */
/* ARB_compressed_texture_pixel_storage (no entry points) */
/* ARB_conservative_depth (no entry points) */
/* ARB_internalformat_query */
/* ARB_map_buffer_alignment (no entry points) */
/* ARB_shader_atomic_counters */
/* ARB_shader_image_load_store */
/* ARB_shading_language_packing (no entry points) */
/* ARB_texture_storage */
/* #endif */

/* #ifndef GL_ARB_depth_buffer_float */
enum { GL_ARB_depth_buffer_float = 1 };
/* #endif */

/* #ifndef GL_ARB_framebuffer_object */
enum { GL_ARB_framebuffer_object = 1 };
/* #ifdef GL3_PROTOTYPES */
GLboolean glIsRenderbuffer (GLuint renderbuffer);
void glBindRenderbuffer (GLenum target, GLuint renderbuffer);
void glDeleteRenderbuffers (GLsizei n, const GLuint *renderbuffers);
void glGenRenderbuffers (GLsizei n, GLuint *renderbuffers);
void glRenderbufferStorage (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
void glGetRenderbufferParameteriv (GLenum target, GLenum pname, GLint *params);
GLboolean glIsFramebuffer (GLuint framebuffer);
void glBindFramebuffer (GLenum target, GLuint framebuffer);
void glDeleteFramebuffers (GLsizei n, const GLuint *framebuffers);
void glGenFramebuffers (GLsizei n, GLuint *framebuffers);
GLenum glCheckFramebufferStatus (GLenum target);
void glFramebufferTexture1D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
void glFramebufferTexture2D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
void glFramebufferTexture3D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset);
void glFramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
void glGetFramebufferAttachmentParameteriv (GLenum target, GLenum attachment, GLenum pname, GLint *params);
void glGenerateMipmap (GLenum target);
void glBlitFramebuffer (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
void glRenderbufferStorageMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
void glFramebufferTextureLayer (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer);
/* #endif GL3_PROTOTYPES */
typedef GLboolean (PFNGLISRENDERBUFFERPROC) (GLuint renderbuffer);
typedef void (PFNGLBINDRENDERBUFFERPROC) (GLenum target, GLuint renderbuffer);
typedef void (PFNGLDELETERENDERBUFFERSPROC) (GLsizei n, const GLuint *renderbuffers);
typedef void (PFNGLGENRENDERBUFFERSPROC) (GLsizei n, GLuint *renderbuffers);
typedef void (PFNGLRENDERBUFFERSTORAGEPROC) (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (PFNGLGETRENDERBUFFERPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef GLboolean (PFNGLISFRAMEBUFFERPROC) (GLuint framebuffer);
typedef void (PFNGLBINDFRAMEBUFFERPROC) (GLenum target, GLuint framebuffer);
typedef void (PFNGLDELETEFRAMEBUFFERSPROC) (GLsizei n, const GLuint *framebuffers);
typedef void (PFNGLGENFRAMEBUFFERSPROC) (GLsizei n, GLuint *framebuffers);
typedef GLenum (PFNGLCHECKFRAMEBUFFERSTATUSPROC) (GLenum target);
typedef void (PFNGLFRAMEBUFFERTEXTURE1DPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
typedef void (PFNGLFRAMEBUFFERTEXTURE2DPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
typedef void (PFNGLFRAMEBUFFERTEXTURE3DPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset);
typedef void (PFNGLFRAMEBUFFERRENDERBUFFERPROC) (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
typedef void (PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC) (GLenum target, GLenum attachment, GLenum pname, GLint *params);
typedef void (PFNGLGENERATEMIPMAPPROC) (GLenum target);
typedef void (PFNGLBLITFRAMEBUFFERPROC) (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
typedef void (PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC) (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (PFNGLFRAMEBUFFERTEXTURELAYERPROC) (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer);
/* #endif */

/* #ifndef GL_ARB_framebuffer_sRGB */
enum { GL_ARB_framebuffer_sRGB = 1 };
/* #endif */

/* #ifndef GL_ARB_half_float_vertex */
enum { GL_ARB_half_float_vertex = 1 };
/* #endif */

/* #ifndef GL_ARB_map_buffer_range */
enum { GL_ARB_map_buffer_range = 1 };
/* #ifdef GL3_PROTOTYPES */
GLvoid* glMapBufferRange (GLenum target, GLintptr offset, GLsizeiptr length, GLbitfield access);
void glFlushMappedBufferRange (GLenum target, GLintptr offset, GLsizeiptr length);
/* #endif GL3_PROTOTYPES */
typedef GLvoid* (PFNGLMAPBUFFERRANGEPROC) (GLenum target, GLintptr offset, GLsizeiptr length, GLbitfield access);
typedef void (PFNGLFLUSHMAPPEDBUFFERRANGEPROC) (GLenum target, GLintptr offset, GLsizeiptr length);
/* #endif */

/* #ifndef GL_ARB_texture_compression_rgtc */
enum { GL_ARB_texture_compression_rgtc = 1 };
/* #endif */

/* #ifndef GL_ARB_texture_rg */
enum { GL_ARB_texture_rg = 1 };
/* #endif */

/* #ifndef GL_ARB_vertex_array_object */
enum { GL_ARB_vertex_array_object = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBindVertexArray (GLuint array);
void glDeleteVertexArrays (GLsizei n, const GLuint *arrays);
void glGenVertexArrays (GLsizei n, GLuint *arrays);
GLboolean glIsVertexArray (GLuint array);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBINDVERTEXARRAYPROC) (GLuint array);
typedef void (PFNGLDELETEVERTEXARRAYSPROC) (GLsizei n, const GLuint *arrays);
typedef void (PFNGLGENVERTEXARRAYSPROC) (GLsizei n, GLuint *arrays);
typedef GLboolean (PFNGLISVERTEXARRAYPROC) (GLuint array);
/* #endif */

/* #ifndef GL_ARB_uniform_buffer_object */
enum { GL_ARB_uniform_buffer_object = 1 };
/* #ifdef GL3_PROTOTYPES */
void glGetUniformIndices (GLuint program, GLsizei uniformCount, const GLchar* *uniformNames, GLuint *uniformIndices);
void glGetActiveUniformsiv (GLuint program, GLsizei uniformCount, const GLuint *uniformIndices, GLenum pname, GLint *params);
void glGetActiveUniformName (GLuint program, GLuint uniformIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformName);
GLuint glGetUniformBlockIndex (GLuint program, const GLchar *uniformBlockName);
void glGetActiveUniformBlockiv (GLuint program, GLuint uniformBlockIndex, GLenum pname, GLint *params);
void glGetActiveUniformBlockName (GLuint program, GLuint uniformBlockIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformBlockName);
void glUniformBlockBinding (GLuint program, GLuint uniformBlockIndex, GLuint uniformBlockBinding);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLGETUNIFORMINDICESPROC) (GLuint program, GLsizei uniformCount, const GLchar* *uniformNames, GLuint *uniformIndices);
typedef void (PFNGLGETACTIVEUNIFORMSIVPROC) (GLuint program, GLsizei uniformCount, const GLuint *uniformIndices, GLenum pname, GLint *params);
typedef void (PFNGLGETACTIVEUNIFORMNAMEPROC) (GLuint program, GLuint uniformIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformName);
typedef GLuint (PFNGLGETUNIFORMBLOCKINDEXPROC) (GLuint program, const GLchar *uniformBlockName);
typedef void (PFNGLGETACTIVEUNIFORMBLOCKIVPROC) (GLuint program, GLuint uniformBlockIndex, GLenum pname, GLint *params);
typedef void (PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC) (GLuint program, GLuint uniformBlockIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformBlockName);
typedef void (PFNGLUNIFORMBLOCKBINDINGPROC) (GLuint program, GLuint uniformBlockIndex, GLuint uniformBlockBinding);
/* #endif */

/* #ifndef GL_ARB_copy_buffer */
enum { GL_ARB_copy_buffer = 1 };
/* #ifdef GL3_PROTOTYPES */
void glCopyBufferSubData (GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLCOPYBUFFERSUBDATAPROC) (GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size);
/* #endif */

/* #ifndef GL_ARB_depth_clamp */
enum { GL_ARB_depth_clamp = 1 };
/* #endif */

/* #ifndef GL_ARB_draw_elements_base_vertex */
enum { GL_ARB_draw_elements_base_vertex = 1 };
/* #ifdef GL3_PROTOTYPES */
void glDrawElementsBaseVertex (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLint basevertex);
void glDrawRangeElementsBaseVertex (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices, GLint basevertex);
void glDrawElementsInstancedBaseVertex (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLsizei primcount, GLint basevertex);
void glMultiDrawElementsBaseVertex (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* *indices, GLsizei primcount, const GLint *basevertex);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDRAWELEMENTSBASEVERTEXPROC) (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLint basevertex);
typedef void (PFNGLDRAWRANGEELEMENTSBASEVERTEXPROC) (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices, GLint basevertex);
typedef void (PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXPROC) (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLsizei primcount, GLint basevertex);
typedef void (PFNGLMULTIDRAWELEMENTSBASEVERTEXPROC) (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* *indices, GLsizei primcount, const GLint *basevertex);
/* #endif */

/* #ifndef GL_ARB_fragment_coord_conventions */
enum { GL_ARB_fragment_coord_conventions = 1 };
/* #endif */

/* #ifndef GL_ARB_provoking_vertex */
enum { GL_ARB_provoking_vertex = 1 };
/* #ifdef GL3_PROTOTYPES */
void glProvokingVertex (GLenum mode);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLPROVOKINGVERTEXPROC) (GLenum mode);
/* #endif */

/* #ifndef GL_ARB_seamless_cube_map */
enum { GL_ARB_seamless_cube_map = 1 };
/* #endif */

/* #ifndef GL_ARB_sync */
enum { GL_ARB_sync = 1 };
/* #ifdef GL3_PROTOTYPES */
GLsync glFenceSync (GLenum condition, GLbitfield flags);
GLboolean glIsSync (GLsync sync);
void glDeleteSync (GLsync sync);
GLenum glClientWaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout);
void glWaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout);
void glGetInteger64v (GLenum pname, GLint64 *params);
void glGetSynciv (GLsync sync, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *values);
/* #endif GL3_PROTOTYPES */
typedef GLsync (PFNGLFENCESYNCPROC) (GLenum condition, GLbitfield flags);
typedef GLboolean (PFNGLISSYNCPROC) (GLsync sync);
typedef void (PFNGLDELETESYNCPROC) (GLsync sync);
typedef GLenum (PFNGLCLIENTWAITSYNCPROC) (GLsync sync, GLbitfield flags, GLuint64 timeout);
typedef void (PFNGLWAITSYNCPROC) (GLsync sync, GLbitfield flags, GLuint64 timeout);
typedef void (PFNGLGETINTEGER64VPROC) (GLenum pname, GLint64 *params);
typedef void (PFNGLGETSYNCIVPROC) (GLsync sync, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *values);
/* #endif */

/* #ifndef GL_ARB_texture_multisample */
enum { GL_ARB_texture_multisample = 1 };
/* #ifdef GL3_PROTOTYPES */
void glTexImage2DMultisample (GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations);
void glTexImage3DMultisample (GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations);
void glGetMultisamplefv (GLenum pname, GLuint index, GLfloat *val);
void glSampleMaski (GLuint index, GLbitfield mask);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLTEXIMAGE2DMULTISAMPLEPROC) (GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations);
typedef void (PFNGLTEXIMAGE3DMULTISAMPLEPROC) (GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations);
typedef void (PFNGLGETMULTISAMPLEFVPROC) (GLenum pname, GLuint index, GLfloat *val);
typedef void (PFNGLSAMPLEMASKIPROC) (GLuint index, GLbitfield mask);
/* #endif */

/* #ifndef GL_ARB_vertex_array_bgra */
enum { GL_ARB_vertex_array_bgra = 1 };
/* #endif */

/* #ifndef GL_ARB_draw_buffers_blend */
enum { GL_ARB_draw_buffers_blend = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBlendEquationiARB (GLuint buf, GLenum mode);
void glBlendEquationSeparateiARB (GLuint buf, GLenum modeRGB, GLenum modeAlpha);
void glBlendFunciARB (GLuint buf, GLenum src, GLenum dst);
void glBlendFuncSeparateiARB (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBLENDEQUATIONIARBPROC) (GLuint buf, GLenum mode);
typedef void (PFNGLBLENDEQUATIONSEPARATEIARBPROC) (GLuint buf, GLenum modeRGB, GLenum modeAlpha);
typedef void (PFNGLBLENDFUNCIARBPROC) (GLuint buf, GLenum src, GLenum dst);
typedef void (PFNGLBLENDFUNCSEPARATEIARBPROC) (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
/* #endif */

/* #ifndef GL_ARB_sample_shading */
enum { GL_ARB_sample_shading = 1 };
/* #ifdef GL3_PROTOTYPES */
void glMinSampleShadingARB (GLclampf value);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLMINSAMPLESHADINGARBPROC) (GLclampf value);
/* #endif */

/* #ifndef GL_ARB_texture_cube_map_array */
enum { GL_ARB_texture_cube_map_array = 1 };
/* #endif */

/* #ifndef GL_ARB_texture_gather */
enum { GL_ARB_texture_gather = 1 };
/* #endif */

/* #ifndef GL_ARB_texture_query_lod */
enum { GL_ARB_texture_query_lod = 1 };
/* #endif */

/* #ifndef GL_ARB_shading_language_include */
enum { GL_ARB_shading_language_include = 1 };
/* #ifdef GL3_PROTOTYPES */
void glNamedStringARB (GLenum type, GLint namelen, const GLchar *name, GLint stringlen, const GLchar *string);
void glDeleteNamedStringARB (GLint namelen, const GLchar *name);
void glCompileShaderIncludeARB (GLuint shader, GLsizei count, const GLchar* *path, const GLint *length);
GLboolean glIsNamedStringARB (GLint namelen, const GLchar *name);
void glGetNamedStringARB (GLint namelen, const GLchar *name, GLsizei bufSize, GLint *stringlen, GLchar *string);
void glGetNamedStringivARB (GLint namelen, const GLchar *name, GLenum pname, GLint *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLNAMEDSTRINGARBPROC) (GLenum type, GLint namelen, const GLchar *name, GLint stringlen, const GLchar *string);
typedef void (PFNGLDELETENAMEDSTRINGARBPROC) (GLint namelen, const GLchar *name);
typedef void (PFNGLCOMPILESHADERINCLUDEARBPROC) (GLuint shader, GLsizei count, const GLchar* *path, const GLint *length);
typedef GLboolean (PFNGLISNAMEDSTRINGARBPROC) (GLint namelen, const GLchar *name);
typedef void (PFNGLGETNAMEDSTRINGARBPROC) (GLint namelen, const GLchar *name, GLsizei bufSize, GLint *stringlen, GLchar *string);
typedef void (PFNGLGETNAMEDSTRINGIVARBPROC) (GLint namelen, const GLchar *name, GLenum pname, GLint *params);
/* #endif */

/* #ifndef GL_ARB_texture_compression_bptc */
enum { GL_ARB_texture_compression_bptc = 1 };
/* #endif */

/* #ifndef GL_ARB_blend_func_extended */
enum { GL_ARB_blend_func_extended = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBindFragDataLocationIndexed (GLuint program, GLuint colorNumber, GLuint index, const GLchar *name);
GLint glGetFragDataIndex (GLuint program, const GLchar *name);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBINDFRAGDATALOCATIONINDEXEDPROC) (GLuint program, GLuint colorNumber, GLuint index, const GLchar *name);
typedef GLint (PFNGLGETFRAGDATAINDEXPROC) (GLuint program, const GLchar *name);
/* #endif */

/* #ifndef GL_ARB_explicit_attrib_location */
enum { GL_ARB_explicit_attrib_location = 1 };
/* #endif */

/* #ifndef GL_ARB_occlusion_query2 */
enum { GL_ARB_occlusion_query2 = 1 };
/* #endif */

/* #ifndef GL_ARB_sampler_objects */
enum { GL_ARB_sampler_objects = 1 };
/* #ifdef GL3_PROTOTYPES */
void glGenSamplers (GLsizei count, GLuint *samplers);
void glDeleteSamplers (GLsizei count, const GLuint *samplers);
GLboolean glIsSampler (GLuint sampler);
void glBindSampler (GLuint unit, GLuint sampler);
void glSamplerParameteri (GLuint sampler, GLenum pname, GLint param);
void glSamplerParameteriv (GLuint sampler, GLenum pname, const GLint *param);
void glSamplerParameterf (GLuint sampler, GLenum pname, GLfloat param);
void glSamplerParameterfv (GLuint sampler, GLenum pname, const GLfloat *param);
void glSamplerParameterIiv (GLuint sampler, GLenum pname, const GLint *param);
void glSamplerParameterIuiv (GLuint sampler, GLenum pname, const GLuint *param);
void glGetSamplerParameteriv (GLuint sampler, GLenum pname, GLint *params);
void glGetSamplerParameterIiv (GLuint sampler, GLenum pname, GLint *params);
void glGetSamplerParameterfv (GLuint sampler, GLenum pname, GLfloat *params);
void glGetSamplerParameterIuiv (GLuint sampler, GLenum pname, GLuint *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLGENSAMPLERSPROC) (GLsizei count, GLuint *samplers);
typedef void (PFNGLDELETESAMPLERSPROC) (GLsizei count, const GLuint *samplers);
typedef GLboolean (PFNGLISSAMPLERPROC) (GLuint sampler);
typedef void (PFNGLBINDSAMPLERPROC) (GLuint unit, GLuint sampler);
typedef void (PFNGLSAMPLERPARAMETERIPROC) (GLuint sampler, GLenum pname, GLint param);
typedef void (PFNGLSAMPLERPARAMETERIVPROC) (GLuint sampler, GLenum pname, const GLint *param);
typedef void (PFNGLSAMPLERPARAMETERFPROC) (GLuint sampler, GLenum pname, GLfloat param);
typedef void (PFNGLSAMPLERPARAMETERFVPROC) (GLuint sampler, GLenum pname, const GLfloat *param);
typedef void (PFNGLSAMPLERPARAMETERIIVPROC) (GLuint sampler, GLenum pname, const GLint *param);
typedef void (PFNGLSAMPLERPARAMETERIUIVPROC) (GLuint sampler, GLenum pname, const GLuint *param);
typedef void (PFNGLGETSAMPLERPARAMETERIVPROC) (GLuint sampler, GLenum pname, GLint *params);
typedef void (PFNGLGETSAMPLERPARAMETERIIVPROC) (GLuint sampler, GLenum pname, GLint *params);
typedef void (PFNGLGETSAMPLERPARAMETERFVPROC) (GLuint sampler, GLenum pname, GLfloat *params);
typedef void (PFNGLGETSAMPLERPARAMETERIUIVPROC) (GLuint sampler, GLenum pname, GLuint *params);
/* #endif */

/* #ifndef GL_ARB_shader_bit_encoding */
enum { GL_ARB_shader_bit_encoding = 1 };
/* #endif */

/* #ifndef GL_ARB_texture_rgb10_a2ui */
enum { GL_ARB_texture_rgb10_a2ui = 1 };
/* #endif */

/* #ifndef GL_ARB_texture_swizzle */
enum { GL_ARB_texture_swizzle = 1 };
/* #endif */

/* #ifndef GL_ARB_timer_query */
enum { GL_ARB_timer_query = 1 };
/* #ifdef GL3_PROTOTYPES */
void glQueryCounter (GLuint id, GLenum target);
void glGetQueryObjecti64v (GLuint id, GLenum pname, GLint64 *params);
void glGetQueryObjectui64v (GLuint id, GLenum pname, GLuint64 *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLQUERYCOUNTERPROC) (GLuint id, GLenum target);
typedef void (PFNGLGETQUERYOBJECTI64VPROC) (GLuint id, GLenum pname, GLint64 *params);
typedef void (PFNGLGETQUERYOBJECTUI64VPROC) (GLuint id, GLenum pname, GLuint64 *params);
/* #endif */

/* #ifndef GL_ARB_vertex_type_2_10_10_10_rev */
enum { GL_ARB_vertex_type_2_10_10_10_rev = 1 };
/* #ifdef GL3_PROTOTYPES */
void glVertexP2ui (GLenum type, GLuint value);
void glVertexP2uiv (GLenum type, const GLuint *value);
void glVertexP3ui (GLenum type, GLuint value);
void glVertexP3uiv (GLenum type, const GLuint *value);
void glVertexP4ui (GLenum type, GLuint value);
void glVertexP4uiv (GLenum type, const GLuint *value);
void glTexCoordP1ui (GLenum type, GLuint coords);
void glTexCoordP1uiv (GLenum type, const GLuint *coords);
void glTexCoordP2ui (GLenum type, GLuint coords);
void glTexCoordP2uiv (GLenum type, const GLuint *coords);
void glTexCoordP3ui (GLenum type, GLuint coords);
void glTexCoordP3uiv (GLenum type, const GLuint *coords);
void glTexCoordP4ui (GLenum type, GLuint coords);
void glTexCoordP4uiv (GLenum type, const GLuint *coords);
void glMultiTexCoordP1ui (GLenum texture, GLenum type, GLuint coords);
void glMultiTexCoordP1uiv (GLenum texture, GLenum type, const GLuint *coords);
void glMultiTexCoordP2ui (GLenum texture, GLenum type, GLuint coords);
void glMultiTexCoordP2uiv (GLenum texture, GLenum type, const GLuint *coords);
void glMultiTexCoordP3ui (GLenum texture, GLenum type, GLuint coords);
void glMultiTexCoordP3uiv (GLenum texture, GLenum type, const GLuint *coords);
void glMultiTexCoordP4ui (GLenum texture, GLenum type, GLuint coords);
void glMultiTexCoordP4uiv (GLenum texture, GLenum type, const GLuint *coords);
void glNormalP3ui (GLenum type, GLuint coords);
void glNormalP3uiv (GLenum type, const GLuint *coords);
void glColorP3ui (GLenum type, GLuint color);
void glColorP3uiv (GLenum type, const GLuint *color);
void glColorP4ui (GLenum type, GLuint color);
void glColorP4uiv (GLenum type, const GLuint *color);
void glSecondaryColorP3ui (GLenum type, GLuint color);
void glSecondaryColorP3uiv (GLenum type, const GLuint *color);
void glVertexAttribP1ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
void glVertexAttribP1uiv (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
void glVertexAttribP2ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
void glVertexAttribP2uiv (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
void glVertexAttribP3ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
void glVertexAttribP3uiv (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
void glVertexAttribP4ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
void glVertexAttribP4uiv (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLVERTEXP2UIPROC) (GLenum type, GLuint value);
typedef void (PFNGLVERTEXP2UIVPROC) (GLenum type, const GLuint *value);
typedef void (PFNGLVERTEXP3UIPROC) (GLenum type, GLuint value);
typedef void (PFNGLVERTEXP3UIVPROC) (GLenum type, const GLuint *value);
typedef void (PFNGLVERTEXP4UIPROC) (GLenum type, GLuint value);
typedef void (PFNGLVERTEXP4UIVPROC) (GLenum type, const GLuint *value);
typedef void (PFNGLTEXCOORDP1UIPROC) (GLenum type, GLuint coords);
typedef void (PFNGLTEXCOORDP1UIVPROC) (GLenum type, const GLuint *coords);
typedef void (PFNGLTEXCOORDP2UIPROC) (GLenum type, GLuint coords);
typedef void (PFNGLTEXCOORDP2UIVPROC) (GLenum type, const GLuint *coords);
typedef void (PFNGLTEXCOORDP3UIPROC) (GLenum type, GLuint coords);
typedef void (PFNGLTEXCOORDP3UIVPROC) (GLenum type, const GLuint *coords);
typedef void (PFNGLTEXCOORDP4UIPROC) (GLenum type, GLuint coords);
typedef void (PFNGLTEXCOORDP4UIVPROC) (GLenum type, const GLuint *coords);
typedef void (PFNGLMULTITEXCOORDP1UIPROC) (GLenum texture, GLenum type, GLuint coords);
typedef void (PFNGLMULTITEXCOORDP1UIVPROC) (GLenum texture, GLenum type, const GLuint *coords);
typedef void (PFNGLMULTITEXCOORDP2UIPROC) (GLenum texture, GLenum type, GLuint coords);
typedef void (PFNGLMULTITEXCOORDP2UIVPROC) (GLenum texture, GLenum type, const GLuint *coords);
typedef void (PFNGLMULTITEXCOORDP3UIPROC) (GLenum texture, GLenum type, GLuint coords);
typedef void (PFNGLMULTITEXCOORDP3UIVPROC) (GLenum texture, GLenum type, const GLuint *coords);
typedef void (PFNGLMULTITEXCOORDP4UIPROC) (GLenum texture, GLenum type, GLuint coords);
typedef void (PFNGLMULTITEXCOORDP4UIVPROC) (GLenum texture, GLenum type, const GLuint *coords);
typedef void (PFNGLNORMALP3UIPROC) (GLenum type, GLuint coords);
typedef void (PFNGLNORMALP3UIVPROC) (GLenum type, const GLuint *coords);
typedef void (PFNGLCOLORP3UIPROC) (GLenum type, GLuint color);
typedef void (PFNGLCOLORP3UIVPROC) (GLenum type, const GLuint *color);
typedef void (PFNGLCOLORP4UIPROC) (GLenum type, GLuint color);
typedef void (PFNGLCOLORP4UIVPROC) (GLenum type, const GLuint *color);
typedef void (PFNGLSECONDARYCOLORP3UIPROC) (GLenum type, GLuint color);
typedef void (PFNGLSECONDARYCOLORP3UIVPROC) (GLenum type, const GLuint *color);
typedef void (PFNGLVERTEXATTRIBP1UIPROC) (GLuint index, GLenum type, GLboolean normalized, GLuint value);
typedef void (PFNGLVERTEXATTRIBP1UIVPROC) (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
typedef void (PFNGLVERTEXATTRIBP2UIPROC) (GLuint index, GLenum type, GLboolean normalized, GLuint value);
typedef void (PFNGLVERTEXATTRIBP2UIVPROC) (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
typedef void (PFNGLVERTEXATTRIBP3UIPROC) (GLuint index, GLenum type, GLboolean normalized, GLuint value);
typedef void (PFNGLVERTEXATTRIBP3UIVPROC) (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
typedef void (PFNGLVERTEXATTRIBP4UIPROC) (GLuint index, GLenum type, GLboolean normalized, GLuint value);
typedef void (PFNGLVERTEXATTRIBP4UIVPROC) (GLuint index, GLenum type, GLboolean normalized, const GLuint *value);
/* #endif */

/* #ifndef GL_ARB_draw_indirect */
enum { GL_ARB_draw_indirect = 1 };
/* #ifdef GL3_PROTOTYPES */
void glDrawArraysIndirect (GLenum mode, const GLvoid *indirect);
void glDrawElementsIndirect (GLenum mode, GLenum type, const GLvoid *indirect);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDRAWARRAYSINDIRECTPROC) (GLenum mode, const GLvoid *indirect);
typedef void (PFNGLDRAWELEMENTSINDIRECTPROC) (GLenum mode, GLenum type, const GLvoid *indirect);
/* #endif */

/* #ifndef GL_ARB_gpu_shader5 */
enum { GL_ARB_gpu_shader5 = 1 };
/* #endif */

/* #ifndef GL_ARB_gpu_shader_fp64 */
enum { GL_ARB_gpu_shader_fp64 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glUniform1d (GLint location, GLdouble x);
void glUniform2d (GLint location, GLdouble x, GLdouble y);
void glUniform3d (GLint location, GLdouble x, GLdouble y, GLdouble z);
void glUniform4d (GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glUniform1dv (GLint location, GLsizei count, const GLdouble *value);
void glUniform2dv (GLint location, GLsizei count, const GLdouble *value);
void glUniform3dv (GLint location, GLsizei count, const GLdouble *value);
void glUniform4dv (GLint location, GLsizei count, const GLdouble *value);
void glUniformMatrix2dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix3dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix4dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix2x3dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix2x4dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix3x2dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix3x4dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix4x2dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glUniformMatrix4x3dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glGetUniformdv (GLuint program, GLint location, GLdouble *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLUNIFORM1DPROC) (GLint location, GLdouble x);
typedef void (PFNGLUNIFORM2DPROC) (GLint location, GLdouble x, GLdouble y);
typedef void (PFNGLUNIFORM3DPROC) (GLint location, GLdouble x, GLdouble y, GLdouble z);
typedef void (PFNGLUNIFORM4DPROC) (GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
typedef void (PFNGLUNIFORM1DVPROC) (GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLUNIFORM2DVPROC) (GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLUNIFORM3DVPROC) (GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLUNIFORM4DVPROC) (GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX2DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX3DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX4DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX2X3DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX2X4DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX3X2DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX3X4DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX4X2DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLUNIFORMMATRIX4X3DVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLGETUNIFORMDVPROC) (GLuint program, GLint location, GLdouble *params);
/* #endif */

/* #ifndef GL_ARB_shader_subroutine */
enum { GL_ARB_shader_subroutine = 1 };
/* #ifdef GL3_PROTOTYPES */
GLint glGetSubroutineUniformLocation (GLuint program, GLenum shadertype, const GLchar *name);
GLuint glGetSubroutineIndex (GLuint program, GLenum shadertype, const GLchar *name);
void glGetActiveSubroutineUniformiv (GLuint program, GLenum shadertype, GLuint index, GLenum pname, GLint *values);
void glGetActiveSubroutineUniformName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name);
void glGetActiveSubroutineName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name);
void glUniformSubroutinesuiv (GLenum shadertype, GLsizei count, const GLuint *indices);
void glGetUniformSubroutineuiv (GLenum shadertype, GLint location, GLuint *params);
void glGetProgramStageiv (GLuint program, GLenum shadertype, GLenum pname, GLint *values);
/* #endif GL3_PROTOTYPES */
typedef GLint (PFNGLGETSUBROUTINEUNIFORMLOCATIONPROC) (GLuint program, GLenum shadertype, const GLchar *name);
typedef GLuint (PFNGLGETSUBROUTINEINDEXPROC) (GLuint program, GLenum shadertype, const GLchar *name);
typedef void (PFNGLGETACTIVESUBROUTINEUNIFORMIVPROC) (GLuint program, GLenum shadertype, GLuint index, GLenum pname, GLint *values);
typedef void (PFNGLGETACTIVESUBROUTINEUNIFORMNAMEPROC) (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name);
typedef void (PFNGLGETACTIVESUBROUTINENAMEPROC) (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name);
typedef void (PFNGLUNIFORMSUBROUTINESUIVPROC) (GLenum shadertype, GLsizei count, const GLuint *indices);
typedef void (PFNGLGETUNIFORMSUBROUTINEUIVPROC) (GLenum shadertype, GLint location, GLuint *params);
typedef void (PFNGLGETPROGRAMSTAGEIVPROC) (GLuint program, GLenum shadertype, GLenum pname, GLint *values);
/* #endif */

/* #ifndef GL_ARB_tessellation_shader */
enum { GL_ARB_tessellation_shader = 1 };
/* #ifdef GL3_PROTOTYPES */
void glPatchParameteri (GLenum pname, GLint value);
void glPatchParameterfv (GLenum pname, const GLfloat *values);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLPATCHPARAMETERIPROC) (GLenum pname, GLint value);
typedef void (PFNGLPATCHPARAMETERFVPROC) (GLenum pname, const GLfloat *values);
/* #endif */

/* #ifndef GL_ARB_texture_buffer_object_rgb32 */
enum { GL_ARB_texture_buffer_object_rgb32 = 1 };
/* #endif */

/* #ifndef GL_ARB_transform_feedback2 */
enum { GL_ARB_transform_feedback2 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBindTransformFeedback (GLenum target, GLuint id);
void glDeleteTransformFeedbacks (GLsizei n, const GLuint *ids);
void glGenTransformFeedbacks (GLsizei n, GLuint *ids);
GLboolean glIsTransformFeedback (GLuint id);
void glPauseTransformFeedback (void);
void glResumeTransformFeedback (void);
void glDrawTransformFeedback (GLenum mode, GLuint id);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBINDTRANSFORMFEEDBACKPROC) (GLenum target, GLuint id);
typedef void (PFNGLDELETETRANSFORMFEEDBACKSPROC) (GLsizei n, const GLuint *ids);
typedef void (PFNGLGENTRANSFORMFEEDBACKSPROC) (GLsizei n, GLuint *ids);
typedef GLboolean (PFNGLISTRANSFORMFEEDBACKPROC) (GLuint id);
typedef void (PFNGLPAUSETRANSFORMFEEDBACKPROC) (void);
typedef void (PFNGLRESUMETRANSFORMFEEDBACKPROC) (void);
typedef void (PFNGLDRAWTRANSFORMFEEDBACKPROC) (GLenum mode, GLuint id);
/* #endif */

/* #ifndef GL_ARB_transform_feedback3 */
enum { GL_ARB_transform_feedback3 = 1 };
/* #ifdef GL3_PROTOTYPES */
void glDrawTransformFeedbackStream (GLenum mode, GLuint id, GLuint stream);
void glBeginQueryIndexed (GLenum target, GLuint index, GLuint id);
void glEndQueryIndexed (GLenum target, GLuint index);
void glGetQueryIndexediv (GLenum target, GLuint index, GLenum pname, GLint *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDRAWTRANSFORMFEEDBACKSTREAMPROC) (GLenum mode, GLuint id, GLuint stream);
typedef void (PFNGLBEGINQUERYINDEXEDPROC) (GLenum target, GLuint index, GLuint id);
typedef void (PFNGLENDQUERYINDEXEDPROC) (GLenum target, GLuint index);
typedef void (PFNGLGETQUERYINDEXEDIVPROC) (GLenum target, GLuint index, GLenum pname, GLint *params);
/* #endif */

/* #ifndef GL_ARB_ES2_compatibility */
enum { GL_ARB_ES2_compatibility = 1 };
/* #ifdef GL3_PROTOTYPES */
void glReleaseShaderCompiler (void);
void glShaderBinary (GLsizei count, const GLuint *shaders, GLenum binaryformat, const GLvoid *binary, GLsizei length);
void glGetShaderPrecisionFormat (GLenum shadertype, GLenum precisiontype, GLint *range, GLint *precision);
void glDepthRangef (GLclampf n, GLclampf f);
void glClearDepthf (GLclampf d);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLRELEASESHADERCOMPILERPROC) (void);
typedef void (PFNGLSHADERBINARYPROC) (GLsizei count, const GLuint *shaders, GLenum binaryformat, const GLvoid *binary, GLsizei length);
typedef void (PFNGLGETSHADERPRECISIONFORMATPROC) (GLenum shadertype, GLenum precisiontype, GLint *range, GLint *precision);
typedef void (PFNGLDEPTHRANGEFPROC) (GLclampf n, GLclampf f);
typedef void (PFNGLCLEARDEPTHFPROC) (GLclampf d);
/* #endif */

/* #ifndef GL_ARB_get_program_binary */
enum { GL_ARB_get_program_binary = 1 };
/* #ifdef GL3_PROTOTYPES */
void glGetProgramBinary (GLuint program, GLsizei bufSize, GLsizei *length, GLenum *binaryFormat, GLvoid *binary);
void glProgramBinary (GLuint program, GLenum binaryFormat, const GLvoid *binary, GLsizei length);
void glProgramParameteri (GLuint program, GLenum pname, GLint value);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLGETPROGRAMBINARYPROC) (GLuint program, GLsizei bufSize, GLsizei *length, GLenum *binaryFormat, GLvoid *binary);
typedef void (PFNGLPROGRAMBINARYPROC) (GLuint program, GLenum binaryFormat, const GLvoid *binary, GLsizei length);
typedef void (PFNGLPROGRAMPARAMETERIPROC) (GLuint program, GLenum pname, GLint value);
/* #endif */

/* #ifndef GL_ARB_separate_shader_objects */
enum { GL_ARB_separate_shader_objects = 1 };
/* #ifdef GL3_PROTOTYPES */
void glUseProgramStages (GLuint pipeline, GLbitfield stages, GLuint program);
void glActiveShaderProgram (GLuint pipeline, GLuint program);
GLuint glCreateShaderProgramv (GLenum type, GLsizei count, const GLchar* *strings);
void glBindProgramPipeline (GLuint pipeline);
void glDeleteProgramPipelines (GLsizei n, const GLuint *pipelines);
void glGenProgramPipelines (GLsizei n, GLuint *pipelines);
GLboolean glIsProgramPipeline (GLuint pipeline);
void glGetProgramPipelineiv (GLuint pipeline, GLenum pname, GLint *params);
void glProgramUniform1i (GLuint program, GLint location, GLint v0);
void glProgramUniform1iv (GLuint program, GLint location, GLsizei count, const GLint *value);
void glProgramUniform1f (GLuint program, GLint location, GLfloat v0);
void glProgramUniform1fv (GLuint program, GLint location, GLsizei count, const GLfloat *value);
void glProgramUniform1d (GLuint program, GLint location, GLdouble v0);
void glProgramUniform1dv (GLuint program, GLint location, GLsizei count, const GLdouble *value);
void glProgramUniform1ui (GLuint program, GLint location, GLuint v0);
void glProgramUniform1uiv (GLuint program, GLint location, GLsizei count, const GLuint *value);
void glProgramUniform2i (GLuint program, GLint location, GLint v0, GLint v1);
void glProgramUniform2iv (GLuint program, GLint location, GLsizei count, const GLint *value);
void glProgramUniform2f (GLuint program, GLint location, GLfloat v0, GLfloat v1);
void glProgramUniform2fv (GLuint program, GLint location, GLsizei count, const GLfloat *value);
void glProgramUniform2d (GLuint program, GLint location, GLdouble v0, GLdouble v1);
void glProgramUniform2dv (GLuint program, GLint location, GLsizei count, const GLdouble *value);
void glProgramUniform2ui (GLuint program, GLint location, GLuint v0, GLuint v1);
void glProgramUniform2uiv (GLuint program, GLint location, GLsizei count, const GLuint *value);
void glProgramUniform3i (GLuint program, GLint location, GLint v0, GLint v1, GLint v2);
void glProgramUniform3iv (GLuint program, GLint location, GLsizei count, const GLint *value);
void glProgramUniform3f (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
void glProgramUniform3fv (GLuint program, GLint location, GLsizei count, const GLfloat *value);
void glProgramUniform3d (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2);
void glProgramUniform3dv (GLuint program, GLint location, GLsizei count, const GLdouble *value);
void glProgramUniform3ui (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2);
void glProgramUniform3uiv (GLuint program, GLint location, GLsizei count, const GLuint *value);
void glProgramUniform4i (GLuint program, GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
void glProgramUniform4iv (GLuint program, GLint location, GLsizei count, const GLint *value);
void glProgramUniform4f (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
void glProgramUniform4fv (GLuint program, GLint location, GLsizei count, const GLfloat *value);
void glProgramUniform4d (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2, GLdouble v3);
void glProgramUniform4dv (GLuint program, GLint location, GLsizei count, const GLdouble *value);
void glProgramUniform4ui (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
void glProgramUniform4uiv (GLuint program, GLint location, GLsizei count, const GLuint *value);
void glProgramUniformMatrix2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix2x3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix3x2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix2x4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix4x2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix3x4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix4x3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glProgramUniformMatrix2x3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix3x2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix2x4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix4x2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix3x4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glProgramUniformMatrix4x3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
void glValidateProgramPipeline (GLuint pipeline);
void glGetProgramPipelineInfoLog (GLuint pipeline, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLUSEPROGRAMSTAGESPROC) (GLuint pipeline, GLbitfield stages, GLuint program);
typedef void (PFNGLACTIVESHADERPROGRAMPROC) (GLuint pipeline, GLuint program);
typedef GLuint (PFNGLCREATESHADERPROGRAMVPROC) (GLenum type, GLsizei count, const GLchar* *strings);
typedef void (PFNGLBINDPROGRAMPIPELINEPROC) (GLuint pipeline);
typedef void (PFNGLDELETEPROGRAMPIPELINESPROC) (GLsizei n, const GLuint *pipelines);
typedef void (PFNGLGENPROGRAMPIPELINESPROC) (GLsizei n, GLuint *pipelines);
typedef GLboolean (PFNGLISPROGRAMPIPELINEPROC) (GLuint pipeline);
typedef void (PFNGLGETPROGRAMPIPELINEIVPROC) (GLuint pipeline, GLenum pname, GLint *params);
typedef void (PFNGLPROGRAMUNIFORM1IPROC) (GLuint program, GLint location, GLint v0);
typedef void (PFNGLPROGRAMUNIFORM1IVPROC) (GLuint program, GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLPROGRAMUNIFORM1FPROC) (GLuint program, GLint location, GLfloat v0);
typedef void (PFNGLPROGRAMUNIFORM1FVPROC) (GLuint program, GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORM1DPROC) (GLuint program, GLint location, GLdouble v0);
typedef void (PFNGLPROGRAMUNIFORM1DVPROC) (GLuint program, GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORM1UIPROC) (GLuint program, GLint location, GLuint v0);
typedef void (PFNGLPROGRAMUNIFORM1UIVPROC) (GLuint program, GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLPROGRAMUNIFORM2IPROC) (GLuint program, GLint location, GLint v0, GLint v1);
typedef void (PFNGLPROGRAMUNIFORM2IVPROC) (GLuint program, GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLPROGRAMUNIFORM2FPROC) (GLuint program, GLint location, GLfloat v0, GLfloat v1);
typedef void (PFNGLPROGRAMUNIFORM2FVPROC) (GLuint program, GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORM2DPROC) (GLuint program, GLint location, GLdouble v0, GLdouble v1);
typedef void (PFNGLPROGRAMUNIFORM2DVPROC) (GLuint program, GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORM2UIPROC) (GLuint program, GLint location, GLuint v0, GLuint v1);
typedef void (PFNGLPROGRAMUNIFORM2UIVPROC) (GLuint program, GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLPROGRAMUNIFORM3IPROC) (GLuint program, GLint location, GLint v0, GLint v1, GLint v2);
typedef void (PFNGLPROGRAMUNIFORM3IVPROC) (GLuint program, GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLPROGRAMUNIFORM3FPROC) (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
typedef void (PFNGLPROGRAMUNIFORM3FVPROC) (GLuint program, GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORM3DPROC) (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2);
typedef void (PFNGLPROGRAMUNIFORM3DVPROC) (GLuint program, GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORM3UIPROC) (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2);
typedef void (PFNGLPROGRAMUNIFORM3UIVPROC) (GLuint program, GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLPROGRAMUNIFORM4IPROC) (GLuint program, GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
typedef void (PFNGLPROGRAMUNIFORM4IVPROC) (GLuint program, GLint location, GLsizei count, const GLint *value);
typedef void (PFNGLPROGRAMUNIFORM4FPROC) (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
typedef void (PFNGLPROGRAMUNIFORM4FVPROC) (GLuint program, GLint location, GLsizei count, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORM4DPROC) (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2, GLdouble v3);
typedef void (PFNGLPROGRAMUNIFORM4DVPROC) (GLuint program, GLint location, GLsizei count, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORM4UIPROC) (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
typedef void (PFNGLPROGRAMUNIFORM4UIVPROC) (GLuint program, GLint location, GLsizei count, const GLuint *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX2FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX3FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX4FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX2DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX3DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX4DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX2X3FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX3X2FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX2X4FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX4X2FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX3X4FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX4X3FVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX2X3DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX3X2DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX2X4DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX4X2DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX3X4DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLPROGRAMUNIFORMMATRIX4X3DVPROC) (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value);
typedef void (PFNGLVALIDATEPROGRAMPIPELINEPROC) (GLuint pipeline);
typedef void (PFNGLGETPROGRAMPIPELINEINFOLOGPROC) (GLuint pipeline, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
/* #endif */

/* #ifndef GL_ARB_vertex_attrib_64bit */
enum { GL_ARB_vertex_attrib_64bit = 1 };
/* #ifdef GL3_PROTOTYPES */
void glVertexAttribL1d (GLuint index, GLdouble x);
void glVertexAttribL2d (GLuint index, GLdouble x, GLdouble y);
void glVertexAttribL3d (GLuint index, GLdouble x, GLdouble y, GLdouble z);
void glVertexAttribL4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glVertexAttribL1dv (GLuint index, const GLdouble *v);
void glVertexAttribL2dv (GLuint index, const GLdouble *v);
void glVertexAttribL3dv (GLuint index, const GLdouble *v);
void glVertexAttribL4dv (GLuint index, const GLdouble *v);
void glVertexAttribLPointer (GLuint index, GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glGetVertexAttribLdv (GLuint index, GLenum pname, GLdouble *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLVERTEXATTRIBL1DPROC) (GLuint index, GLdouble x);
typedef void (PFNGLVERTEXATTRIBL2DPROC) (GLuint index, GLdouble x, GLdouble y);
typedef void (PFNGLVERTEXATTRIBL3DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z);
typedef void (PFNGLVERTEXATTRIBL4DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
typedef void (PFNGLVERTEXATTRIBL1DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIBL2DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIBL3DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIBL4DVPROC) (GLuint index, const GLdouble *v);
typedef void (PFNGLVERTEXATTRIBLPOINTERPROC) (GLuint index, GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
typedef void (PFNGLGETVERTEXATTRIBLDVPROC) (GLuint index, GLenum pname, GLdouble *params);
/* #endif */

/* #ifndef GL_ARB_viewport_array */
enum { GL_ARB_viewport_array = 1 };
/* #ifdef GL3_PROTOTYPES */
void glViewportArrayv (GLuint first, GLsizei count, const GLfloat *v);
void glViewportIndexedf (GLuint index, GLfloat x, GLfloat y, GLfloat w, GLfloat h);
void glViewportIndexedfv (GLuint index, const GLfloat *v);
void glScissorArrayv (GLuint first, GLsizei count, const GLint *v);
void glScissorIndexed (GLuint index, GLint left, GLint bottom, GLsizei width, GLsizei height);
void glScissorIndexedv (GLuint index, const GLint *v);
void glDepthRangeArrayv (GLuint first, GLsizei count, const GLclampd *v);
void glDepthRangeIndexed (GLuint index, GLclampd n, GLclampd f);
void glGetFloati_v (GLenum target, GLuint index, GLfloat *data);
void glGetDoublei_v (GLenum target, GLuint index, GLdouble *data);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLVIEWPORTARRAYVPROC) (GLuint first, GLsizei count, const GLfloat *v);
typedef void (PFNGLVIEWPORTINDEXEDFPROC) (GLuint index, GLfloat x, GLfloat y, GLfloat w, GLfloat h);
typedef void (PFNGLVIEWPORTINDEXEDFVPROC) (GLuint index, const GLfloat *v);
typedef void (PFNGLSCISSORARRAYVPROC) (GLuint first, GLsizei count, const GLint *v);
typedef void (PFNGLSCISSORINDEXEDPROC) (GLuint index, GLint left, GLint bottom, GLsizei width, GLsizei height);
typedef void (PFNGLSCISSORINDEXEDVPROC) (GLuint index, const GLint *v);
typedef void (PFNGLDEPTHRANGEARRAYVPROC) (GLuint first, GLsizei count, const GLclampd *v);
typedef void (PFNGLDEPTHRANGEINDEXEDPROC) (GLuint index, GLclampd n, GLclampd f);
typedef void (PFNGLGETFLOATI_VPROC) (GLenum target, GLuint index, GLfloat *data);
typedef void (PFNGLGETDOUBLEI_VPROC) (GLenum target, GLuint index, GLdouble *data);
/* #endif */

/* #ifndef GL_ARB_cl_event */
enum { GL_ARB_cl_event = 1 };
/* #ifdef GL3_PROTOTYPES */
GLsync glCreateSyncFromCLeventARB (struct _cl_context * context, struct _cl_event * event, GLbitfield flags);
/* #endif GL3_PROTOTYPES */
typedef GLsync (PFNGLCREATESYNCFROMCLEVENTARBPROC) (struct _cl_context * context, struct _cl_event * event, GLbitfield flags);
/* #endif */

/* #ifndef GL_ARB_debug_output */
enum { GL_ARB_debug_output = 1 };
/* #ifdef GL3_PROTOTYPES */
void glDebugMessageControlARB (GLenum source, GLenum type, GLenum severity, GLsizei count, const GLuint *ids, GLboolean enabled);
void glDebugMessageInsertARB (GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar *buf);
void glDebugMessageCallbackARB (GLDEBUGPROCARB callback, const GLvoid *userParam);
GLuint glGetDebugMessageLogARB (GLuint count, GLsizei bufsize, GLenum *sources, GLenum *types, GLuint *ids, GLenum *severities, GLsizei *lengths, GLchar *messageLog);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDEBUGMESSAGECONTROLARBPROC) (GLenum source, GLenum type, GLenum severity, GLsizei count, const GLuint *ids, GLboolean enabled);
typedef void (PFNGLDEBUGMESSAGEINSERTARBPROC) (GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar *buf);
typedef void (PFNGLDEBUGMESSAGECALLBACKARBPROC) (GLDEBUGPROCARB callback, const GLvoid *userParam);
typedef GLuint (PFNGLGETDEBUGMESSAGELOGARBPROC) (GLuint count, GLsizei bufsize, GLenum *sources, GLenum *types, GLuint *ids, GLenum *severities, GLsizei *lengths, GLchar *messageLog);
/* #endif */

/* #ifndef GL_ARB_robustness */
enum { GL_ARB_robustness = 1 };
/* #ifdef GL3_PROTOTYPES */
GLenum glGetGraphicsResetStatusARB (void);
void glGetnMapdvARB (GLenum target, GLenum query, GLsizei bufSize, GLdouble *v);
void glGetnMapfvARB (GLenum target, GLenum query, GLsizei bufSize, GLfloat *v);
void glGetnMapivARB (GLenum target, GLenum query, GLsizei bufSize, GLint *v);
void glGetnPixelMapfvARB (GLenum map, GLsizei bufSize, GLfloat *values);
void glGetnPixelMapuivARB (GLenum map, GLsizei bufSize, GLuint *values);
void glGetnPixelMapusvARB (GLenum map, GLsizei bufSize, GLushort *values);
void glGetnPolygonStippleARB (GLsizei bufSize, GLubyte *pattern);
void glGetnColorTableARB (GLenum target, GLenum format, GLenum type, GLsizei bufSize, GLvoid *table);
void glGetnConvolutionFilterARB (GLenum target, GLenum format, GLenum type, GLsizei bufSize, GLvoid *image);
void glGetnSeparableFilterARB (GLenum target, GLenum format, GLenum type, GLsizei rowBufSize, GLvoid *row, GLsizei columnBufSize, GLvoid *column, GLvoid *span);
void glGetnHistogramARB (GLenum target, GLboolean reset, GLenum format, GLenum type, GLsizei bufSize, GLvoid *values);
void glGetnMinmaxARB (GLenum target, GLboolean reset, GLenum format, GLenum type, GLsizei bufSize, GLvoid *values);
void glGetnTexImageARB (GLenum target, GLint level, GLenum format, GLenum type, GLsizei bufSize, GLvoid *img);
void glReadnPixelsARB (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLsizei bufSize, GLvoid *data);
void glGetnCompressedTexImageARB (GLenum target, GLint lod, GLsizei bufSize, GLvoid *img);
void glGetnUniformfvARB (GLuint program, GLint location, GLsizei bufSize, GLfloat *params);
void glGetnUniformivARB (GLuint program, GLint location, GLsizei bufSize, GLint *params);
void glGetnUniformuivARB (GLuint program, GLint location, GLsizei bufSize, GLuint *params);
void glGetnUniformdvARB (GLuint program, GLint location, GLsizei bufSize, GLdouble *params);
/* #endif GL3_PROTOTYPES */
typedef GLenum (PFNGLGETGRAPHICSRESETSTATUSARBPROC) (void);
typedef void (PFNGLGETNMAPDVARBPROC) (GLenum target, GLenum query, GLsizei bufSize, GLdouble *v);
typedef void (PFNGLGETNMAPFVARBPROC) (GLenum target, GLenum query, GLsizei bufSize, GLfloat *v);
typedef void (PFNGLGETNMAPIVARBPROC) (GLenum target, GLenum query, GLsizei bufSize, GLint *v);
typedef void (PFNGLGETNPIXELMAPFVARBPROC) (GLenum map, GLsizei bufSize, GLfloat *values);
typedef void (PFNGLGETNPIXELMAPUIVARBPROC) (GLenum map, GLsizei bufSize, GLuint *values);
typedef void (PFNGLGETNPIXELMAPUSVARBPROC) (GLenum map, GLsizei bufSize, GLushort *values);
typedef void (PFNGLGETNPOLYGONSTIPPLEARBPROC) (GLsizei bufSize, GLubyte *pattern);
typedef void (PFNGLGETNCOLORTABLEARBPROC) (GLenum target, GLenum format, GLenum type, GLsizei bufSize, GLvoid *table);
typedef void (PFNGLGETNCONVOLUTIONFILTERARBPROC) (GLenum target, GLenum format, GLenum type, GLsizei bufSize, GLvoid *image);
typedef void (PFNGLGETNSEPARABLEFILTERARBPROC) (GLenum target, GLenum format, GLenum type, GLsizei rowBufSize, GLvoid *row, GLsizei columnBufSize, GLvoid *column, GLvoid *span);
typedef void (PFNGLGETNHISTOGRAMARBPROC) (GLenum target, GLboolean reset, GLenum format, GLenum type, GLsizei bufSize, GLvoid *values);
typedef void (PFNGLGETNMINMAXARBPROC) (GLenum target, GLboolean reset, GLenum format, GLenum type, GLsizei bufSize, GLvoid *values);
typedef void (PFNGLGETNTEXIMAGEARBPROC) (GLenum target, GLint level, GLenum format, GLenum type, GLsizei bufSize, GLvoid *img);
typedef void (PFNGLREADNPIXELSARBPROC) (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLsizei bufSize, GLvoid *data);
typedef void (PFNGLGETNCOMPRESSEDTEXIMAGEARBPROC) (GLenum target, GLint lod, GLsizei bufSize, GLvoid *img);
typedef void (PFNGLGETNUNIFORMFVARBPROC) (GLuint program, GLint location, GLsizei bufSize, GLfloat *params);
typedef void (PFNGLGETNUNIFORMIVARBPROC) (GLuint program, GLint location, GLsizei bufSize, GLint *params);
typedef void (PFNGLGETNUNIFORMUIVARBPROC) (GLuint program, GLint location, GLsizei bufSize, GLuint *params);
typedef void (PFNGLGETNUNIFORMDVARBPROC) (GLuint program, GLint location, GLsizei bufSize, GLdouble *params);
/* #endif */

/* #ifndef GL_ARB_shader_stencil_export */
enum { GL_ARB_shader_stencil_export = 1 };
/* #endif */

/* #ifndef GL_ARB_base_instance */
enum { GL_ARB_base_instance = 1 };
/* #ifdef GL3_PROTOTYPES */
void glDrawArraysInstancedBaseInstance (GLenum mode, GLint first, GLsizei count, GLsizei primcount, GLuint baseinstance);
void glDrawElementsInstancedBaseInstance (GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount, GLuint baseinstance);
void glDrawElementsInstancedBaseVertexBaseInstance (GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount, GLint basevertex, GLuint baseinstance);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDRAWARRAYSINSTANCEDBASEINSTANCEPROC) (GLenum mode, GLint first, GLsizei count, GLsizei primcount, GLuint baseinstance);
typedef void (PFNGLDRAWELEMENTSINSTANCEDBASEINSTANCEPROC) (GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount, GLuint baseinstance);
typedef void (PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXBASEINSTANCEPROC) (GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount, GLint basevertex, GLuint baseinstance);
/* #endif */

/* #ifndef GL_ARB_shading_language_420pack */
enum { GL_ARB_shading_language_420pack = 1 };
/* #endif */

/* #ifndef GL_ARB_transform_feedback_instanced */
enum { GL_ARB_transform_feedback_instanced = 1 };
/* #ifdef GL3_PROTOTYPES */
void glDrawTransformFeedbackInstanced (GLenum mode, GLuint id, GLsizei primcount);
void glDrawTransformFeedbackStreamInstanced (GLenum mode, GLuint id, GLuint stream, GLsizei primcount);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLDRAWTRANSFORMFEEDBACKINSTANCEDPROC) (GLenum mode, GLuint id, GLsizei primcount);
typedef void (PFNGLDRAWTRANSFORMFEEDBACKSTREAMINSTANCEDPROC) (GLenum mode, GLuint id, GLuint stream, GLsizei primcount);
/* #endif */

/* #ifndef GL_ARB_compressed_texture_pixel_storage */
enum { GL_ARB_compressed_texture_pixel_storage = 1 };
/* #endif */

/* #ifndef GL_ARB_conservative_depth */
enum { GL_ARB_conservative_depth = 1 };
/* #endif */

/* #ifndef GL_ARB_internalformat_query */
enum { GL_ARB_internalformat_query = 1 };
/* #ifdef GL3_PROTOTYPES */
void glGetInternalformativ (GLenum target, GLenum internalformat, GLenum pname, GLsizei bufSize, GLint *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLGETINTERNALFORMATIVPROC) (GLenum target, GLenum internalformat, GLenum pname, GLsizei bufSize, GLint *params);
/* #endif */

/* #ifndef GL_ARB_map_buffer_alignment */
enum { GL_ARB_map_buffer_alignment = 1 };
/* #endif */

/* #ifndef GL_ARB_shader_atomic_counters */
enum { GL_ARB_shader_atomic_counters = 1 };
/* #ifdef GL3_PROTOTYPES */
void glGetActiveAtomicCounterBufferiv (GLuint program, GLuint bufferIndex, GLenum pname, GLint *params);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLGETACTIVEATOMICCOUNTERBUFFERIVPROC) (GLuint program, GLuint bufferIndex, GLenum pname, GLint *params);
/* #endif */

/* #ifndef GL_ARB_shader_image_load_store */
enum { GL_ARB_shader_image_load_store = 1 };
/* #ifdef GL3_PROTOTYPES */
void glBindImageTexture (GLuint unit, GLuint texture, GLint level, GLboolean layered, GLint layer, GLenum access, GLenum format);
void glMemoryBarrier (GLbitfield barriers);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLBINDIMAGETEXTUREPROC) (GLuint unit, GLuint texture, GLint level, GLboolean layered, GLint layer, GLenum access, GLenum format);
typedef void (PFNGLMEMORYBARRIERPROC) (GLbitfield barriers);
/* #endif */

/* #ifndef GL_ARB_shading_language_packing */
enum { GL_ARB_shading_language_packing = 1 };
/* #endif */

/* #ifndef GL_ARB_texture_storage */
enum { GL_ARB_texture_storage = 1 };
/* #ifdef GL3_PROTOTYPES */
void glTexStorage1D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width);
void glTexStorage2D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height);
void glTexStorage3D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth);
void glTextureStorage1DEXT (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width);
void glTextureStorage2DEXT (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height);
void glTextureStorage3DEXT (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth);
/* #endif GL3_PROTOTYPES */
typedef void (PFNGLTEXSTORAGE1DPROC) (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width);
typedef void (PFNGLTEXSTORAGE2DPROC) (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (PFNGLTEXSTORAGE3DPROC) (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth);
typedef void (PFNGLTEXTURESTORAGE1DEXTPROC) (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width);
typedef void (PFNGLTEXTURESTORAGE2DEXTPROC) (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (PFNGLTEXTURESTORAGE3DEXTPROC) (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth);
/* #endif */
]]

return ffi.load(ffi.os == 'OSX' and 'OpenGL.framework/OpenGL' or 'GL')
