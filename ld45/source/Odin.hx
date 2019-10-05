package;

import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Class declaration for the Odinson
 */
class Odin extends FlxSprite
{
	// TODO: figure out how to get the real framecount;
	var frameCount = 0;
	var movespeed = 10;

	/**
	 * Constructor for the player - just initializing a simple sprite using a graphic.
	 */ 
	public function new()
	{
		// This initializes this sprite object with the graphic of the ship and
		// positions it in the middle of the screen.
		super(FlxG.width / 2 - 6, FlxG.height / 2 - 6,"assets/sprites/odin.png");
	}

	private function handleMovement():Void {
		
		velocity.x *= .8;
		velocity.y *= .8;

		// If the player is pressing left, set velocity to left 100
		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			velocity.x -= movespeed;
		}
		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			velocity.x += movespeed;
		}
			
		if (FlxG.keys.anyPressed([UP, W]))
		{
			velocity.y -= movespeed;
		}

		if (FlxG.keys.anyPressed([DOWN, S]))
		{
			velocity.y += movespeed;
		}

		if (Math.abs(velocity.x) > .01  || Math.abs(velocity.y) > .01) {
			if (frameCount % 10 == 0) {
				var footDust = new Footdust();
				footDust.x = x;
				footDust.y = y + 10;
				FlxG.state.add(footDust);
			} 
		}

	}
	/**
	 * Basic game loop function again!
	 */
	override public function update(elapsed:Float):Void
	{
		frameCount++;

		this.handleMovement();

		
		// Just like in PlayState, this is easy to forget but very important!
		// Call this to automatically evaluate your velocity and position and stuff.
		super.update(elapsed);
	}
}