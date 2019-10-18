pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- adventure map demo / poc

debug=""
-- sprites
s_grass=1
s_door=5
s_odoor=6
s_key=7
s_trap=10

function _init()
 p={
  --player pos in cels
  x=2,
  y=4,
  s=3,
  g=0,
  i={}
 }
 --current map pos
 m={
  x=0,
  y=0
 }
 --start of map
 mstart={
  x=p.x,
  y=p.y
 }
 --target sprite, global for ease
 tspr=0
end

function _update()
 --deltas, intended updates
 --detect collision before
 --applying
 local dx=0
 local dy=0
 if (btnp(0)) dx=-1
 if (btnp(1)) dx=1
 if (btnp(2)) dy=-1
 if (btnp(3)) dy=1
 
 --new x/y or collided pos
 nx=p.x+dx
 ny=p.y+dy
 
 --target sprite
 tspr=mget(nx,ny)
 --detect collidables
 --& update player position
 if not fget(tspr,0) then
  p.x+=dx
  p.y+=dy
 end
 
 -- all things below are when
 -- the player -did- move to
 -- the new location
 
 check_chest()
 --detect doors
 check_door()
 check_key()
 check_trapdoor()
	update_map()
end

function check_chest()
 if fget(tspr,1) then
  p.g+=100
  sfx(0)
  mset(p.x,p.y,1)
 end 
end

function check_door()
 if tspr == s_door then
  --check key
  if haskey() then
   --change to open door
   mset(nx,ny, s_odoor)
   sfx(2)
   --remove key
   del(p.i,s_key)
  else
   --narp
   sfx(3)
  end
 end
end

function check_key()
 --detect key
 if tspr == s_key then
  add(p.i,s_key)
  sfx(0)
  mset(nx,ny,s_grass)
 end
end

function check_trapdoor()
 --detect trap floor
 if fget(tspr,2) then
  sfx(4)
  --teleport back to entrance
  p.x=mstart.x
  p.y=mstart.y 
 end
end

function update_map()
 --map transition
 local nmx=flr(p.x/16)
 local nmy=flr(p.y/16)
 if (m.x != nmx or m.y != nmy) then
  -- we are moving; record 
  -- players position on new map
  m.x=nmx
  m.y=nmy
  mstart={
   x=p.x,
   y=p.y
  }
 end
end

function _draw()
 cls()
 --draw current map section
 map(m.x*16,m.y*16,0,0,48,16)
 --draw player relative to map
 spr(p.s,(p.x%16)*8,(p.y%16)*8)

 print(debug,0,0,7)
end

-- todo: i'm sure there's a 
-- func to check if an array
-- has a key. eh.
function haskey() 
 for i in all(p.i) do
  if (i==s_key) return true
 end
 return false
