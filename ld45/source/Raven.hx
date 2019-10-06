package;

import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Raven extends FlxSprite {
    public var player:FlxSprite;

    public function new(posx:Float, posy:Float) {
        super(posx, posy);
        
        loadGraphic(AssetPaths.raven__png, true, 10, 10);
        animation.add("idle", [for (i in 0...37) i], 10, true, false, false);
        animation.add("flying", [for (i in 38...43) i], 12, true);

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
        if (FlxG.random.bool())
        {
            facing = FlxObject.LEFT;
        }

        animation.play("idle", false, false, -1);
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (player != null)
        {
            var delta:FlxVector = new FlxVector(x - player.x, y - player.y);
            if (delta.lengthSquared < GameConstants.RAVEN_FLEERANGE)
            {
                if (animation.curAnim.name != "flying")
                {
                    animation.play("flying", false, false, -1);
                }

                delta.normalize().scale(GameConstants.RAVEN_VELOCITY);
                velocity.set(delta.x, delta.y);

                if (velocity.x < 0) {
                    facing = FlxObject.LEFT;
                } else {
                    facing = FlxObject.RIGHT;
                }
            }
        }

        if (x < -20 || x > 4000 || y < -20 || y > 2000) {
            kill();
        }
    }
}