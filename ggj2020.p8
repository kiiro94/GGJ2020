pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main


--Screen from 0 to 127
--Data   from 1 to 128


------------------------------------------
-------------MEMORY STUFF-----------------
------------------------------------------

--function fixind(ind)
--   if ind<=9472 then
--	  return 2815+ind
--   else
--	  return 17152+(ind-9472)
--   end
--end
--
--
--function writeobj(x,y,c,s,b)
--   b=0
--   if (col==3) b=1 
--   poke(fixind(x + (y*128)), c+s*64+b*128)
--end
--
--function setobjs(addr, val)
--   poke(addr, bor(0b1000000, val))
--end
--
--function unsetobjs(addr, val)
--   poke(addr, bxor(0b1000000, val))
--end
--
--function setobjc(addr, val, newcol)
--   poke(addr,  bor(0b11111))
--   poke(addr, band(0b11111))
--   newval = bxor(newcol, peek(addr))
--   local temp = val
--   if val>=128 then
--      temp -= 128
--      newval += 128
--   end
--   if val>=64 then
--      temp -= 64
--      newval += 64
--   end
--   poke(addr, newval)
--end




-- 0000 0000 -> 1 byte
-- SSSS BBBB -> leftmost 4 are 4 pixels of S, rightmost 4 are 4 pixels of B
-- 1234 1234

function getColFromPoint(x,y)
   local index = x+y*128
   local val = peek(flr(index/2))
   if index%2!=0 then
	  --take leftmost pixel, discard everything right with shift
	  return shr(val, 4)
   else
	  --take rightmost pixel, discard everything left with and
	  return band(val, 15)
   end
end




function getSFromPoint(x,y)
   local index = x+y*128
   local val = peek(flr(index/4)+0x4300)
   local r = index%4
   if r==0 then
	  val = shr(val, 7)
   elseif r==1 then
	  val = shr(val, 6)
   elseif r==2 then
	  val = shr(val, 5)
   elseif r==3 then
	  val = shr(val, 4)
   end
   return band(val, 0b00000001) -- take only one bit at the end
end

function getBFromPoint(x,y)
   local index = x+y*128
   local val = peek(flr(index/4)+0x4300)
   local r = index%4
   if r==0 then
	  val = shr(val, 3)
   elseif r==1 then
	  val = shr(val, 2)
   elseif r==2 then
	  val = shr(val, 1)
   elseif r==3 then
	  --val = shr(val, 0) --not necessary
   end
   return band(val, 0b00000001) -- take only one bit at the end
end


function setSFromPoint(x,y,newVal)
   local index = x+y*128 
   local addr = flr(index/4)+0x4300
   local currVal = peek(addr)
   local r = index%4
   local finalVal = 0

   
   if r==0 then
	  bit = band(shr(currVal, 7), 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b01111111) --Unset the glag with and
		 poke(addr, finalVal  )
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b10000000) --Set the flag with or
		 poke(addr, finalVal  )
	  end
   elseif r==1 then
	  bit = band(shr(currVal, 6), 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b10111111) --Unset the glag with and
		 poke(addr, finalVal  )
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b01000000) --Set the flag with or
		 poke(addr, finalVal  )
	  end
   elseif r==2 then
	  bit = band(shr(currVal, 5), 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b11011111) --Unset the glag with and
		 poke(addr, finalVal  )
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b00100000) --Set the flag with or
		 poke(addr, finalVal  )
	  end
   elseif r==3 then
	  bit = band(shr(currVal, 4), 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b11101111) --Unset the glag with and
		 poke(addr, finalVal  )
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b00010000) --Set the flag with or
		 poke(addr, finalVal  )
	  end
   end

   --printh("---")
   --printh("from: ".. currVal)
   --printh("to  : ".. finalVal)
   --printh("for addr: 0x" .. num2hex(addr))

end


