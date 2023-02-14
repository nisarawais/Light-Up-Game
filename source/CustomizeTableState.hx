package;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode;
import flixel.util.FlxColor;
import openfl.text.TextField;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class CustomizeTableState extends FlxSubState
{
    //initializing the variables
    var _btnPlay:FlxButton;
    var instruction:FlxText;
    var _btnUpRow:FlxButton;
    var _btnDownRow:FlxButton;
    var _btnUpColumn:FlxButton;
    var _btnDownColumn:FlxButton;
    var columnText:FlxText;
    var rowText:FlxText;
    public var columns: Int;
	public var rows: Int;
    var alertText:FlxText;
    var rowTitleText:FlxText;
    var columnTitleText:FlxText;
    var _btnBack:FlxButton;
    var titleText:FlxText;
    var background:FlxSprite;

    override public function create():Void
    {  

        super.create();

        // ***** If the background is on here, the text is not visible *****
    /*  background = new FlxSprite();
		background.loadGraphic("assets/images/menu_background.png");
		background.scale.set(FlxG.width / background.width, FlxG.height / background.height);
		background.updateHitbox();
		background.x = FlxG.width - background.width;
		background.y = FlxG.height - background.height;
		add(background); */

        // setting up the inital rows and columns
        rows = 4;
        columns = 4;

        titleText = new FlxText(280,50,200, "Set Up The Graph", 15);
        titleText.screenCenter(X);
        titleText.color = FlxColor.BLACK;
        add(titleText);


        rowTitleText = new FlxText(240,190,200, "Row", 15);
        rowTitleText.color = FlxColor.BLACK;
        add(rowTitleText);

        _btnUpRow = new FlxButton(270,160, "Up",increaseRowCol);
        add(_btnUpRow);

        rowText = new FlxText(250,125,200, ""+rows,20);
        rowText.color = FlxColor.BLACK;
        rowText.screenCenter(Y);
		add(rowText);

        _btnDownRow = new FlxButton(270,270, "Down",decreaseRowCol);
        add(_btnDownRow);
   

        columnTitleText = new FlxText(320,190,200, "Column", 15);
        columnTitleText.color = FlxColor.BLACK;
        add(columnTitleText);

        columnText = new FlxText(350,165,200, ""+columns,20);
        columnText.color = FlxColor.BLACK;
        columnText.screenCenter(Y);
		add(columnText);

        //adding the button for the user to click to start the game
        _btnPlay = new FlxButton(320,400, "Start",clickPlay);
        add(_btnPlay);
        
        alertText = new FlxText(170,120,400, "You must choose the number between 4-10.", 10);
        alertText.color = FlxColor.RED;


        _btnBack = new FlxButton(220, 400, "Back", clickBack);
        add(_btnBack);

    }

    //play button is clicked
    function clickPlay():Void
    {
        // switched state from current to PlayState
        FlxG.switchState(new PlayState(columns, rows));
    }

    // increase the row

    function increaseRowCol():Void{ 
        if(rows <10)
            {
                rows ++;
                rowText.text = ""+ rows;
                columns ++;
                columnText.text = ""+ columns;
                remove(alertText);
            }

        else{
            remove(alertText);
            add(alertText);
            
        }    
    }

    // decrease the row
    function decreaseRowCol():Void{
        if(rows >4){
            rows --;
            rowText.text = ""+ rows;
            columns --;
            columnText.text = ""+ columns;
            remove(alertText);
        }
        else{
                remove(alertText);
                add(alertText);
        }

    }


        //play button is clicked
        function clickBack():Void
            {
                // switched state from current to MenuState
                FlxG.switchState(new MenuState());
            }

    override public function update(elapsed:Float):Void
    {
            super.update(elapsed);
    }
}