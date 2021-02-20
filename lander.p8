pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	g=0.025 --gravity
	randseed = rndb(1,6)
	game_over=false
	win=false
	make_player()
	make_ground()
end

function _draw()
	cls()
	draw_stars()
	draw_player()
	draw_ground()
	if (game_over) then
  if (win) then
   print("you win!",48,48,11)
  else
   print("game over!",48,48,8)
  end
		print("press ❎ to play again",20,70,5)
	end
end

function _update()
	if (not game_over) then
		move_player()
		check_land()
		else
		if(btnp(5)) _init()
	end
end

function move_player()
	p.dy+=g

	thrust()

	p.x+=p.dx
	p.y+=p.dy

	stay_on_screen()
end

function stay_on_screen()
 if (p.x<0) then
 	p.x=0
 	p.dx=0
 end
 if (p.x>119) then
  p.x=119
  p.dx=0
 end
 if (p.y<0) then
  p.y=0
  p.dy=0
 end
end

function make_player()
	p={}
	p.x=60
	p.y=8
	p.dx=0
	p.dy=0
	p.sprite=1
	p.alive=true
	p.thrust=0.075
end

function draw_player()
	spr(p.sprite,p.x,p.y)
	if (game_over and win) then
  spr(6,p.x,p.y-8) --flag
 elseif (game_over) then
  spr(7,p.x,p.y) --explosion
 end
end

function thrust()
if (btn(0)) p.dx-=p.thrust
if (btn(1)) p.dx+=p.thrust
if (btn(2)) p.dy-=p.thrust

if (btn(0) or btn(1) or btn(2)) sfx(0)
end

function rndb(low,high)
		return flr(rnd(high-low+1)+low)
end

function draw_stars()
	srand(randseed)
	for i=1,50 do
		pset(rndb(00,127), rndb(0, 127), 7)
	end
	srand(time())
end		

function make_ground()
 --create the ground
 gnd={}
 local top=96  --highest point
 local btm=120 --lowest point
 --set up the landing pad
 pad={}
 pad.width=15
 pad.x=rndb(0,126-pad.width)
 pad.y=rndb(top,btm)
 pad.sprite=4
 --create ground at pad
 for i=pad.x,pad.x+pad.width do
  gnd[i]=pad.y
 end
 --create ground right of pad
 for i=pad.x+pad.width+1,127 do
  local h=rndb(gnd[i-1]-3,gnd[i-1]+3)
  gnd[i]=mid(top,h,btm)
 end
 --create ground left of pad
 for i=pad.x-1,0,-1 do
  local h=rndb(gnd[i+1]-3,gnd[i+1]+3)
  gnd[i]=mid(top,h,btm)
 end
end

function draw_ground()
 for i=0,127 do
  line(i,gnd[i],i,127,5)
 end
 spr(pad.sprite,pad.x,pad.y-6,2,1)
end

function check_land()
 l_x=flr(p.x)   --left side of ship
 r_x=flr(p.x+7) --right side of ship
 b_y=flr(p.y+7) --bottom of ship
 over_pad=l_x>=pad.x and r_x<=pad.x+pad.width
 on_pad=b_y>=pad.y-1-6
 slow=p.dy<1.5
 if (over_pad and on_pad and slow) then
  end_game(true)
 elseif (over_pad and on_pad) then
  end_game(false)
 else
  for i=l_x,r_x do
   if (gnd[i]<=b_y) end_game(false)
  end
end end
function end_game(won)
 game_over=true
 win=won
 if (win) then
  sfx(1)
	else
		sfx(2)
	end
end




__gfx__
0000000000666600760dddddddddd766711111111111111700000000008888000000000000000000000000000000000000000000000000000000000000000000
00000000066c76607600000000000666766666666666666700000000089999800000000000000000000000000000000000000000000000000000000000000000
0070070066ccc7660066666666666660077777777777777000000000899aa9980000000000000000000000000000000000000000000000000000000000000000
0007700066cccc66000766666666660007000007000000700008600089aaaa980000000000000000000000000000000000000000000000000000000000000000
0007700066555566000000000000000070000000700000070088600089aaaa980000000000000000000000000000000000000000000000000000000000000000
00700700066666600000000000000000700000007000000708886000899aa9980000000000000000000000000000000000000000000000000000000000000000
00000000050550500000000000000000000000000000000000006000089999800000000000000000000000000000000000000000000000000000000000000000
00000000660660660000000000000000000000000000000000006000008888000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000a63007600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c000020070200301b0701b030170701703020070200301c0001b0001b070200702003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400003c67039670326602c6602865026650236401f6401c630196201762014620116200f6200b6100861006610056100361003610016100061003600006000000000000000000000000000000000000000000
