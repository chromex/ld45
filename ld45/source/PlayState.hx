package;

import flixel.util.FlxColor;
import haxe.display.Position.Range;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.math.FlxRect;
import lime.math.Rectangle;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.util.FlxSort;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;

class PlayState extends FlxState {
	var _player:Odin;

	var _testSprite:FlxSprite;

	var overlayCamera:FlxCamera;

	var followers:FlxTypedGroup<Follower>;
	var agents:FlxTypedGroup<FlxSprite>;

	var rng:FlxRandom;

	var terrain:FlxTilemap;
	var water:FlxTilemap;
	var doodads:FlxTilemap;

	override public function create():Void {
		super.create();

		agents = new FlxTypedGroup();
		LoadMap();

		FlxG.camera.zoom = 2;
		FlxG.camera.follow(_player, FlxCameraFollowStyle.TOPDOWN_TIGHT, GameConstants.CameraLerp);

		rng = new FlxRandom(3);
		FlxG.camera.bgColor = 0x2f2e36;

		followers = new FlxTypedGroup();

		for (i in 0...20) {
			var follower:Follower = new Follower(
				rng.float(FlxG.width / -2, FlxG.width / 2), 
				rng.float(FlxG.height / -2, FlxG.height / 2));
			follower.mass = 30;
			follower.color = FlxColor.RED;
			followers.add(follower);
			agents.add(follower);
		}

		for (i in 0...20) {
			var spawnRange:Float = 50;
			var follower:Follower = new Follower(_player.x + 50 + rng.float(-spawnRange, spawnRange), _player.y + rng.float(-spawnRange, spawnRange));
			follower.leader = _player;
			followers.add(follower);
			agents.add(follower);
		}

		add(agents);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		agents.sort(FlxSort.byY);
		FlxG.collide(followers, followers);
		FlxG.collide(followers, terrain);
		FlxG.collide(_player, followers);
		FlxG.collide(_player, terrain);
	}

	private function PlaceEntities(entityName:String, entityData:Xml):Void {
		var px = entityData.get("x");
		var py = entityData.get("y");

		if (entityName == "player")
		{
			_player = new Odin(Std.parseInt(px), Std.parseInt(py));
			agents.add(_player);
		}
		else if (entityName == "minion")
		{
			// RYDER SPAWN SHIT
		}
		else if (entityName == "leader")
		{
			// RYDER SPAWN MORE SHIT
		}
	}

	private function LoadMap():Void {
		var map:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.island__oel);
		water = map.loadTilemap(AssetPaths.water__png, 16, 16, "water");
		doodads = map.loadTilemap(AssetPaths.doodads__png, 16, 16, "doodads");
		terrain = map.loadTilemap(AssetPaths.tileset__png, 16, 16, "terrain");
		terrain.follow();
		terrain.setTileProperties(0, FlxObject.ANY, null, null, 256);
		terrain.setTileProperties(17, FlxObject.NONE);
		terrain.setTileProperties(97, FlxObject.NONE);
		add(water);
		add(terrain);
		add(doodads);

		map.loadEntities(PlaceEntities, "entities");
	}
}
