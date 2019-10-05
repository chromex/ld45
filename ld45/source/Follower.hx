package;

import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.FlxSprite;

class Follower extends FlxSprite
{
	public var leader:Odin;

	private var leaderOffset:FlxVector;
	
	static private var rng:FlxRandom = new FlxRandom();
	static private var kSpreadRange:Float = 40;
	static private var kSpeed:Float = 40;

	public function new(posx:Float, posy:Float)
	{
		super(posx, posy, "assets/images/follower.png");
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (leader != null)
		{
			var followPoint:FlxVector = leader.GetFollowPoint();

			if (leaderOffset == null)
			{
				leaderOffset = (new FlxVector(x - followPoint.x, y - followPoint.y)).normalize().scale(rng.float(5, kSpreadRange)); 
			}
			
			followPoint.addPoint(leaderOffset); 
			var heading:FlxVector = followPoint.subtractNew(new FlxVector(x, y));
			
			if (heading.length < (kSpeed * elapsed))
			{
				x = followPoint.x;
				y = followPoint.y;
			}
			else
			{
				var maxStep:FlxVector = heading.normalize().scale(elapsed * kSpeed);
				x = x + maxStep.x;
				y = y + maxStep.y;
			}
		}
	}
}