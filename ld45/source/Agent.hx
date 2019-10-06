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
	private var damageCounter:Float = 0;

	public var OriginColor:FlxColor;

	public function new(posx:Float, posy:Float) {
		super(posx, posy);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		var rng:FlxRandom = new FlxRandom();
		state = Idle;
		oldPosition = new FlxPoint(x, y);
	}

	public function injure(damage:Float, origin:Agent) {
		health -= damage;
		damageCounter = 3;
		var deltaFromOrigin:FlxVector = cast(this.getPosition(), FlxVector).subtract(origin.x,  origin.y);
		velocity.x += deltaFromOrigin.x;
		velocity.y += deltaFromOrigin.y;

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (damageCounter > 0) {
			damageCounter--;
			if (color != FlxColor.RED) {
				color = FlxColor.RED;
			}
		} else {
			if (OriginColor != null && color != OriginColor) {
				color = OriginColor;
			} else if (color != FlxColor.WHITE) {
				color = FlxColor.WHITE;
			}
		}
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
					animation.play("attack", true, false);
			}
		}
	}
}
