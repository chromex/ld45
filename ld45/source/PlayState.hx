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
		_player = new Odin();
		// Adds the player to the state
		add(_player);
		FlxG.camera.zoom = 1;
		FlxG.camera.follow(_player, FlxCameraFollowStyle.TOPDOWN, GameConstants.CameraLerp);
		var helper:Float = Math.max(FlxG.width, FlxG.height) / 2;
		FlxG.camera.deadzone = FlxRect.get((FlxG.width - helper) / 2, (FlxG.height - helper) / 2, helper, helper);
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
