package;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;

class TutorialBoard extends FlxState{
    var boardWidth: Int;
	var boardHeight: Int;
    var columns:Int;
    var rows:Int;
    var squareWidth: Int;
	var squareHeight: Int;
	var tiles: Array<Array<FlxSprite>>;

    var grid: Array<Array<Int>>;

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
}