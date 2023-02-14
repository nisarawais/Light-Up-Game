package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEvent;
import flixel.input.mouse.FlxMouseButton;


class PlayState extends FlxState
{

	var boardWidth: Int;
	var boardHeight: Int;
	var columns: Int;
	var rows: Int;
	var squareWidth: Int;
	var squareHeight: Int;
	var tiles: Array<Array<FlxSprite>>;
	var grid: Array<Array<Int>>;
	var gridSolution: Array<Array<Int>>;
	var _btnSolve: FlxButton;
	var _btnCheckSolution: FlxButton;
	var _btnBack:FlxButton;

	var numOfLights: Array<Array<Int>>;
	var lightBulbs: Array<Array<FlxSprite>>;
<<<<<<< Updated upstream
	var crosses: Array<Array<FlxSprite>>;
=======
	var score = 0;
>>>>>>> Stashed changes

	override public function new(columnsPassed: Int, rowsPassed: Int) {
		super();
		columns = columnsPassed;
		rows = rowsPassed;
	}
	override public function create()
	{
		super.create();
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

		
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
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
            tile.color = FlxColor.WHITE;
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
	*	Generate a new play board
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
			lightBulbs = new Array<Array<FlxSprite>>();
			crosses = new  Array<Array<FlxSprite>>();

			for (x in 0...columns) {
				tiles[x] = new Array<FlxSprite>();
				lightBulbs[x] = new Array<FlxSprite>();
				crosses[x] = new Array<FlxSprite>();
				for (y in 0...rows) {
					tiles[x][y] = new FlxSprite();
					lightBulbs[x][y] = new FlxSprite();
					crosses[x][y] = new FlxSprite();
					// make black if negative (-1)
					if (grid[x][y] < 0) {
						tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.BLACK);
					}
					else {
						tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.WHITE);
						lightBulbs[x][y].loadGraphic(AssetPaths.lightbulb__png, squareWidth, squareHeight);
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
                // } else if (grid[x][y] == -1){
                //     trace("Checking black square at:");
                //     if(!validateBlackSquare(x,y)) win = false;
                }
            }
        }

		// setting text for win message
		// win Text
		var text = new FlxText(FlxG.width/2, FlxG.height - 450 , 0, "You Win!");
		text.color = 0x7002FD02;

		// Lose Text
		var text2 = new FlxText(FlxG.width/2, FlxG.height - 450, 0, "You don't win yet!");
		text2.color = 0x70FF0202;

		// win if statement
        if(win){
            remove(text2);
            add (text);
        } else {
            remove(text);
            add (text2);
        }
        
    }

	//play button is clicked
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
