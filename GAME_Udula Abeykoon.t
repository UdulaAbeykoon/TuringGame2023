%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  DISRUPTION IN THE UNIVERSE                   %
%                                                               %
%     You're a planet in space being attacked by asteroids!     %
%         Dodge them and see how long you can survive!          %
%     Customize your environment to improve your experience     %
%                       HAVE FUN & GOOD LUCK                    %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abeykoon, Udula, 342711579               %
% ICS201.2D Udula Abeykoon                 %
% Date: 14 June 2023                       %
% Summative                                %
% Summative Project                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Declaration Constants                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
const groundColour := 1
const asteroidColour1 := white
const asteroidColour2 := 54
const explosionColour := 2
const playerColour := brightred
const playerSpeed := 4
const turnDelay := 100
const outOfPlay := -1
const maxAsteroids := 100
const BLACK := 255
const PURPLE := 57
const WHITE := 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Global Variables                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var numAsteroids : int := 1
% the number of asteroids in play
var evadedAsteroids : int := 0

% total number of asteroids evaded
var tx : int := maxx div 2
% the x position of the player in pixels
var ty : int := maxy div 2
% the y position of the player in pixels
var turns, timer, dist : int

var section : string := "main"
var mX, mY, click : int
var pClick : boolean := false
var keys : array char of boolean
var x, y, b : int
var start : boolean := true

%CUSTOM VARIABLES
var backgroundCus : int := BLACK
var planetCus : int := playerColour
var asteroidCus : int

%PICTURE VARIABLES
var main : int := Pic.FileNew ("1.bmp")
var information : int := Pic.FileNew ("2.bmp")
var exitgame : int := Pic.FileNew ("3.bmp")

procedure Instructions
    Draw.FillBox (0, 0, 639, 399, BLACK)
    color (WHITE)
    put ""
    locate (10, 28)
    put "DISRUPTION IN THE UNIVERSE"
    put ""
    locate (11, 26)
    put "You are a planet in outerspace!"
    locate (12, 6)
    put "Ununfortunately, there are planet seeking ASTEROIDS heading your way!"
    locate (13, 12)
    put "Luckily if you manuever carefully,you can dodge them."
    put ""
    locate (14, 10)
    put "You will first complete a DEMO and then START your game!"
    color (PURPLE)
    put ""
    locate (15, 26)
    color (PURPLE)
    put "Hit any key to start..."
    Input.Pause
    cls
end Instructions

cls
colorback (BLACK)

const PSIZE := 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              This procedure draws the player.                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure DrawPlayer (clr : int)
    Draw.FillOval (round (tx), round (ty), PSIZE, PSIZE, clr)
end DrawPlayer

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This procedure handles any key strokes by reading any char  %
% from the keyboard and moving the player in response to it.    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure ControlPlayer

    Mouse.Where (x, y, b)
    if b = 1 and (x not= tx or y not= ty) then
	DrawPlayer (backgroundCus)

	var d : real := sqrt ((x - tx) ** 2 + (y - ty) ** 2)
	var dx : int := round ((x - tx) * playerSpeed / d)
	var dy : int := round ((y - ty) * playerSpeed / d)
	if abs (dx) > abs (x - tx) then
	    tx := x
	else
	    tx := tx + dx
	end if
	if abs (dy) > abs (y - ty) then
	    ty := y
	else
	    ty := ty + dy
	end if

	% Make certain the player doesn't go off the screen.
	if tx < 10 then
	    tx := 10
	elsif tx > maxx - 10 then
	    tx := maxx - 10
	end if
	if ty < 10 then
	    ty := 10
	elsif ty > maxy - 10 then
	    ty := maxy - 10
	end if

	% Draw the player in its new position
	DrawPlayer (planetCus)
    end if
end ControlPlayer

function bClick (x1, y1, x2, y2 : int) : boolean
    if not pClick and click = 1 and mX >= x1 and mX <= x2 and mY >= y1
	    and mY <= y2 then
	result true
    else
	result false
    end if
end bClick


procedure previousClick
    if click = 1 then
	pClick := true
    else
	pClick := false
    end if
end previousClick

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Main Body                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var px, py : array 1 .. maxAsteroids of int
% The position array for the asteroids
var vx, vy : array 1 .. maxAsteroids of int
% The velocity array for the asteroids

randomize
setscreen ("graphics,noecho")

var check : boolean := false

