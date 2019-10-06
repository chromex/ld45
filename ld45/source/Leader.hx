package;

import GameConstants.SystemConstants;
import Agent.Agent_State_ENUM;
import Agent.Faction_Enum;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.math.FlxRandom;

class Leader extends Agent {
	private var leaderOffset:FlxVector;

	static private var rng:FlxRandom = new FlxRandom();

	public var target:Agent;

	var aiCounter:Int;

	var damage:Float;

	var gatheredFollowers:Bool = false;

	public function new(posx:Float, posy:Float, _faction:Faction_Enum = enemy) {
		super(posx, posy);
		health = 100;
		loadGraphic(AssetPaths.leader__png, true, 70, 70, true);

		animation.add("idle", [for (i in 0...1) i], 12, true);
		animation.add("walk", [for (i in 2...6) i], 12, true);
		animation.add("attack", [for (i in 7...14) i], 12, true);
		animation.add("dead", [15], 18, true);

		animation.play("idle", true, false, -1);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		this.setSize(15, 15);
		this.offset.x = 30;
		this.offset.y = 60;
		this.immovable = true;

		var rng:FlxRandom = new FlxRandom();
		mass = rng.float(GameConstants.Leader_MassRange.x, GameConstants.Leader_MassRange.y);
		scale = new FlxPoint(mass / GameConstants.Leader_MassRange.y, mass / GameConstants.Leader_MassRange.y);

		state = Idle;
		oldPosition = new FlxPoint(x, y);
		aiCounter = rng.int(0, SystemConstants.FOLLOWER_AI_DECISION_SPEED);
		damage = mass / 100 * GameConstants.Leader_DamageMultiplier;
		health = mass * GameConstants.Leader_HealthMultiplier;
		setFaction(_faction);
	}

	private function handleAI() {
		aiCounter--;
		if (aiCounter < 0) {
			if (!gatheredFollowers) {
				gatheredFollowers = true;
				for (i in cast(FlxG.state, PlayState).agents) {
					if (i.faction == Faction_Enum.unset) {
						if (cast(i.getPosition().subtract(x, y), FlxVector).length < GameConstants.Leader_SpellRange) {
							i.setLeader(this);
						}
					}
				}
			}

			aiCounter = SystemConstants.FOLLOWER_AI_DECISION_SPEED;
			if (target == null) {
				if (faction != unset) {
					switch faction {
						case player:
							for (i in cast(FlxG.state, PlayState).enemyFollowers) {
								if (Math.abs(i.x - x) < GameConstants.Leader_DetectionRange) {
									if (cast(i.getPosition().subtract(x, y), FlxVector).lengthSquared < GameConstants.Leader_DetectionRange) {
										target = i;
										break;
									}
								}
							}
						case enemy:
							for (i in cast(FlxG.state, PlayState).followers) {
								if (Math.abs(i.x - x) < GameConstants.Leader_DetectionRange) {
									if (cast(i.getPosition().subtract(x, y), FlxVector).lengthSquared < GameConstants.Leader_DetectionRange) {
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
			}

			heading = followPoint.subtractNew(new FlxVector(x, y));

			if (target == null) {
				facing = heading.x > 0 ? FlxObject.LEFT : FlxObject.RIGHT;
			} else {
				facing = target.x > x ? FlxObject.LEFT : FlxObject.RIGHT;
			}

			if (heading.length < (GameConstants.Leader_MoveSpeed * elapsed)) {
				x = followPoint.x;
				y = followPoint.y;
			} else {
				var maxStep:FlxVector = heading.normalize().scale(elapsed * GameConstants.Leader_MoveSpeed);
				x = x + maxStep.x;
				y = y + maxStep.y;
			}

			if (Math.abs(x - oldPosition.x) > .5 || Math.abs(y - oldPosition.y) > .5) {
				setState(Walking);
			} else {
				if (target != null) {
					if (heading.length < 3) {
						if (animation.frameIndex == 14) {
							for (i in cast(FlxG.state, PlayState).followers) {
								if (cast(i.getPosition().subtract(x, y), FlxVector).length < GameConstants.Leader_AttackRange) {
									i.injure(GameConstants.Leader_Damage, this);
								}
							}
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
}
