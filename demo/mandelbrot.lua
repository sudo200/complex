local complex = require("complex")

local ROWS, COLS = tonumber(os.getenv('LINES')) or 56, tonumber(os.getenv('COLUMNS')) or 210
local ITERATIONS, ESCAPE = 32, 16



local function mandelbrot_pixel(c)
  local z = c

  for i = 1, ITERATIONS do
    z = z*z + c
    if z.abs()^2 > ESCAPE then
      return i
    end
  end
  return 0
end

for row = 0, ROWS - 4 do
  for col = 0, COLS - 1 do
    if mandelbrot_pixel(complex.new((col - COLS/2) * .02, (row - ROWS/2) * .038)) == 0 then
      io.write(' ')
    else
      io.write('#')
    end
  end
  io.write('\n')
end

