package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;

class Footdust extends FlxSprite {
	public function new() {
		super(0, 0, "assets/sprites/footdust.png");
		scale.x = 0;
		scale.y = 0;
		FlxTween.tween(scale, {x: 2, y: 2}, 1, {ease: FlxEase.quadOut});
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		alpha -= .01;
		if (alpha < 0) {
			destroy();
		}
	}
}
