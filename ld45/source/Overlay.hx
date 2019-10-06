package;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Overlay extends FlxGroup {
	public var overlay:FlxSprite;
	public var title:FlxSprite;
	public var position:FlxPoint;
	public var credits:FlxSprite;
	public var healthBar:FlxSprite;

	private var gameState:PlayState;

	public function new() {
		super();
		position = new FlxPoint(-1000, -1000);
		overlay = new FlxSprite(position.x, position.y, "assets/sprites/overlay.png");
		title = new FlxSprite(-440, -760, "assets/sprites/FOO_Title.png");
		title.scale.set(4, 4);
		title.alpha = 0.85;
		healthBar = new FlxSprite(-600, -350);
		healthBar.makeGraphic(400, 30, FlxColor.RED);
		add(healthBar);
		add(overlay);
		add(title);
		gameState = cast(FlxG.state, PlayState);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([W, A, S, D, UP, DOWN, LEFT, RIGHT, SPACE]) || FlxG.mouse.justPressed) {
			remove(title);
		}

		if (gameState._player != null) {
			if (gameState._player.health > 0) {
				this.healthBar.scale.x = gameState._player.health / GameConstants.Odin_StartHealth;
			} else {
				this.healthBar.scale.x = 0;
			}
		}
	}

	public function showCredits() {
		if (credits == null) {
			credits = new FlxSprite(-520, -760, "assets/sprites/Credits.png");
			credits.scale.set(2, 2);
			add(credits);
		}
	}
}
