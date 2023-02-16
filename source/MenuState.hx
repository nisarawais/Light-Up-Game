package;

import flixel.input.gamepad.FlxGamepad;
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

    // New variables for controller input
    var cursorSprite:FlxSprite;
    var menuItems:Array<FlxButton>;
    var cursorIndex:Int = 0;
    var gamepad:FlxGamepad;

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

        // Initialize the cursor sprite and menu items array
        cursorSprite = new FlxSprite();
        cursorSprite.loadGraphic("assets/images/cursor.png");
        cursorSprite.x = _btnPlay.x + _btnPlay.width/2 - cursorSprite.width;
        cursorSprite.y = _btnPlay.y + _btnPlay.height/2 - 8;
        add(cursorSprite);

        // Initialize the menu items array
        menuItems = [_btnPlay, _btnTutorial, _btnRules];
        cursorIndex = 0;

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

            gamepad = FlxG.gamepads.lastActive;
            if (gamepad != null) {

                updateGamepadInput(gamepad);
            }
    }
	function updateGamepadInput(gamepad:FlxGamepad) {
        // Check if the joystick is moved up or down
        if (gamepad.justPressed.LEFT_STICK_DIGITAL_DOWN || gamepad.justPressed.DPAD_DOWN)
        {
            // Move the cursor down
            cursorIndex++;
            if (cursorIndex >= menuItems.length) cursorIndex = 0;
        }
        else if (gamepad.justPressed.LEFT_STICK_DIGITAL_UP || gamepad.justPressed.DPAD_UP)
        {
            // Move the cursor up
            cursorIndex--;
            if (cursorIndex < 0) cursorIndex = menuItems.length - 1;
        }

        // Check if the A button is pressed
        if (gamepad.justReleased.A)
        {
            // Call the function corresponding to the selected menu item
            switch (cursorIndex)
            {
                case 0:
                    clickPlay();
                case 1:
                    clickTutorial();
                case 2:
                    clickRules();
            }
        }
        // Update the position of the cursor sprite
        cursorSprite.y = menuItems[cursorIndex].y + menuItems[cursorIndex].height/2 -8;
    }
}