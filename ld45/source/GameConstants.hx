package;

import flixel.math.FlxPoint;

class GameConstants {
	public static var CameraLerp:Float = 0.3;
	static public var Follower_MoveSpeed:Float = 40;

	// determines the average amount of time before a follower moves around while idle
	static public var Follower_Restlessness:Int = 5;

	// mass also determines scale & health & damage
	static public var Follower_MassRange:FlxPoint = new FlxPoint(70, 90);

	static public var Follower_DamageMultiplier:Float = 1;
	static public var Follower_HealthMultiplier:Float = 1;

	static public var Follower_DetectionRange:Float = 1000;

	static public var Follower_ClumpSize:Float = 80;

	/*
		___________ _____ _   _
		|  _  |  _  \_   _| \ | |
		| | | | | | | | | |  \| |
		| | | | | | | | | | . ` |
		\ \_/ / |/ / _| |_| |\  |
		 \___/|___/  \___/\_| \_/
	 */
	static public var Odin_Movespeed:Float = 50;
	static public var Odin_AttackRange:Float = 30;
	static public var Odin_Damage:Float = 5;

	static public var Odin_SpellRange:Float = 100;
	static public var Odin_SpellCooldown:Float = 60;

	static public var Odin_StartHealth:Float = 100;
	static public var Odin_Mass:Float = 100;



}

class SystemConstants {
	// amount of frames betweem followers deciding do stuff
	public static var FOLLOWER_AI_DECISION_SPEED:Int = 30;
}
