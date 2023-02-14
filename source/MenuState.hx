package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
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
    var background:FlxSprite;

    override public function create():Void
    {
        super.create();
        if (FlxG.sound.music == null) // don't restart the music if it's already playing
            {
                FlxG.sound.playMusic("assets/music/suspense_dark_ambient_8413.ogg", 1, true);
            }
        camera.bgColor = FlxColor.WHITE;

        background = new FlxSprite();
		background.loadGraphic("assets/images/menu_background.png");
		background.scale.set(FlxG.width / background.width, FlxG.height / background.height);
		background.updateHitbox();
		background.x = FlxG.width - background.width;
		background.y = FlxG.height - background.height;
		add(background);

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