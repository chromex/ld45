package;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Overlay extends FlxGroup {
	public var overlay:FlxSprite;
    public var position:FlxPoint;

	public function new() {
		super();
        position = new FlxPoint(-1000,-1000);
		overlay = new FlxSprite(position.x, position.y, "assets/sprites/overlay.png");
		add(overlay);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
