local ft    = require 'lib.ft'
local iconv = require 'lib.iconv'
local face  = ft.New_Face '/System/Library/Fonts/LucidaGrande.ttc'
local size  = 12
local ic    = iconv.open('UCS-2LE', 'UTF-8')

assert(ft.Set_Char_Size(face, 0, size * 64, 0, 0))

local ucs2, size = iconv.iconv_uint16(ic, 'Kośi płąść kęsię')

local prev = 0
for c = 0, size-1 do
  local index = ft.Get_Char_Index(face, ucs2[c])
  if prev ~= 0 then
    local x, y = ft.Get_Kerning(face, prev, index, ft.KERNING_DEFAULT)
    -- print('delta='..x..','..y)
  end
  if ft.Load_Glyph(face, index, ft.LOAD_RENDER) ~= 0 then
    print('error='..index)
  else
    local glyph = face.glyph
    local bitmap = glyph.bitmap
    local minx = ft.Floor(glyph.metrics.horiBearingX)
    local maxx = minx + ft.Ceil(glyph.metrics.width)
    local maxy = ft.Floor(glyph.metrics.horiBearingY)
    local miny = maxy - ft.Ceil(glyph.metrics.height)
    local advance = ft.Ceil(glyph.metrics.horiAdvance)
    print('index='..index..' pitch='..bitmap.pitch..' rows='..bitmap.rows..' minx='..minx..' maxxy='..maxx..' maxy='..maxy..' miny='..miny..' adv='..advance)
  end
  prev = index
end
