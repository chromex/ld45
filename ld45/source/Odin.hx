package;

import flixel.util.FlxColor;
import Agent.Faction_Enum;
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
	var spellCooldownCounter = 60;

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
		animation.add("dead", [20], 12, false);
		mass = GameConstants.Odin_Mass;
		this.setSize(15, 15);
		this.offset.x = 30;
		this.offset.y = 60;
		health = GameConstants.Odin_StartHealth;
		setFaction(player);
	}

	private function handleMovement():Void {
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

		if (moving) {
			setState(Walking);
			var direction = Math.atan2(delta.x, delta.y);
			velocity.x = -(Math.sin(direction)) * GameConstants.Odin_Movespeed;
			velocity.y = (Math.cos(direction)) * GameConstants.Odin_Movespeed;

			facing = velocity.x > 0 ? FlxObject.LEFT : FlxObject.RIGHT;

			if (frameCount % 10 == 0) {
				var footDust = new Footdust();
				footDust.x = x + 10;
				footDust.y = y + 10;
				FlxG.state.add(footDust);
			}
		} else {
			setState(Idle);
		}
	}

	private function handleAttack():Void {
		if (FlxG.keys.anyPressed([SPACE])) {
			if (state != Attacking) {
				FlxG.state.camera.shake(mass / 100000);
				setState(Attacking);
			}
		}

		if (state == Attacking) {
			if (animation.frameIndex == 9) {
				for (i in cast(FlxG.state, PlayState).enemyFollowers) {
					if (cast(i.getPosition().subtract(x, y), FlxVector).length < GameConstants.Odin_AttackRange) {
						i.injure(GameConstants.Odin_Damage, this);
						Stats.dmg += GameConstants.Odin_Damage;
					}
				}

				for (i in cast(FlxG.state, PlayState).tombstones) {
					if (i.alive && cast(i.getPosition().subtract(x, y), FlxVector).length < GameConstants.Odin_AttackRange) {
						i.krak();
						health = Math.min(health + GameConstants.Odin_HealthPerKrak, GameConstants.Odin_StartHealth);
					}
				}
			}

			if (animation.frameIndex == 13) {
				// hack to get out of teh Attack state
				state = Walking;
				setState(Idle);
			}
		}
	}

	private function handleSpellcasting():Void {
		if (spellCooldownCounter < GameConstants.Odin_SpellCooldown) {
			spellCooldownCounter++;
		} else {
			if (FlxG.keys.anyPressed([E])) {
				for (i in cast(FlxG.state, PlayState).agents) {
					if (i.faction == Faction_Enum.unset) {
						if (cast(i.getPosition().subtract(x, y), FlxVector).length < GameConstants.Odin_SpellRange) {
							i.setLeader(this);
						}
					}
				}
				spellCooldownCounter = 0;
				var flash = new Pillar(x, y, FlxColor.YELLOW);
				gameState.add(flash);
			}
		}
	}

	/**
	 * Basic game loop function again!
	 */
	override public function update(elapsed:Float):Void {
		var newScale = Math.min(1 + (gameState.followers.length / 20) * GameConstants.Odin_FollowerScaleMultiplier, 4);
		if (newScale != scale.x)
		{
			scale.x = newScale;
			scale.y = newScale;
			var theight = Math.abs(scale.y) * frameHeight;
			this.offset.y = theight - (16 * Math.abs(scale.y)) - (gameState.followers.length * GameConstants.Odin_FollowerScaleMultiplier);
		}

		frameCount++;
		velocity.x *= .9;
		velocity.y *= .9;

		if (state != Dead) {
			this.handleMovement();
			this.handleAttack();
			this.handleSpellcasting();
			// Just like in PlayState, this is easy to forget but very important!
			// Call this to automatically evaluate your velocity and position and stuff.
		}
		super.update(elapsed);
	}

	public override function GetFollowPoint():FlxVector {
		return FlxG.mouse.getPosition();
	}
}
