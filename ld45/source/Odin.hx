package;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.FlxG;

/**
 * Class declaration for the Odinson
 */
class Odin extends Agent {
	// TODO: figure out how to get the real framecount;
	var frameCount = 0;
	var movespeed = 50;

	/**
	 * Constructor for the player - just initializing a simple sprite using a graphic.
	 */
	public function new(posx:Float, posy:Float) {
		super(posx, posy);
		// This initializes this sprite object with the graphic of the ship and
		// positions it in the middle of the screen.

		loadGraphic(AssetPaths.odin__png, true, 70, 70);
		animation.add("idle", [for (i in 0...2) i], 2, true);
		animation.add("walk", [for (i in 3...7) i], 12, true);
		animation.add("attack", [for (i in 7...14) i], 12, false);
		mass = 100;
		this.setSize(15, 15);
		this.offset.x = 30;
		this.offset.y = 60;
	}

	private function handleMovement():Void {
		velocity.x *= .9;
		velocity.y *= .9;

		var delta:FlxPoint = new FlxPoint(0, 0);
		var moving = false;

		// If the player is pressing left, set velocity to left 100
		if (FlxG.keys.anyPressed([LEFT, A])) {
			delta.x = 1;
			moving = true;
		}
		if (FlxG.keys.anyPressed([RIGHT, D])) {
			delta.x = -1;
			moving = true;
		}

		if (FlxG.keys.anyPressed([UP, W])) {
			delta.y = -1;
			moving = true;
		}

		if (FlxG.keys.anyPressed([DOWN, S])) {
			delta.y = 1;
			moving = true;
		}

		if (FlxG.keys.anyPressed([SPACE])) {
			setState(Attacking);
		}

		if (state == Attacking && animation.frameIndex == 13) {
			state = Walking;
			setState(Idle);
		}

		if (moving) {
			setState(Walking);
			var direction = Math.atan2(delta.x, delta.y);
			velocity.x = -(Math.sin(direction)) * movespeed;
			velocity.y = (Math.cos(direction)) * movespeed;

			facing = velocity.x > 0 ? FlxObject.LEFT : FlxObject.RIGHT;

			if (frameCount % 10 == 0) {
				var footDust = new Footdust();
				footDust.x = x + 10;
				footDust.y = y + 20;
				FlxG.state.add(footDust);
			}
		} else {
			setState(Idle);
		}
	}

	/**
	 * Basic game loop function again!
	 */
	override public function update(elapsed:Float):Void {
		frameCount++;

		this.handleMovement();

		// Just like in PlayState, this is easy to forget but very important!
		// Call this to automatically evaluate your velocity and position and stuff.
		super.update(elapsed);
	}

	public function GetFollowPoint():FlxVector {
		return FlxG.mouse.getPosition();
	}
}
