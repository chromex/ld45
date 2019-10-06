package;

import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxRandom;

class Fog extends FlxSprite {
    var rng:FlxRandom = new FlxRandom();
    var vertPos:Float;
    var time:Float = 0;

    public function new(posx:Float, posy:Float) {
        super(posx, posy);
        vertPos = posy;

        if (rng.bool())
            setFacingFlip(FlxObject.LEFT, true, false);

        loadGraphic(AssetPaths.Clouds__png, true, 80, 20);
        animation.add("cloud1", [0], 1, true);
        animation.add("cloud2", [1], 1, true);
        animation.add("cloud3", [2], 1, true);
        animation.add("cloud4", [3], 1, true);
        animation.add("cloud9", [4], 1, true);

        alpha = 0.25;
        scale.set(rng.float(2.5, 4), rng.float(2.5, 4));
        time = rng.float(0, 3.14);

        switch (rng.int(0, 6))
        {
            case 0: animation.play("cloud1", true, false, 0); 
            case 1: animation.play("cloud2", true, false, 0); 
            case 2: animation.play("cloud3", true, false, 0); 
            case 3: animation.play("cloud4", true, false, 0); 
            case 4: animation.play("cloud9", true, false, 0); 
        }
    }

    override public function update(elapsed:Float):Void {
        time += elapsed;
        x -= elapsed * 3.5;
        y = vertPos + 2 * FlxMath.fastSin(time);

        if (x < -100)
        {
            x = 4000;
        }
    } 
}