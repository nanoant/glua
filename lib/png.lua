local ffi = require 'ffi'

ffi.cdef [[
// stdio.h used by libpng
typedef struct FILE FILE;
FILE *fopen(const char *restrict filename, const char *restrict mode);
int fclose(FILE *stream);

// libpng.h
typedef struct png_color *png_colorp;
typedef struct png_struct *png_structp;
typedef const struct png_struct *png_const_structp;
typedef struct png_info *png_infop;
typedef const struct png_info *png_const_infop;
typedef void (* png_error_ptr)(png_structp, const char *);
uint32_t png_access_version_number(void);
// getters
char *png_get_libpng_ver(png_const_structp png_ptr);
uint32_t png_get_valid(png_const_structp png_ptr, png_const_infop info_ptr, uint32_t flag);
size_t png_get_rowbytes(png_const_structp png_ptr, png_const_infop info_ptr);
uint8_t png_get_channels(png_const_structp png_ptr, png_const_infop info_ptr);
uint32_t png_get_image_width(png_const_structp png_ptr, png_const_infop info_ptr);
uint32_t png_get_image_height(png_const_structp png_ptr, png_const_infop info_ptr);
uint8_t png_get_bit_depth(png_const_structp png_ptr, png_const_infop info_ptr);
uint8_t png_get_color_type(png_const_structp png_ptr, png_const_infop info_ptr);
uint32_t png_get_gAMA(png_const_structp png_ptr, png_const_infop info_ptr, double *file_gamma);
// functions
png_structp png_create_read_struct(const char *user_png_ver, void *error_ptr, png_error_ptr error_fn, png_error_ptr warn_fn);
png_infop png_create_info_struct(png_structp png_ptr);
void png_init_io(png_structp png_ptr, FILE *fp);
void png_read_info(png_structp png_ptr, png_infop info_ptr);
void png_set_expand(png_structp png_ptr);
void png_set_gamma(png_structp png_ptr, double screen_gamma, double default_file_gamma);
void png_set_strip_16(png_structp png_ptr);
void png_set_packing(png_structp png_ptr);
void png_read_update_info(png_structp png_ptr, png_infop info_ptr);
void png_read_image(png_structp png_ptr, uint8_t **image);
void png_read_end(png_structp png_ptr, png_infop info_ptr);
void png_destroy_info_struct(png_structp png_ptr, png_infop *info_ptr_ptr);
void png_destroy_read_struct(png_structp *png_ptr_ptr, png_infop *info_ptr_ptr, png_infop *end_info_ptr_ptr);
enum {
  PNG_INFO_gAMA = 0x000,
  PNG_INFO_sBIT = 0x000,
  PNG_INFO_cHRM = 0x000,
  PNG_INFO_PLTE = 0x000,
  PNG_INFO_tRNS = 0x001,
  PNG_INFO_bKGD = 0x002,
  PNG_INFO_hIST = 0x004,
  PNG_INFO_pHYs = 0x008,
  PNG_INFO_oFFs = 0x010,
  PNG_INFO_tIME = 0x020,
  PNG_INFO_pCAL = 0x040,
  PNG_INFO_sRGB = 0x0800,
  PNG_INFO_iCCP = 0x1000,
  PNG_INFO_sPLT = 0x2000,
  PNG_INFO_sCAL = 0x4000,
  PNG_INFO_IDAT = 0x8000
}
enum {
  PNG_COLOR_MASK_PALETTE    = 1,
  PNG_COLOR_MASK_COLOR      = 2,
  PNG_COLOR_MASK_ALPHA      = 4
};
enum {
  PNG_COLOR_TYPE_GRAY       = 0,
  PNG_COLOR_TYPE_PALETTE    = (PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_PALETTE),
  PNG_COLOR_TYPE_RGB        = (PNG_COLOR_MASK_COLOR),
  PNG_COLOR_TYPE_RGB_ALPHA  = (PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_ALPHA),
  PNG_COLOR_TYPE_GRAY_ALPHA = (PNG_COLOR_MASK_ALPHA),
  PNG_COLOR_TYPE_RGBA       = PNG_COLOR_TYPE_RGB_ALPHA,
  PNG_COLOR_TYPE_GA         = PNG_COLOR_TYPE_GRAY_ALPHA
};
]]

