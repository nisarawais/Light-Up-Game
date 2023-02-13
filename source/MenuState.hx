package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.input.FlxAccelerometer;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
    //initializing the variables
    var _btnPlay:FlxButton;
    var _btnCustomize:FlxButton;
    var _btnTutorial:FlxButton;

    override public function create():Void
    {
        super.create();

        camera.bgColor = FlxColor.WHITE;
        //adding the button for the user to click to start the game
        _btnPlay = new FlxButton(50,50, "Play",clickPlay);
        _btnPlay.screenCenter(X);
        add(_btnPlay);

        //adding the button for the user to click to set up the row and column for the graph
        _btnCustomize = new FlxButton(50,110, "Customize The Graph",customizeTable);
        _btnCustomize.screenCenter(X);
        add(_btnCustomize);

        _btnTutorial = new FlxButton(50, 170, "Tutorial Board", clickTutorial);
        _btnTutorial.screenCenter(X);
        add(_btnTutorial);

    }

    //play button is clicked
    function clickPlay():Void
    {
        // switched state from current to PlayState
        FlxG.switchState(new PlayState());
    }
    
    function customizeTable():Void 
    {
        // switched state from current to CustomizeTableState  //ERRORS
        FlxG.switchState(new CustomizeTableState());
    }

    function clickTutorial():Void 
    {
        // switched state from current to CustomizeTableState  //ERRORS
        FlxG.switchState(new TutorialBoard());
    }

    override public function update(elapsed:Float):Void
    {
            super.update(elapsed);
    }
}