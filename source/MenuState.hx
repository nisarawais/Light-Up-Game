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
    var _btnRules:FlxButton;

    override public function create():Void
    {
        super.create();

        camera.bgColor = FlxColor.WHITE;
        //adding the button for the user to click to start the game
        _btnPlay = new FlxButton(50,180, "New Game",clickPlay);
        _btnPlay.screenCenter(X);
        add(_btnPlay);

        _btnTutorial = new FlxButton(50, 110, "Tutorial Board", clickTutorial);
        _btnTutorial.screenCenter(X);
        _btnTutorial.screenCenter(Y);
        add(_btnTutorial);

        _btnRules = new FlxButton(50, 280, "Rules", clickRules);
        _btnRules.screenCenter(X);
        add(_btnRules);

    }

    //play button is clicked
    function clickPlay():Void
    {
        // switched state from current to PlayState
        FlxG.switchState(new CustomizeTableState());
    }
    
    function clickTutorial():Void 
    {
        // switched state from current to TutorialBoard 
        FlxG.switchState(new TutorialBoard());
    }

    function clickRules():Void 
        {
            // switched state from current to RulesState
            FlxG.switchState(new RulesState());
        }
    

    override public function update(elapsed:Float):Void
    {
            super.update(elapsed);
    }
}