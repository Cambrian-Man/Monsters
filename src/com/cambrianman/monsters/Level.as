package com.cambrianman.monsters 
{
	import com.cambrianman.monsters.environment.*;
	import com.cambrianman.monsters.items.*;
	import com.cambrianman.monsters.monsters.*;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	/**
	 * Level class, the base world class.
	 * @author Evan Furchtgott
	 */
	public class Level extends World 
	{
		
		[Embed(source = "levels/tiles.tsx", mimeType = "application/octet-stream")] private const XMLTILESET:Class;
		[Embed(source = "gfx/environment/tiles.png")] private const IMGTILES:Class;
		[Embed(source = "gfx/environment/backdrop.png")] private const IMGBACK:Class;
		
		public var player:Player;
		
		private var levelData:XML;
		private var levelWidth:int;
		private var levelHeight:int;
		
		private var cameraPoint:Point;
		
		public var ground:Entity;
		
		private var backdrop:Backdrop;
		private var backdropEntity:Entity;
		
		private var tileLayers:Vector.<Entity>;
		
		private var damagers:Vector.<int>;
		private var solids:Array;
		
		private var exits:Vector.<Entity>;
		private var entrances:Object;
		private var items:Vector.<Item>;
		
		private var monsters:Vector.<Monster>;
		
		private var environment:Vector.<Entity>;
		
		public function Level() 
		{
			player = new Player(this);
			player.layer = 2;
			add(player);
			
			cameraPoint = new Point();
			
			backdrop = new Backdrop(IMGBACK, true, false);
			backdrop.scrollX = 0.2;
			backdrop.scrollY = 0.2;
			backdropEntity = new Entity(0, 0, backdrop);
			backdropEntity.layer = 9;
			add(backdropEntity);
			
			damagers = new Vector.<int>;
			
			player.checkpoint.level = Levels.start
			player.checkpoint.entrance = "gameStart";
			
			loadLevel(player.checkpoint.level, player.checkpoint.entrance);
		}
		
		override public function update():void
		{
			super.update();
			
			var _e:Exit = player.collide("exit", player.x, player.y) as Exit;
			if (_e)
			{
				if (_e.from != player.facing)
				{
					player.checkpoint.level = _e.to;
					player.checkpoint.entrance = _e.entrance;
					loadLevel(_e.to, _e.entrance);
				}
			}
			updateCamera();
		}
		
		/**
		 * Handles camera updates every frame.
		 */
		private function updateCamera():void
		{
			cameraPoint.x = player.centerX - FP.halfWidth;
			cameraPoint.y = player.centerY - FP.halfHeight + player.cameraOffset;
			FP.clampInRect(cameraPoint, 0, 0, levelWidth - FP.width, levelHeight - FP.height);
			
			FP.setCamera(cameraPoint.x, cameraPoint.y);
		}
		
		/**
		 * Checks to see if the object has collided with a damaging tile on the ground layer.
		 * @param	direction	A direction, Mobile.LEFT, etc.
		 * @param	entity		The entity that is colliding
		 * @param	callback	An optional callback if we are damaged.
		 * @return				Are we damaged?
		 */
		public function checkDamage(direction:int, entity:Entity, callback:Function = null):Boolean
		{
			if (direction == Mobile.DOWN)
			{
				if (damagers.indexOf(getTileByLoc(entity.left, entity.bottom + 1)) > -1)
					return true;
				else if (damagers.indexOf(getTileByLoc(entity.right, entity.bottom + 1)) > -1)
					return true;
			}
			else if (direction == Mobile.UP)
			{
				if (damagers.indexOf(getTileByLoc(entity.left, entity.top - 1)) > -1)
					return true;
				else if (damagers.indexOf(getTileByLoc(entity.right, entity.top - 1)) > -1)
					return true;
			}
			else if (direction == Mobile.LEFT)
			{
				if (damagers.indexOf(getTileByLoc(entity.left - 1, entity.top)) > -1)
					return true;
				else if (damagers.indexOf(getTileByLoc(entity.left - 1, entity.bottom)) > -1)
					return true;
			}
			else if (direction == Mobile.RIGHT)
			{
				if (damagers.indexOf(getTileByLoc(entity.right + 1, entity.top)) > -1)
					return true;
				else if (damagers.indexOf(getTileByLoc(entity.right + 1, entity.bottom)) > -1)
					return true;
			}
			
			return false;
		}
		
		/**
		 * Gets a tile index on the ground layer from x and y coordinates.
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function getTileByLoc(x:Number, y:Number):int
		{
			return (ground.graphic as Tilemap).getTile(Math.floor(x / 16), Math.floor(y / 16));
		}
		
		public function isSolidTile(x:Number, y:Number):Boolean
		{
			return (solids.indexOf(getTileByLoc(x, y)) > -1); 
		}
		
		/**
		 * Our primary level load function.
		 * @param	data		A reference to the embedded level data.
		 * @param	entrance	Which entrance to set the player to.
		 */
		public function loadLevel(data:Class, entrance:String):void
		{	
			// Clear the old stuff.
			if (exits)
				removeList(exits);
				
			if (tileLayers)
				removeList(tileLayers);
			
			levelData = new XML(new data);
			var _tileset:XML = new XML(new XMLTILESET);
			
			levelWidth = levelData.@width * _tileset.@tilewidth;
			levelHeight = levelData.@height * _tileset.@tileheight;

			// Load in our special tiles, the ones that are solid or that damage.
			solids = new Array();
			for each (var _t:XML in _tileset.(@name == "tiles").tile)
			{
				if (_t..property.(@name == "solid").@value == "true" ) 
					solids.push(int(_t.@id));
				
				if (_t..property.(@name == "damage").@value == "true" )
					damagers.push(int(_t.@id));
			}
			
			// Load the tile layers, in order from farthest back
			// to closest.
			tileLayers = new Vector.<Entity>();
			
			var _layer:int = 9;
			for each (var _l:XML in levelData.layer)
			{
				var _tilemap:Tilemap = new Tilemap(IMGTILES, levelWidth, levelHeight, _tileset.@tilewidth, _tileset.@tileheight);

				setTilesByArray(_tilemap, _l.data.split(","));
				
				// We need some special handling for the ground layer, namely it needs solids and a
				// collision type.
				var _entity:Entity;
				if (_l.@name == "Ground")
				{
					_entity = new Entity(0, 0, _tilemap, _tilemap.createGrid(solids));
					_entity.type = "ground";
					ground = _entity;
				}
				else
					_entity = new Entity(0, 0, _tilemap);
				
				_entity.layer = _layer;
					
				tileLayers.push(_entity);
				_layer--;
			}
			
			addList(tileLayers);
			
			// Load in our connections. Exits are actual entities that the player
			// can collide with. Entrances are just strings corresponding to
			// where the player can enter the next board.
			exits = new Vector.<Entity>();
			entrances = new Object();
			
			for each (var _e:XML in levelData.objectgroup.(@name == "Connections").object)
			{
				if (_e.@type == "exit")
				{					
					var exit:Exit = new Exit(_e.@x, _e.@y, _e.@width, _e.@height);
					exit.to = Levels[_e..property.(@name == "to").@value];
					exit.entrance = _e..property.(@name == "entrance").@value;
					
					// We need to set which directions the player is allowed to enter from.
					// Actually, this allows all BUT the side listed.
					// TODO: Change that, if necessary.
					if (_e..property.(@name == "from").@value == "left")
						exit.from = Mobile.LEFT;
					else if (_e..property.(@name == "from").@value == "right")
						exit.from = Mobile.RIGHT;
					else if (_e..property.(@name == "from").@value == "up")
						exit.from = Mobile.UP;
					else if (_e..property.(@name == "from").@value == "down")
						exit.from = Mobile.DOWN;
					
					exits.push(exit);
				}
				else if (_e.@type == "entrance")
				{
					var _entrance:Point = new Point(_e.@x, _e.@y);
					entrances[_e.@name] = _entrance;
				}
			}
			
			addList(exits);
			
			player.x = entrances[entrance].x;
			player.y = entrances[entrance].y;
			
			loadSpawns();
		}
		
		/**
		 * Loads in the plant and monster spawns.
		 */
		private function loadSpawns():void
		{
			if (items)
				removeList(items);
			
			if (environment)
				removeList(environment);
				
			if (monsters)
				removeList(monsters);
			
			items = new Vector.<Item>();
			environment = new Vector.<Entity>();
			monsters = new Vector.<Monster>();
	
			var _m:Monster;
			for each (var _i:XML in levelData.objectgroup.(@name == "Spawns").object)
			{
				switch (_i.@type.toString()) 
				{
					case "firePlant":
						spawnPlant(FirePlant, _i.@x, _i.@y);
					break;
					case "waterPlant":
						spawnPlant(WaterPlant, _i.@x, _i.@y);
					break;
					case "fireRoot":
						(spawnPlant(FireRoot, _i.@x, _i.@y) as Root).level = this;
					break;
					case "waterRoot":
						(spawnPlant(WaterRoot, _i.@x, _i.@y) as Root).level = this;
					break;
					case "balloonMonster":
						_m = new Balloon(this, _i.@x, _i.@y);
						monsters.push(_m);
					break;
					case "blockMonster":
						_m = new Block(this, _i.@x, _i.@y);
						(_m as Block).setSize(_i..property.(@name == "size").@value);
						monsters.push(_m);
					break;
					case "pushyMonster":
						_m = new Pushy(this, _i.@x, _i.@y);
						if (_i..property.(@name == "facing").@value == "left")
							(_m as Pushy).facing = Mobile.LEFT;
						else
							(_m as Pushy).facing = Mobile.RIGHT;
						
						_m.setState(_i..property.(@name == "state").@value);
						
						monsters.push(_m);
					break;
				}
			}
			
			addList(monsters);
			addList(environment);
		}
		
		/**
		 * Spawns a plant as well as its associated seed in the world.
		 * @param	type	The class of the plant.
		 * @param	x
		 * @param	y
		 */
		private function spawnPlant(type:Class, x:Number, y:Number):Entity
		{
			var _p:* = new type(x, y);
			environment.push(_p);
			
			if (type == FirePlant)
				spawnSeed(_p, Item.FIRE);
			else if (type == WaterPlant)
				spawnSeed(_p, Item.WATER);
				
			return _p;
		}
		
		/**
		 * Given an array of indices and a tilemap, sets the tilemap.
		 * @param	map		The tilemap to set.
		 * @param	tiles	Due to Tiled's tilemap indices, the map will be set to i - 1.
		 */
		private function setTilesByArray(map:Tilemap, tiles:Array):void {
			var mapWidth:int = levelData.@width;
			var mapHeight:int = levelData.@height;
			
			for (var i:int = 0; i < tiles.length; i++) 
			{
				var x:int = i % mapWidth;
				var y:int = Math.floor(i / mapWidth);
				if (tiles[i] > 0)
					map.setTile(x, y, tiles[i] - 1);
			}
		}
		
		/**
		 * Spawns a new seed, or, if one is available, resets a recycled one.
		 * @param	spawner	The plant that spwns this.
		 * @param	type	The type of seed, Item.FIRE, Item.WATER, etc.
		 */
		public function spawnSeed(spawner:Entity, type:int):void
		{
			var seed:Item;
			
			switch (type) 
			{
				case Item.FIRE:
					seed = create(FireSeed) as Item;
				break;
				case Item.WATER:
					seed = create(WaterSeed) as Item;
				break;
				case Item.FIREDROP:
					seed = create(FireDrop) as Item;
				break;
				case Item.WATERDROP:
					seed = create(WaterDrop) as Item;
				break;
			}
			
			seed.spawn(spawner, this);
			add(seed);
			if (items.indexOf(seed) == -1)
				items.push(seed);
		}
	}

}