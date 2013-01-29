package com.cambrianman.monsters.items 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import com.cambrianman.monsters.monsters.Monster;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	
	/**
	 * Base class for held items.
	 * @author Evan Furchtgott
	 */
	public class Item extends Mobile 
	{
		public static var FIRE:int = 0;
		public static var WATER:int = 1;
		
		public static var FIREDROP:int = 10;
		public static var WATERDROP:int = 11;
				
		protected var held:Boolean = false;
		protected var spawner:Entity;
		
		public var itemType:int;
		
		private var fireGraphic:Spritemap;
		private var waterGraphic:Spritemap;
		
		[Embed(source = "../gfx/items/fire_seed.png")] private const IMGFIRE:Class;
		[Embed(source = "../gfx/items/water_seed.png")] private const IMGWATER:Class;
		
		public function Item() 
		{
			super(level, x, y, graphic, mask);
			
			collidables = ["ground", "monster", "backgroundMonster"];
			
			width = 8;
			height = 8;
			
			type = "item";
			layer = 3;
			
			maxSpeed.x = 6;
			maxSpeed.y = 2;
			
			fireGraphic = new Spritemap(IMGFIRE, 16, 16);
			fireGraphic.add("anim", [0, 1, 2, 3], 8, true);
			fireGraphic.play("anim");
			
			waterGraphic = new Spritemap(IMGWATER, 16, 16);
			waterGraphic.add("anim", [0, 1, 2, 3], 8, true);
			waterGraphic.play("anim");
			
			sweep = true;
		}
		
		override public function update():void
		{
			if (x < -200 || x > level.width + 200 || y < -200 || y > level.height + 200)
				die();
			
			if (held)
			{
				if (itemType == FIRE)
					y = level.player.y + 4;
				else if (itemType == WATER)
					y = level.player.y + 8;
					
				if (level.player.facing == RIGHT)
					x = level.player.right - 4;
				else
					x = level.player.x - 4;
			}
			super.update();
		}
		
		public function spawn(spawner:Entity, level:Level, type:int):void
		{
			this.level = level;
			this.spawner = spawner;
			this.itemType = type;

			speed.x = 0;
			speed.y = 0;
			maxSpeed.y = 10;
			
			// Tweak the parameters for each item type.
			switch (type) 
			{
				case FIRE:
					acceleration.y = 0;
					x = spawner.x + 16;
					y = spawner.y + 12;
					setOrigin( -4, -6);
					graphic = fireGraphic;
					fireGraphic.play("anim");
				break;
				case WATER:
					acceleration.y = 0;
					x = spawner.x + 16;
					y = spawner.y + 12;
					setOrigin( -4, -2);
					graphic = waterGraphic;
					waterGraphic.play("anim");
				break;
				case FIREDROP:
					acceleration.y = 0.2;
					x = spawner.x + 8;
					y = spawner.y + 12;
					setOrigin( -4, -6);
					graphic = fireGraphic;
					fireGraphic.play("anim");
				break;
				case WATERDROP:
					acceleration.y = 0.2;
					x = spawner.x + 8;
					y = spawner.y + 12;
					setOrigin( -4, -6);
					graphic = waterGraphic;
					waterGraphic.play("anim");
				break;
			}
		}
		
		public function grab():void
		{
			if (itemType == WATERDROP || itemType == FIREDROP)
				return;
			
			level.player.held = this;
			held = true;
		}
		
		public function toss(direction:int):void
		{
			held = false;
			level.player.held = null;
			switch (direction) 
			{
				case Mobile.LEFT:
					speed.x = -6;
				break;
				case Mobile.RIGHT:
					speed.x = 6;
				break;
				case Mobile.UP:
					speed.y = -6;
				break;
				case Mobile.DOWN:
					speed.y = 6;
				break;
			}
				
			acceleration.y = 0.1;
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			super.moveCollideX(e);
			onCollide(e);
			
			return true;
		}
		
		override public function moveCollideY(e:Entity):Boolean
		{
			super.moveCollideY(e);
			onCollide(e);
			
			return true;
		}
		
		/**
		 * Generic collision handling for the seed.
		 * @param	e
		 */
		protected function onCollide(e:Entity):void
		{
			if (itemType == FIRE || itemType == FIREDROP)
			{
				level.particles.burstAt(x, y, FIRE);
				if (e is Monster)
					(e as Monster).onFire();
			}
			else if (itemType == WATER || itemType == WATERDROP)
			{
				level.particles.burstAt(x, y, WATER);
				if (e is Monster)
					(e as Monster).onWater();
			}

			die();
		}
		
		public function die():void
		{
			if (itemType == FIRE || itemType == WATER)
			{
				level.spawnSeed(spawner, itemType);
				if (level.player.held == this)
					level.player.held = null;
			}
			
			level.recycle(this);
		}
	}

}