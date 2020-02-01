pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function getcolfrompoint(x,y)
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




function getsfrompoint(x,y)
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

function getbfrompoint(x,y)
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


function setsfrompoint(x,y,newval)
   local index = x+y*128 
   local addr = flr(index/4)+0x4300
   local currval = peek(addr)
   local r = index%4
   local finalval = 0

   --printh("setting b for addr: 0x" .. num2hex(addr))
   
   if r==0 then
	  currval = band(shr(val, 7), 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b01111111) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b10000000) --set the flag with or
      end
   elseif r==1 then
	  currval = band(shr(val, 6), 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b10111111) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b01000000) --set the flag with or
      end
   elseif r==2 then
	  currval = band(shr(val, 5), 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b11011111) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b00100000) --set the flag with or
      end
   elseif r==3 then
	  currval = band(shr(val, 4), 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b11101111) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b00010000) --set the flag with or
      end
   end

end


function setbfrompoint(x,y,newval)
   local index = x+y*128
   local addr = flr(index/4)+0x4300
   local currval = peek(addr)
   local r = index%4
   local finalval = 0

   if r==0 then
	  currval = band(shr(val, 3), 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b11110111) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b00001000) --set the flag with or
      end
   elseif r==1 then
	  currval = band(shr(val, 2), 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b11111011) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b00000100) --set the flag with or
      end
   elseif r==2 then
	  currval = band(shr(val, 1), 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b11111101) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b00000010) --set the flag with or
      end
   elseif r==3 then
	  currval = band(val, 0b00000001)
	  if currval == 1 and newval==0 then
		 finalval = band(currval, 0b11111110) --unset the glag with and
	  elseif currval==0 and newval==1 then
		 finalval = bor(currval, 0b00000001) --set the flag with or
      end
   end
end





function _init()

   -- clear all user data
   memset(0x4300, 0, 0x1b00)

   for j=0,8 do
	  for i=0,8 do
		 if i%2==0 then
			setsfrompoint(i,j,1)
		 else
			setsfrompoint(i,j,0)
		 end
	  end
   end

end


function _draw()
   cls()
   pset(31,31,8)
   pset(31+16+2,31,8)
   
   for j=0,16 do
	  for i=0,16 do
		 local s = getsfrompoint(i,j)
		 if s==0 then
			pset(i+32,j+32,2)
		 else
			pset(i+32,j+32,3)
		 end
	  end
   end
end









__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
