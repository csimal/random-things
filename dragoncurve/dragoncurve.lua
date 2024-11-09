require "turtle"
require "math"

size(900, 900)
n = 15
step = 2

function drawSeg(direction)
  if direction == 1 then
    turn(90)
   else if direction == 0 then
    turn(-90)
   end
  end
  move(step)
end

--Main
turn(-90)
move(step)
for i=1,((2^n-1)) do
  j =i
  if (j%2)==0 then
    repeat
      j=j/2
    until j%2 == 1
  end
  drawSeg(math.floor(j/2)%2)
  --save(("dragoncurve%i"):format(i))
end  

print("done")
save("dragoncurve")
wait()