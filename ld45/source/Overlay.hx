package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
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
		title.scale.set(4,4);
		title.alpha = 1;

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

			var skore = Stats.kills * -17 + Stats.frens * 5 + Stats.dmg * 0.5 + FlxG.random.float(-100, 2);
			var sentiment:String;
			if (skore < 0) {
				sentiment = "SAD";
			} else if (skore < 100) {
				sentiment = "meh";
			} else if (skore < 200) {
				sentiment = "bleh";
			} else if (skore < 300) {
				sentiment = "okaaay";
			} else {
				sentiment = "GODHOOD";
			}
			add(new FlxText(-570, -370, 0, "GOD SKORE: " + Std.int(skore) + " ... " + sentiment, 32));
		}
	}
}
