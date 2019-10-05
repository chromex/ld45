package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.math.FlxRandom;

class Follower extends FlxSprite {
	public var leader:Odin;

	private var leaderOffset:FlxVector;

	static private var rng:FlxRandom = new FlxRandom();
	static private var kSpreadRange:Float = 40;
	static private var kSpeed:Float = 40;

	public function new(posx:Float, posy:Float) {
		super(posx, posy);
		loadGraphic(AssetPaths.follower__png, true, 32, 32);
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 12, true);
		animation.add("attack", [for (i in 12...25) i], 12, true);
		animation.play("attack", true, false, -1);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (leader != null) {
			var followPoint:FlxVector = leader.GetFollowPoint();

			if (leaderOffset == null) {
				leaderOffset = (new FlxVector(x - followPoint.x, y - followPoint.y)).normalize().scale(rng.float(5, kSpreadRange));
			}

			followPoint.addPoint(leaderOffset);
			var heading:FlxVector = followPoint.subtractNew(new FlxVector(x, y));
            
            facing = heading.x > 0 ? FlxObject.LEFT : FlxObject.RIGHT;

			if (heading.length < (kSpeed * elapsed)) {
				x = followPoint.x;
				y = followPoint.y;
			} else {
				var maxStep:FlxVector = heading.normalize().scale(elapsed * kSpeed);
				x = x + maxStep.x;
				y = y + maxStep.y;
			}
		}
	}
}
