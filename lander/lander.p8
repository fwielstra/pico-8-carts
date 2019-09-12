pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
  game_over=false
  win=false
  g=0.025 --gravity
  -- random stars for every lvl
  starseed=flr(rnd(127))
  make_player()
  make_ground()
end

function _update()
  if (not game_over) then
    move_player()
    check_land()
  else
  	if (btnp(5)) _init()
  end
end

function _draw()
  cls()
  draw_stars()
  draw_ground()
  draw_player()
  
  if (game_over) then
    if (win) then
      print("a winner is you!",35,48,11)
    else
      print("sadfeis!",48,48,8)
    end
    print("press ❎ to play again",20,70,5)
  end
end
-->8
-- player functions

function make_player()
  p={
    -- position
    x=60,
    y=8,
    dx=0,
    dy=0,
    sprite=1,
    alive=true,
    thrust=0.075
  }
end

function draw_player()
  spr(p.sprite,p.x,p.y)
  if (game_over and win) then
    spr(4,p.x,p.y-8) -- flag
  elseif (game_over) then
    spr(5,p.x,p.y) -- boom
  end 
end

function move_player()
  p.dy += g -- add gravity
  
  thrust()

  p.x += p.dx --hori mov
  p.y += p.dy --vert mov
  stay_on_screen()
end

function thrust()
  -- add thrust to movement
  -- l/r
  if (btn(0)) p.dx-=p.thrust
  if (btn(1)) p.dx+=p.thrust
  -- up; down is done by grav
  if (btn(2)) p.dy-=p.thrust
  
  -- sound
  if (btn(0) or btn(1) or btn(2)) sfx(2)
end

-- fixes position and kills 
-- velocity on screen edges
function stay_on_screen()
  -- left
  if(p.x<0) then
    p.x=0
    p.dx=0
  end
  
  -- right, minus sprite width
  if(p.x>119) then
    p.x=119
    p.dx=0
  end
  
  -- top
  if(p.y<0) then
    p.y=0
    p.dy=0
  end
end

function check_land()
  l_x=flr(p.x)   --left side
  r_x=flr(p.x+7) --right side
  b_y=flr(p.y+7) -- bottom
  
  over_pad=l_x>=pad.x and r_x<=pad.x+pad.width
  on_pad=b_y>=pad.y-1
  slow=p.dy<1
  
  if (over_pad and on_pad and slow) then
    end_game(true)
  elseif (over_pad and on_pad) then
    end_game(false)
  else
    for i=l_x,r_x do
      if(gnd[i]<b_y) end_game(false)
    end
  end
end

function end_game(won)
  game_over=true
  win=won
  
  if(win) then
    sfx(0)
  else
    sfx(1)
  end
end
-->8
-- stars
function rndb(low,high)
	return flr(rnd(high-low+1)+low)
end

function draw_stars()
  -- set rand seed to fixed
  -- for repeated results
  srand(starseed)
  for i=1,50 do
    pset(rndb(0,127),rndb(0,127),rndb(5,7))
  end
  -- reset rand seed
  srand(time())
end
-->8
-- ground
-- stored as list of heights
-- across the x axis
-- with a flat for the landing pad

function make_ground()
  gnd={}
  local top=96 -- upper bound
  local btm=120 -- lower bound
  
  -- create landing pad
  pad={}
  pad.width=15
  pad.x=rndb(0,126-pad.width)
  pad.y=rndb(top,btm)
  pad.sprite=2
  
  --create ground at pad
  for i=pad.x,pad.x+pad.width do
    gnd[i]=pad.y
  end
  
  --create ground right of pad
  --take left val and vary by +- 3
  for i=pad.x+pad.width+1,127 do
    local prev=gnd[i-1]
    local h=rndb(prev-3,prev+3)
    gnd[i]=mid(top,h,btm)
  end
  
  --create ground left of pad
  for i=pad.x-1,0,-1 do
    local nxt=gnd[i+1]
    local h=rndb(nxt-3,nxt+3)
    gnd[i]=mid(top,h,btm)
  end
end

function draw_ground()
  for i=0,127 do
  	line(i,gnd[i],i,127,5)
  end
  spr(pad.sprite,pad.x,pad.y,2,1)
end
__gfx__
0000000000666600761dddddddddd766000000000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066c76607666666666666666000000000899998000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070066ccc766007666666666660000000000899aa99800000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700066cccc660000000000000000000b600089aaaa9800000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700066555566000000000000000000bb600089aaaa9800000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000666666000000000000000000bbb6000899aa99800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050550500000000000000000000060000899998000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000660660660000000000000000000060000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000c00001807018030140701403010070100301a0701a030000001507019070190300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400003c07036060320502f0402b0402803024030200301d020190201602014020100100e0100d0100a01008010060100501000000000000000000000000000000000000000000000000000000000000000000
00100000086300b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