loop
    Input.KeyDown (keys)
    mousewhere (mX, mY, click)

    case section of
	label "main" :
	    Pic.Draw (main, 0, 0, 0)
	    if bClick (112, 122, 242, 175) then
		section := "playing"
	    end if

	    if bClick (256, 122, 386, 175) then
		section := "information"
	    end if

	    if bClick (400, 122, 529, 175) then
		section := "exit"
	    end if
	label "exit" :
	    Pic.Draw (exitgame, 0, 0, 0)
	    exit
	label "information" :
	    Pic.Draw (information, 0, 0, 0)
	    if keys (KEY_ESC) then
		section := "main"
	    end if
	label "playing" :
	    if start then
		Instructions
	    end if
	    start := false

	    % Initialize the asteroid array.
	    for i : 1 .. numAsteroids
		px (i) := Rand.Int (0, maxx)
		py (i) := 0
		vx (i) := 0
		vy (i) := Rand.Int (1, 5)
	    end for

	    % Draw the screen
	    cls
	    drawline (0, 0, maxx, 0, 1)
	    DrawPlayer (playerColour)

	    % Set the clock and number of elapsed turns
	    turns := 0

	    % The main loop
	    loop
		turns += 1

		% For each ASTEROID:
		% Determine the new x velocity
		% Determine the new y velocity
		% Set the new asteroid position
		% Draw a travel line
		% Check to see if it hit the ground
		% Check to see if it hit the player

		for i : 1 .. numAsteroids
		    const ox := px (i)
		    const oy := py (i)

		    if ox not= outOfPlay then
			% Determine the x velocity
			dist := abs (vx (i)) * (abs (vx (i)) + 1) div 2
			if vx (i) < 0 and ox - dist < 0 then
			    vx (i) += 2
			elsif vx (i) > 0 and ox + dist > maxx then
			    vx (i) -= 2
			elsif turns > 100 then
			    if turns mod 20 = 0 then
				vx (i) -= sign (vx (i))
			    end if
			elsif ox < tx then
			    vx (i) += 1
			elsif ox > tx then
			    vx (i) -= 1
			end if

			% Determine the y velocity
			dist := abs (vy (i)) * (abs (vy (i)) + 1) div 2
			if vy (i) > 0 and oy + dist > maxy then
			    vy (i) -= 2
			elsif turns > 100 then
			    if turns mod 8 = 0 then
				vy (i) -= 1
			    end if
			elsif vy (i) < 0 and oy - dist < -turns div 15 then
			    vy (i) += 2
			elsif oy < ty then
			    vy (i) += 1
			elsif oy > ty then
			    vy (i) -= 1
			end if

			% Set the new asteroid position
			px (i) += vx (i)
			py (i) += vy (i)

			% Draw a travel line
			if turns > 100 then
			    Draw.ThickLine (ox, oy, px (i), py (i), 1, asteroidColour2)
			else
			    Draw.ThickLine (ox, oy, px (i), py (i), 2, asteroidColour1)
			end if

			% Check to see if it hit the ground
			if py (i) <= 0 then
			    drawline (px (i), 0, px (i) - 4, 4, explosionColour)
			    drawline (px (i), 0, px (i), 6, explosionColour)
			    drawline (px (i), 0, px (i) + 4, 4, explosionColour)
			    px (i) := outOfPlay
			    evadedAsteroids += 1
			end if

			% Check to see if it hit the player
			if Math.DistancePointLine (tx, ty, ox, oy, px (i), py (i)) < 3 then
			    drawfillstar (tx - 7, ty - 7, tx + 7, ty + 7, brightblue)
			    locate (10, 30)
			    put "YOU FINISHED YOUR DEMO! YOU EVADED ", evadedAsteroids, " ASTEROIDS! " ..
			    locate (1, 1)
			    section := "customize"
			end if
		    end if
		end for

		% Check if the player is being controlled
		ControlPlayer

		% This is a timer delay loop to make sure that each turn takes
		% the same length of time to execute, regardless of the number
		% of asteroids on the screen
		Time.DelaySinceLast (30)

		% This will leave the loop when all the asteroids have crashed.
		var endNow : boolean := true
		for i : 1 .. numAsteroids
		    if px (i) not= outOfPlay then
			endNow := false
		    end if
		end for
		exit when endNow
	    end loop



	    % After each time all the asteroids have crashed, add 1 to the number
	    % of asteroids with a maximum of maxAsteroids.
	    numAsteroids += 1
	    if numAsteroids > maxAsteroids then
		numAsteroids := maxAsteroids
	    end if
