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
	Casting;
	Dead;
}

enum Faction_Enum {
	unset;
	player;
	enemy;
}

class Agent extends FlxSprite {
	private var leader:Agent;

	static private var rng:FlxRandom = new FlxRandom();

	public var faction:Faction_Enum;

	private var state:Agent_State_ENUM;
	private var oldPosition:FlxPoint;
	private var damageCounter:Float = 0;
	private var gameState:PlayState;

	public var OriginColor:FlxColor = FlxColor.GRAY;

	public function setLeader(newLeader:Agent, overrideCurrentLeader:Bool = false) {
		if (leader == null || overrideCurrentLeader) {
			leader = newLeader;
			setFaction(leader.faction);
		}
	}

	public function setFaction(newFaction:Faction_Enum) {
		if (faction == unset) {
			faction = newFaction;
			switch newFaction {
				case player:
					OriginColor = FlxColor.WHITE;
					gameState.followers.add(this);
				case enemy:
					OriginColor = FlxColor.RED;
					gameState.enemyFollowers.add(this);
				default:
			}
		} else {
			if (faction != newFaction) {
				switch newFaction {
					case player:
						OriginColor = FlxColor.WHITE;
						gameState.followers.add(this);
						gameState.enemyFollowers.remove(this);
					case enemy:
						OriginColor = FlxColor.RED;
						gameState.enemyFollowers.add(this);
						gameState.followers.remove(this);
					default:
				}

				faction = newFaction;
			}
		}
	}

	public function new(posx:Float, posy:Float) {
		super(posx, posy);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		var rng:FlxRandom = new FlxRandom();
		OriginColor = FlxColor.GRAY;
		state = Idle;
		oldPosition = new FlxPoint(x, y);
		gameState = cast(FlxG.state, PlayState);
		faction = Faction_Enum.unset;
	}

	public function injure(damage:Float, origin:Agent) {
		health -= damage;
		if (health < 0) {
			state = Idle;
			gameState.followers.remove(this);
			gameState.enemyFollowers.remove(this);
			setSize(1,1);
			
			setState(Dead);
		} else {
			damageCounter = 3;
		}

		var deltaFromOrigin:FlxVector = cast(this.getPosition(), FlxVector).subtract(origin.x, origin.y);
		velocity.x += Util.Clamp(deltaFromOrigin.x, -10, 10);
		velocity.y += Util.Clamp(deltaFromOrigin.y, -10, 10);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (damageCounter > 0) {
			damageCounter--;
			if (color != FlxColor.RED) {
				color = FlxColor.RED;
			}
		} else {
			if (OriginColor != FlxColor.GRAY) {
				if (color != OriginColor) {
					color = OriginColor;
				}
			} else if (color != FlxColor.GRAY) {
				color = FlxColor.GRAY;
			}
		}
	}

	private function setState(newState:Agent_State_ENUM, overrideState: Bool = false):Void {
		if (state != newState && (state != Attacking || overrideState)) {
			state = newState;
			switch newState {
				case Idle:
					animation.play("idle", true, false, -1);
				case Walking:
					animation.play("walk", true, false, -1);
				case Attacking:
					animation.play("attack", true, false);
				case Dead:
					animation.play("dead", true, false);
				default:
			}
		}
	}

	public function GetFollowPoint():FlxVector {
		return this.getPosition();
	}
}
