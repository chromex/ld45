package;

import Agent.Faction_Enum;
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

	public var followers:FlxTypedGroup<Agent>;
	public var enemyFollowers:FlxTypedGroup<Agent>;
	public var agents:FlxTypedGroup<Agent>;

	var rng:FlxRandom;

	var terrain:FlxTilemap;
	var water:FlxTilemap;
	var doodads:FlxTilemap;

	override public function create():Void {
		super.create();

		followers = new FlxTypedGroup();
		enemyFollowers = new FlxTypedGroup();
		agents = new FlxTypedGroup();
		LoadMap();

		FlxG.camera.zoom = 2;
		FlxG.camera.follow(_player, FlxCameraFollowStyle.TOPDOWN_TIGHT, GameConstants.CameraLerp);
		var overlay = new Overlay();
		add(overlay);
		overlayCamera = new FlxCamera(0,0, 1280, 720, 1);
		overlayCamera.bgColor = FlxColor.TRANSPARENT;
		
		overlayCamera.follow(overlay.overlay, FlxCameraFollowStyle.NO_DEAD_ZONE);
		FlxG.cameras.add(overlayCamera);

		rng = new FlxRandom(3);

		FlxG.camera.bgColor = 0x2f2e36;

		for (i in 0...20) {
			var follower:Follower = new Follower(rng.float(FlxG.width / -2, FlxG.width / 2), rng.float(FlxG.height / -2, FlxG.height / 2));
			follower.mass = 30;
			agents.add(follower);
		}

		add(agents);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		agents.sort(FlxSort.byY);
		FlxG.collide(agents, agents);
		FlxG.collide(agents, terrain);
	}

	private function PlaceEntities(entityName:String, entityData:Xml):Void {
		rng = new FlxRandom(3);
		var px = Std.parseFloat(entityData.get("x"));
		var py = Std.parseFloat(entityData.get("y"));

		if (entityName == "player") {
			_player = new Odin(px, py);
			agents.add(_player);
		} else if (entityName == "minion") {
			for (i in 0...3) {
				var spawnRange:Float = 50;
				var follower:Follower = new Follower(px + 50 + rng.float(-spawnRange, spawnRange), py + rng.float(-spawnRange, spawnRange), enemy);
				agents.add(follower);
			}
		} else if (entityName == "leader") {
			// for (i in 0...6) {
			// 	var spawnRange:Float = 50;
			// 	var follower:Follower = new Follower(px + 50 + rng.float(-spawnRange, spawnRange), py + rng.float(-spawnRange, spawnRange));
			// 	agents.add(follower);
			// 	follower.setFaction(enemy);
			// }
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
