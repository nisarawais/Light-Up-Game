package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEvent;
import flixel.input.mouse.FlxMouseButton;
import flixel.input.gamepad.FlxGamepad;

class TutorialBoard extends FlxState{
    var boardWidth: Int;
	var boardHeight: Int;
    var columns:Int;
    var rows:Int;
    var squareWidth: Int;
	var squareHeight: Int;
	var tiles: Array<Array<FlxSprite>>;
    var _btnBack:FlxButton;
    var _btnWin:FlxButton;
    var grid: Array<Array<Int>>;

    var lightBulbs: Array<Array<FlxSprite>>;
    var blackGrid:Array<Array<Int>>;
    var crosses: Array<Array<FlxSprite>>;

    // New variables for controller input
	var cursorPositionX:Int;
	var cursorPositionY:Int;
	var inGameBool:Bool = false;
    var cursorSprite:FlxSprite;
    var menuItems:Array<FlxButton>;
    var cursorIndex:Int = 0;
    var gamepad:FlxGamepad;

    override public function create():Void {
        super.create();
                
        // ======== SET UP VARS ==========
        columns = 3;		// TODO: change via menu
        rows = 3;			// TODO: change via menu
        // --- Board ---
        boardWidth = FlxG.width - 100;
        boardHeight = FlxG.height - 100;
        // --- Squares ---
        squareWidth = Math.floor(boardWidth/columns)-2;
        squareHeight = Math.floor(boardHeight/rows)-2;
        grid = new Array<Array<Int>>();

        // ======= INITIAL LIGHT VALUES =======
        for (x in 0...columns) {
            // each column is an array
            grid[x] = new Array<Int>();

            // set each value in the column to 0
            for (y in 0...rows) {
                grid[x][y] = 0;
            }
        }

        // ======= THE BOARD AND BORDERS ==========
		var board = new FlxSprite();
		board.makeGraphic(boardWidth, boardHeight, FlxColor.GRAY);
		board.setPosition(FlxG.width/2 - boardWidth/2, FlxG.height/2 - boardHeight/2);
		add(board);

        // grid = 
        // [   [ 0, -1, -1, 0,  0,  0,  1],
        //     [ 0,  1,  0, 0, -1,  1, -1],
        //     [ 1, -1,  0, 1,  0,  0, -1],
        //     [ 0,  1,  0, 0,  0,  0,  0],
        //     [-1,  0,  1, 0,  0, -1,  0],
        //     [-1,  0, -1, 0,  0,  0,  1],
        //     [ 0,  0,  1, 0, -1, -1,  0]
        // ];
        grid = [
            [ 0, 0,-1],
            [-1, 0, 0],
            [ 0, 0,-1]
        ];


		// ====== ORIGINAL SQUARES =========
		tiles = new Array<Array<FlxSprite>>();
        lightBulbs = new Array<Array<FlxSprite>>();
        blackGrid = new Array<Array<Int>>();
        crosses = new  Array<Array<FlxSprite>>();

		var squareX = board.x + 1;
		var squareY = board.y + 1;

		for (x in 0...columns) {
			tiles[x] = new Array<FlxSprite>();
            lightBulbs[x] = new Array<FlxSprite>();
            blackGrid[x] = new Array<Int>();
            crosses[x] = new Array<FlxSprite>();
			for (y in 0...rows) {
				tiles[x][y] = new FlxSprite();
                lightBulbs[x][y] = new FlxSprite();
                crosses[x][y] = new FlxSprite();
				// make black if negative (-1)
				if (grid[x][y] < 0) {
					tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.BLACK);
                    //determine how many lights must be around square. checks for neighbouring black squares and edge of board,
                    //but it's not perfect. It does not check if a solution is possible
                    var blackMax = 4;
                    if (x == 0 || grid[x-1][y] == -1) blackMax--;
                    if (y == 0 || grid[x][y-1] == -1) blackMax--;
                    if( x == columns - 1 || grid[x+1][y] == -1) blackMax--;
                    if( y == rows - 1 || grid[x][y+1] == -1) blackMax--;
                    blackGrid[x][y] = Math.floor(Math.random() * (blackMax + 1.5))-1;
				}
                else if (grid[x][y] == 1) {
                    tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.YELLOW);
                    blackGrid[x][y] = -1;
                }
				else {
					tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.WHITE);
                    lightBulbs[x][y].loadGraphic(AssetPaths.lightbulb__png, squareWidth, squareHeight);
                    crosses[x][y].loadGraphic(AssetPaths.x__png, squareWidth, squareHeight);
                    //Mouse interaction with tiles (adding/removing lamps)
                    FlxMouseEvent.add(tiles[x][y], function(sprite:FlxSprite) {
                        if(grid[x][y] == 1) {
                            grid[x][y] = 0;
                            if(!lightVisibleFromCell(x, y)) {
                                lightUp(0, sprite);
                            }
                            lightBulbs[x][y].kill();
                            lightBeam(false, tiles[x][y], x, y);
                        } else {
                            grid[x][y] = 1;
                            lightUp(1, sprite);
                            lightBulbs[x][y].revive();
                            crosses[x][y].kill();
                            lightBeam(true, tiles[x][y], x, y);
                        }
                    }, null, null, null, true);
                    FlxMouseEvent.add(tiles[x][y], function(sprite:FlxSprite) {
                        if(grid[x][y] == 1) {
                            grid[x][y] = 0;
                            if(!lightVisibleFromCell(x, y)) {
                                lightUp(0, sprite);
                            }
                            lightBulbs[x][y].kill();
                            lightBeam(false, tiles[x][y], x, y);
                        }
                        if(crosses[x][y].alive) {
                            crosses[x][y].kill();
                        } else {
                            crosses[x][y].revive();
                        }
                    }, null, null, null, true, true, true, [FlxMouseButtonID.RIGHT]);
                    blackGrid[x][y] = -1;
				}
				tiles[x][y].setPosition(squareX, squareY);
                lightBulbs[x][y].setPosition(squareX, squareY);
                crosses[x][y].setPosition(squareX, squareY);
				add(tiles[x][y]);
                add(lightBulbs[x][y]);
                add(crosses[x][y]);
                lightBulbs[x][y].kill();
                crosses[x][y].kill();
				// next square up
				squareY += 2 + squareHeight;
			}
			// reset y values
			squareY = board.y + 1;
			// next column over
			squareX += squareWidth + 2;
		}

        blackGrid = [
            [-1, -1, 2],
            [ 1, -1,-1],
            [-1, -1, 1]
        ];

        for(x in 0...blackGrid.length){
            for (y in 0...blackGrid[0].length){
                if(blackGrid[x][y] != -1){
                    var text = new FlxText(tiles[x][y].x, tiles[x][y].y, 0, '${blackGrid[x][y]}', 24);
                    add(text);
                }
            }
        }

        var _btnWin = new FlxButton(FlxG.width/2, FlxG.height - 50, "Check Win", checkWin);
        _btnWin.screenCenter(X);
        add(_btnWin);

        _btnBack = new FlxButton(50, 450, "Back", clickBack);
        _btnBack.screenCenter(X);
        add(_btnBack);

        cursorPositionX = 0;
		cursorPositionY = 0;
		// Initialize the cursor sprite and menu items array
		cursorSprite = new FlxSprite();
		cursorSprite.loadGraphic("assets/images/cursor.png");
		cursorSprite.x = tiles[0][0].x - cursorSprite.width - 8;
		cursorSprite.y = tiles[0][0].y - 8;
		add(cursorSprite);

		// Initialize the menu items array
		menuItems = [_btnWin, _btnBack];
		cursorIndex = 0;
    }

        //play button is clicked
        function clickBack():Void
            {
                // switched state from current to MenuState
                FlxG.switchState(new MenuState());
            }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        gamepad = FlxG.gamepads.lastActive;
		if (gamepad != null) {

			updateGamepadInput(gamepad);
		}
	}

	function updateGamepadInput(gamepad:FlxGamepad) {
		if(gamepad.justPressed.Y){
			if(inGameBool == true)
				inGameBool = false;
			else if (inGameBool == false)
				inGameBool = true;
		}
		if(inGameBool){
			// Check if the joystick is moved up or down
			if (gamepad.justPressed.LEFT_STICK_DIGITAL_DOWN || gamepad.justPressed.DPAD_DOWN)
				{
					// Move the cursor down
					cursorPositionY++;
					if (cursorPositionY >= rows) cursorPositionY = rows-1;

				}
				else if (gamepad.justPressed.LEFT_STICK_DIGITAL_UP || gamepad.justPressed.DPAD_UP)
				{
					// Move the cursor up
					cursorPositionY--;
					if (cursorPositionY < 0) cursorPositionY = 0;
				}
				else if (gamepad.justPressed.LEFT_STICK_DIGITAL_LEFT || gamepad.justPressed.DPAD_LEFT)
				{
					// Move the cursor left
					cursorPositionX--;
					if (cursorPositionX < 0) cursorPositionX = 0;
				}
				else if (gamepad.justPressed.LEFT_STICK_DIGITAL_RIGHT || gamepad.justPressed.DPAD_RIGHT)
				{
					// Move the cursor right
					cursorPositionX++;
					if (cursorPositionX >= columns) cursorPositionX = columns-1;
				}
					
				// Check if the A button is pressed
				if (gamepad.justReleased.A)
				{
					// Call the function corresponding to the selected menu item
					if(grid[cursorPositionX][cursorPositionY] == 1) {
						grid[cursorPositionX][cursorPositionY] = 0;
						if(!lightVisibleFromCell(cursorPositionX, cursorPositionY)) {
							lightUp(0, tiles[cursorPositionX][cursorPositionY]);
						}
						lightBulbs[cursorPositionX][cursorPositionY].kill();
						lightBeam(false, tiles[cursorPositionX][cursorPositionY], cursorPositionX, cursorPositionY);
					} else {
						grid[cursorPositionX][cursorPositionY] = 1;
						lightUp(1, tiles[cursorPositionX][cursorPositionY]);
						lightBulbs[cursorPositionX][cursorPositionY].revive();
						crosses[cursorPositionX][cursorPositionY].kill();
						lightBeam(true, tiles[cursorPositionX][cursorPositionY], cursorPositionX, cursorPositionY);
					}
				}
				if (gamepad.justReleased.B){
					if(grid[cursorPositionX][cursorPositionY] == 1) {
						grid[cursorPositionX][cursorPositionY] = 0;
						if(!lightVisibleFromCell(cursorPositionX, cursorPositionY)) {
							lightUp(0, tiles[cursorPositionX][cursorPositionY]);
						}
						lightBulbs[cursorPositionX][cursorPositionY].kill();
						lightBeam(false, tiles[cursorPositionX][cursorPositionY], cursorPositionX, cursorPositionY);
					}
					if(crosses[cursorPositionX][cursorPositionY].alive) {
						crosses[cursorPositionX][cursorPositionY].kill();
					} else {
						crosses[cursorPositionX][cursorPositionY].revive();
					}
				}
				// Update the position of the cursor sprite
				cursorSprite.y = tiles[cursorPositionX][cursorPositionY].y - 8;
				cursorSprite.x = tiles[cursorPositionX][cursorPositionY].x;
		}
		if(!inGameBool){
			// Check if the joystick is moved up or down
			if (gamepad.justPressed.LEFT_STICK_DIGITAL_DOWN || gamepad.justPressed.DPAD_DOWN)
			{
				// Move the cursor down
				cursorIndex++;
				if (cursorIndex >= menuItems.length) cursorIndex = 0;
			}
			else if (gamepad.justPressed.LEFT_STICK_DIGITAL_UP || gamepad.justPressed.DPAD_UP)
			{
				// Move the cursor up
				cursorIndex--;
				if (cursorIndex < 0) cursorIndex = menuItems.length - 1;
			}

			// Check if the A button is pressed
			if (gamepad.justReleased.A)
			{
				// Call the function corresponding to the selected menu item
				switch (cursorIndex)
				{
					case 0:
						checkWin();
					case 1:
						clickBack();
				}
			}
			// Update the position of the cursor sprite
			cursorSprite.y = menuItems[cursorIndex].y - 8;
			cursorSprite.x = menuItems[cursorIndex].x;
		}
    }

    public function checkWin(){
        var win = true;
        for(x in 0...columns){
            for(y in 0...rows){
                //if the cell has a light in it
                if(grid[x][y] == 1){
                    trace("checking light at:");
                    if(lightVisibleFromCell(x, y)) win = false;
                }
                //if the cell is empty
                else if (grid[x][y] == 0){
                    trace("checking empty cell at:");
                    if(!lightVisibleFromCell(x,y)) win = false;
                } else if (grid[x][y] == -1){
                    trace("Checking black square at:");
                    if(!validateBlackSquare(x,y)) win = false;
                }
            }
        }

        if(win){
            var text = new FlxText(FlxG.width/2, 50, 0, "You Win!");
            add (text);
        } else {
            var text = new FlxText(FlxG.width/2, 50, 0, "You don't win yet!");
            add (text);
        }
        
    }

    /**
    * Check if a light is visible from the given cell
    * @param x the x-coordinate of the cell to check
    * @param y the y-coordinate of the cell to check
    * @return true if a light is visible, false otherwise
    **/
    function lightVisibleFromCell(x:Int, y:Int){
        trace('X: $x');
        trace('Y: $y');
        //check left
        if(x > 0){ 
            var j = x;
            while(j-- > 0){
                trace('Looking left of $x, $y at $j, $y');
                if(grid[j][y] == 1){
                    trace("Light Found");
                    return true;
                    }
                else if (grid[j][y] == -1) break;
            }
        }
        //check right
        if(x < columns){ 
            for(j in x+1...columns){
                trace('Looking right of $x, $y at $j, $y');
                if(grid[j][y] == 1){
                    trace("Light Found");
                    return true;
                    }
                else if (grid[j][y] == -1) break;
            }
        }
        //check up
        if(y > 0){ 
            var k = y;
            while(k-- > 0){
                trace('Looking above $x, $y at $x, $k');
                if(grid[x][k] == 1){
                    trace("Light Found");
                    return true;
                    }
                else if (grid[x][k] == -1) break;
            }
        }
        //check down
        if(y < rows){ 
            for(k in y+1...rows){
                trace('Looking below $x, $y at $x, $k');
                if(grid[x][k] == 1){
                    trace("Light Found");
                    return true;
                    }
                else if (grid[x][k] == -1) break;
            }
        }
        return false;
    }

    function validateBlackSquare(x:Int, y:Int){
        trace('X: $x');
        trace('Y: $y');
        var numLights = 0;
        if(x > 0 && grid[x-1][y] == 1) {
            numLights++;
            trace('$numLights lights');
        };
        if(x < columns -1 && grid[x + 1][y] == 1) {
            numLights++;
            trace('$numLights lights');
        };
        if(y > 0 && grid[x][y-1] == 1) {
            numLights++;
            trace('$numLights lights');
        };
        if(y < rows - 1 && grid[x][y+1] == 1){
            numLights++;
            trace('$numLights lights');
        };

        if(blackGrid[x][y] > -1 && numLights == blackGrid[x][y]) return true;
        return false;
    }

    /**
	 * Change the light of each square
	 * @param gridVal -1 is black, 0 is white, 1 is yellow, and above is red
	 * @param tile the tile to update
	 */
	function lightUp (gridVal: Int, tile: FlxSprite) {
		if (gridVal < 0) {
			// tile.makeGraphic(squareWidth, squareHeight, FlxColor.BLACK);
            tile.color = FlxColor.BLACK;
		}
		else if (gridVal == 0) {
			// tile.makeGraphic(squareWidth, squareHeight, FlxColor.WHITE);
            tile.color = FlxColor.WHITE;
		}
		else if (gridVal == 1) {
			// tile.makeGraphic(squareWidth, squareHeight, FlxColor.YELLOW);
            tile.color = 0x70fff584;
		}
		else if (gridVal > 1) {
			// tile.makeGraphic(squareWidth, squareHeight, FlxColor.RED);
            tile.color = 0x70ff8484;
		}
	}

    /**
     * Make a beam of light originating from a tile in all directions
     * @param gridVal true is a beam of on lights (yellow), false is a beam of off lights (white)
     * @param tile the tile of origin
     * @param x the x of the tile of origin
     * @param y the y of the tile of origin
     */
    function lightBeam(gridVal:Bool, tile:FlxSprite, x:Int, y:Int) {
        //Up!
        lightBeamUp(gridVal, tile, x, y);
        //Down!
        lightBeamDown(gridVal, tile, x, y);
        //Left!
        lightBeamLeft(gridVal, tile, x, y);
        //Right!
        lightBeamRight(gridVal, tile, x, y);
    }

    function lightBeamUp(gridVal:Bool, tile:FlxSprite, x:Int, y:Int) {
        if(gridVal) {
            //Up!
            if(y - 1 >= 0) {
                if(grid[x][y - 1] == 0) {
                    lightUp(1, tiles[x][y - 1]);
                    lightBeamUp(gridVal, tiles[x][y - 1], x, y - 1);
                }
            }
        } else {
            if(y - 1 >= 0) {
                if(grid[x][y - 1] == 0) {
                    if(!lightVisibleFromCell(x, y - 1)){
                        lightUp(0, tiles[x][y - 1]);
                    }
                    lightBeamUp(gridVal, tiles[x][y - 1], x, y - 1);
                }
            }
        }
    }

    function lightBeamDown(gridVal:Bool, tile:FlxSprite, x:Int, y:Int) {
        if(gridVal) {
            if(y + 1 <= columns) {
                if(grid[x][y + 1] == 0) {
                    lightUp(1, tiles[x][y + 1]);
                    lightBeamDown(gridVal, tiles[x][y + 1], x, y + 1);
                }
            }
        } else {
            if(y + 1 <= columns) {
                if(grid[x][y + 1] == 0) {
                    if(!lightVisibleFromCell(x, y + 1)) {
                        lightUp(0, tiles[x][y + 1]);
                    } 
                    lightBeamDown(gridVal, tiles[x][y + 1], x, y + 1);
                }
            }
        }
    }

    function lightBeamLeft(gridVal:Bool, tile:FlxSprite, x:Int, y:Int) {
        if(gridVal) {
            if(x - 1 >= 0) {
                if(grid[x - 1][y] == 0) {
                    lightUp(1, tiles[x - 1][y]);
                    lightBeamLeft(gridVal, tiles[x - 1][y], x - 1, y);
                }
            }
        } else {
            if(x - 1 >= 0) {
                if(grid[x - 1][y] == 0) {
                    if(!lightVisibleFromCell(x - 1, y)) {
                        lightUp(0, tiles[x - 1][y]);
                    }
                    lightBeamLeft(gridVal, tiles[x - 1][y], x - 1, y);
                }
            }
        }
    }

    function lightBeamRight(gridVal:Bool, tile:FlxSprite, x:Int, y:Int) {
        if(gridVal) {
            if(x + 1 <= rows - 1) {
                if(grid[x + 1][y] == 0) {
                    lightUp(1, tiles[x + 1][y]);
                    lightBeamRight(gridVal, tiles[x + 1][y], x + 1, y);
                }
            }
        } else {
            if(x + 1 <= rows - 1) {
                if(grid[x + 1][y] == 0) {
                    if(!lightVisibleFromCell(x + 1, y)) {
                        lightUp(0, tiles[x + 1][y]);
                    }
                    lightBeamRight(gridVal, tiles[x + 1][y], x + 1, y);
                }
            }
        }
    }
}