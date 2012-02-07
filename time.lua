local ffi = require 'ffi'

ffi.cdef [[
struct timeval {
	long tv_sec;
	long tv_usec;
};
void gettimeofday(struct timeval *tv, void *p);
]]

local time, timeMT, timevalMT = {}, {}, {}
setmetatable(time, timeMT)

function timeMT:__call(...)
  local now = time.new(...)
  ffi.C.gettimeofday(now, nil)
  return now
end

function timevalMT:__index(i)
  if i == 'since' then
    local now = time()
    return tonumber(now.tv_sec) - tonumber(self.tv_sec) + tonumber(now.tv_usec - self.tv_usec) / 1000000.0
  end
  return nil
end

time.new = ffi.metatype('struct timeval', timevalMT)

return time