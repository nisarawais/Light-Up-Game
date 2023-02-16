package;

import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEvent;
import flixel.input.mouse.FlxMouseButton;
import flixel.input.gamepad.FlxGamepad;

class PlayState extends FlxState
{
	var boardWidth: Int;
	var boardHeight: Int;
	var columns: Int;
	var rows: Int;
	var squareWidth: Int;
	var squareHeight: Int;
	var background:FlxSprite;
	var tiles: Array<Array<FlxSprite>>;
	var grid: Array<Array<Int>>;
	var gridSolution: Array<Array<Int>>;
	var _btnSolve: FlxButton;
	var _btnCheckSolution: FlxButton;
	var _btnBack:FlxButton;

	var numOfLights: Array<Array<Int>>;
	var lightBulbs: Array<Array<FlxSprite>>;
	var crosses: Array<Array<FlxSprite>>;
	var score = 0;
	var candleSound:FlxSound;

	// New variables for controller input
	var cursorPositionX:Int;
	var cursorPositionY:Int;
	var inGameBool:Bool = false;
    var cursorSprite:FlxSprite;
    var menuItems:Array<FlxButton>;
    var cursorIndex:Int = 0;
    var gamepad:FlxGamepad;


	var winText:FlxText;
	var noWinText:FlxText;

	override public function new(columnsPassed: Int, rowsPassed: Int) {
		super();
		columns = columnsPassed;
		rows = rowsPassed;
	}
	override public function create()
	{
		super.create();

		background = new FlxSprite();
		background.loadGraphic("assets/images/background.png");
		background.scale.set(FlxG.width / background.width, FlxG.height / background.height);
		background.updateHitbox();
		background.x = FlxG.width - background.width;
		background.y = FlxG.height - background.height;
		add(background);
		generateBoard();

        _btnSolve = new FlxButton(20, 20, "Solve Puzzle", solvePuzzle);
        add(_btnSolve);

		_btnCheckSolution = new FlxButton(FlxG.width/2, FlxG.height - 50, "Check Win", checkWin);
		// _btnCheckSolution.x = FlxG.width - _btnCheckSolution.width - 20;
		_btnCheckSolution.screenCenter(X);
        add(_btnCheckSolution);

        _btnBack = new FlxButton(50, 450, "Back", clickBack);
        _btnBack.screenCenter(X);
        add(_btnBack);
		
		// setting text for win message
		// win Text
		winText = new FlxText(FlxG.width/2, FlxG.height - 450 , 0, "You Win!", 15);
		winText.color = 0x7002FD02;
		add (winText);
		winText.kill();

		// Lose Text
		noWinText = new FlxText(FlxG.width/2, FlxG.height - 450, 0, "You don't win yet!", 15);
		noWinText.color = 0x70FF0202;
		add (noWinText);
		noWinText.kill();

		cursorPositionX = 0;
		cursorPositionY = 0;
		// Initialize the cursor sprite and menu items array
		cursorSprite = new FlxSprite();
		cursorSprite.loadGraphic("assets/images/cursor.png");
		cursorSprite.x = tiles[0][0].x + tiles[0][0].width - cursorSprite.width;
		cursorSprite.y = tiles[0][0].y + tiles[0][0].height - 8;
		add(cursorSprite);

		// Initialize the menu items array
		menuItems = [_btnSolve, _btnCheckSolution, _btnBack];
		cursorIndex = 0;
	}