function setBFromPoint(x,y,newVal)
   local index = x+y*128
   local addr = flr(index/4)+0x4300
   local currVal = peek(addr)
   local r = index%4
   local finalVal = 0

   if r==0 then
	  bit = band(shr(currVal, 3), 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b11110111) --Unset the glag with and
		 poke(addr, finalVal)
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b00001000) --Set the flag with or
		 poke(addr, finalVal)
	  end
   elseif r==1 then
	  bit = band(shr(currVal, 2), 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b11111011) --Unset the glag with and
		 poke(addr, finalVal)
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b00000100) --Set the flag with or
		 poke(addr, finalVal)
	  end
   elseif r==2 then
	  bit = band(shr(currVal, 1), 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b11111101) --Unset the glag with and
		 poke(addr, finalVal)
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b00000010) --Set the flag with or
		 poke(addr, finalVal)
	  end
   elseif r==3 then
	  bit = band(currVal, 0b00000001)
	  if bit == 1 and newVal==0 then
		 finalVal = band(currVal, 0b11111110) --Unset the glag with and
		 poke(addr, finalVal)
	  elseif bit==0 and newVal==1 then
		 finalVal = bor(currVal, 0b00000001) --Set the flag with or
		 poke(addr, finalVal)
	  end
   end
   --printh("---")
   --printh("from: ".. currVal)
   --printh("to  : ".. finalVal)
   --printh("for addr: 0x" .. num2hex(addr))
end





--function readobj(x,y)
--   local val = peek(fixind(x + (y*128)))
--   return {
--	  x=x,--x=ind%128,
--	  y=y,--y=flr(ind/128),
--	  c=val%16,
--	  s=shr(band(val, 0b1000000), 6),
--	  b=shr(band(val, 0b10000000), 7)
--   }
--end


function checkDist(x1, y1, x2, y2, treshold)
   --local dist =sqrt((x1 - x2)^2 + (y1 - y2)^2)
   local dist = abs(x1+1 - x2) + abs(y1+1 - y2)
   return (dist < treshold)
end


function pointsInBox(x,y,w,h)
   local points = {}
   for j=y-h/2,y+h/2 do	
	  for i=x-w/2,x+w/2 do	
		 add(points, {i,j})
	  end
   end
   return points
end


function destroyPoint(x,y)
   local checkBox = pointsInBox(x, y, 20, 20)
   for p in all(checkBox) do
      --local pointDataIndex = fixind(p[1] + (p[2]*128))
      --local pointData = peek(pointDataIndex)
      --local point_s = shr(band(pointData, 0b1000000), 6)
      --local point_b = shr(band(pointData, 0b10000000), 7)
	  local point_s = getSFromPoint(p[1], p[2])
	  local point_b = getBFromPoint(p[1], p[2])
      if checkDist(p[1], p[2], x, y, 5+rnd(5)) and point_s == 1 then
         --unsetobjs(pointDataIndex, pointData)
		 setSFromPoint(p[1], p[2], 0)

		 local point_c = getColFromPoint(p[1], p[2])
		 add(destroyedPoints, {p[1], p[2], 0, point_c, point_b})

         createParticle(p[1], p[2], point_c)
     end
   end

   shake.t = 21
end



function createParticle(x, y, c)
   add(particles, {x = x, y = y, c = c, sx = rnd(5)+1, sy = rnd(2)-1})
end

function createBoosterParticle(x, y, c)
   add(particles, {x = x, y = y, c = c, sx = rnd(5)+1, sy = rnd(2)-1})
end

function updateHp()
   sum = 0
   for bP in all(brokenData) do
      --decrease hp bar relative to color destroyed
      if     bP.c == 13 then sum += 2
      elseif bP.c == 2 then sum += 2
      elseif bP.c == 7 then sum += 1
      elseif bP.c == 6 then sum += 2
      elseif bP.c == 8 then sum += 13
      elseif bP.c == 9 then sum += 7
      end
   end
   hp = maxhp - sum
end


