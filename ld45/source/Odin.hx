package;

import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Class declaration for the Odinson
 */
class Odin extends FlxSprite
{

	var movespeed = 10;

	/**
	 * Constructor for the player - just initializing a simple sprite using a graphic.
	 */ 
	public function new(posx:Float, posy:Float)
	{
		// This initializes this sprite object with the graphic of the ship and
		// positions it in the middle of the screen.
		super(posx, posy, "assets/images/odin.png");
	}
	
	/**
	 * Basic game loop function again!
	 */
	override public function update(elapsed:Float):Void
	{
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

		
		// Just like in PlayState, this is easy to forget but very important!
		// Call this to automatically evaluate your velocity and position and stuff.
		super.update(elapsed);
	}

	public function GetFollowPoint():FlxVector
	{
		return FlxG.mouse.getPosition();
	}
}