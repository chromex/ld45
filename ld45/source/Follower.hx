package;

import flixel.FlxG;
import flixel.FlxSprite;

class Follower extends FlxSprite {
	public function new() {
		super(FlxG.width / 2 - 6, FlxG.height / 2 - 6);
		loadGraphic(AssetPaths.follower__png, true, 32, 32);
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 12, true);
		animation.play("idle");
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
