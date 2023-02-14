package;

import flixel.ui.FlxButton;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEvent;

class TutorialBoard extends FlxState{
    var boardWidth: Int;
	var boardHeight: Int;
    var columns:Int;
    var rows:Int;
    var squareWidth: Int;
	var squareHeight: Int;
	var tiles: Array<Array<FlxSprite>>;
    var _btnBack:FlxButton;
    var grid: Array<Array<Int>>;

    var lightBulbs: Array<Array<FlxSprite>>;
    var blackGrid:Array<Array<Int>>;

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

		var squareX = board.x + 1;
		var squareY = board.y + 1;

		for (x in 0...columns) {
			tiles[x] = new Array<FlxSprite>();
            lightBulbs[x] = new Array<FlxSprite>();
            blackGrid[x] = new Array<Int>();
			for (y in 0...rows) {
				tiles[x][y] = new FlxSprite();
                lightBulbs[x][y] = new FlxSprite();
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
                    FlxMouseEvent.add(tiles[x][y], function(sprite:FlxSprite) {
                        if(grid[x][y] == 1) {
                            grid[x][y] = 0;
                            lightUp(0, sprite);
                            lightBulbs[x][y].kill();
                            lightBeam(false, tiles[x][y], x, y);
                        } else {
                            grid[x][y] = 1;
                            lightUp(1, sprite);
                            lightBulbs[x][y].revive();
                            lightBeam(true, tiles[x][y], x, y);
                        }
                    });
                    blackGrid[x][y] = -1;
				}
				tiles[x][y].setPosition(squareX, squareY);
                lightBulbs[x][y].setPosition(squareX, squareY);
				add(tiles[x][y]);
                add(lightBulbs[x][y]);
                lightBulbs[x][y].kill();
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

        var winButton = new FlxButton(FlxG.width/2, FlxG.height - 50, "Check Win", checkWin);
        add(winButton);



        _btnBack = new FlxButton(50, 450, "Back", clickBack);
        _btnBack.screenCenter(X);
        add(_btnBack);

    }

        //play button is clicked
        function clickBack():Void
            {
                // switched state from current to MenuState
                FlxG.switchState(new MenuState());
            }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        
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
                    lightUp(0, tiles[x][y - 1]);
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
                    lightUp(0, tiles[x][y + 1]);
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
                    lightUp(0, tiles[x - 1][y]);
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
                    lightUp(0, tiles[x + 1][y]);
                    lightBeamRight(gridVal, tiles[x + 1][y], x + 1, y);
                }
            }
        }
    }
}