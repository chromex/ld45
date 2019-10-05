package;

import flixel.FlxG;
import flixel.FlxSprite;

class Follower extends FlxSprite
{
	public function new()
	{
		// This initializes this sprite object with the graphic of the ship and
		// positions it in the middle of the screen.
		super(FlxG.width / 2 - 6, FlxG.height / 2 - 6,"assets/images/follower.png");
	}
	
	override public function update(elapsed:Float):Void
	{
		
		
		super.update(elapsed);
	}
}