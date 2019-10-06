package;

import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Pillar extends FlxSprite {
	public function new(posx:Float, posy:Float, flashColor) {
		super(posx, posy - 300.0);
		scale.x = 0;
		scale.y = 1;
		makeGraphic(10, 300, flashColor);
		alpha = 1;
		FlxTween.tween(scale, {x: 4, y: 1}, .3, {ease: FlxEase.quadOut});
		FlxTween.tween(this, {alpha: 0}, .3, {ease: FlxEase.quadOut});
		FlxG.state.camera.shake(.003);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (alpha < .01) {
			destroy();
		}
	}
}
