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
end


function mouseLeft()
	destroyPoint(mx, my)
end

function mouseRight()
   recreateEveryPoint()
end

function _update()
	mx = stat(32)
	my = stat(33)


	if mb==0 then
		mb = stat(34)
		if mb==1 then
		   mouseLeft()
		elseif mb==2 then
         mouseRight()
      end
	end
	mb = stat(34)

   t += 1

   animateParticles()
   animateStars()
   createBoosterParticles()
end





function _draw()
   cls()
   drawStars()
   drawParticles()
   drawStruct()
   drawBoosters()
   pset(mx, my, 8)
   if btn(5) then
	  print("Mem :"..stat(0), 0,  0, 8)
	  print("Cpu1:"..stat(1), 0,  8, 8)
	  print("Cpu2:"..stat(2), 0, 16, 8)
	  print("Fps :"..stat(7), 0, 24, 8)
	  print("mx: " .. mx, 0, 32, 8)
	  print("my: " .. my, 0, 40, 8)
	  print("mb: " .. mb, 0, 48, 8)
   end
end




--cose
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
0000000000000000000000000000000000001f827777772222777777222222277777772222277777777722277777222222222111000000000000000000000000
0000000000000000000000000000000000001f8277777722777777777777777777777777722777777777777777777777777772f1100000000000000000000000
000000000000000000000000000000000001f882777777227777777777777777777777777227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777227777777777777777777777777227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777277777777777777777777777777727777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777677777777777777777777777777767777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777677777777777777777777777777767777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777277777777777777777777777777727777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777227777777777777777777777777227777777777777777777777777728f100000000000000000000000
000000000000000000000000000000000001f882777777227777777777777777777777777227777777777777777777777777728f100000000000000000000000
0000000000000000000000000000000000001f8277777722777777777777777777777777722777777777777777777777777772f1100000000000000000000000
0000000000000000000000000000000000001f827777772222777777222222277777772222277777777722277777222222222111000000000000000000000000
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
