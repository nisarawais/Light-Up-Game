package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.input.FlxAccelerometer;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class RulesState extends FlxState
{
    //initializing the variables
    var _btnBack:FlxButton;
    var _rulesText:FlxText;
    var _titleText:FlxText;

    override public function create():Void
    {
        super.create();

        camera.bgColor = FlxColor.WHITE;

        _titleText = new FlxText(300,10,550, "Rules", 15);
        _titleText.color = FlxColor.BLACK;
        add(_titleText);

        _rulesText = new FlxText(100,50,550, "1. Light blocks can be placed anywhere on the grid where there isn't any black squares
        \n2. Light blocks make a line of light in all 4 directions (up, down, left, right), including the square they were placed on, until they either hit the edge of the map or a black square
        \n3. Light blocks cannot be placed within line of sight of another light block (in the trail of light from another light block)
        \n4. All white squares must be lit up to solve the puzzle
        \n5. You can place a marker where you don't think a light block will go (has no effect on the game besides not allowing a light block to be placed on it, like a bomb flag in minesweeper)
        \n6. Black blocks can have no number, 0, 1, 2, 3, or 4 on them
        \n7. Black blocks with a number on them needs to have exactly that number of light blocks near them (within one block up, down, left, or right of them, but the diagonals do not count) and cannot have more or less near them to successfully solve the puzzle
        \n8. Black blocks with no number can have any number of light blocks around them", 11);
        _rulesText.screenCenter(X);
        _rulesText.color = FlxColor.BLACK;
        add(_rulesText);

        _btnBack = new FlxButton(50, 430, "Back", clickBack);
        _btnBack.screenCenter(X);
        add(_btnBack);

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