%THIS IS THE CUSTOMIZE CODE
	label "customize" :
	    numAsteroids := 0
	    drawfillbox (0, 0, maxx, maxy, BLACK)
	    color (WHITE)
	    for i : 0 .. 147
		colour (255)
		colorback (i)
		put i : 4 ..
	    end for
	    locate (8, 10)
	    colorback (BLACK)
	    put "CUSTOMIZE YOUR GAME! *Make sure to choose 3 different colours!"
	    locate (10, 28)
	    color (PURPLE )
	    put "What background do you want: "
	    get backgroundCus
	    locate (11, 28)
	    put backgroundCus
	    put ""
	    locate (12, 28)
	    put "What planet do you want: "
	    get planetCus
	    locate (13, 28)
	    put planetCus
	    put ""
	    locate (14, 28)
	    put "What asteroid do you want: "
	    get asteroidCus
	    locate (15, 28)
	    put asteroidCus
	    put ""
	    section := "playCustom"

	label "playCustom" :
	    if start then
		Instructions
	    end if
	    start := false
	    colorback (backgroundCus)
	    % Initialize the asteroid array.
	    for i : 1 .. numAsteroids
		px (i) := Rand.Int (0, maxx)
		py (i) := 0
		vx (i) := 0
		vy (i) := Rand.Int (1, 5)
	    end for

	    % Draw the screen
	    cls
	    drawline (0, 0, maxx, 0, 1)
	    DrawPlayer (planetCus)

	    % Set the clock and number of elapsed turns
	    turns := 0

	    % The main loop
	    loop
		turns += 1

		% For each ASTEROID:
		% Determine the new x velocity
		% Determine the new y velocity
		% Set the new asteroid position
		% Draw a travel line
		% Check to see if it hit the ground
		% Check to see if it hit the player
		for i : 1 .. numAsteroids
		    const ox : int := px (i)
		    const oy : int := py (i)

		    if ox not= outOfPlay then
			% Determine the x velocity
			dist := abs (vx (i)) * (abs (vx (i)) + 1) div 2
			if vx (i) < 0 and ox - dist < 0 then
			    vx (i) += 2
			elsif vx (i) > 0 and ox + dist > maxx then
			    vx (i) -= 2
			elsif turns > 100 then
			    if turns mod 20 = 0 then
				vx (i) -= sign (vx (i))
			    end if
			elsif ox < tx then
			    vx (i) += 1
			elsif ox > tx then
			    vx (i) -= 1
			end if

			% Determine the y velocity
			dist := abs (vy (i)) * (abs (vy (i)) + 1) div 2
			if vy (i) > 0 and oy + dist > maxy then
			    vy (i) -= 2
			elsif turns > 100 then
			    if turns mod 8 = 0 then
				vy (i) -= 1
			    end if
			elsif vy (i) < 0 and oy - dist < -turns div 15 then
			    vy (i) += 2
			elsif oy < ty then
			    vy (i) += 1
			elsif oy > ty then
			    vy (i) -= 1
			end if

			% Set the new asteroid position
			px (i) += vx (i)
			py (i) += vy (i)

			% Draw a travel line
			if turns > 100 then
			    Draw.ThickLine (ox, oy, px (i), py (i), 1, asteroidColour2)
			else
			    Draw.ThickLine (ox, oy, px (i), py (i), 2, asteroidCus)
			end if

			% Check to see if it hit the ground
			if py (i) <= 0 then
			    drawline (px (i), 0, px (i) - 4, 4, explosionColour)
			    drawline (px (i), 0, px (i), 6, explosionColour)
			    drawline (px (i), 0, px (i) + 4, 4, explosionColour)
			    px (i) := outOfPlay
			    evadedAsteroids += 1
			end if

			% Check to see if it hit the player
			if Math.DistancePointLine (tx, ty, ox, oy, px (i), py (i)) < 3 then
			    drawfillstar (tx - 7, ty - 7, tx + 7, ty + 7, brightblue)
			    locate (10, 30)
			    put "YOU EVADED ", evadedAsteroids, " ASTEROIDS! " ..
			    locate (1, 1)
			    delay (500)
			    return
			end if
		    end if
		end for

		% Check if the player is being controlled
		ControlPlayer

		% This is a timer delay loop to make sure that each turn takes
		% the same length of time to execute, regardless of the number
		% of asteroids on the screen
		Time.DelaySinceLast (30)

		% This will leave the loop when all the asteroids have crashed.
		var endNow : boolean := true
		for i : 1 .. numAsteroids
		    if px (i) not= outOfPlay then
			endNow := false
		    end if
		end for
		exit when endNow
	    end loop

	    % After each time all the asteroids have crashed, add 1 to the number
	    % of asteroids with a maximum of maxAsteroids.
	    numAsteroids += 1
	    if numAsteroids > maxAsteroids then
		numAsteroids := maxAsteroids
	    end if

    end case
    previousClick
end loop
