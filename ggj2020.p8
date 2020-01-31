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
	  if p.x==x and p.y==y then
		 p.s = 0
	  end
   end
end


function getStruct()
   cls()
   spr(1, 32, 32, 8, 8)
   struct = {}
   for j=0,127 do
	  for i=0,127 do
		 if pget(i,j)!=0 then
			add(struct, makePoint(i, j, 6))
		 end
	  end
   end
   cls()
   return struct
end

function updatePoint(p)

end


function drawPoint(p)
   if p.s==1 then
	  pset(p.x, p.y, p.c)
   else
	  pset(p.x, p.y, 2)
   end

end

function drawStruct()
   foreach(data, drawPoint)
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



--------------------------------




function _init()
    poke(0x5F2D, 1)
	mx = stat(32)
	my = stat(33)
	mb = stat(34)
	data = getStruct()
	t = 0
	pset(127,0,8)
end


function mouseLeft()
	destroyPoint(mx, my)
end

function _update()
	mx = stat(32)
	my = stat(33)


	if mb==0 then
		mb = stat(34)
		if mb==1 then
		   mouseLeft()
		end
	end
	mb = stat(34)


   foreach(data, updatePoint)
   t += 0.01
end





function _draw()
   cls()
   drawStruct()

   pset(mx, my, 8)

   print("Mem :"..stat(0), 0,  0, 8)
   print("Cpu1:"..stat(1), 0,  8, 8)
   print("Cpu2:"..stat(2), 0, 16, 8)
   print("Fps :"..stat(7), 0, 24, 8)
   print("mx: " .. mx, 0, 32, 8)
   print("my: " .. my, 0, 40, 8)
   print("mb: " .. mb, 0, 48, 8)
end




--cose
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555556666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555566666666665555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000556666666666665555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000056666666666666666655555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000056666666666666666665555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666666666666666666655500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005556666666666666666665550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000556666666666666666666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000556666666666666666666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000055666666666666666666666550000000000000000000000000000000555500000000000000000000000000000000000000000000000000000000
00000000000055566666666666666666666665550000000000055555555555555555555500000000000000000000000000000000000000000000000000000000
00000000000005556666666666666666666665555555555555555555555555555556665500000000000000000000000000000000000000000000000000000000
00000000000000056666666666666666666666666655555555555555556666556666665000000000000000000000000000000000000000000000000000000000
00000000000000005566666666666666666666666666666666666666666666666666665000000000000000000000000000000000000000000000000000000000
00000000000000000556666666666666666666666666666666666666666666666666655000000000000000000000000000000000000000000000000000000000
00000000000000000055566666666666666666666666666666666666666666666666550000000000000000000000000000000000000000000000000000000000
00000000000000000005556666666666666666666666666666666666666666665555550000000000000000000000000000000000000000000000000000000000
00000000000000000005556666666666666666666666666666666666666666655555500000000000000000000000000000000000000000000000000000000000
00000000000000000055556666666666666666666666666666666666666666555555000000000000000000000000000000000000000000000000000000000000
00000000000000000055556666666666666666666666666666666666666655555550000000000000000000000000000000000000000000000000000000000000
00000000000000000555566666666666666666666666666666666666665555555500000000000000000000000000000000000000000000000000000000000000
00000000000000000555566666666666666666666666666666666555555555555000000000000000000000000000000000000000000000000000000000000000
00000000000000000055566666666666666666666666666666655555555555000000000000000000000000000000000000000000000000000000000000000000
00000000000000000055566666666666666665555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000005566666666666666555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000556666666666655555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000005566666666666655550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000055566666666666555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555666666666655555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000055556666666666655555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000555566666666666655555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005555666666666666555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000555556666666666665555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005555556666666666665555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555666666666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555666666666665555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005555666655566655555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005555555555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000055555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
