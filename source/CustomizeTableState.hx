package;

import flixel.FlxSubState;
import flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode;
import flixel.util.FlxColor;
import js.html.svg.EllipseElement;
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

    override public function create():Void
    {  

        super.create();

        // setting up the inital rows and columns
        rows = 4;
        columns = 4;


        rowTitleText = new FlxText(110,80,200, "Row", 15);
        rowTitleText.color = FlxColor.BLACK;
        add(rowTitleText);

        _btnUpRow = new FlxButton(90,100, "Up",increaseRow);
        add(_btnUpRow);

        rowText = new FlxText(120,125,200, ""+rows,20);
        rowText.color = FlxColor.BLACK;
		add(rowText);

        _btnDownRow = new FlxButton(90,150, "Down",decreaseRow);
        add(_btnDownRow);
   

        columnTitleText = new FlxText(200,80,200, "Column", 15);
        columnTitleText.color = FlxColor.BLACK;
        add(columnTitleText);

        _btnUpColumn = new FlxButton(200,100, "Up",increaseColumn);
        add(_btnUpColumn);

        columnText = new FlxText(230,125,200, ""+columns,20);
        columnText.color = FlxColor.BLACK;
		add(columnText);

        _btnDownColumn = new FlxButton(200,150, "Down",decreaseColumn);
        add(_btnDownColumn);

        //adding the button for the user to click to start the game
        _btnPlay = new FlxButton(50,100, "Start",clickPlay);
        _btnPlay.screenCenter();
        add(_btnPlay);
        
        alertText = new FlxText(100,50,200, "You must choose the number between 4-15.", 10);
        alertText.color = FlxColor.RED;

    }

    //play button is clicked
    function clickPlay():Void
    {
        // switched state from current to PlayState
        FlxG.switchState(new PlayState());
    }

    // increase the row

    function increaseRow():Void{ 
        if(rows <15)
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
        if(columns < 15)
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

    override public function update(elapsed:Float):Void
    {
            super.update(elapsed);
    }
}