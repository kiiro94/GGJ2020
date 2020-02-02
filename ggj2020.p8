pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main


--Screen from 0 to 127
--Data   from 1 to 128


------------------------------------------
-------------MEMORY STUFF-----------------
------------------------------------------


-- 0000 0000 -> 1 byte
-- SSSS BBBB -> leftmost 4 are 4 pixels of S, rightmost 4 are 4 pixels of B
-- 1234 1234

function getColFromPoint(x,y)
   return sget(x+8,y)
end

function setColFromPoint(x,y,newCol)
   sset(x+8,y,newCol)
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
end




--====================================
------------ UTILS -------------------
--====================================

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

function getStruct()
   cls()
   spr(3, 16, 0, 16, 16)
   struct = {}
   for j=0,127 do
	  for i=0,127 do
		 local col = pget(i,j)
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
   for p in all(shipPoints) do 
	  local point_s = getBFromPoint(p[1], p[2])
      if point_s == 1 then
         add(bS, p)
      end
   end
   return bS
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


--====================================
------------ Actions -----------------
--====================================

function destroyPoint(x,y)
   local checkBox = pointsInBox(x, y, 16, 16)
   for p in all(checkBox) do
	  local point_s = getSFromPoint(p[1], p[2])
	  local point_b = getBFromPoint(p[1], p[2])
      if checkDist(p[1], p[2], x, y, 5+rnd(5)) and point_s == 1 then
		 setSFromPoint(p[1], p[2], 0)
		 local point_c = getColFromPoint(p[1], p[2])
		 add(destroyedPoints, {p[1], p[2], 0, point_c, point_b})
		 createParticle(p[1], p[2], point_c)
		 updateHp()
	  end
   end
   shake.t = 21
end

