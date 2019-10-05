package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;

import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var _player:Odin;

	var _testSprite:FlxSprite;

	var overlayCamera:FlxCamera;

	var followers:FlxTypedGroup<FlxSprite>;

	var rng:FlxRandom;

	override public function create():Void
	{
		super.create();
		_player = new Odin();
		// Adds the player to the state
		add(_player);
		FlxG.camera.zoom = 2;
		FlxG.camera.follow(_player);
		rng = new FlxRandom();

		followers = new FlxTypedGroup(30);

		for (i in 0...10) {
			// Instantiate a new sprite offscreen
			var sprite = new FlxSprite(rng.float(FlxG.width / -2, FlxG.width / 2), rng.float(FlxG.height / -2, FlxG.height / 2), "assets/images/follower.png");
			// Add it to the group of player bullets
			followers.add(sprite);
			add(sprite);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
