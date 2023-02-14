package;

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

    override public function create():Void
    {  

        super.create();

        // setting up the inital rows and columns
        rows = 4;
        columns = 4;

        titleText = new FlxText(280,50,200, "Set Up The Graph", 15);
        titleText.screenCenter(X);
        titleText.color = FlxColor.BLACK;
        add(titleText);


        rowTitleText = new FlxText(240,160,200, "Row", 15);
        rowTitleText.color = FlxColor.BLACK;
        add(rowTitleText);

        _btnUpRow = new FlxButton(220,190, "Up",increaseRow);
        add(_btnUpRow);

        rowText = new FlxText(250,125,200, ""+rows,20);
        rowText.color = FlxColor.BLACK;
        rowText.screenCenter(Y);
		add(rowText);

        _btnDownRow = new FlxButton(220,270, "Down",decreaseRow);
        add(_btnDownRow);
   

        columnTitleText = new FlxText(320,160,200, "Column", 15);
        columnTitleText.color = FlxColor.BLACK;
        add(columnTitleText);

        _btnUpColumn = new FlxButton(320,190, "Up",increaseColumn);
        add(_btnUpColumn);

        columnText = new FlxText(350,125,200, ""+columns,20);
        columnText.color = FlxColor.BLACK;
        columnText.screenCenter(Y);
		add(columnText);

        _btnDownColumn = new FlxButton(320,270, "Down",decreaseColumn);
        add(_btnDownColumn);

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

    function increaseRow():Void{ 
        if(rows <10)
            {
                rows ++;
                rowText.text = ""+ rows;
                remove(alertText);
            }

        else{
            remove(alertText);
            add(alertText);
            
        }    
    }

    // decrease the row
    function decreaseRow():Void{
        if(rows >4){
            rows --;
            rowText.text = ""+ rows;
            remove(alertText);
        }
        else{
                remove(alertText);
                add(alertText);
        }

    }

    // increase the column
    function increaseColumn():Void{
        if(columns < 10)
            {
            columns ++;
            columnText.text = ""+ columns;
            remove(alertText);
            }
        else{
            remove(alertText);
            add(alertText);
        }    

    }

    // decrease the column
    function decreaseColumn():Void{
        if(columns > 4)
            {
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