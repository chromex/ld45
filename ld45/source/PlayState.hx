package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;

class PlayState extends FlxState {
	var _player:Odin;

	var _testSprite:FlxSprite;

	var overlayCamera:FlxCamera;

	var followers:FlxTypedGroup<Follower>;

	var rng:FlxRandom;

	override public function create():Void {
		super.create();
		_player = new Odin();
		// Adds the player to the state
		add(_player);
		FlxG.camera.zoom = 2;
		FlxG.camera.follow(_player);
		rng = new FlxRandom(3);

		followers = new FlxTypedGroup(30);

		for (i in 0...20) {
			var follower:Follower = new Follower();
			follower.mass = 30;

			follower.x = rng.float(FlxG.width / -2, FlxG.width / 2);
			follower.y = rng.float(FlxG.height / -2, FlxG.height / 2);
			add(follower);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(followers, _player);
	}
}
