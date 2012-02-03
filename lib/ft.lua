-- Core FreeType implenentation for LuaJIT FFI
--
-- Copyright 1996-2011 by
-- David Turner, Robert Wilhelm, and Werner Lemberg.
--
-- This file is part of the FreeType project, and may only be used,
-- modified, and distributed under the terms of the FreeType project
-- license, LICENSE.TXT.  By continuing to use, modify, or distribute
-- this file you indicate that you have read the license and
-- understand and accept it fully.

local ffi = require 'ffi'
local bit = require 'bit'

ffi.cdef [[
// ftconfig.h
typedef int32_t  FT_Int32;
typedef uint32_t FT_UInt32;

// fttypes.h
typedef unsigned char  FT_Bool;
typedef signed short   FT_FWord;   /* distance in FUnits */
typedef unsigned short FT_UFWord;  /* unsigned distance */
typedef signed char    FT_Char;
typedef unsigned char  FT_Byte;
typedef const FT_Byte* FT_Bytes;
typedef FT_UInt32      FT_Tag;
typedef char           FT_String;
typedef signed short   FT_Short;
typedef unsigned short FT_UShort;
typedef signed int     FT_Int;
typedef unsigned int   FT_UInt;
typedef signed long    FT_Long;
typedef unsigned long  FT_ULong;
typedef signed short   FT_F2Dot14;
typedef signed long    FT_F26Dot6;
typedef signed long    FT_Fixed;
typedef int            FT_Error;
typedef void*          FT_Pointer;
typedef size_t         FT_Offset;
typedef ptrdiff_t      FT_PtrDist;
typedef struct         FT_UnitVector_
{
  FT_F2Dot14  x;
  FT_F2Dot14  y;
} FT_UnitVector;
typedef struct FT_Matrix_
{
  FT_Fixed  xx, xy;
  FT_Fixed  yx, yy;
} FT_Matrix;
typedef struct FT_Data_
{
  const FT_Byte*  pointer;
  FT_Int          length;
} FT_Data;
typedef void  (*FT_Generic_Finalizer)(void*  object);
typedef struct  FT_Generic_
{
  void*                 data;
  FT_Generic_Finalizer  finalizer;
} FT_Generic;
typedef struct FT_ListNodeRec_*  FT_ListNode;
typedef struct FT_ListRec_*      FT_List;
typedef struct FT_ListNodeRec_
{
  FT_ListNode  prev;
  FT_ListNode  next;
  void*        data;
} FT_ListNodeRec;
typedef struct FT_ListRec_
{
  FT_ListNode  head;
  FT_ListNode  tail;
} FT_ListRec;

// ftsystem.h
typedef struct FT_MemoryRec_* FT_Memory;
typedef struct FT_StreamRec_* FT_Stream;

// ftimage.h
typedef signed long FT_Pos;
typedef struct FT_Vector_
{
  FT_Pos  x;
  FT_Pos  y;
} FT_Vector;
typedef struct FT_BBox_
{
  FT_Pos  xMin, yMin;
  FT_Pos  xMax, yMax;
} FT_BBox;
typedef enum FT_Pixel_Mode_
{
  FT_PIXEL_MODE_NONE = 0,
  FT_PIXEL_MODE_MONO,
  FT_PIXEL_MODE_GRAY,
  FT_PIXEL_MODE_GRAY2,
  FT_PIXEL_MODE_GRAY4,
  FT_PIXEL_MODE_LCD,
  FT_PIXEL_MODE_LCD_V,
  FT_PIXEL_MODE_MAX      /* do not remove */
} FT_Pixel_Mode;
typedef struct FT_Bitmap_
{
  int             rows;
  int             width;
  int             pitch;
  unsigned char*  buffer;
  short           num_grays;
  char            pixel_mode;
  char            palette_mode;
  void*           palette;
} FT_Bitmap;
typedef struct  FT_Outline_
{
  short       n_contours;      /* number of contours in glyph        */
  short       n_points;        /* number of points in the glyph      */
  FT_Vector*  points;          /* the outline's points               */
  char*       tags;            /* the points flags                   */
  short*      contours;        /* the contour end points             */
  int         flags;           /* outline masks                      */
} FT_Outline;

// freetype.h
typedef struct FT_Glyph_Metrics_
{
  FT_Pos  width;
  FT_Pos  height;
  FT_Pos  horiBearingX;
  FT_Pos  horiBearingY;
  FT_Pos  horiAdvance;
  FT_Pos  vertBearingX;
  FT_Pos  vertBearingY;
  FT_Pos  vertAdvance;
} FT_Glyph_Metrics;
typedef struct FT_Bitmap_Size_
{
  FT_Short  height;
  FT_Short  width;
  FT_Pos    size;
  FT_Pos    x_ppem;
  FT_Pos    y_ppem;
} FT_Bitmap_Size;
typedef struct FT_LibraryRec_*   FT_Library;
typedef struct FT_ModuleRec_*    FT_Module;
typedef struct FT_DriverRec_*    FT_Driver;
typedef struct FT_RendererRec_*  FT_Renderer;
typedef struct FT_FaceRec_*      FT_Face;
typedef struct FT_SizeRec_*      FT_Size;
typedef struct FT_GlyphSlotRec_* FT_GlyphSlot;
typedef struct FT_CharMapRec_*   FT_CharMap;
typedef struct FT_Face_InternalRec_* FT_Face_Internal;
typedef struct FT_SubGlyphRec_*  FT_SubGlyph;
typedef struct FT_Slot_InternalRec_*  FT_Slot_Internal;
typedef struct FT_FaceRec_
{
  FT_Long           num_faces;
  FT_Long           face_index;
  FT_Long           face_flags;
  FT_Long           style_flags;
  FT_Long           num_glyphs;
  FT_String*        family_name;
  FT_String*        style_name;
  FT_Int            num_fixed_sizes;
  FT_Bitmap_Size*   available_sizes;
  FT_Int            num_charmaps;
  FT_CharMap*       charmaps;
  FT_Generic        generic;
  FT_BBox           bbox;
  FT_UShort         units_per_EM;
  FT_Short          ascender;
  FT_Short          descender;
  FT_Short          height;
  FT_Short          max_advance_width;
  FT_Short          max_advance_height;
  FT_Short          underline_position;
  FT_Short          underline_thickness;
  FT_GlyphSlot      glyph;
  FT_Size           size;
  FT_CharMap        charmap;
  /*@private begin */
  FT_Driver         driver;
  FT_Memory         memory;
  FT_Stream         stream;
  FT_ListRec        sizes_list;
  FT_Generic        autohint;
  void*             extensions;
  FT_Face_Internal  internal;
  /*@private end */
} FT_FaceRec;
typedef enum FT_Glyph_Format_
{
  FT_GLYPH_FORMAT_NONE = 0
} FT_Glyph_Format;
typedef struct  FT_GlyphSlotRec_
{
  FT_Library        library;
  FT_Face           face;
  FT_GlyphSlot      next;
  FT_UInt           reserved;       /* retained for binary compatibility */
  FT_Generic        generic;
  FT_Glyph_Metrics  metrics;
  FT_Fixed          linearHoriAdvance;
  FT_Fixed          linearVertAdvance;
  FT_Vector         advance;
  FT_Glyph_Format   format;
  FT_Bitmap         bitmap;
  FT_Int            bitmap_left;
  FT_Int            bitmap_top;
  FT_Outline        outline;
  FT_UInt           num_subglyphs;
  FT_SubGlyph       subglyphs;
  void*             control_data;
  long              control_len;
  FT_Pos            lsb_delta;
  FT_Pos            rsb_delta;
  void*             other;
  FT_Slot_Internal  internal;
} FT_GlyphSlotRec;
// constants
typedef enum FT_Kerning_Mode_
{
  FT_KERNING_DEFAULT  = 0,
  FT_KERNING_UNFITTED,
  FT_KERNING_UNSCALED
} FT_Kerning_Mode;
enum {
  FT_LOAD_DEFAULT                      = 0x0,
  FT_LOAD_NO_SCALE                     = 0x1,
  FT_LOAD_NO_HINTING                   = 0x2,
  FT_LOAD_RENDER                       = 0x4,
  FT_LOAD_NO_BITMAP                    = 0x8,
  FT_LOAD_VERTICAL_LAYOUT              = 0x10,
  FT_LOAD_FORCE_AUTOHINT               = 0x20,
  FT_LOAD_CROP_BITMAP                  = 0x40,
  FT_LOAD_PEDANTIC                     = 0x80,
  FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH  = 0x200,
  FT_LOAD_NO_RECURSE                   = 0x400,
  FT_LOAD_IGNORE_TRANSFORM             = 0x800,
  FT_LOAD_MONOCHROME                   = 0x1000,
  FT_LOAD_LINEAR_DESIGN                = 0x2000,
  FT_LOAD_NO_AUTOHINT                  = 0x8000U,
  /* used internally only by certain font drivers! */
  FT_LOAD_ADVANCE_ONLY                 = 0x100,
  FT_LOAD_SBITS_ONLY                   = 0x4000,
  /* ported from FT_LOAD_TARGET_(x) macro */
  FT_LOAD_TARGET_NORMAL                = 0x00000,
  FT_LOAD_TARGET_LIGHT                 = 0x10000,
  FT_LOAD_TARGET_MONO                  = 0x20000,
  FT_LOAD_TARGET_LCD                   = 0x30000,
  FT_LOAD_TARGET_LCD_V                 = 0x40000
};
typedef enum FT_Render_Mode_
{
  FT_RENDER_MODE_NORMAL = 0,
  FT_RENDER_MODE_LIGHT,
  FT_RENDER_MODE_MONO,
  FT_RENDER_MODE_LCD,
  FT_RENDER_MODE_LCD_V,
  FT_RENDER_MODE_MAX
} FT_Render_Mode;
// functions
FT_Error FT_Init_FreeType( FT_Library  *alibrary );
FT_Error FT_New_Face( FT_Library   library,
                      const char*  filepathname,
                      FT_Long      face_index,
                      FT_Face     *aface );
FT_Error FT_Set_Char_Size( FT_Face     face,
                           FT_F26Dot6  char_width,
                           FT_F26Dot6  char_height,
                           FT_UInt     horz_resolution,
                           FT_UInt     vert_resolution );
FT_UInt FT_Get_Char_Index( FT_Face   face,
                           FT_ULong  charcode );
FT_Error FT_Get_Kerning( FT_Face     face,
                         FT_UInt     left_glyph,
                         FT_UInt     right_glyph,
                         FT_UInt     kern_mode,
                         FT_Vector  *akerning );
FT_Error FT_Render_Glyph( FT_GlyphSlot    slot,
                          FT_Render_Mode  render_mode );
FT_Error FT_Load_Glyph( FT_Face   face,
                        FT_UInt   glyph_index,
                        FT_Int32  load_flags );
]]