function getStruct()
   cls()
   spr(3, 16, 0, 16, 16)
   struct = {}
   for j=0,127 do
	  for i=0,127 do
		 local col = pget(i,j)
		 --writeobj(i,j,col,1,0)
		 if col!=0 then
			add(struct, {i,j})
			setSFromPoint(i,j,1)
			if col==3 then
				setBFromPoint(i,j,1)
			    add(botSpawnPoints, {i,j})
			else
				setBFromPoint(i,j,0)
			end
		 end
	  end
   end
   cls()
   return struct
end

function getBotSpawn()
   bS = {}
   for p in all(data) do 
      if p.b == 1 then
         add(bS, p)
      end
   end
   return bS
end
function drawShip()
   spr(3, 16, 0, 16, 16)
   for p in all(destroyedPoints) do
	  pset(p[1], p[2], 0)
   end
end

function drawStruct()
   foreach(data, drawPoint)
end

function drawBotSpawn()
   foreach(botSpawn, drawPoint)
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
      if (p.x < 0) del(particles, p) 
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
      createBoosterParticle(16, 40, 9)
      createBoosterParticle(16, 88, 9)
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
      add(bots, {x = 51, y = 63, s = rnd(1) + 2, t_ind=0, t = nil, wait = false})
      add(bots, {x = 51, y = 64, s = rnd(1) + 2, t_ind=0, t = nil, wait = false})
      add(bots, {x = 51, y = 65, s = rnd(1) + 2, t_ind=0, t = nil, wait = false})
      add(bots, {x = 51, y = 66, s = rnd(1) + 2, t_ind=0, t = nil, wait = false})
   end
end




function searchTarget()
   if #destroyedPoints > 0 then 
	  for p in all(destroyedPoints) do
		 if p[3]==0  and (botCol==p[4] or p[5]==1) then
			p[3] = 1
			return { x = p[1], y = p[2] }
		 end
	  end
   end
   return nil
end







function moveBots()
   for b in all(bots) do
      if b.t == nil then
		 --find target
         b.t = searchTarget()
		 if (b.t==nil) del(bots, b)
	  else
		 --move towards the target
		 if b.x < b.t.x then b.x += b.s
         elseif b.x > b.t.x then b.x -= b.s end
         if b.y < b.t.y then b.y += b.s
         elseif b.y > b.t.y then b.y -= b.s end


		 --Collision with target
		 if checkDist(b.x, b.y, b.t.x, b.t.y, 4) then
			--local pointAddr = fixind(b.t.x + (b.t.y*128))
			--local pointData = peek(pointAddr)
			--local pointS = shr(band(pointData, 0b1000000), 6)
			--local pointC = pointData%16
			local pointS = getSFromPoint(b.t.x, b.t.y)
			local pointC = getColFromPoint(b.t.x, b.t.y)

			--Extinguish fire
			for f in all(fires) do
			   if f.x == p.x and f.y == p.y then
				  del(fires, f)
			   end
			end

			--reset the point status
			--setobjs(pointAddr, pointData)
			setSFromPoint(b.t.x, b.t.y, 1)

			--Kill the bot
			del(bots, b)

			--increase hp bar relative to color repaired
			if     pointC == 13 then hp += 2
			elseif pointC ==  2 then hp += 2
			elseif pointC ==  7 then hp += 1
			elseif pointC ==  6 then hp += 2
			elseif pointC ==  8 then hp += 13
			elseif pointC ==  9 then hp += 7
			end
                  updateHp()
		 end
	  end
   end
end


function createFire()
   source = {x = flr(rnd(128)), y = flr(rnd(128)), growth = 0}
   add(fires, source)
   --local pointAddr = fixind(mx + (my*128))
   --local pointData = peek(pointAddr)
   --unsetobjs(pointAddr, pointData)
   setSFromPoint(mx, my, 0)               -- FIX THIS!!!!!
end