function selfDestruct()
   sdspeed += 50
   for i=0,sdspeed do
      point = shipPoints[flr(rnd(#shipPoints)) + 1]
	  local point_s = getSFromPoint(point[1], point[2])
	  if point_s != 0 then
		 setSFromPoint(point[1], point[2], 0)
         if sdspeed < 250 then
            createParticle(point[1], point[2], 8)
         elseif sdspeed > 2000 then
            gameover = true
         end
	  end
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
	  local point_c = getColFromPoint(p[1], p[2])
	  setColFromPoint(p[1], p[2], botCol)
	  p[4] = botCol
   end
end

--====================================
------------ Inits -------------------
--====================================

function createParticle(x, y, c)
   add(particles, {x = x, y = y, c = c, sx = rnd(2)+0.1, sy = rnd(2)-1, size = rnd(1)})
end

function createBoosterParticle(x, y, c)
   add(particles, {x = x, y = y+rnd(6)-3, c = c, sx = rnd(2)+1, sy = rnd(2)-1, size = 1})
end

function createStars()
   s = {}
   for i = 0,25 do
      add(s, {x = rnd(127), y = rnd(127), l = flr(rnd(3))})
   end
   return s
end

function createBoosterParticles()
   createBoosterParticle(16, 40, 9)
   createBoosterParticle(16, 88, 9)
end

function createBot()
   local pos = botSpawnPoints[flr(rnd(#botSpawnPoints))+1]
   add(bots, {x = pos[1], y = pos[2], s = rnd(1) + 2,
			  t_ind=0, t = nil, path = {}})
end

function createBots()
   if #bots < 20 then
	  createBot()
	  createBot()
	  createBot()
   end
end

function createFire()
   source = {x = flr(rnd(128)), y = flr(rnd(128)), growth = 0}
   local point_c = getColFromPoint(source.x, source.y)
   if (point_c == 7) then
      setSFromPoint(source.x, source.y, 0)
      add(fires, source)
   end
end

function createLaserone()
   laserone = {y = my, g = 0}
end

function createAsteroid()
   local ast = { x = 140, y = flr(rnd(128)), t = {x = flr(rnd(128)), y = flr(rnd(128))}, s = rnd(1) + 2 }
   local hit = false
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

function _init()
   --clean memory
   memset(0x4300, 0, 0x1b00)

   --init mouse
   poke(0x5F2D, 1)
   mx = stat(32)
   my = stat(33)
   mb = stat(34)

   --setup data structs
   particles = {}
   botSpawnPoints = {}
   destroyedPoints = {}
   shipPoints = getStruct()
   stars = createStars()

   --screenshake
   shake = { x = 0, y = 0, t = 0}

   --bots
   bots = {}
   botCol = 3

   --hazards
   fires = {}
   sdspeed = 1
   laserone = nil
   asteroids = {}

   --game loop
   selfdestruct = false
   t=0
   maxhp = 1500
   hp = maxhp
   gameover = false
   goan = 0

   --pretty stuff
   pretty_rect = {x=64,y=64,size=128, targ_size=128, ang=0, ang_delta=0.01}
end

--====================================
------------ Updates -----------------
--====================================

function updateHp()
   sum = 0
   for bP in all(destroyedPoints) do
      --decrease hp bar relative to color destroyed
      if     bP[4] == 13 then sum += 2
      elseif bP[4] == 2 then sum += 2
      elseif bP[4] == 7 then sum += 1
      elseif bP[4] == 6 then sum += 2
      elseif bP[4] == 8 then sum += 13
      elseif bP[4] == 9 then sum += 7
      end
   end
   hp = maxhp - sum
end

function updateParticles()
   for p in all(particles) do
      p.x -= p.sx
      p.y += p.sy
      if (p.x < 0) del(particles, p) 
   end
end

function updateStars()
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

function updateBots()
   for b in all(bots) do
      if b.t == nil then
		 --search for target/path
         b.t = searchTarget()
		 if b.t!=nil then
			b.path = findPath({b.x, b.y}, {b.t.x, b.t.y})
		 end
		 if b.t==nil or path == nil then
			del(bots, b)
		 end
	  else
		 --move
		 if #b.path > 0 then
			b.x = b.path[1][1]
			b.y = b.path[1][2]
			del(b.path, b.path[1])
		 end

		 --Collision with target
		 if checkDist(b.x, b.y, b.t.x, b.t.y, 4) then
			local pointS = getSFromPoint(b.t.x, b.t.y)
			local pointC = getColFromPoint(b.t.x, b.t.y)

			--Extinguish fire
			for f in all(fires) do
			   if f.x == b.x and f.y == b.y then
				  del(fires, f)
			   end
			end

			--reset the point status
			setSFromPoint(b.t.x, b.t.y, 1)
			for p in all(destroyedPoints) do
			   if p[1] == b.t.x and p[2] == b.t.y then
				  del(destroyedPoints, p)
			   end
			end

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

function updateFires()
   if #fires > 0 then
      for k=1,#fires do
         fires[k].growth += 0.02
         for i=0,30 do
            local point = shipPoints[flr(rnd(#shipPoints)) + 1]
            local tresh = rnd(1)+fires[k].growth
            local d = checkDist(point[1] , point[2], fires[k].x, fires[k].y, tresh)

            local point_c = getColFromPoint(point[1], point[2])
            local point_s = getSFromPoint(point[1], point[2])

            if d and point_s == 1 and point_c == 7 then
               setSFromPoint(point[1], point[2], 0)
               createParticle(point[1], point[2], 8)
               updateHp()
            end
         end
      end
   end
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
			pretty_rect.x = a.t.x
			pretty_rect.y = a.t.y
			pretty_rect.size = 2
			pretty_rect.ang_delta = (rnd(100)-50)/1000
            del(asteroids, a)

            break
         end
      end
   end
end

function _update60()
   --mouse
   mx = stat(32)
   my = stat(33)

   --screenshake
   camera(0 + shake.x, 0 + shake.y)
   screenShake()

   --time variable
   t += 1

   --Update objects
   updateParticles()
   updateStars()
   if (not selfdestruct) createBoosterParticles()
   updateBots()
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

   if  t % 50 == 0 and not selfdestruct then
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




--====================================
------------ Draws -------------------
--====================================

function drawShip()
   spr(3, 16, 0, 13, 16)
   for p in all(destroyedPoints) do
	  pset(p[1], p[2], 0)
   end
end

function drawPoint(p)
   local point_c = getColFromPoint(p[1], p[2])
   local point_s = getSFromPoint(p[1], p[2])
   if point_s==1 then
	  pget(p[1], p[2], point_c)
   end
end

function drawParticles()
   for p in all(particles) do
      --pset(p.x, p.y, p.c)
	  circfill(p.x, p.y, p.size, p.c)
   end
end

function drawStars()
   for s in all(stars) do
      pset(s.x, s.y, 7)
   end
end

function drawLaserone()
   line(0, laserone.y, laserone.g, laserone.y, 11)
   line(0, laserone.y + 1, laserone.g, laserone.y + 1, 11)
end

function drawHpBar()
   rectfill(0, 0, (hp/maxhp)*128, 4, 13)
   print(hp .. "/" .. maxhp, 49, 0, 7)
end

function drawAsteroid()
   for a in all(asteroids) do
      circfill(a.x, a.y, 3, 5)
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


function drawPrettyRect()
   if pretty_rect.size < pretty_rect.targ_size then
	  if pretty_rect.size == 0 then pretty_rect.size=1 end
	  pretty_rect.size *= 1.1
	  pretty_rect.ang += pretty_rect.ang_delta
	  local x1 = pretty_rect.x + pretty_rect.size*cos(pretty_rect.ang)
	  local y1 = pretty_rect.y + pretty_rect.size*sin(pretty_rect.ang)
	  local x2 = pretty_rect.x + pretty_rect.size*cos(pretty_rect.ang + 0.25)
	  local y2 = pretty_rect.y + pretty_rect.size*sin(pretty_rect.ang + 0.25)
	  local x3 = pretty_rect.x + pretty_rect.size*cos(pretty_rect.ang + 0.5)
	  local y3 = pretty_rect.y + pretty_rect.size*sin(pretty_rect.ang + 0.5)
	  local x4 = pretty_rect.x + pretty_rect.size*cos(pretty_rect.ang + 0.75)
	  local y4 = pretty_rect.y + pretty_rect.size*sin(pretty_rect.ang + 0.75)
	  line(x1+1, y1+1, x2+1, y2+1, 9)
	  line(x2+1, y2+1, x3+1, y3+1, 9)
	  line(x3+1, y3+1, x4+1, y4+1, 9)
	  line(x4+1, y4+1, x1+1, y1+1, 9)

	  line(x1, y1, x2, y2, 8)
	  line(x2, y2, x3, y3, 8)
	  line(x3, y3, x4, y4, 8)
	  line(x4, y4, x1, y1, 8)
   end
end


function _draw()
   cls(shake.x%3)

   --draw layers
   drawStars()
   if (selfdestruct) then
	  foreach(shipPoints, drawPoint)
   else
      drawShip()
	  foreach(botSpawn, drawPoint)
	  if t % 4 == 0 then
		 spr(65, 16, 32, 2, 2)
		 spr(65, 16, 80, 2, 2)
	  end
   end
   drawParticles()
   for b in all(bots) do pset(b.x, b.y, 11) end
   if (laserone != nil) then drawLaserone() end
   drawAsteroid()

   --gui
   if not selfdestruct then drawHpBar() end
   drawGameOver()
   drawPrettyRect()

   --debug
   if btn(2) then
	  pset(mx, my, 8)
	  print("Cpu1:"..stat(1), 0,  8, 8)
	  print("m:" .. mx .. "," .. my, 0,  16, 8)
	  print("cose :".. #particles , 0, 24, 8)
   end

end




























--Total count : 16053
--with start : 33,62
--with goal : 47,62









--------------------------------






function mouseMiddle()
   createFire()
end







--cose


-->8
--pathfinding

function findPath(start, goal)
   if goal==nil then return nil end
   if start==nil then return nil end

   --printh("start: " .. start[1] .. "," .. start[2])

   --initialize data with current point
   frontier = {}
   insert(frontier, start, 0)
   came_from = {}
   came_from[vectoindex(start)] = nil
   cost_so_far = {}
   cost_so_far[vectoindex(start)] = 0

   --Cycle until i have frontiers unexplored
   local count = 0
   while (#frontier > 0 and #frontier < 1000) do
	  count += 1
	  --Take the current frontier tile
	  current = popEnd(frontier)
	  if current!=nil then

		 --If I have reach my goal we can break
		 if (vectoindex(current) == vectoindex(goal)) then
			printh("Reached goal!")
			break 
		 end

		 --Get cycle through all the neighbours
		 local neighbours = {}
		 local x = current[1]
		 local y = current[2]




		 if (rnd(100)<100 and x>0) then
			if (sget(x-1, y) != 2 or getSFromPoint(x-1,y)==0) then
			   add(neighbours, {x-1,y})
			end
		 end

		 if (rnd(100)<100 and x<127) then
			if (sget(x+1, y) != 2 or getSFromPoint(x+1,y)==0) then
			   add(neighbours, {x+1,y})
			end
		 end

		 if (rnd(100)<100 and y>0) then
			if (sget(x, y-1) != 2 or getSFromPoint(x,y-1)==0) then
			   add(neighbours, {x,y-1})
			end
		 end

		 if (rnd(100)<100 and y<127) then
			if (sget(x, y+1) != 2 or getSFromPoint(x,y+1)==0) then
			   add(neighbours, {x,y+1})
			end
		 end

		 if ((x+y) % 2 == 0) reverse(neighbours)


		 for next in all(neighbours) do
			local nextIndex = vectoindex(next)
			local new_cost = cost_so_far[vectoindex(current)] + 1

			--If I have not explored this tile or if I found a better route to an existing one
			if (cost_so_far[nextIndex] == nil) or (new_cost < cost_so_far[nextIndex]) then
			   --Set this tile as a new frontier and save its cost
			   cost_so_far[nextIndex] = new_cost
			   insert(frontier, next, new_cost + heuristic(goal, next))
			   came_from[nextIndex] = current
			end 
		 end
	  end
   end
   printh("Total count : " .. count)
   printh("with start : " .. start[1] .. "," .. start[2])
   printh("with goal : " .. goal[1] .. "," .. start[2])

   --printh("exited loop")
   --printh("came from count: " .. #came_from)
   --printh("frontier count: " .. #frontier)
   --printh("start: " .. start[1] .. "," .. start[2])
   --printh("goal : " .. goal[1] .. "," .. goal[2])

   --Recreate the path from the goal
   current = came_from[vectoindex(goal)]
   path = nil
   if current != nil then
	  path = {}
	  local cindex = vectoindex(current)
	  local sindex = vectoindex(start)
	  while cindex != sindex do
		 add(path, current)
		 current = came_from[cindex]
		 cindex = vectoindex(current)
	  end
	  reverse(path)
   end

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
   --printh("find neighbours for " .. pos[1] .. "," .. pos[2] )
   local neighbours={}
   local x = pos[1]
   local y = pos[2]

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
0000000000000000000000000000000111111222222272222222ddd6110000000000000000000000000000000000000000000000000000000000000000000000
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
000000007777700000000000799991f8888827777777777777777677777777777777777777777771111111111111116666111116666666666666110000000000
000000000777700000000000079991f888882777777777777777227777777777777777777777772f116666666666666666666666666666666666110000000000
000000000077700000000000007991f888882777777777777772dd27777777777777777777777728ff1166666666666666666666666666666666110000000000
0000000000077000000000000007711f88882777777777777772dd2777777777777777777777772888ff17777777777777777777777777777771100000000000
00000000000000000000000000000001ffff2777777777777772dd277777777777777777777777288888f1777777777777777777777777711111000000000000
0000000000000000000000000000000011112777777777777772dd27777777777777777777777721111111111111111111111111111111111110000000000000
0000000000000000000000000000000001662777777777777772dd27777777777777777777777721111111111111111111111111111111100000000000000000
000000000000000000000000000000001ddd2222222777777722dd22777777222222222777777200000000000000000000000000000000000000000000000000
000000000000000000000000000000001dddd62dddd2666662dddddd266662ddddddddd266666222222222222222221100000000000000000000000000000000
000000000000000000000000000000001ddddd627227777777227722777777222272222777777772777777777777772210000000000000000000000000000000
000000000000000000000000000000001ddddd627777777777777777777777777777777777777772777777777777777211000000000000000000000000000000
0000000000000000000000000000000001dddd6277777777777777777777777777777777777777727777777777777772f1100000000000000000000000000000
00000000000000000000000000000000001ddd62777777777777777777777777777777777777777277777777777777772f110000000000000000000000000000
000000000000000000000000000000000001dd627777777777777777777777777777777777777772777777777777777728f11000000000000000000000000000
000000000000000000000000000000000000111277777777777777777777777777777777777777722222222777772222288f1100000000000000000000000000
0000000000000000000000000000000000001ff2777777722226666222222222666662222277777772222dd26662dddd2288f110000000000000000000000000
0000000000000000000000000000000000001f827777772222333333222222233333332222277777777727277777222722222111000000000000000000000000
0000000000000000000000000000000000001f8277777722333333333333333333333333322777777777777777777777777772f1100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777233333333333333333333333333327777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f887777777633333333333333333333333333367777777777777777777777777778f100000000000000000000000
000000000000000000000000000000000001f882777777633333333333333333333333333367777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777233333333333333333333333333327777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777223333333333333333333333333227777777777777777777777777728f100000000000000000000000
0000000000000000000000000000000000001f8277777722333333333333333333333333322777777777777777777777777772f1100000000000000000000000
0000000000000000000000000000000000001f827777772222333333222222233333332222277777777727277777222722222111000000000000000000000000
0000000000000000000000000000000000001ff2777777722226666222222222666662222277777772222dd26662dddd2288f110000000000000000000000000
000000000000000000000000000000000000111277777777777777777777777777777777777777722222222777772222288f1100000000000000000000000000
000000000000000000000000000000000001dd627777777777777777777777777777777777777772777777777777777728f11000000000000000000000000000
00000000000000000000000000000000001ddd62777777777777777777777777777777777777777277777777777777772f110000000000000000000000000000
0000000000000000000000000000000001dddd6277777777777777777777777777777777777777727777777777777772f1100000000000000000000000000000
000000000000000000000000000000001ddddd627777777777777777777777777777777777777772777777777777777211000000000000000000000000000000
000000000000000000000000000000001ddddd627227777777227722777777222272222777777772777777777777772210000000000000000000000000000000
000000000000000000000000000000001dddd62dddd2666662dddddd266662ddddddddd266666222222222222222221100000000000000000000000000000000
000000000000000000000000000000001ddd2222222777777722dd22777777222222222777777200000000000000000000000000000000000000000000000000
0000000000000000000000000000000001662777777777777772dd27777777777777777777777721111111111111111111111111111111100000000000000000
0000000000000000000000000000000011112777777777777772dd27777777777777777777777721111111111111111111111111111111111110000000000000
00000000000000000000000000000001ffff2777777777777772dd277777777777777777777777288888f1777777777777777777777777711111000000000000
0000000000000000000000000007711f88882777777777777772dd2777777777777777777777772888ff17777777777777777777777777777771100000000000
000000000000000000000000007991f888882777777777777772dd27777777777777777777777728ff1166666666666666666666666666666666110000000000
000000000000000000000000079991f888882777777777777777227777777777777777777777772f116666666666666666666666666666666666110000000000
000000000000000000000000799991f8888827777777777777777677777777777777777777777771111111111111116666111116666666666666110000000000
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
0000000000000000000000000000000111111222222272222222ddd6110000000000000000000000000000000000000000000000000000000000000000000000
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
