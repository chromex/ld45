package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.math.FlxRandom;

enum Agent_State_ENUM {
	Idle;
	Walking;
	Attacking;
}

class Agent extends FlxSprite {
	static private var rng:FlxRandom = new FlxRandom();

	private var state:Agent_State_ENUM;
	private var oldPosition:FlxPoint;

	public function new(posx:Float, posy:Float) {
		super(posx, posy);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		var rng:FlxRandom = new FlxRandom();
		state = Idle;
		oldPosition = new FlxPoint(x, y);
	}

	private function setState(newState:Agent_State_ENUM):Void {
		if (state != newState && state != Attacking) {
			state = newState;
			switch newState {
				case Idle:
					animation.play("idle", true, false, -1);
				case Walking:
					animation.play("walk", true, false, -1);
				case Attacking:
					animation.play("attack", true, false, -1);
			}
		}
	}
}
