package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.math.FlxRandom;

class Follower extends Agent {
	public var leader:Odin;

	private var leaderOffset:FlxVector;

	static private var rng:FlxRandom = new FlxRandom();
	static private var kSpreadRange:Float = 80;
	static private var kSpeed:Float = 40;

	public function new(posx:Float, posy:Float) {
		super(posx, posy);
		health = 100;
		loadGraphic(AssetPaths.follower__png, true, 32, 32, true);

		animation.add("idle", [for (i in 0...11) i], 12, true);
		animation.add("attack", [for (i in 12...25) i], 12, true);
		animation.add("walk", [for (i in 26...32) i], 18, true);
		animation.play("idle", true, false, -1);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		this.setSize(15, 15);
		this.offset.x = 10;
		this.offset.y = 20;

		var rng:FlxRandom = new FlxRandom();
		mass = rng.float(70, 90);
		scale = new FlxPoint(mass / 90, mass / 90);

		state = Idle;
		oldPosition = new FlxPoint(x, y);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		velocity.x *= .9;
		velocity.y *= .9;

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

		if (Math.abs(x - oldPosition.x) > .5 || Math.abs(y - oldPosition.y) > .5) {
			setState(Walking);
		} else {
			setState(Idle);
		}

		oldPosition = new FlxPoint(x, y);
	}
}
