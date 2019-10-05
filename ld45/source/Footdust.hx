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
        alpha = .5;
		FlxTween.tween(scale, {x: 2, y: 2}, .7, {ease: FlxEase.quadOut});
		FlxTween.tween(this, {alpha: 0}, .7, {ease: FlxEase.quadOut});
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (alpha < .1) {
			destroy();
		}
	}
}
