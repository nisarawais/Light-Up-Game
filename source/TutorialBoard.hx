package;

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

    override public function create():Void {
        super.create();
                
        // ======== SET UP VARS ==========
        columns = 7;		// TODO: change via menu
        rows = 7;			// TODO: change via menu
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

        grid = 
        [   [0, -1, -1, 0, 0, 0, 0],
            [0, 0, 0, 0, -1, 0, -1],
            [0, -1, 0, 0, 0, 0, -1],
            [0, 0, 0, 0, 0, 0, 0],
            [-1, 0, 0, 0, 0, -1, 0],
            [-1, 0, -1, 0, 0, 0, 0],
            [0, 0, 0, 0, -1, -1, 0]
        ];


		// ====== ORIGINAL SQUARES =========
		tiles = new Array<Array<FlxSprite>>();
        lightBulbs = new Array<Array<FlxSprite>>();
		var squareX = board.x + 1;
		var squareY = board.y + 1;

		for (x in 0...columns) {
			tiles[x] = new Array<FlxSprite>();
            lightBulbs[x] = new Array<FlxSprite>();
			for (y in 0...rows) {
				tiles[x][y] = new FlxSprite();
                lightBulbs[x][y] = new FlxSprite();
				// make black if negative (-1)
				if (grid[x][y] < 0) {
					tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.BLACK);
				}
				else {
					tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.WHITE);
                    lightBulbs[x][y].loadGraphic(AssetPaths.lightbulb__png, squareWidth, squareHeight);
                    FlxMouseEvent.add(tiles[x][y], function(sprite:FlxSprite) {
                        if(sprite.color == 0x70fff584) {
                            lightUp(0, sprite);
                            lightBulbs[x][y].kill();
                            lightBeam(false, tiles[x][y], x, y);
                        } else {
                            lightUp(1, sprite);
                            lightBulbs[x][y].revive();
                            lightBeam(true, tiles[x][y], x, y);
                        }
                    });
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

        var tile1_4 = new FlxText(tiles[1][4].x + (tiles[1][4].width/2), tiles[1][4].y , 0, "1", 24);
        var tile1_6 = new FlxText(tiles[1][6].x + (tiles[1][6].width/2), tiles[1][6].y , 0, "2", 24);
        var tile2_1 = new FlxText(tiles[2][1].x + (tiles[2][1].width/2), tiles[2][1].y , 0, "3", 24);
        var tile2_6 = new FlxText(tiles[2][6].x + (tiles[2][6].width/2), tiles[2][6].y , 0, "0", 24);
        var tile4_5 = new FlxText(tiles[4][5].x + (tiles[4][5].width/2), tiles[4][5].y , 0, "0", 24);
        var tile5_0 = new FlxText(tiles[5][0].x + (tiles[5][0].width/2), tiles[5][0].y , 0, "0", 24);
        var tile5_2 = new FlxText(tiles[5][2].x + (tiles[5][2].width/2), tiles[5][2].y , 0, "2", 24);
        var tile6_5 = new FlxText(tiles[6][5].x + (tiles[6][5].width/2), tiles[6][5].y , 0, "0", 24);

        add(tile1_4);
        add(tile1_6);
        add(tile2_1);
        add(tile2_6);
        add(tile4_5);
        add(tile5_0);
        add(tile5_2);
        add(tile6_5);



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