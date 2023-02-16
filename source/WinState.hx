import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.gamepad.FlxGamepad;

class WinState extends FlxSubState{
    var gamepad:FlxGamepad;

        public function new()
        {
            super(0x61000000);
        }
    
        override public function create()
        {
            super.create();
            final boundingBox = new FlxSprite();
            boundingBox.makeGraphic(550, 300, 0xff751919);
            boundingBox.screenCenter(XY);
            add(boundingBox);
    
            final gameOverTxt = new FlxText(0, (boundingBox.y + 55), 0, "GAME COMPLETE", 48);
            gameOverTxt.screenCenter(X);
            add(gameOverTxt);
    
            final subGameOverTxt = new FlxText(0, boundingBox.y + 135, 0, "Press SPACE or Xbox A to restart", 24);
            subGameOverTxt.screenCenter(X);
            add(subGameOverTxt);

        }
    
        override public function update(elapsed:Float)
        {
            super.update(elapsed);
            gamepad = FlxG.gamepads.lastActive;
            if (gamepad != null) {
                updateGamepadInput(gamepad);
            }
            if (FlxG.keys.justPressed.SPACE)
            {
                FlxG.resetGame();
            }
        }
	function updateGamepadInput(gamepad:FlxGamepad) {
        if(gamepad.justReleased.A){
            FlxG.resetGame();
        }
    }

}