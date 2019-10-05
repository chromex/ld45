package;

import flixel.math.FlxRect;
import lime.math.Rectangle;
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

		_player = new Odin(100, 60);
		// Adds the player to the state
		add(_player);

		FlxG.camera.zoom = 3;
		FlxG.camera.follow(_player, FlxCameraFollowStyle.TOPDOWN_TIGHT, GameConstants.CameraLerp);

		rng = new FlxRandom(3);

		followers = new FlxTypedGroup(30);

		for (i in 0...20) {
			var follower:Follower = new Follower(
				rng.float(FlxG.width / -2, FlxG.width / 2), 
				rng.float(FlxG.height / -2, FlxG.height / 2));
			follower.mass = 30;
			add(follower);
		}

		for (i in 0...20) {
			var follower:Follower = new Follower(rng.float(0, FlxG.width), rng.float(0, FlxG.height));
			follower.leader = _player;
			
			add(follower);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(followers, _player);
	}
}