local M = {}

local png = ffi.load('png')

local png_structpp = ffi.typeof('png_structp[1]')
local png_infopp   = ffi.typeof('png_infop[1]')
local png_doublep  = ffi.typeof('double[?]')
local png_rowp     = ffi.typeof('uint8_t[?]')
local png_rowpp    = ffi.typeof('uint8_t *[?]')

function M.bitmap(path)
  local intver = png.png_access_version_number()
  local ver_major = math.floor(intver / 10000)
  local ver_minor = math.floor(intver % 10000 / 100)
  local ver_patch = math.floor(intver % 100)
  local version = ver_major..'.'..ver_minor..'.'..ver_patch

  local ptr = png.png_create_read_struct(version, nil, nil, nil)
  local info = png.png_create_info_struct(ptr)
  local fp = png.fopen(path, 'rb')

  if fp == nil then
    return nil
  end

  png.png_init_io(ptr, fp)
  png.png_read_info(ptr, info)

  local color_type = png.png_get_color_type(ptr, info)
  local bit_depth  = png.png_get_bit_depth(ptr, info)
  local valid_tRNS = png.png_get_valid(ptr, info, png.PNG_INFO_tRNS)
  local valid_gAMA = png.png_get_valid(ptr, info, png.PNG_INFO_gAMA)

  if color_type == png.PNG_COLOR_TYPE_PALETTE or
     color_type == png.PNG_COLOR_TYPE_GRAY and bit_depth < 8 or
     valid_tRNS ~= 0 then
    png.png_set_expand(ptr)
  end

  local screen_gamma = 2.0

  if valid_gAMA ~= 0 then
    local gamap = png_doublep()
    png.png_get_gAMA(ptr, info, gamap)
    png.png_set_gamma(ptr, screen_gamma, gamap[0]);
  else
    png.png_set_gamma(ptr, screen_gamma, 0.45);
  end

  if bit_depth == 16 then png.png_set_strip_16(ptr) end
  if bit_depth  <  8 then png.png_set_packing(ptr) end

  png.png_read_update_info(ptr, info)

  color_type = png.png_get_color_type(ptr, info)
  bit_depth  = png.png_get_bit_depth(ptr, info)

  local channels = png.png_get_channels(ptr, info)

  if channels ~= 1 and channels ~= 3 and channels ~=4 then
    png.png_destroy_read_struct(png_structpp(ptr), png_infopp(info), nil)
    png.fclose(fp)
    error(string.format('found %d channels, but only 1, 3 or 4 supported', channels))
    return nil
  end

  if bit_depth ~= 8 then
    png.png_destroy_read_struct(png_structpp(ptr), png_infopp(info), nil)
    png.fclose(fp)
    error(string.format('found %d BPP, but only 8 supported', bit_depth))
    return nil
  end

  if color_type ~= png.PNG_COLOR_TYPE_RGB and
     color_type ~= png.PNG_COLOR_TYPE_GRAY and
     color_type ~= png.PNG_COLOR_TYPE_RGB_ALPHA then
    png.png_destroy_read_struct(png_structpp(ptr), png_infopp(info), nil)
    png.fclose(fp)
    error(string.format('found %d color type, but only gray, RGB and RGBA are supported', color_type))
    return nil
  end

  local width  = png.png_get_image_width(ptr, info)
  local height = png.png_get_image_height(ptr, info)
  local rowbytes = png.png_get_rowbytes(ptr, info)
  local rows   = png_rowpp(height)
  local bitmap = png_rowp(height * rowbytes)

  for row = 0, height - 1 do
    rows[row] = bitmap + row * rowbytes
  end

  png.png_read_image(ptr, rows)
  png.png_destroy_read_struct(png_structpp(ptr), png_infopp(info), nil)
  png.fclose(fp)

  return bitmap, width, height, channels 
end

setmetatable(M, { __index = png })

return M
