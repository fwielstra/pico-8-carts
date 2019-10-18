pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- toy train
-- tutorial

function _init()
 switch_state=0
 train={
  {64,8},
  {72,8},
  {80,8}
 }
end

function _update()
 if btpn(4) then
  adv_switch()
 end

 for t in all(train) do
  move_segment(t,switch_state)
 end
end

function _draw()
 cls()
 mpa(0,0,0,0,16,16)
 draw_switch()
 draw_train()
end

function move_segment(s,dir)
 spd=dir*2
 
 --top side
 if s[2]==8 then
  --top right; set y
  if s[1]==112 then
   s[2]+=spd
  else
   s[1]+=spd
  end
 
 -- right side
 elseif s[1]==112 then
  -- bottom right
  if s[2]==112 then
   s[1]-=spd
  else
   s[2]+=spd
  end
 -- bottom side
 elseif s[ 2]==112 then
  if s[1]==8 then
   s[2]-=spd
  else
   s[1]-=spd
  end
  --left side
 elseif s[1]==8 then
  --top left
  if s[2]==8 then
   s[1]+=spd
  else
   s[2]-=spd
  end
 end
end

function adv_switch()
 if switch_state<1 then
  switch_state+=1
 else
  switch_state=0
 end
end

function draw_train()
  for t=1,#train do
   if t==1 then
   	sprite=11
   elseif t==#train then
    sprite=13
   else
    sprite=12
   end
   spr(sprite,train[t][1],train[t][2])
  end
end

function draw_switch()
 if switch_state==1 then
  sspr(0,16,16,16,56,56,16,16)
 else
  sspr(64,16,16,16,56,56,16,16)
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