-- setup library & remove FT_ prefix
local ftlib = ffi.load 'freetype'
local ft = {}
setmetatable(ft, {
  __index = function(t, n)
    local s = ftlib['FT_'..n]
    rawset(t, n, s)
    return s
  end,
  __gc = function(t)
    ftlib.FT_Done_FreeType(ft.library)
  end
})

-- initialize library
local libraryPtr = ffi.new('FT_Library[1]')
assert(ft.Init_FreeType(libraryPtr))
ft.library = libraryPtr[0]

-- math macros
function ft.Float(x) return tonumber(x) / 64 end
function ft.Ceil(x)  return bit.band(tonumber(x) + 63, -64) / 64 end
function ft.Floor(x) return bit.band(tonumber(x), -64) / 64 end

-- conveniance functions for functions using pointers
function ft.New_Face(name, flags)
  flags = flags or 0
  local facePtr = ffi.new('FT_Face[1]')
  assert(ftlib.FT_New_Face(ft.library, name, flags, facePtr))
  return facePtr[0]
end

function ft.Get_Kerning(face, prev, index, flags)
  flags = flags or 0
  local deltaPtr = ffi.new('FT_Vector[1]')
  assert(ftlib.FT_Get_Kerning(face, prev, index, flags, deltaPtr))
  return tonumber(deltaPtr[0].x), tonumber(deltaPtr[0].y)
end

return ft
