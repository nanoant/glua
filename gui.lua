local gl    = require 'gl'
local ft    = require 'lib.ft'
local iconv = require 'lib.iconv'
local ic    = iconv.open('UCS-2LE', 'UTF-8')

-- set up texture rectangle extension
gl.TEXTURE_RECTANGLE = 0x84F5

local gui = {}

local Font = {}

function gui:Font()
  self = self or {}
  self.size    = self.size   or 12
  self.texdim  = self.texdim or 1024
  -- load font
  self.face    = ft.New_Face(self.font)
  self.map     = {}
  setmetatable(self, {
    __index = Font,
    __gc = function(self)
      ft.Face_Done(self.face)
    end
  })
  self:resize(self.size)
  -- setup texture
  self.x         = 0
  self.y         = 0
  self.maxheight = 0
  self.texture   = gl.GenTexture()
  gl.Enable(gl.TEXTURE_RECTANGLE)
  gl.BindTexture(gl.TEXTURE_RECTANGLE, self.texture)
  gl.TexImage2D(gl.TEXTURE_RECTANGLE, 0, gl.ALPHA, self.texdim, self.texdim, 0, gl.ALPHA, gl.UNSIGNED_BYTE, nil)
  gl.PixelStorei(gl.UNPACK_ALIGNMENT, 1);
  return self
end

function Font:resize(size)
  ft.Set_Char_Size(self.face, 0, size * 64, 0, 0)
end

function Font:glyphs(str)
  local ucs2, size = iconv.iconv_uint16(ic, str)
  local map = self.map
  local chars = {}
  for c = 0, size-1 do
    local ch = ucs2[c]
    local entry = map[ch]
    if entry == nil then
      local index = ft.Get_Char_Index(self.face, ch)
      if ft.Load_Glyph(self.face, index, ft.LOAD_RENDER) ~= 0 then
        entry = {
          minx    = 0,
          maxx    = 0,
          maxy    = 0,
          miny    = 0,
          advance = 0,
          pitch   = 0,
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
        entry.advance = ft.Ceil(glyph.advance.x)
        entry.pitch   = bitmap.pitch
        entry.height  = bitmap.rows
        entry.left    = glyph.bitmap_left
        entry.top     = glyph.bitmap_top
        -- skip to next row
        if self.x + entry.pitch > self.texdim then
          self.x = 0
          self.y = self.y + entry.maxheight
          self.maxheight = 0
        end
        entry.x = self.x
        entry.y = self.y
        -- load character to texture
        gl.TexSubImage2D(gl.TEXTURE_RECTANGLE, 0,
                         entry.x, entry.y,
                         entry.pitch, entry.height,
                         gl.ALPHA, gl.UNSIGNED_BYTE, bitmap.buffer)
        -- move horizontally
        if self.maxheight < entry.height then
          self.maxheight = entry.height
        end
        self.x = self.x + entry.pitch
      end
      map[ch] = entry
    end
    chars[#chars+1] = entry
  end
  return chars
end

function Font:draw(str, width)
  width = width or 1e20
  local glyphs = self:glyphs(str)
  gl.Enable(gl.TEXTURE_RECTANGLE)
  gl.BindTexture(gl.TEXTURE_RECTANGLE, self.texture)
  gl.Begin(gl.QUADS)
  local x = 0
  local y = 0
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
      gl.TexCoord2i(glyph.x,
                    glyph.y)
      gl.Vertex2i(x + glyph.left,
                  y + self.size - glyph.top)
      gl.TexCoord2i(glyph.x + glyph.pitch,
                    glyph.y)
      gl.Vertex2i(x + glyph.left + glyph.pitch,
                  y + self.size - glyph.top)
      gl.TexCoord2i(glyph.x + glyph.pitch,
                    glyph.y + glyph.height)
      gl.Vertex2i(x + glyph.left + glyph.pitch,
                  y + self.size - glyph.top + glyph.height)
      gl.TexCoord2i(glyph.x,
                    glyph.y + glyph.height)
      gl.Vertex2i(x + glyph.left,
                  y + self.size - glyph.top + glyph.height)
      x = x + glyph.advance
    end
  end
  gl.Disable(gl.TEXTURE_RECTANGLE)
  gl.End()
end

return gui
