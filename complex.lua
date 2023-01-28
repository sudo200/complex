--[[
-- Written by sudo200
--
-- This is free and unencumbered software released into the public domain.
--
-- Anyone is free to copy, modify, publish, use, compile, sell, or
-- distribute this software, either in source code form or as a compiled
-- binary, for any purpose, commercial or non-commercial, and by any
-- means.
--
-- In jurisdictions that recognize copyright laws, the author or authors
-- of this software dedicate any and all copyright interest in the
-- software to the public domain. We make this dedication for the benefit
-- of the public at large and to the detriment of our heirs and
-- successors. We intend this dedication to be an overt act of
-- relinquishment in perpetuity of all present and future rights to this
-- software under copyright law.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
-- OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
--
-- For more information, please refer to <http://unlicense.org/>
--]]

--[[
-- TODO
-- * Test all functions
--]]

local complex = { _VERSION = 'v1.0.0' }

function complex.new(real, imag)
  local self = {
    _real = real or 0,
    _imag = imag or 0,
  }

  local function err()
    error('Not a (complex) number !')
  end

  local iface = {}

  function iface.real()
    return self._real
  end

  function iface.imag()
    return self._imag
  end

  function iface.abs()
    return math.sqrt(iface.real() ^ 2 + iface.imag() ^ 2)
  end

  function iface.arg()
    return math.atan(iface.imag(), iface.real())
  end

  function iface.neg()
    return complex.new(-iface.real(), -iface.imag())
  end

  function iface.add(num)
    if type(num) == 'number' then
      return iface.add(complex.new(num))
    elseif type(num) == 'table' then
      return complex.new(iface.real() + num.real(), iface.imag() + num.imag())
    else
      err()
    end
  end

  function iface.sub(num)
    if type(num) == 'number' then
      return iface.add(-num)
    elseif type(num) == 'table' then
      return iface.add(num.neg())
    else
      err()
    end
  end

  function iface.mul(num)
    if type(num) == 'number' then
      return complex.new(iface.real() * num, iface.imag() * num)
    elseif type(num) == 'table' then
      return complex.new(
        iface.real() * num.real() - iface.imag() * num.imag(),
        iface.real() * num.imag() + iface.imag() * num.real()
      );
    else
      err()
    end
  end

  function iface.conj()
    return complex.new(iface.real(), -iface.imag())
  end

  function iface.div(num)
    if type(num) == 'number' then
      return complex.new(iface.real() / num, iface.imag() / num)
    elseif type(table) == 'table' then
      return complex.new(
      (iface.real() * num.real() + iface.imag() * num.imag()) / (num.real() ^ 2 + num.imag() ^ 2),
      (iface.imag() * num.real() - iface.real() * num.imag()) / (num.real() ^ 2 + num.imag() ^ 2)
      )
    else
      err()
    end
  end

  function iface.exp()
    local exp = math.exp(iface.real())
    return complex.new(exp * math.cos(iface.imag()), exp * math.sin(iface.imag()))
  end

  function iface.ln()
    return complex.new(math.log(iface.abs(), math.exp(1)), iface.arg())
  end

  function iface.log(base)
    if type(base) == 'number' then
      return iface.log(complex.new(base, 0))
    elseif type(base) == 'table' then
      local z1, z2 = iface.ln(), base.ln()
      return z1.div(z2)
    else
      err()
    end
  end

  --[[ FIXME
  function iface.pow(num)
    if type(num) == 'number' then
      local z = iface + 0
      for i = 2, num do
        z = z * z
      end
      return z
    elseif type(num) == 'table' then
      return iface.ln().mul(num).exp()
    else
      err()
    end
  end
  --]]

  return setmetatable(iface, {
    __name = 'complex number',
    __tostring = function(this)
      return string.format(
        "(%s) + (%s)i",
        this.real(),
        this.imag()
      )
    end,

    __add = function(this, num)
      return this.add(num)
    end,
    __sub = function(this, num)
      return this.sub(num)
    end,
    __mul = function(this, num)
      return this.mul(num)
    end,
    __div = function(this, num)
      return this.div(num)
    end,
    __pow = function(this, num)
      return this.pow(num)
    end,

    __unm = function(this)
      return this.neg()
    end,
    __bnot = function(this)
      return this.conj()
    end
  })
end

return complex

