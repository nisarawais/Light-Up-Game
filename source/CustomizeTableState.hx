package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class CustomizeTableStae extends FlxState
{
    //initializing the variables
    var _btnPlay:FlxButton;

    override public function create():Void
        {
            
            //adding the button for the user to click to start the game
            _btnPlay = new FlxButton(50,50, "Play",clickPlay);
            _btnPlay.screenCenter();
            add(_btnPlay);
            super.create();
        }

        //play button is clicked
        function clickPlay():Void
            {
                // switched state from current to PlayState
                FlxG.switchState(new PlayState());
            }

            override public function update(elapsed:Float):Void
            
                {
                    super.update(elapsed);
            }
}