function updateFires()
   if #fires > 0 then
      for k=1,#fires do
         fires[k].growth += 0.02
         for i=0,30 do
            local point = shipPoints[flr(rnd(#shipPoints)) + 1]
			local tresh = rnd(1)+fires[k].growth
			local d = checkDist(point.x , point.y, fires[k].x, fires[k].y, tresh)
			--local pointAddr = fixind(mx + (my*128))
			--local pointData = peek(pointAddr)
			--local point_c = pointData%16
			--local point_s = shr(band(pointData, 0b1000000), 6)
			local point_c = getColFromPoint(mx, my) -- FIX THIS!!!!
			local point_s = getSFromPoint(mx, my) -- FIX THIS!!!!

            if d and point_s == 1 and point_c == 7 then
			   --unsetobjs(pointAddr, pointData)
			   setSFromPoint(mx, my, 0) -- FIX THIS!!!
               createParticle(point.x, point.y, 8)
               updateHp()
            end
         end
      end
   end
end


function selfDestruct()
   sdspeed += 50
   for i=0,sdspeed do
      point = shipPoints[flr(rnd(#shipPoints)) + 1]
	  --local pointAddr = fixind(point[1] + (point[2]*128))
	  --local pointData = peek(pointAddr)
	  --local point_s = shr(band(pointData, 0b1000000), 6)
	  local point_s = getSFromPoint(point[1], point[2])
	  if point_s != 0 then
		 --unsetobjs(pointAddr, pointData)
		 setSFromPoint(point[1], point[2], 0)
         if sdspeed < 250 then
            createParticle(point[1], point[2], 8)
         elseif sdspeed > 2000 then
            gameover = true
         end
	  end
   end
end


function createLaserone()
   laserone = {y = my, g = 0}
end

function drawLaserone()
   line(0, laserone.y, laserone.g, laserone.y, 11)
   line(0, laserone.y + 1, laserone.g, laserone.y + 1, 11)
end

function updateLaserone()
   laserone.g += 2
   for p in all(shipPoints) do
      if (p.x == laserone.g + 2 and p.y == laserone.y + flr(rnd(2)) - 1) then
         p.s = 0
         createParticle(p.x, p.y, p.c)
      end
   end
   if laserone.g > 128 then
      laserone = nil
   end
end


function cycleBots(dir)
   if dir == 0 then
      if botCol != 15 then
         botCol += 1
      else
         botCol = 0
      end
   else
      if botCol != 0 then
         botCol -= 1
      else
         botCol = 15
      end
   end

   for p in all(botSpawnPoints) do
      --local pointAddr = fixind(p[1] + (p[2]*128))
	  --local pointData = peek(pointAddr)
	  --local point_c = pointData%16
	  local point_c = getColFromPoint(p[1], p[2])
      --setobjc(pointAddr, pointData, botCol)
	  -- FIX THIS !!!
	  p[4] = botCol
   end
end


function drawHpBar()
   rectfill(0, 0, (hp/maxhp)*128, 4, 13)
   print(hp .. "/" .. maxhp, 49, 0, 7)
end


function createAsteroid()
   local ast = { x = 140, y = flr(rnd(128)), t = {x = flr(rnd(128)), y = flr(rnd(128))}, s = rnd(1) + 2 }
   --local ast = { x = 140, y = flr(rnd(128)), t = {x = 64, y = 50}, s = rnd(1) + 1 }
   local hit = false
   --local pointAddr = fixind(ast.t.x + (ast.t.y*128))
   --local pointData = peek(pointAddr)
   --local point_c = pointData%16
   local point_c = getColFromPoint(ast.t.x, ast.t.y)
   local point_b = getBFromPoint(ast.t.x, ast.t.y)
   if point_c != 0 then
      hit = true
      if point_b == 1 then
         hit = false
      end
   end
   if not hit then
      ast.t.x = -50
   end
   add(asteroids, ast)
end

function drawAsteroid()
   for a in all(asteroids) do
      circfill(a.x, a.y, 3, 5)
   end
end

function updateAsteroid()
   for a in all(asteroids) do
      if a.x <= -10 or a.y > 138 then
         del(asteroids, a)
      else
         local angle = atan2(a.t.x - a.x, a.t.y - a.y)
         a.x = a.x + a.s * cos(angle)
         a.y = a.y + a.s * sin(angle)
      
         dist = abs(a.x - a.t.x) + abs(a.y - a.t.y)
         if dist < 2 then
            destroyPoint(a.t.x, a.t.y)
            del(asteroids, a)
            break
         end
      end
   end
end

function drawGameOver()
   if gameover then
      rectfill(64-goan, 60, 64+goan, 65, 8)
      goan += 5
      if t % 8 != 0 then
         print("GAME OVER", 45, 60, 0)
      end
   end
end

--------------------------------




function _init()
   poke(0x5F2D, 1)
   memset(0x4300, 0, 0x1b00)
   mx = stat(32)
   my = stat(33)
   mb = stat(34)
   --dataIndexed = {}
   botSpawnPoints = {}
   destroyedPoints = {}
   shipPoints = getStruct()



   t=0
   particles = {}
   stars = createStars()

   shake = { x = 0, y = 0, t = 0}

   bots = {}

   fires = {}

   sdspeed = 1
   selfdestruct = false

   printh("--- start to find path")
   --findPath({64, 64}, {60, 30})
   --index = maptoindex(64,64)
   --pt = dataIndexed[index]
   --printh("TEST: " .. pt.x .. ", " .. pt.y)

   laserone = nil

   botCol = 3

   maxhp = 1500
   hp = maxhp

   asteroids = {}

   gameover = false
   goan = 0
end


function mouseMiddle()
   createFire()
end


function _update60()
   mx = stat(32)
   my = stat(33)

   camera(0 + shake.x, 0 + shake.y)
   screenShake()

   t += 1

   animateParticles()
   animateStars()

   if not selfdestruct then
      createBoosterParticles()
   end

   moveBots()

   updateFires()

   if btnp(4) then
      createBots()
   end

   if (btnp(0)) then
      cycleBots(0)
   elseif (btnp(1)) then
      cycleBots(1)
   end

   if selfdestruct and sdspeed < 2500 then selfDestruct() end


   if laserone != nil then
      updateLaserone()
   end

   if  t % 150 == 0 and not selfdestruct then
      createAsteroid()
   end 

   if t % 800 == 0 and not selfdestruct then
      createFire()
   end

   updateAsteroid()
   if hp <= 0 then
      selfdestruct = true
   end
end





function _draw()
   --if (not btn(5)) then
   cls()
   --end
   --foreach(shipPoints, drawPoint)
   drawStars()
   drawShip()
   drawParticles()
   if not selfdestruct then
      spr(3, 16, 0, 16, 16)
   end

   if (selfdestruct) then
      drawStruct()
   else
      drawBotSpawn()
      drawBrokenStruct()
      drawBoosters()
   end
   pset(mx, my, 8)
   print("Cpu1:"..stat(1), 0,  8, 8)
   print("Cpu2:"..stat(2), 0, 16, 8)
   print("Fps :"..stat(7), 0, 24, 8)
   print("Mem :"..stat(0), 0,  32, 11)
   print("ship pixels: " .. #shipPoints, 0, 56, 8)

   drawParticles()

   for b in all(bots) do
      pset(b.x, b.y, 11)
   end

   if (laserone != nil) then
      drawLaserone()
   end

   if not selfdestruct then
      drawHpBar()
   end

   drawAsteroid()
   drawGameOver()
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
	  for p in all(shipPoints) do
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
   return ((x+1) * 128) + y
end
function indextomap(index)
   local x = (index-1)/128
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


-->8
function num2hex(number)
    local base = 16
    local result = {}
    local resultstr = ""

    local digits = "0123456789abcdef"
    local quotient = flr(number / base)
    local remainder = number % base

    add(result, sub(digits, remainder + 1, remainder + 1))

  while (quotient > 0) do
    local old = quotient
    quotient /= base
    quotient = flr(quotient)
    remainder = old % base

         add(result, sub(digits, remainder + 1, remainder + 1))
  end

  for i = #result, 1, -1 do
    resultstr = resultstr..result[i]
  end

  return resultstr
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
