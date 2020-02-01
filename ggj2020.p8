pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main


printh("---------------------")


--Screen from 0 to 127
--Data   from 1 to 128

function makePoint(x, y, col)
   return {
	  x = x,
	  y = y,
	  s = 1,
	  c = col
   }
end

function destroyPoint(x,y)
   for p in all(data) do
     dist = sqrt((p.x - x)^2 + (p.y - y)^2)
	  if dist < rnd(5)+5 and p.s == 1 then
		 p.s = 0
       createParticle(p.x, p.y, p.c)
	  end
   end

   for b in all(bots) do
      b.wait = false
   end

   shake.t = 21
end

function recreateEveryPoint()
   for p in all(data) do	
		p.s = 1
	end
end

function createParticle(x, y, c)
   add(particles, {x = x, y = y, c = c, sx = rnd(5)+1, sy = rnd(2)-1})
end


function getStruct()
   cls()
   spr(3, 16, 0, 16, 16)
   struct = {}
   for j=0,127 do
	  for i=0,127 do
       pt = pget(i,j)
		 if pt!=0 then
			add(struct, makePoint(i, j, pt))
		 end
	  end
   end
   cls()
   return struct
end

function drawPoint(p)
   if p.s==1 then
	   pset(p.x, p.y, p.c)
   --elseif p.s==2 then
      --pset(p.x, p.y, 14)
   end
end

function drawStruct()
   foreach(data, drawPoint)
end

function drawParticles()
   for p in all(particles) do
      pset(p.x, p.y, p.c)
   end
end

function animateParticles()
   for p in all(particles) do
      p.x -= p.sx
      p.y += p.sy

      if (p.x < 0) then
         del(particles, p)
      end
   end
end


function printData()
   for j=1,32 do
	  s = ""
	  for i=1,128 do
		 s1 = "0"
		 if (data[j][i]==6) s1 = "."
		 s = s .. s1
	  end
	  printh(s)
   end
end

function createStars()
   s = {}
   for i = 0,25 do
      add(s, {x = rnd(127), y = rnd(127), l = flr(rnd(3))})
   end
   return s
end

function drawStars()
   for s in all(stars) do
      pset(s.x, s.y, 7)
   end
end

function animateStars()
   for s in all(stars) do
      if (s.l == 0) then s.x -= 1
      elseif (s.l == 1) then s.x -= 2
      elseif (s.l == 2) then s.x -= 4 end

      if (s.x < 0) then
         s.x = 129
         s.l = flr(rnd(3))
      end
   end
end

function drawBoosters()
   if t % 4 == 0 then
      spr(65, 16, 32, 2, 2)
      spr(65, 16, 80, 2, 2)
   end
end

function createBoosterParticles()
   --if t % 1 == 0 then
      createParticle(16, 40, 9)
      createParticle(16, 88, 9)
   --end
end

function screenShake()
   if shake.t > 0 then
      if shake.t % 3 == 0 then
         shake.x += rnd(3) - 1.5
         shake.y += rnd(3) - 1.5
      else
         shake.x = 0
         shake.y = 0
      end
      shake.t -= 1
   end
end


function createBots()
   if #bots < 20 then
      add(bots, {x = mx, y = my, s = rnd(0.5) + 1, t = nil, wait = false})
      add(bots, {x = mx, y = my, s = rnd(0.5) + 1, t = nil, wait = false})
   end
end

function searchTarget(b)
   pivot = flr(rnd(5206))
   for i=pivot,5207 do
      if data[i].s == 0 then
         data[i].s = 2
         return { x = data[i].x, y = data[i].y }
      end
   end
   for i=1,pivot do
      if data[i].s == 0 then
         data[i].s = 2
         return { x = data[i].x, y = data[i].y }
      end
   end
   
   b.wait = true
   return nil
end


