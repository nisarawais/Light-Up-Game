package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;

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
	var _solveButton: FlxButton;
	var _checkSolution: FlxButton;

	var numOfLights: Array<Array<Int>>;



	override public function new(columnsPassed: Int, rowsPassed: Int) {
		super();
		columns = columnsPassed;
		rows = rowsPassed;
	}
	override public function create()
	{
		super.create();
		generateBoard();

        _solveButton = new FlxButton(20, 20, "Solve Puzzle", solvePuzzle);
        add(_solveButton);

		_checkSolution = new FlxButton(20, 20, "Check solution", checkSolution);
		_checkSolution.x = FlxG.width - _checkSolution.width - 20;
        add(_checkSolution);
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
		numOfLights = new Array<Array<Int>>();

		// ======= INITIAL LIGHT VALUES =======
        for (x in 0...columns) {
            // each column is an array
            grid[x] = new Array<Int>();
			numOfLights[x] = new Array<Int>();

            // set each value in the column to 0
            for (y in 0...rows) {
                grid[x][y] = 0;
				numOfLights[x][y] = 0;
            }
        }

        // ======== RANDOMIZE BLACK SQUARES ==========
        var x = 0;
        var y = 0;

		for (x in 0...columns) {
			for (y in 0...rows) {
				if (FlxG.random.bool(40))
					grid[x][y] = -1;
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

			for (x in 0...columns) {
				tiles[x] = new Array<FlxSprite>();
				for (y in 0...rows) {
					tiles[x][y] = new FlxSprite();
					// make black if negative (-1)
					if (grid[x][y] < 0) {
						tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.BLACK);
					}
					else {
						tiles[x][y].makeGraphic(squareWidth, squareHeight, FlxColor.WHITE);
					}
					tiles[x][y].setPosition(squareX, squareY);
					add(tiles[x][y]);


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
				if(grid[x][y] == 0){
					grid[x][y] = 1;
					var i = x+1;
					var j = y+1;
					while (i < columns && (grid[i][y] == 0 || grid[i][y] == 2)){
						if (grid[i][y] == 0) {
							grid[i][y] = 2;
						}
						if (i < columns-1)
							i++;
						else 
							break;
					}
					while (j < rows && (grid[x][j] == 0 || grid[x][j] == 2)){
						if (grid[x][j] == 0) {
							grid[x][j] = 2;
						}
						if (j < rows-1)
							j++;
						else 
							break;
					}
				} else if (grid[x][y] == -1) {
				} else if (grid[x][y] == 1) {
				} else if (grid[x][y] == 2) {
				}
			}
		}
		for (x in 0...columns) {
			for (y in 0...rows) {
				if(grid[x][y] == 0){
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
				if (grid[x][y] == 2) {
					lightUp(1, tiles[x][y]);
				} else if (grid[x][y] == 1) {
					lightUp(2, tiles[x][y]);
				}
			}
		}
	}
	function checkSolution() {

	}


	
}
