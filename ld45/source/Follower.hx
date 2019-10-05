package;

import flixel.FlxG;
import flixel.FlxSprite;

class Follower extends FlxSprite
{
	public function new()
	{
		super(FlxG.width / 2 - 6, FlxG.height / 2 - 6,"assets/images/follower.png");
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}