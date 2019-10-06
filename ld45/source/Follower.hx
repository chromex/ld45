package;

import GameConstants.SystemConstants;
import Agent.Agent_State_ENUM;
import Agent.Faction_Enum;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.math.FlxRandom;

class Follower extends Agent {
	private var leaderOffset:FlxVector;

	static private var rng:FlxRandom = new FlxRandom();

	public var target:Agent;

	var aiCounter:Int;

	var damage:Float;

	public function new(posx:Float, posy:Float, _faction:Faction_Enum = unset) {
		super(posx, posy);
		health = 100;
		loadGraphic(AssetPaths.follower__png, true, 32, 32, true);

		animation.add("idle", [for (i in 0...11) i], 12, true);
		animation.add("attack", [for (i in 12...25) i], 12, true);
		animation.add("walk", [for (i in 26...32) i], 18, true);
		animation.add("dead", [32], 18, true);

		animation.play("idle", true, false, -1);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		this.setSize(15, 15);
		this.offset.x = 10;
		this.offset.y = 20;

		var rng:FlxRandom = new FlxRandom();
		mass = rng.float(GameConstants.Follower_MassRange.x, GameConstants.Follower_MassRange.y);
		scale = new FlxPoint(mass / GameConstants.Follower_MassRange.y, mass / GameConstants.Follower_MassRange.y);

		state = Idle;
		oldPosition = new FlxPoint(x, y);
		aiCounter = rng.int(0, SystemConstants.FOLLOWER_AI_DECISION_SPEED);
		damage = mass / 100 * GameConstants.Follower_DamageMultiplier;
		health = mass * GameConstants.Follower_HealthMultiplier;
		setFaction(_faction);
	}

	private function handleAI() {
		aiCounter--;
		if (aiCounter < 0) {
			aiCounter = SystemConstants.FOLLOWER_AI_DECISION_SPEED;
			if (target == null) {
				if (faction != unset) {
					switch faction {
						case player:
							for (i in cast(FlxG.state, PlayState).enemyFollowers) {
								if (Math.abs(i.x - x) < GameConstants.Follower_DetectionRange) {
									if (cast(i.getPosition().subtract(x, y), FlxVector).lengthSquared < GameConstants.Follower_DetectionRange) {
										target = i;
										break;
									}
								}
							}
						case enemy:
							for (i in cast(FlxG.state, PlayState).followers) {
								if (Math.abs(i.x - x) < GameConstants.Follower_DetectionRange) {
									if (cast(i.getPosition().subtract(x, y), FlxVector).lengthSquared < GameConstants.Follower_DetectionRange) {
										target = i;
										break;
									}
								}
							}
						default:
					}
				}
			}
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		velocity.x *= .9;
		velocity.y *= .9;
		if (state != Dead) {
			handleAI();

			var heading:FlxVector = new FlxVector(x, y);
			var followPoint:FlxVector = new FlxVector(x, y);

			if (target != null) {
				if (target.state == Agent_State_ENUM.Dead || target.faction == faction) {
					target = null;
					setState(Idle, true);
				} else {
					followPoint = target.getPosition();
					if (new FlxVector(x - followPoint.x, y - followPoint.y).length < 20) {
						followPoint = getPosition();
					}
				}
			} else {
				if (leader != null) {
					followPoint = leader.GetFollowPoint();

					if (leaderOffset == null || rng.int(0, GameConstants.Follower_Restlessness * 60) == 0) {
						leaderOffset = (new FlxVector(x - followPoint.x, y - followPoint.y)).normalize().scale(rng.float(5, GameConstants.Follower_ClumpSize));
					}

					followPoint.addPoint(leaderOffset);
				}
			}

			if (leader != null && leader.state == Dead) {
				target = null;
				setFaction(unset);
				leader = null;
				setState(Idle, true);
			}

			heading = followPoint.subtractNew(new FlxVector(x, y));

			if (target == null) {
				facing = heading.x > 0 ? FlxObject.LEFT : FlxObject.RIGHT;
			} else {
				facing = target.x > x ? FlxObject.LEFT : FlxObject.RIGHT;
			}

			if (heading.length < (GameConstants.Follower_MoveSpeed * elapsed)) {
				x = followPoint.x;
				y = followPoint.y;
			} else {
				var maxStep:FlxVector = heading.normalize().scale(elapsed * GameConstants.Follower_MoveSpeed);
				x = x + maxStep.x;
				y = y + maxStep.y;
			}

			if (Math.abs(x - oldPosition.x) > .5 || Math.abs(y - oldPosition.y) > .5) {
				setState(Walking);
			} else {
				if (target != null) {
					if (heading.length < 3) {
						if (animation.frameIndex == 24) {
							target.injure(damage, this);
						}
						setState(Attacking);
					}
				} else {
					setState(Idle);
				}
			}

			oldPosition = new FlxPoint(x, y);
		}
	}

	public override function OnDed():Void {
		Stats.kills += 1;
	}
}
