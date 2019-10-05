package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var _player:Odin;

	var _testSprite:FlxSprite;

	override public function create():Void
	{
		super.create();
		_player = new Odin();
		// Adds the player to the state
		add(_player);

		_testSprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		_testSprite.makeGraphic(4,4, FlxColor.BLUE);
		add(_testSprite);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
