package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Tombstone extends FlxSprite {

    public function new(posx:Float, posy:Float) {
        super(posx, posy);
        
        loadGraphic(AssetPaths.doodads__png, true, 16, 16);
        animation.add("idle", [23], 1);
        animation.play("idle", false, false, -1);
    }

    public function krak() {
        if (alive)
        {
            kill();
            var flash = new Pillar(x, y+16, FlxColor.RED);
            FlxG.state.add(flash);
        }
    }
}