require "turtle"
require "math"

--size(900, 900)
n = 10
step = 6

local dx, dy

function draw(x, y, angle, length)
  line(x, y, x+length*math.cos(angle), y+length*math.sin(angle))
  dx, dy = x+length*math.cos(angle), y+length*math.sin(angle) --store new position
end

function dragoncurve(x, y, direction, iterations)
  if iterations == 1 then
    draw(x, y, direction, step)
  else
    dragoncurve(x, y, direction, iterations-1)
    dragoncurve(dx+(y-dy), dy+(dx-x), direction+math.pi/2, iterations-1)
  end
end

--Main
dragoncurve(0, 0, 0, n)
save("dragoncurve")
wait()