end
__gfx__
0000000033333b3349444944009999003333333355555555555555553333333366666676555dd555999999a90000000000000000000000000000000000000000
000000003b333333494449440999999033344333559449555433333533333333666666665dddddd5999999990000000000000000000000000000000000000000
00700700333333339999999909f1ff10334444335494494554433335333aa333667666665d5555d599a999990000000000000000000000000000000000000000
00077000333333334449444949fffff034444443549449455443333533a33a3366666766dd5555dd99999a990000000000000000000000000000000000000000
0007700033b33333444944490ccccccc39999993549449a554433335333aa33366666666dd5555dd999999990000000000000000000000000000000000000000
0070070033333b3399999999f0cccc0f344aa4435494494554a33335333a3333667666675d5555d59999999a0000000000000000000000000000000000000000
00000000333333334944494400c00c00344444435494494554433335333aa333666666665dddddd599a999990000000000000000000000000000000000000000
00000000333333334944494400f00f00344444435555555555555555333a333366667666555dd5559999a9990000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58888885888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58555585555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58588585858585850000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58588585585858580000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58555585555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58888885888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58585585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58558585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58585585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58558585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58585585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58558585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58585585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58558585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
44494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449
44494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
4944494433333b3333333b3333333b3333333b3333333b3333333b3333333b33494449443333333333333b33333333334944494433333b3333333b3349444944
494449443b3333333b3333333b3333333b3333333b3333333b3333333b33333349444944333443333b33333333333333494449443b3333333b33333349444944
9999999933333333333333333333333333333333333333333333333333333333999999993344443333333333333aa33399999999333333333333333399999999
444944493333333333333333333333333333333333333333333333333333333344494449344444433333333333a33a3344494449333333333333333344494449
4449444933b3333333b3333333b3333333b3333333b3333333b3333333b33333444944493999999333b33333333aa3334449444933b3333333b3333344494449
9999999933333b3333333b3333333b3333333b3333333b3333333b3333333b3399999999344aa44333333b33333a33339999999933333b3333333b3399999999
4944494433333333333333333333333333333333333333333333333333333333494449443444444333333333333aa33349444944333333333333333349444944
4944494433333333333333333333333333333333333333333333333333333333494449443444444333333333333a333349444944333333333333333349444944
4944494433333b3333333b3333333b3333333b3333333b3333333b3333333b334944494433333b3333333b3333333b334944494433333b3333333b3349444944
494449443b3333333b3333333b3333333b3333333b3333333b3333333b333333494449443b3333333b3333333b333333494449443b3333333b33333349444944
99999999333333333333333333333333333333333333333333333333333333339999999933333333333333333333333399999999333333333333333399999999
44494449333333333333333333333333333333333333333333333333333333334449444933333333333333333333333344494449333333333333333344494449
4449444933b3333333b3333333b3333333b3333333b3333333b3333333b333334449444933b3333333b3333333b333334449444933b3333333b3333344494449
9999999933333b3333333b3333333b3333333b3333333b3333333b3333333b339999999933333b3333333b3333333b339999999933333b3333333b3399999999
49444944333333333333333333333333333333333333333333333333333333334944494433333333333333333333333349444944333333333333333349444944
49444944333333333333333333333333333333333333333333333333333333334944494433333333333333333333333349444944333333333333333349444944
4944494433333b3333333b3333333b3333333b3333333b3333333b3333333b33494449444944494455555555494449444944494433333b3333333b3349444944
494449443b3333333b3333333b3333333b3333333b3333333b3333333b33333349444944494449445594495549444944494449443b3333333b33333349444944
99999999333333333333333333333333333333333333333333333333333333339999999999999999549449459999999999999999333333333333333399999999
44494449333333333333333333333333333333333333333333333333333333334449444944494449549449454449444944494449333333333333333344494449
4449444933b3333333b3333333b3333333b3333333b3333333b3333333b333334449444944494449549449a5444944494449444933b3333333b3333344494449
9999999933333b3333333b3333333b3333333b3333333b3333333b3333333b33999999999999999954944945999999999999999933333b3333333b3399999999
49444944333333333333333333333333333333333333333333333333333333334944494449444944549449454944494449444944333333333333333349444944
49444944333333333333333333333333333333333333333333333333333333334944494449444944555555554944494449444944333333333333333349444944
4944494433333b333399993333333b3333333b333333333333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3355555555
494449443b333333399999933b3333333b333333333333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b33333355944955
999999993333333339f1ff133333333333333333333aa33333333333333333333333333333333333333333333333333333333333333333333333333354944945
444944493333333349fffff3333333333333333333a33a3333333333333333333333333333333333333333333333333333333333333333333333333354944945
4449444933b333333ccccccc33b3333333b33333333aa33333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b33333549449a5
9999999933333b33f3cccc3f33333b3333333b33333a333333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3354944945
494449443333333333c33c333333333333333333333aa33333333333333333333333333333333333333333333333333333333333333333333333333354944945
494449443333333333f33f333333333333333333333a333333333333333333333333333333333333333333333333333333333333333333333333333355555555
4944494433333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3349444944
494449443b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b33333349444944
99999999333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333399999999
44494449333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333344494449
4449444933b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333344494449
9999999933333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3399999999
49444944333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333349444944
49444944333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333349444944
4944494433333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3349444944
494449443b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b33333349444944
99999999333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333399999999
44494449333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333344494449
4449444933b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333344494449
9999999933333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3333333b3399999999
49444944333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333349444944
49444944333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333349444944
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
44494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449
44494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
49444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944494449444944
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
58888885888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888858888885
58555585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558555585
58588585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858558588585
58588585585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858588585
58555585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558555585
58888885888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888858888885
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555557755775755577555555555577755555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555575557575755575755755555575755555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555575557575755575755555555575755555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555575757575755575755755555575755555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555577757755777577755555555577755555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555575757775757555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555575757555757557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555577557755777555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555575757555557557555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555575757775777555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
58585585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558585585
58558585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558558585
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
58888885888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888858888885
58555585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558555585
58588585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858558588585
58588585585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858588585
58555585555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555558555585
58888885888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888858888885
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__gff__
0000010002010000000104000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101020401070201010202010101010101010101010101010105010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101020101010201010202010101010101010101010101010102020101010101020202020102010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101020205020201010202010101010101010101010101010102020101010101020104020102010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101070101010101010101010501010101010101010101010101010102020101010101020102020102010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101010101010202010202020202020101010101010102020101010101020101010102010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101010101010202010101010107020101010101010102020101010101020202020202010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101010101010202020202020202020202020202020202020202020202020202020202020201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101010101010202020202020202020202020202020202020202020202020202020202020201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101010101010202010101010101010101010101010102020101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101010101010202010101010101010101010101010102020101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101010101010101010202010101010101010101010101010102020101010101010101010202020101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101080808010101010101010202010101010101070101010101010102020101010101010101010504020101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101080808010101020202010201010101010101010101010101010101010101010101010101010202020101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101090809010101010101010101010101010101010101010101010102020101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202090809020202020202020202020202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090809090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09080808080a080a080808080808080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a0808080a080a0a0a080a0808080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a080a080a08080808080a0808080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a080a080a0a080a0a080a0a0a080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a080a08080a080a0808080808080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a080a0a080a080a080a0a0a0a080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090808080a08080808080808080a080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09080a0808080a0a0a080a0a080a080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09080a0a0a08080808080808080a080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09080a0808080a0a080a0a0a0a0a080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09080a0a0a0a0a08080808080808080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09080808080808080a0a0a0a0a080a0900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a080a080a0a0a0a0808080a080a0900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a080a080808080a0808080808080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090908090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000700002e5502e400355500000000000000003200032000350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900000a05003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e000027150291502a1502b1502b1402b1302b1202b110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00001315013150131001310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600002e0702d0702906024060200501b0501505011040090300001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