function moveBots()
   for b in all(bots) do
      if b.t == nil and not b.wait then
         b.t = searchTarget(b)
      end
      

      if (b.t != nil) then
         if b.x < b.t.x then b.x += b.s
         elseif b.x > b.t.x then b.x -= b.s end
         if b.y < b.t.y then b.y += b.s
         elseif b.y > b.t.y then b.y -= b.s end

         dist = sqrt((b.x - b.t.x)^2 + (b.y - b.t.y)^2)
         if (dist < 2) then
            for p in all(data) do
               if (b.t.x == p.x and b.t.y == p.y) do
                  p.s = 1
                  del(bots, b)
               end
            end
         end
      end
   end
end


function createFire()
   source = {x = mx, y = my, growth = 0}
   add(fires, source)
   for p in all(data) do
      if p.x == source.x and p.y == source.y then
         p.s = 0
      end
   end
end

function updateFires()
   if #fires > 0 then
      for k=1,#fires do
         fire = flr(rnd(#fires)) + 1
         fires[k].growth += 0.02
         for i=0,30 do
            point = flr(rnd(5207)) + 1
            dist = sqrt((data[point].x - fires[k].x)^2 + (data[point].y - fires[k].y)^2)
            if dist < rnd(1)+fires[k].growth and data[point].s == 1 then
               data[point].s = 0
               createParticle(data[point].x, data[point].y, 8)
               
               for b in all(bots) do
                  b.wait = false
               end
            end
         end
      end
   end
end


function selfDestruct()
   sdspeed += 50

   for i=0,sdspeed do
      point = flr(rnd(5207)) + 1

      if (data[point].s != 0) then
         data[point].s = 0
         if sdspeed < 250 then
            createParticle(data[point].x, data[point].y, 8)
         end
      end
   end
end

--------------------------------




function _init()
   poke(0x5F2D, 1)
	mx = stat(32)
	my = stat(33)
	mb = stat(34)
	data = getStruct()
	t = 0
	pset(127,0,8)

   particles = {}
   stars = createStars()

   shake = { x = 0, y = 0, t = 0}

   bots = {}

   fires = {}

   sdspeed = 1
   selfdestruct = false
end


function mouseLeft()
   if pget(mx-1, my) == 3 then
      createBots()
   end
end

function mouseRight()
   destroyPoint(mx, my)
end

function mouseMiddle()
   createFire()
   --recreateEveryPoint()
end




function _update()
	mx = stat(32)
	my = stat(33)

   camera(0 + shake.x, 0 + shake.y)
   screenShake()

	if mb==0 then
		mb = stat(34)
		if mb==1 then
		   mouseLeft()
      elseif mb==2 then
         mouseRight()
      elseif mb==4 then
         mouseMiddle()
      end
	end
	mb = stat(34)

   t += 1

   animateParticles()
   animateStars()

   if not selfdestruct then
      createBoosterParticles()
   end

   moveBots()

   updateFires()

   if btnp(4) then
      selfdestruct = true
   end

   if selfdestruct and sdspeed < 2500 then selfDestruct() end
end





function _draw()
   cls()
   drawStars()
   drawParticles()
   drawStruct()
   if not selfdestruct then
      drawBoosters()
   end
   pset(mx, my, 8)
   if btn(5) then
	  print("Mem :"..stat(0), 0,  0, 8)
	  print("Cpu1:"..stat(1), 0,  8, 8)
	  print("Cpu2:"..stat(2), 0, 16, 8)
	  print("Fps :"..stat(7), 0, 24, 8)
	  print("mx: " .. mx, 0, 32, 8)
	  print("my: " .. my, 0, 40, 8)
	  print("mb: " .. mb, 0, 48, 8)
     print("ship pixels: " .. #data, 0, 56, 8)
   end

   for b in all(bots) do
      pset(b.x, b.y, 11)
   end

   --for f in all(fires) do
      --pset(f.x, f.y, 13)
   --end
end




--cose


-->8
--pathfinding




function findPath(start, goal)
   wallCol = 2

   --initialize data with current point
   frontier = {}
   insert(frontier, start, 0)
   came_from = {}
   came_from[vectoindex(start)] = nil
   cost_so_far = {}
   cost_so_far[vectoindex(start)] = 0

   --Cycle until i have frontiers unexplored
   while (#frontier > 0 and #frontier < 1000) do
	  --Take the current frontier tile
	  current = popEnd(frontier)

	  --If I have reach my goal we can break
	  if (vectoindex(current) == vectoindex(goal)) break 

	  --Get cycle through all the neighbours
	  local neighbours = getNeighbours(current)
	  for next in all(neighbours) do
		 local nextIndex = vectoindex(next)
		 local new_cost = cost_so_far[vectoindex(current)] + 1

		 --If I have not explored this tile or if I found a better route to an existing one
		 if (cost_so_far[nextIndex] == nil) or (new_cost < cost_so_far[nextIndex]) then
			--Set this tile as a new frontier and save its cost
			cost_so_far[nextIndex] = new_cost
			local priority = new_cost + heuristic(goal, next)
			insert(frontier, next, priority)
			
			--Save from where I came
			came_from[nextIndex] = current
			
			--if (nextIndex != vectoindex(start)) and (nextIndex != vectoindex(goal)) then
			--   mset(next[1],next[2],19)
			--end
		 end 
	  end
   end

   --Recreate the path from the goal
   current = came_from[vectoindex(goal)]
   path = {}
   local cindex = vectoindex(current)
   local sindex = vectoindex(start)
   while cindex != sindex do
	  add(path, current)
	  current = came_from[cindex]
	  cindex = vectoindex(current)
   end
   reverse(path)

   return path
   --for point in all(path) do
   --	  mset(point[1],point[2],18)
   --end

end









-- manhattan distance on a square grid
function heuristic(a, b)
   return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

-- find all existing neighbours of a position that are not walls
debugCounter = 0
function getNeighbours(pos)
   local neighbours={}
   local x = pos[1]
   local y = pos[2]



   if x>0 and x<128 and y>0 and y<128 then
	  for p in all(data) do
		 if p.c!=2 then
			if     (p.x==x-1 and p.y==y) then add(neighbours, {x-1,y})
		    elseif (p.x==x+1 and p.y==y) then add(neighbours, {x+1,y})
            elseif (p.x==x and p.y==y+1) then add(neighbours, {x,y+1})
            elseif (p.x==x and p.y==y-1) then add(neighbours, {x,y-1})
			end
		 end
	  end
   end
   debugCounter += 1
   printh(pos[1] .. "," .. pos[2] .. " dc:" .. debugCounter)

   -- for making diagonals
   --if (x+y) % 2 == 0 then
   --	  reverse(neighbours)
   --end
   return neighbours
end

-- insert into start of table
function insert(t, val)
   for i=(#t+1),2,-1 do
	  t[i] = t[i-1]
   end
   t[1] = val
end

-- insert into table and sort by priority
function insert(t, val, p)
   if #t >= 1 then
	  add(t, {})
	  for i=(#t),2,-1 do
		 
		 local next = t[i-1]
		 if p < next[2] then
			t[i] = {val, p}
			return
		 else
			t[i] = next
		 end
	  end
	  t[1] = {val, p}
   else
	  add(t, {val, p}) 
   end
end

-- pop the last element off a table
function popEnd(t)
   local top = t[#t]
   del(t,t[#t])
   return top[1]
end

function reverse(t)
   for i=1,(#t/2) do
	  local temp = t[i]
	  local oppindex = #t-(i-1)
	  t[i] = t[oppindex]
	  t[oppindex] = temp
   end
end

-- translate a 2d x,y coordinate to a 1d index and back again
function vectoindex(vec)
   return maptoindex(vec[1],vec[2])
end
function maptoindex(x, y)
   return ((x+1) * 16) + y
end
function indextomap(index)
   local x = (index-1)/16
   local y = index - (x*w)
   return {x,y}
end

-- pop the first element off a table (unused
function pop(t)
   local top = t[1]
   for i=1,(#t) do
	  if i == (#t) then
		 del(t,t[i])
	  else
		 t[i] = t[i+1]
	  end
   end
   return top
end






__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011666666661100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dd6110000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddd611000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dddd61100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddddd6110000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd6dddddd611000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddd6ddd6ddddd61100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011dddddddddddddd6110000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011dd6dd6dd6dddddd611000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011dddddddddddddddd61100000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddd6ddd6ddddddddd6110000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd6dddddddddddd611000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddddddddddddd61100000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dddddddddddddd6110000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddddddddddddddd611000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dddddddddddddddd61100000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000111111222222222222222ddd6110000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111127777777777777772ddd110000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000001ffff27777777777777772ddd110000000000000000000000000000000000000000000000000000000000000000000000
0000000000077000000000000007711f888827777777777777772ddd110000000000000000000000000000000000000000000000000000000000000000000000
000000000077700000000000007991f8888827777777777777772dd2222222222222222222000000000000000000000000000000000000000000000000000000
000000000777700000000000079991f8888827777777777777772d27777777777777777777200000000000000000000000000000000000000000000000000000
000000007777700000000000799991f8888827777777777777772d27777777777777777777721111111111111111111111111111111111111000000000000000
000000007777700000000000799991f8888827777777777777772227777777777777777777772111111111111111111111111111111111111100000000000000
000000007777700000000000799991f88888277777777777777776777777777777777777777772dddddddddddddddddddddddddddd1666666111000000000000
000000007777700000000000799991f888882777777777777777767777777777777777777777772ddddddddddddddd6666ddddd6661666666611100000000000
000000007777700000000000799991f8888827777777777777777677777777777777777777777726666666666666661111666661116666666666110000000000
000000007777700000000000799991f8888827777777777777777677777777777777777777777721111111111111116666111116666666666666110000000000
000000000777700000000000079991f888882777777777777777227777777777777777777777772f116666666666666666666666666666666666110000000000
000000000077700000000000007991f888882777777777777772dd27777777777777777777777728ff1166666666666666666666666666666666110000000000
0000000000077000000000000007711f88882777777777777772dd2777777777777777777777772888ff17777777777777777777777777777771100000000000
00000000000000000000000000000001ffff2777777777777772dd277777777777777777777777288888f1777777777777777777777777711111000000000000
0000000000000000000000000000000011112777777777777772dd27777777777777777777777721111111111111111111111111111111111110000000000000
0000000000000000000000000000000001662777777777777772dd27777777777777777777777721111111111111111111111111111111100000000000000000
000000000000000000000000000000001ddd2222222777777722dd22777777222222222777777200000000000000000000000000000000000000000000000000
000000000000000000000000000000001dddd62dddd2666662dddddd266662ddddddddd266666222222222222222221100000000000000000000000000000000
000000000000000000000000000000001ddddd622227777777222222777777222222222777777772777777777777772210000000000000000000000000000000
000000000000000000000000000000001ddddd627777777777777777777777777777777777777772777777777777777211000000000000000000000000000000
0000000000000000000000000000000001dddd6277777777777777777777777777777777777777727777777777777772f1100000000000000000000000000000
00000000000000000000000000000000001ddd62777777777777777777777777777777777777777277777777777777772f110000000000000000000000000000
000000000000000000000000000000000001dd627777777777777777777777777777777777777772777777777777777728f11000000000000000000000000000
000000000000000000000000000000000000111277777777777777777777777777777777777777722222222777772222288f1100000000000000000000000000
0000000000000000000000000000000000001ff2777777722226666222222222666662222277777772222dd26662dddd2288f110000000000000000000000000
0000000000000000000000000000000000001f827777772222333333222222233333332222277777777722277777222222222111000000000000000000000000
0000000000000000000000000000000000001f8277777722333333333333333333333333322777777777777777777777777772f1100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777233333333333333333333333333327777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777633333333333333333333333333367777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777633333333333333333333333333367777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777233333333333333333333333333327777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
0000000000000000000000000000000000001f8277777722333333333333333333333333322777777777777777777777777772f1100000000000000000000000
0000000000000000000000000000000000001f827777772222333333222222233333332222277777777722277777222222222111000000000000000000000000
0000000000000000000000000000000000001ff2777777722226666222222222666662222277777772222dd26662dddd2288f110000000000000000000000000
000000000000000000000000000000000000111277777777777777777777777777777777777777722222222777772222288f1100000000000000000000000000
000000000000000000000000000000000001dd627777777777777777777777777777777777777772777777777777777728f11000000000000000000000000000
00000000000000000000000000000000001ddd62777777777777777777777777777777777777777277777777777777772f110000000000000000000000000000
0000000000000000000000000000000001dddd6277777777777777777777777777777777777777727777777777777772f1100000000000000000000000000000
000000000000000000000000000000001ddddd627777777777777777777777777777777777777772777777777777777211000000000000000000000000000000
000000000000000000000000000000001ddddd622227777777222222777777222222222777777772777777777777772210000000000000000000000000000000
000000000000000000000000000000001dddd62dddd2666662dddddd266662ddddddddd266666222222222222222221100000000000000000000000000000000
000000000000000000000000000000001ddd2222222777777722dd22777777222222222777777200000000000000000000000000000000000000000000000000
0000000000000000000000000000000001662777777777777772dd27777777777777777777777721111111111111111111111111111111100000000000000000
0000000000000000000000000000000011112777777777777772dd27777777777777777777777721111111111111111111111111111111111110000000000000
00000000000000000000000000000001ffff2777777777777772dd277777777777777777777777288888f1777777777777777777777777711111000000000000
0000000000000000000000000007711f88882777777777777772dd2777777777777777777777772888ff17777777777777777777777777777771100000000000
000000000000000000000000007991f888882777777777777772dd27777777777777777777777728ff1166666666666666666666666666666666110000000000
000000000000000000000000079991f888882777777777777777227777777777777777777777772f116666666666666666666666666666666666110000000000
000000000000000000000000799991f8888827777777777777777677777777777777777777777721111111111111116666111116666666666666110000000000
000000000000000000000000799991f8888827777777777777777677777777777777777777777726666666666666661111666661116666666666110000000000
000000000000000000000000799991f888882777777777777777767777777777777777777777772ddddddddddddddd6666ddddd6661666666611100000000000
000000000000000000000000799991f88888277777777777777776777777777777777777777772dddddddddddddddddddddddddddd1666666111000000000000
000000000000000000000000799991f8888827777777777777772227777777777777777777772111111111111111111111111111111111111100000000000000
000000000000000000000000799991f8888827777777777777772d27777777777777777777721111111111111111111111111111111111111000000000000000
000000000000000000000000079991f8888827777777777777772d27777777777777777777200000000000000000000000000000000000000000000000000000
000000000000000000000000007991f8888827777777777777772dd2222222222222222222000000000000000000000000000000000000000000000000000000
0000000000000000000000000007711f888827777777777777772ddd110000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000001ffff27777777777777772ddd110000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111127777777777777772ddd110000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000111111222222222222222ddd6110000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dddddddddddddddd61100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddddddddddddddd611000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dddddddddddddd6110000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddddddddddddd61100000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd6dddddddddddd611000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddd6ddd6ddddddddd6110000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011dddddddddddddddd61100000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011dd6dd6dd6dddddd611000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011dddddddddddddd6110000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddd6ddd6ddddd61100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd6dddddd611000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddddd6110000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dddd61100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1ddd611000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011ddddd1dd6110000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011666666661100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