	override public function update(elapsed:Float)
	{
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
						candleSound.play();
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
				cursorSprite.y = tiles[cursorPositionX][cursorPositionY].y + tiles[cursorPositionX][cursorPositionY].height/2 - 8;
				cursorSprite.x = tiles[cursorPositionX][cursorPositionY].x + tiles[cursorPositionX][cursorPositionY].width/2;
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
						solvePuzzle();
					case 1:
						checkWin();
					case 2:
						clickBack();
				}
			}
			// Update the position of the cursor sprite
			cursorSprite.y = menuItems[cursorIndex].y + menuItems[cursorIndex].height/2 - 8;
			cursorSprite.x = menuItems[cursorIndex].x + menuItems[cursorIndex].width/2 - cursorSprite.width;
		}
    }

	/**
	 * Change the light of each square
	 * @param gridVal -1 is black, 0 is white, 1 is yellow, 2 is green, and above is red
	 * @param tile the tile to update
	 */
	 function lightUp (gridVal: Int, tile: FlxSprite) {
		if (gridVal < 0) {
            tile.color = FlxColor.BLACK;
		}
		else if (gridVal == 0) {
            tile.color = 0xFF696969;
		}
		else if (gridVal == 1) {
            tile.color = 0x70fff584;
		}
		else if (gridVal == 2) {
            tile.color = 0x7a84ff84;
		}
		else if (gridVal > 2) {
            tile.color = 0x70ff8484;
		}
	}

	/**
	*	Generate a new play board, the grid for the solution, and create the array of sprites
	*/
	function generateBoard() {
		// --- Board ---
		boardWidth = FlxG.width - 100;
		boardHeight = FlxG.height - 100;
		// --- Squares ---
		squareWidth = Math.floor(boardWidth/columns)-2;
		squareHeight = Math.floor(boardHeight/rows)-2;
		grid = new Array<Array<Int>>();
		gridSolution = new Array<Array<Int>>();

		numOfLights = new Array<Array<Int>>();

		// ======= INITIAL LIGHT VALUES =======
        for (x in 0...columns) {
            // each column is an array
            grid[x] = new Array<Int>();
			gridSolution[x] = new Array<Int>();
			numOfLights[x] = new Array<Int>();

            // set each value in the column to 0
            for (y in 0...rows) {
                grid[x][y] = 0;
				gridSolution[x][y] = 0;
				numOfLights[x][y] = 0;
            }
        }

        // ======== RANDOMIZE BLACK SQUARES ==========
        var x = 0;
        var y = 0;
		
		for (x in 0...columns) {
			for (y in 0...rows) {
				if (FlxG.random.bool(40)){
					grid[x][y] = -1;
					gridSolution[x][y] = -1;
				}
			}
		}

		if(!isSolvable()){
			generateBoard();
		} else{
				// ======= THE BOARD AND BORDERS ==========
			var board = new FlxSprite();
			board.makeGraphic(boardWidth, boardHeight, FlxColor.GRAY);
			board.setPosition(FlxG.width/2 - boardWidth/2, FlxG.height/2 - boardHeight/2);
			add(board);

			// ====== ORIGINAL SQUARES =========
			tiles = new Array<Array<FlxSprite>>();
			var squareX = board.x + 1;
			var squareY = board.y + 1;
			var randomizeWallTiles;
			var randomizeFloorTiles;
			lightBulbs = new Array<Array<FlxSprite>>();
			crosses = new  Array<Array<FlxSprite>>();
			candleSound = FlxG.sound.load(AssetPaths.match_light__wav);
			candleSound.volume = 0.6;
			for (x in 0...columns) {
				tiles[x] = new Array<FlxSprite>();
				lightBulbs[x] = new Array<FlxSprite>();
				crosses[x] = new Array<FlxSprite>();
				for (y in 0...rows) {
					tiles[x][y] = new FlxSprite();
					lightBulbs[x][y] = new FlxSprite();
					crosses[x][y] = new FlxSprite();

					randomizeWallTiles = FlxG.random.int(1, 5);
					randomizeFloorTiles = FlxG.random.int(1, 3);
					// make black if negative (-1)
					if (grid[x][y] < 0) {
						if (grid[x][y] < 0) {
							if(randomizeWallTiles == 1){
								tiles[x][y].loadGraphic("assets/images/brown_tile.png", squareWidth, squareHeight);
								tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
								tiles[x][y].updateHitbox();
                        		tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);
							}
							if(randomizeWallTiles == 2){
								tiles[x][y].loadGraphic("assets/images/light_brown_tile.png", squareWidth, squareHeight);
								tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
								tiles[x][y].updateHitbox();
                        		tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);

							}
							if(randomizeWallTiles == 3){
								tiles[x][y].loadGraphic("assets/images/pink_tile.png", squareWidth, squareHeight);
								tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
								tiles[x][y].updateHitbox();
                        		tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);

							}
							if(randomizeWallTiles == 4){
								tiles[x][y].loadGraphic("assets/images/orange_tile.png", squareWidth, squareHeight);
								tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
								tiles[x][y].updateHitbox();
                        		tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);

							}
							if(randomizeWallTiles == 5){
								tiles[x][y].loadGraphic("assets/images/dark_red_tile.png", squareWidth, squareHeight);
								tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
								tiles[x][y].updateHitbox();
                        		tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);
							}
						}
					}
					else {
						if(randomizeFloorTiles == 1){
							tiles[x][y].loadGraphic("assets/images/flooring_tile_1.png", squareWidth, squareHeight);
							tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
							tiles[x][y].updateHitbox();
							tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);
						}
						if(randomizeFloorTiles == 2){
							tiles[x][y].loadGraphic("assets/images/flooring_tile_2.png", squareWidth, squareHeight);
							tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
							tiles[x][y].updateHitbox();
							tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);
						}
						if(randomizeFloorTiles == 3){
							tiles[x][y].loadGraphic("assets/images/flooring_tile_3.png", squareWidth, squareHeight);
							tiles[x][y].scale.set(squareWidth/tiles[x][y].width, squareHeight/tiles[x][y].height);
							tiles[x][y].updateHitbox();
							tiles[x][y].setPosition(tiles[x][y].x - squareWidth/2, tiles[x][y].y - squareHeight/2);
						}
						lightUp(0, tiles[x][y]);

						lightBulbs[x][y].loadGraphic(AssetPaths.lightbulb__png, squareWidth, squareHeight);
						lightBulbs[x][y].scale.set((squareHeight - (squareHeight*0.1))/lightBulbs[x][y].height, (squareHeight - (squareHeight*0.1))/lightBulbs[x][y].height);
						lightBulbs[x][y].updateHitbox();
                        lightBulbs[x][y].setPosition(lightBulbs[x][y].x - squareWidth/2, lightBulbs[x][y].y - squareHeight/2);

						crosses[x][y].loadGraphic(AssetPaths.x__png, squareWidth, squareHeight);
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
								candleSound.play();
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
			addNumbersToTiles();
		}
	}

	/**
	*	Adds numbers to the tiles based on the number of lamps adjacent to the black block
	**/
	function addNumbersToTiles() {
		var count:Int = 0;
		for (x in 0...columns) {
			for (y in 0...rows) {
				if (grid[x][y] == -1) {
					if(x > 0 && gridSolution[x-1][y] == 1) {
						count++;
					};
					if(x < columns -1 && gridSolution[x + 1][y] == 1) {
						count++;
					};
					if(y > 0 && gridSolution[x][y-1] == 1) {
						count++;
					};
					if(y < rows - 1 && gridSolution[x][y+1] == 1){
						count++;
					};
				}
				numOfLights[x][y] = count;
				count = 0;
			}
		}
		for(x in 0...numOfLights.length){
            for (y in 0...numOfLights[0].length){
                if(numOfLights[x][y] > -1 && grid[x][y] == -1 && FlxG.random.bool(60)){
                    var text = new FlxText(tiles[x][y].x, tiles[x][y].y, 0, '${numOfLights[x][y]}',
					 Math.floor(tiles[x][y].height - tiles[x][y].height*0.25));
                    add(text);
                }
            }
        }
	}

	/**
	 * Check if generated puzzle can be solved ans set the solution in the grid variable
	 */
	function isSolvable():Bool {
		for (x in 0...columns) {
			for (y in 0...rows) {
				if(gridSolution[x][y] == 0){
					gridSolution[x][y] = 1;
					var i = x+1;
					var j = y+1;
					while (i < columns && (gridSolution[i][y] == 0 || gridSolution[i][y] == 2)){
						if (gridSolution[i][y] == 0) {
							gridSolution[i][y] = 2;
						}
						if (i < columns-1)
							i++;
						else 
							break;
					}
					while (j < rows && (gridSolution[x][j] == 0 || gridSolution[x][j] == 2)){
						if (gridSolution[x][j] == 0) {
							gridSolution[x][j] = 2;
						}
						if (j < rows-1)
							j++;
						else 
							break;
					}
				} else if (gridSolution[x][y] == -1) {
				} else if (gridSolution[x][y] == 1) {
				} else if (gridSolution[x][y] == 2) {
				}
			}
		}
		for (x in 0...columns) {
			for (y in 0...rows) {
				if(gridSolution[x][y] == 0){
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * Display the solved puzzle on the board
	 */
	function solvePuzzle() {
		for (x in 0...columns) {
			for (y in 0...rows) {
				if (gridSolution[x][y] == 2) {
					lightUp(1, tiles[x][y]);
				} else if (gridSolution[x][y] == 1) {
					lightUp(2, tiles[x][y]);
				}
			}
		}
	}
	/**
	*	Check if the win conditions are met and displays the win/no win message
	*/
	public function checkWin(){
        var win = true;
        for(x in 0...columns){
            for(y in 0...rows){
                //if the cell has a light in it
                if(grid[x][y] == 1){
                    // trace("checking light at:");
                    if(lightVisibleFromCell(x, y)) win = false;
                }
                //if the cell is empty
                else if (grid[x][y] == 0){
                    // trace("checking empty cell at:");
                    if(!lightVisibleFromCell(x,y)) win = false;

					if (!correctLightNum()){
						win=false;
					}
                }
            }
        }

		// win if statement
        if(win){
			noWinText.kill();
            winText.revive();
			winState();
        } else {
			winText.kill();
			noWinText.revive();
        }
    }
	function winState() {
		{
			final win = new WinState();
			openSubState(win);
		}
	}

	function correctLightNum():Bool {
		var correct:Bool = true;
		var count:Int = 0;
		for (x in 0...columns) {
			for (y in 0...rows) {
				if (grid[x][y] == -1) {
					if(x > 0 && grid[x-1][y] == 1) {
						count++;
					};
					if(x < columns -1 && grid[x + 1][y] == 1) {
						count++;
					};
					if(y > 0 && grid[x][y-1] == 1) {
						count++;
					};
					if(y < rows - 1 && grid[x][y+1] == 1){
						count++;
					};
				}
				if (count != numOfLights[x][y]) {
					correct = false;
				}
				count = 0;
			}
		}
		return correct;
	}


	/**
	*	Switches the state back to the menu state when the play button is clicked
	*/
	function clickBack():Void
	{
		// switched state from current to MenuState
		FlxG.switchState(new MenuState());
	}

	/**
    * Check if a light is visible from the given cell
    * @param x the x-coordinate of the cell to check
    * @param y the y-coordinate of the cell to check
    * @return true if a light is visible, false otherwise
    **/
    function lightVisibleFromCell(x:Int, y:Int){
        // trace('X: $x');
        // trace('Y: $y');
        //check left
        if(x > 0){ 
            var j = x;
            while(j-- > 0){
                // trace('Looking left of $x, $y at $j, $y');
                if(grid[j][y] == 1){
                    // trace("Light Found");
                    return true;
                    }
                else if (grid[j][y] == -1) break;
            }
        }
        //check right
        if(x < columns){ 
            for(j in x+1...columns){
                // trace('Looking right of $x, $y at $j, $y');
                if(grid[j][y] == 1){
                    // trace("Light Found");
                    return true;
                    }
                else if (grid[j][y] == -1) break;
            }
        }
        //check up
        if(y > 0){ 
            var k = y;
            while(k-- > 0){
                // trace('Looking above $x, $y at $x, $k');
                if(grid[x][k] == 1){
                    // trace("Light Found");
                    return true;
                    }
                else if (grid[x][k] == -1) break;
            }
        }
        //check down
        if(y < rows){ 
            for(k in y+1...rows){
                // trace('Looking below $x, $y at $x, $k');
                if(grid[x][k] == 1){
                    // trace("Light Found");
                    return true;
                    }
                else if (grid[x][k] == -1) break;
            }
        }
        return false;
    }

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
