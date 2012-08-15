local gl    = require 'glua'
local ffi   = require 'ffi'
local ft    = require 'glua.lib.ft'
local iconv = require 'glua.lib.iconv'
local ic    = iconv.open('UCS-2LE', 'UTF-8')

local gui = {}

local font   = {}
local fontMT = { __index = font }

function gui:font()
  self = self or {}
  self.font    = self.font   or ffi.os == 'OSX'     and '/System/Library/Fonts/LucidaGrande.ttc'
                             or ffi.os == 'Linux'   and '/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf'
                             or ffi.os == 'Windows' and 'C:\\WINDOWS\\fonts\\tahoma.ttf'
  self.lcd     = self.lcd    or false
  self.size    = self.size   or 12
  self.texdim  = self.texdim or 512
  -- load font
  self.face    = ft.New_Face(self.font)
  self.map     = {}
  setmetatable(self, fontMT)
  self:resize(self.size)
  -- setup texture
  self.x         = 0
  self.y         = 0
  self.maxheight = 0
  self.texture   = gl.GenTexture()
  gl.BindTexture(gl.TEXTURE_RECTANGLE, self.texture)
  local format
  if self.lcd then
    format = gl.RGB
  else
    format = gl.RED
    gl.PixelStorei(gl.UNPACK_ALIGNMENT, 1)
  end
  gl.TexImage2D(gl.TEXTURE_RECTANGLE, 0, format, self.texdim, self.texdim, 0, format, gl.UNSIGNED_BYTE, nil)
  return self
end

function fontMT:__gc()
  ft.Face_Done(self.face)
  gl.DeleteTexture(self.texture)
end

function fontMT:__call()
  gl.BindTexture(self.texture)
end

function font:resize(size)
  ft.Set_Char_Size(self.face, 0, size * 64, 0, 0)
end

function font:glyphs(str)
  local ucs2, size = iconv.iconv(ic, str, true)
  local map = self.map
  local chars = {}
  local options = ft.LOAD_FORCE_AUTOHINT + ft.LOAD_RENDER
  local lcd = self.lcd
  local format
  if lcd then
    options = options + ft.LOAD_TARGET_LCD
    format  = gl.RGB
  else
    format  = gl.RED
  end
  for c = 0, size-1 do
    local ch = ucs2[c]
    local entry = map[ch]
    if entry == nil then
      local index = ft.Get_Char_Index(self.face, ch)
      if ft.Load_Glyph(self.face, index, options) ~= 0 then
        entry = {
          minx    = 0,
          maxx    = 0,
          maxy    = 0,
          miny    = 0,
          advance = 0,
          width   = 0,
          height  = 0,
          x       = 0,
          y       = 0,
          left    = 0,
          top     = 0,
          ch      = ch
        }
      else
        local glyph = self.face.glyph
        local bitmap = glyph.bitmap
        entry = { ch = ch }
        entry.minx    = ft.Floor(glyph.metrics.horiBearingX)
        entry.maxx    = entry.minx + ft.Ceil(glyph.metrics.width)
        entry.maxy    = ft.Floor(glyph.metrics.horiBearingY)
        entry.miny    = entry.maxy - ft.Ceil(glyph.metrics.height)
        -- entry.advance = ft.Ceil(glyph.metrics.horiAdvance)
        entry.advance = ft.Float(glyph.advance.x)
        entry.width   = lcd and math.floor(bitmap.pitch / 3) or bitmap.pitch
        entry.height  = bitmap.rows
        entry.left    = glyph.bitmap_left
        entry.top     = glyph.bitmap_top
        -- skip to next row
        if self.x + entry.width > self.texdim then
          self.x = 0
          self.y = self.y + self.maxheight
          self.maxheight = 0
        end
        entry.x = self.x
        entry.y = self.y
        -- load character to texture
        gl.TexSubImage2D(gl.TEXTURE_RECTANGLE, 0,
                         entry.x, entry.y,
                         entry.width, entry.height,
                         format, gl.UNSIGNED_BYTE, bitmap.buffer)
        -- move horizontally
        if self.maxheight < entry.height then
          self.maxheight = entry.height
        end
        self.x = self.x + entry.width
      end
      map[ch] = entry
    end
    chars[#chars+1] = entry
  end
  return chars
end

function font:array(program, str, width)
  width = width or 1e20
  local glyphs = self:glyphs(str)
  local x = 0
  local y = 0
  local attr = {}
  for index = 1, #glyphs do
    local glyph = glyphs[index]
    local ch = glyph.ch
    if ch == 32 or ch == 9 then
      local wordsize = glyph.advance
      for windex = index+1, #glyphs do
        local wglyph = glyphs[windex]
        if wglyph.ch == 32 or wglyph.ch == 9 or wglyph.ch == 10 then break end
        wordsize = wordsize + wglyph.advance
      end
      if x + wordsize > width then ch = 10 end
    end
    if ch == 10 then
      x = 0
      y = y + self.size
    else
      attr[#attr+1] = x + glyph.left
      attr[#attr+1] = y + self.size - glyph.top
      attr[#attr+1] = 0
      attr[#attr+1] = glyph.x
      attr[#attr+1] = glyph.y

      attr[#attr+1] = x + glyph.left + glyph.width
      attr[#attr+1] = y + self.size - glyph.top
      attr[#attr+1] = 0
      attr[#attr+1] = glyph.x + glyph.width
      attr[#attr+1] = glyph.y

      attr[#attr+1] = x + glyph.left + glyph.width
      attr[#attr+1] = y + self.size - glyph.top + glyph.height
      attr[#attr+1] = 0
      attr[#attr+1] = glyph.x + glyph.width
      attr[#attr+1] = glyph.y + glyph.height

      attr[#attr+1] = attr[#attr-4]
      attr[#attr+1] = attr[#attr-4]
      attr[#attr+1] = attr[#attr-4]
      attr[#attr+1] = attr[#attr-4]
      attr[#attr+1] = attr[#attr-4]

      attr[#attr+1] = x + glyph.left
      attr[#attr+1] = y + self.size - glyph.top + glyph.height
      attr[#attr+1] = 0
      attr[#attr+1] = glyph.x
      attr[#attr+1] = glyph.y + glyph.height

      attr[#attr+1] = attr[#attr-24]
      attr[#attr+1] = attr[#attr-24]
      attr[#attr+1] = attr[#attr-24]
      attr[#attr+1] = attr[#attr-24]
      attr[#attr+1] = attr[#attr-24]

      x = x + glyph.advance
    end
  end
  return gl.array(program, attr, 'position', 3, 'texCoord', 2)
end

return gui
